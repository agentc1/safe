#!/usr/bin/env python3
"""Validate the PR11.1 Rosetta starter corpus through the compile-only chain."""

from __future__ import annotations

import argparse
import os
import sys
import tempfile
from pathlib import Path
from typing import Any

from _lib.harness_common import (
    display_path,
    ensure_sdkroot,
    finalize_deterministic_report,
    require,
    run,
    write_report,
)
from _lib.pr09_emit import (
    REPO_ROOT,
    compile_emitted_ada,
    emit_paths,
    run_emit,
)
from _lib.pr111_language_eval import starter_corpus_paths, safec_path


def generate_report(*, safec: Path, env: dict[str, str]) -> dict[str, Any]:
    with tempfile.TemporaryDirectory(prefix="pr111-rosetta-") as temp_root_str:
        temp_root = Path(temp_root_str)
        fixtures: list[dict[str, Any]] = []

        for source in starter_corpus_paths():
            root = temp_root / source.stem
            out_dir = root / "out"
            iface_dir = root / "iface"
            ada_dir = root / "ada"
            out_dir.mkdir(parents=True, exist_ok=True)
            iface_dir.mkdir(parents=True, exist_ok=True)
            ada_dir.mkdir(parents=True, exist_ok=True)

            check = run(
                [str(safec), "check", str(source)],
                cwd=REPO_ROOT,
                env=env,
                temp_root=temp_root,
            )
            emit = run_emit(
                safec=safec,
                source=source,
                out_dir=out_dir,
                iface_dir=iface_dir,
                ada_dir=ada_dir,
                env=env,
                temp_root=temp_root,
            )
            compile_result = compile_emitted_ada(
                ada_dir=ada_dir,
                env=env,
                temp_root=temp_root,
            )

            expected = emit_paths(root, source)
            for path in expected.values():
                require(path.exists(), f"{source}: missing emitted artifact {path}")

            fixtures.append(
                {
                    "source": display_path(source, repo_root=REPO_ROOT),
                    "check": {
                        "command": check["command"],
                        "cwd": check["cwd"],
                        "returncode": check["returncode"],
                    },
                    "emit": {
                        "command": emit["command"],
                        "cwd": emit["cwd"],
                        "returncode": emit["returncode"],
                    },
                    "compile": compile_result,
                }
            )

        return {"fixtures": fixtures}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--report", type=Path, help="optional path to write the deterministic report JSON")
    args = parser.parse_args()

    report = finalize_deterministic_report(
        lambda: generate_report(safec=safec_path(), env=ensure_sdkroot(os.environ.copy())),
        label="PR11.1 Rosetta corpus",
    )
    if args.report is not None:
        write_report(args.report, report)
        print(f"rosetta corpus: OK ({display_path(args.report)})")
    else:
        print("rosetta corpus: OK")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, FileNotFoundError) as exc:
        print(f"rosetta corpus: ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
