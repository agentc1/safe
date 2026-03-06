#!/usr/bin/env python3
"""Build the early frontend and run deterministic smoke checks."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parent.parent
COMPILER_ROOT = REPO_ROOT / "compiler_impl"
DEFAULT_REPORT = REPO_ROOT / "execution" / "reports" / "pr00-pr04-frontend-smoke.json"
POSITIVE_AST = REPO_ROOT / "tests" / "positive" / "rule1_accumulate.safe"
POSITIVE_PIPELINE = REPO_ROOT / "tests" / "positive" / "channel_pipeline.safe"


def find_command(name: str, fallback: Path | None = None) -> str:
    found = shutil.which(name)
    if found:
        return found
    if fallback and fallback.exists():
        return str(fallback)
    raise FileNotFoundError(f"required command not found: {name}")


def run(
    argv: list[str],
    *,
    cwd: Path,
    env: dict[str, str] | None = None,
    stdout_path: Path | None = None,
) -> dict[str, Any]:
    if stdout_path is not None:
        stdout_path.parent.mkdir(parents=True, exist_ok=True)
        with stdout_path.open("w", encoding="utf-8") as handle:
            completed = subprocess.run(
                argv,
                cwd=cwd,
                env=env,
                text=True,
                stdout=handle,
                stderr=subprocess.PIPE,
                check=False,
            )
        stdout_text = stdout_path.read_text(encoding="utf-8")
    else:
        completed = subprocess.run(
            argv,
            cwd=cwd,
            env=env,
            text=True,
            capture_output=True,
            check=False,
        )
        stdout_text = completed.stdout
    result = {
        "command": argv,
        "cwd": str(cwd),
        "returncode": completed.returncode,
        "stdout": stdout_text,
        "stderr": completed.stderr,
    }
    if completed.returncode != 0:
        raise RuntimeError(json.dumps(result, indent=2))
    return result


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while True:
            chunk = handle.read(65536)
            if not chunk:
                break
            digest.update(chunk)
    return digest.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()

    args.report.parent.mkdir(parents=True, exist_ok=True)

    alr = find_command("alr", Path.home() / "bin" / "alr")
    python = find_command("python3")

    env = os.environ.copy()

    build_cmd = [alr, "build"]
    build = run(build_cmd, cwd=COMPILER_ROOT, env=env)

    safec = COMPILER_ROOT / "bin" / "safec"
    if not safec.exists():
        raise RuntimeError(f"expected compiled binary at {safec}")

    with tempfile.TemporaryDirectory(prefix="safec-smoke-") as temp_root_str:
        temp_root = Path(temp_root_str)
        ast_path = temp_root / "rule1_accumulate.ast.json"
        ast_run = run(
            [str(safec), "ast", str(POSITIVE_AST)],
            cwd=REPO_ROOT,
            env=env,
            stdout_path=ast_path,
        )
        ast_validate = run(
            [python, str(REPO_ROOT / "scripts" / "validate_ast_output.py"), str(ast_path)],
            cwd=REPO_ROOT,
            env=env,
        )
        check_accumulate = run(
            [str(safec), "check", str(POSITIVE_AST)],
            cwd=REPO_ROOT,
            env=env,
        )
        check_pipeline = run(
            [str(safec), "check", str(POSITIVE_PIPELINE)],
            cwd=REPO_ROOT,
            env=env,
        )

        emit_a_root = temp_root / "emit-a"
        emit_b_root = temp_root / "emit-b"
        for root in (emit_a_root, emit_b_root):
            run(
                [
                    str(safec),
                    "emit",
                    str(POSITIVE_PIPELINE),
                    "--out-dir",
                    str(root / "out"),
                    "--interface-dir",
                    str(root / "iface"),
                ],
                cwd=REPO_ROOT,
                env=env,
            )

        expected_files = {
            "out/channel_pipeline.ast.json",
            "out/channel_pipeline.typed.json",
            "out/channel_pipeline.mir.json",
            "iface/channel_pipeline.safei.json",
        }
        observed_files = {
            str(path.relative_to(emit_a_root))
            for path in emit_a_root.rglob("*")
            if path.is_file()
        }
        if observed_files != expected_files:
            raise RuntimeError(
                f"unexpected emitted files: expected {sorted(expected_files)}, got {sorted(observed_files)}"
            )

        file_hashes: dict[str, str] = {}
        for relative in sorted(expected_files):
            left = emit_a_root / relative
            right = emit_b_root / relative
            left_bytes = left.read_bytes()
            right_bytes = right.read_bytes()
            if left_bytes != right_bytes:
                raise RuntimeError(f"non-deterministic output for {relative}")
            file_hashes[relative] = sha256(left)

        report = {
            "build": build,
            "ast": ast_run,
            "ast_validation": ast_validate,
            "check_runs": [check_accumulate, check_pipeline],
            "deterministic_outputs": file_hashes,
            "samples": {
                "ast": str(POSITIVE_AST.relative_to(REPO_ROOT)),
                "emit": str(POSITIVE_PIPELINE.relative_to(REPO_ROOT)),
            },
        }

    args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"frontend smoke: OK ({args.report})")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, FileNotFoundError) as exc:
        print(f"frontend smoke: ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
