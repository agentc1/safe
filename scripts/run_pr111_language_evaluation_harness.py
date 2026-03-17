#!/usr/bin/env python3
"""Run the PR11.1 language-evaluation-harness gate."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import sys
from pathlib import Path
from typing import Any

import run_rosetta_corpus
from _lib.harness_common import (
    display_path,
    ensure_sdkroot,
    finalize_deterministic_report,
    find_command,
    require,
    run,
    sha256_file,
    write_report,
)
from _lib.pr111_language_eval import (
    REPO_ROOT,
    safe_build_paths,
    safe_launcher_path,
)


DEFAULT_REPORT = REPO_ROOT / "execution" / "reports" / "pr111-language-evaluation-harness-report.json"
SEQUENTIAL_SMOKE = REPO_ROOT / "samples" / "rosetta" / "arithmetic" / "fibonacci.safe"
CONCURRENCY_SMOKE = REPO_ROOT / "samples" / "rosetta" / "concurrency" / "producer_consumer.safe"
VSCODE_ROOT = REPO_ROOT / "editors" / "vscode"


def validate_vscode_artifacts() -> dict[str, Any]:
    package_path = VSCODE_ROOT / "package.json"
    grammar_path = VSCODE_ROOT / "syntaxes" / "safe.tmLanguage.json"
    config_path = VSCODE_ROOT / "language-configuration.json"
    extension_path = VSCODE_ROOT / "extension.js"
    lsp_path = REPO_ROOT / "scripts" / "safe_lsp.py"
    safe_path = safe_launcher_path()
    readme_path = REPO_ROOT / "samples" / "rosetta" / "README.md"

    package_payload = json.loads(package_path.read_text(encoding="utf-8"))
    grammar_payload = json.loads(grammar_path.read_text(encoding="utf-8"))
    config_payload = json.loads(config_path.read_text(encoding="utf-8"))

    require(package_payload["main"] == "./extension.js", "VSCode package main drifted")
    require(grammar_payload["scopeName"] == "source.safe", "VSCode grammar scope drifted")
    require(
        package_payload["contributes"]["languages"][0]["id"] == "safe",
        "VSCode language id drifted",
    )
    require(config_payload["comments"]["lineComment"] == "--", "VSCode comment config drifted")
    for path in (extension_path, lsp_path, safe_path, readme_path):
        require(path.exists(), f"missing PR11.1 artifact {display_path(path, repo_root=REPO_ROOT)}")

    return {
        "package.json": sha256_file(package_path),
        "safe.tmLanguage.json": sha256_file(grammar_path),
        "language-configuration.json": sha256_file(config_path),
        "extension.js": sha256_file(extension_path),
        "safe_lsp.py": sha256_file(lsp_path),
        "safe": sha256_file(safe_path),
        "samples/rosetta/README.md": sha256_file(readme_path),
    }


def run_safe_build_smoke(
    *,
    source: Path,
    env: dict[str, str],
) -> dict[str, Any]:
    safe = safe_launcher_path()
    result = run(
        [str(safe), "build", str(source)],
        cwd=REPO_ROOT,
        env=env,
    )
    paths = safe_build_paths(source)
    executable = paths["exe"]
    require(executable.exists(), f"{source}: safe build did not produce {executable}")
    report = {
        "source": display_path(source, repo_root=REPO_ROOT),
        "command": result["command"],
        "cwd": result["cwd"],
        "returncode": result["returncode"],
        "stdout": result["stdout"],
        "executable": display_path(executable, repo_root=REPO_ROOT),
    }
    shutil.rmtree(paths["root"], ignore_errors=True)
    return report


def generate_report(*, env: dict[str, str]) -> dict[str, Any]:
    python = find_command("python3")
    return {
        "tooling": validate_vscode_artifacts(),
        "rosetta_corpus": run_rosetta_corpus.generate_report(
            safec=run_rosetta_corpus.safec_path(),
            env=env,
        ),
        "safe_build_smoke": [
            run_safe_build_smoke(source=SEQUENTIAL_SMOKE, env=env),
            run_safe_build_smoke(source=CONCURRENCY_SMOKE, env=env),
        ],
        "launcher_help": run(
            [python, str(safe_launcher_path()), "--help"],
            cwd=REPO_ROOT,
            env=env,
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()

    report = finalize_deterministic_report(
        lambda: generate_report(env=ensure_sdkroot(os.environ.copy())),
        label="PR11.1 language evaluation harness",
    )
    write_report(args.report, report)
    print(f"pr111 language evaluation harness: OK ({display_path(args.report, repo_root=REPO_ROOT)})")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, FileNotFoundError, json.JSONDecodeError) as exc:
        print(f"pr111 language evaluation harness: ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
