#!/usr/bin/env python3
"""Run the PR11.7 reference-surface experiments gate."""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path
from typing import Any

from _lib.harness_common import (
    display_path,
    ensure_sdkroot,
    finalize_deterministic_report,
    managed_scratch_root,
    normalize_text,
    read_diag_json,
    require,
    run,
    write_report,
)
from _lib.pr09_emit import (
    REPO_ROOT,
    compile_emitted_ada,
    emit_paths,
    emitted_body_file,
    emitted_spec_file,
    repo_arg,
)
from _lib.pr111_language_eval import safec_path
from _lib.pr117_surface import (
    migration_examples,
    negative_cases,
    negative_paths,
    readability_examples,
    technical_cases,
    technical_paths,
)
from migrate_pr117_reference_surface import rewrite_safe_source


DEFAULT_REPORT = REPO_ROOT / "execution" / "reports" / "pr117-reference-surface-experiments-report.json"
EXPERIMENT_FLAG = "pr117-reference-signal"


def safec_argv(
    safec: Path,
    command: str,
    source: Path,
    *,
    experiment: bool,
    extra: list[str] | None = None,
) -> list[str]:
    argv = [str(safec), command, repo_arg(source)]
    if experiment:
        argv.extend(["--experiment", EXPERIMENT_FLAG])
    if extra:
        argv.extend(extra)
    return argv


def write_variant_source(*, source: Path, mode: str, text: str, temp_root: Path) -> Path:
    variant_dir = temp_root / mode
    variant_dir.mkdir(parents=True, exist_ok=True)
    variant_path = variant_dir / source.name
    variant_path.write_text(text, encoding="utf-8")
    return variant_path


def normalize_variant_artifact(text: str, *, source: Path, variant: Path, temp_root: Path) -> str:
    normalized = normalize_text(text, temp_root=temp_root, repo_root=REPO_ROOT)
    return normalized.replace(f"$TMPDIR/{variant.name}", repo_arg(source))


def classify_best_effort_difference(*, baseline_text: str, variant_text: str) -> dict[str, Any]:
    if baseline_text == variant_text:
        return {"identical": True, "classification": "identical"}
    return {"identical": False, "classification": "resolver_shape_difference"}


def run_emit_case(
    *,
    safec: Path,
    source: Path,
    env: dict[str, str],
    temp_root: Path,
    experiment: bool,
    compile_ada: bool,
) -> dict[str, Any]:
    root = temp_root / source.stem
    out_dir = root / "out"
    iface_dir = root / "iface"
    ada_dir = root / "ada"
    out_dir.mkdir(parents=True, exist_ok=True)
    iface_dir.mkdir(parents=True, exist_ok=True)
    ada_dir.mkdir(parents=True, exist_ok=True)

    check_result = run(
        safec_argv(safec, "check", source, experiment=experiment),
        cwd=REPO_ROOT,
        env=env,
        temp_root=temp_root,
    )
    emit_result = run(
        safec_argv(
            safec,
            "emit",
            source,
            experiment=experiment,
            extra=[
                "--out-dir",
                str(out_dir),
                "--interface-dir",
                str(iface_dir),
                "--ada-out-dir",
                str(ada_dir),
            ],
        ),
        cwd=REPO_ROOT,
        env=env,
        temp_root=temp_root,
    )
    paths = emit_paths(root, source)
    for path in paths.values():
        require(path.exists(), f"{source.name}: missing emitted artifact {display_path(path, repo_root=REPO_ROOT)}")
    validate_mir = run(
        [str(safec), "validate-mir", str(paths["mir"])],
        cwd=REPO_ROOT,
        env=env,
        temp_root=temp_root,
    )
    compile_result: dict[str, Any] | None = None
    if compile_ada:
        compile_result = compile_emitted_ada(
            ada_dir=ada_dir,
            env=env,
            temp_root=temp_root,
        )

    return {
        "root": root,
        "paths": paths,
        "check": {
            "command": check_result["command"],
            "cwd": check_result["cwd"],
            "returncode": check_result["returncode"],
        },
        "emit": {
            "command": emit_result["command"],
            "cwd": emit_result["cwd"],
            "returncode": emit_result["returncode"],
        },
        "validate_mir": {
            "command": validate_mir["command"],
            "cwd": validate_mir["cwd"],
            "returncode": validate_mir["returncode"],
        },
        "compile": None
        if compile_result is None
        else {
            "command": compile_result["command"],
            "cwd": compile_result["cwd"],
            "returncode": compile_result["returncode"],
        },
        "typed_text": paths["typed"].read_text(encoding="utf-8"),
        "mir_text": paths["mir"].read_text(encoding="utf-8"),
        "ada_text": emitted_spec_file(ada_dir).read_text(encoding="utf-8")
        + "\n"
        + emitted_body_file(ada_dir).read_text(encoding="utf-8"),
    }


def run_technical_case(*, safec: Path, source: Path, env: dict[str, str], temp_root: Path) -> dict[str, Any]:
    original_text = source.read_text(encoding="utf-8")
    implicit_text = rewrite_safe_source(original_text, mode="implicit-deref")
    combined_text = rewrite_safe_source(original_text, mode="combined")
    implicit_source = write_variant_source(source=source, mode="implicit", text=implicit_text, temp_root=temp_root)
    combined_source = write_variant_source(source=source, mode="combined", text=combined_text, temp_root=temp_root)

    baseline = run_emit_case(
        safec=safec,
        source=source,
        env=env,
        temp_root=temp_root,
        experiment=False,
        compile_ada=True,
    )
    implicit_variant = run_emit_case(
        safec=safec,
        source=implicit_source,
        env=env,
        temp_root=temp_root,
        experiment=False,
        compile_ada=False,
    )
    combined_variant = run_emit_case(
        safec=safec,
        source=combined_source,
        env=env,
        temp_root=temp_root,
        experiment=True,
        compile_ada=True,
    )

    baseline_ada = normalize_variant_artifact(
        baseline["ada_text"],
        source=source,
        variant=source,
        temp_root=temp_root,
    )
    implicit_ada = normalize_variant_artifact(
        implicit_variant["ada_text"],
        source=source,
        variant=implicit_source,
        temp_root=temp_root,
    )
    emitted_ada_parity = {
        "identical": baseline_ada == implicit_ada,
        "classification": "identical" if baseline_ada == implicit_ada else "emitted_ada_mismatch",
    }
    typed_comparison = classify_best_effort_difference(
        baseline_text=normalize_variant_artifact(
            baseline["typed_text"],
            source=source,
            variant=source,
            temp_root=temp_root,
        ),
        variant_text=normalize_variant_artifact(
            implicit_variant["typed_text"],
            source=source,
            variant=implicit_source,
            temp_root=temp_root,
        ),
    )
    mir_comparison = classify_best_effort_difference(
        baseline_text=normalize_variant_artifact(
            baseline["mir_text"],
            source=source,
            variant=source,
            temp_root=temp_root,
        ),
        variant_text=normalize_variant_artifact(
            implicit_variant["mir_text"],
            source=source,
            variant=implicit_source,
            temp_root=temp_root,
        ),
    )

    require(".all." not in implicit_text, f"{source.name}: implicit-deref rewrite still contains `.all.`")
    require(".all." not in combined_text, f"{source.name}: combined rewrite still contains `.all.`")

    return {
        "source": repo_arg(source),
        "baseline": {
            "check": baseline["check"],
            "emit": baseline["emit"],
            "validate_mir": baseline["validate_mir"],
            "compile": baseline["compile"],
        },
        "implicit_deref_variant": {
            "source": f"$TMPDIR/{implicit_source.name}",
            "check": implicit_variant["check"],
            "emit": implicit_variant["emit"],
            "validate_mir": implicit_variant["validate_mir"],
            "emitted_ada_parity": emitted_ada_parity,
            "typed_comparison": typed_comparison,
            "mir_comparison": mir_comparison,
        },
        "reference_signal_combined_variant": {
            "source": f"$TMPDIR/{combined_source.name}",
            "check": combined_variant["check"],
            "emit": combined_variant["emit"],
            "validate_mir": combined_variant["validate_mir"],
            "compile": combined_variant["compile"],
        },
    }


def run_negative_case(
    *,
    safec: Path,
    source: Path,
    env: dict[str, str],
    temp_root: Path,
    expected_reason: str,
    expected_message: str,
    default_mode_expected_success: bool = False,
) -> dict[str, Any]:
    default_mode: dict[str, Any] | None = None
    if default_mode_expected_success:
        result = run(
            safec_argv(safec, "check", source, experiment=False),
            cwd=REPO_ROOT,
            env=env,
            temp_root=temp_root,
        )
        default_mode = {
            "command": result["command"],
            "cwd": result["cwd"],
            "returncode": result["returncode"],
        }

    result = run(
        safec_argv(safec, "check", source, experiment=True, extra=["--diag-json"]),
        cwd=REPO_ROOT,
        env=env,
        temp_root=temp_root,
        expected_returncode=1,
    )
    payload = read_diag_json(result["stdout"], repo_arg(source))
    diagnostics = payload.get("diagnostics", [])
    require(diagnostics, f"{source.name}: expected at least one diagnostic")
    first = diagnostics[0]
    require(first["reason"] == expected_reason, f"{source.name}: expected reason {expected_reason!r}")
    require(expected_message in first["message"], f"{source.name}: expected message containing {expected_message!r}")
    return {
        "source": repo_arg(source),
        "default_mode": default_mode,
        "experiment_mode": {
            "command": result["command"],
            "cwd": result["cwd"],
            "returncode": result["returncode"],
        },
        "first_diagnostic": {
            "reason": first["reason"],
            "message": first["message"],
            "path": first["path"],
        },
    }


def run_migration_example(example: dict[str, Any]) -> dict[str, Any]:
    rewritten = rewrite_safe_source(example["source"], mode=example["mode"])
    for fragment in example.get("required_fragments", ()):
        require(fragment in rewritten, f"{example['name']}: missing fragment {fragment!r}")
    for fragment in example.get("forbidden_fragments", ()):
        require(fragment not in rewritten, f"{example['name']}: retained fragment {fragment!r}")
    return {
        "name": example["name"],
        "mode": example["mode"],
        "required_fragments": list(example.get("required_fragments", ())),
        "forbidden_fragments": list(example.get("forbidden_fragments", ())),
    }


def run_readability_example(example: dict[str, Any]) -> dict[str, Any]:
    implicit = rewrite_safe_source(example["source"], mode="implicit-deref")
    combined = rewrite_safe_source(example["source"], mode="combined")
    return {
        "name": example["name"],
        "description": example["description"],
        "baseline": example["source"],
        "implicit_deref": implicit,
        "reference_signal_and_implicit_deref": combined,
    }


def generate_report(*, env: dict[str, str], scratch_root: Path | None = None) -> dict[str, Any]:
    safec = safec_path()
    technical: list[dict[str, Any]] = []
    negatives: list[dict[str, Any]] = []
    migrations: list[dict[str, Any]] = []
    readability: list[dict[str, Any]] = []

    with managed_scratch_root(scratch_root=scratch_root, prefix="pr117-reference-") as temp_root:
        for case in technical_cases():
            technical.append(
                run_technical_case(
                    safec=safec,
                    source=case["source"],
                    env=env,
                    temp_root=temp_root,
                )
            )
        for case in negative_cases():
            negatives.append(
                run_negative_case(
                    safec=safec,
                    source=case["source"],
                    env=env,
                    temp_root=temp_root,
                    expected_reason=case["reason"],
                    expected_message=case["message"],
                    default_mode_expected_success=case.get("default_mode_expected_success", False),
                )
            )
        for example in migration_examples():
            migrations.append(run_migration_example(example))
        for example in readability_examples():
            readability.append(run_readability_example(example))

    implicit_admit = all(
        case["implicit_deref_variant"]["emitted_ada_parity"]["identical"]
        for case in technical
    )
    if implicit_admit:
        implicit_decision = "admit"
        implicit_rationale = [
            "Implicit dereference is already implemented and specified in the current compiler surface.",
            "Across the fixed ownership/reference corpus, explicit `.all` and implicit-dereference variants preserve accept/reject outcomes and emitted Ada parity after deterministic normalization.",
            "PR11.7 therefore records implicit dereference as admitted reference-surface behavior while keeping explicit `.all` admitted for now.",
        ]
    else:
        implicit_decision = "defer"
        implicit_rationale = [
            "Implicit dereference is already implemented for part of the current compiler surface, but the fixed ownership/reference corpus still exposes emitted-Ada divergence from explicit `.all` spellings.",
            "Those mismatches mean PR11.7 cannot yet bless implicit dereference as a parity-clean recommended reference surface across the full fixed corpus.",
            "PR11.7 therefore records implicit dereference as deferred for future surface tightening, while leaving the currently accepted explicit `.all` spellings fully admitted.",
        ]

    return {
        "task": "PR11.7",
        "status": "ok",
        "scope": {
            "included": [
                "capitalisation as reference signal",
                "implicit dereference",
            ],
            "excluded": [
                "capitalisation as export signal",
                "move keyword",
            ],
            "experiment_flag": f"--experiment {EXPERIMENT_FLAG}",
            "default_surface_changed": False,
        },
        "technical_corpus": {
            "sources": technical_paths(),
            "cases": technical,
        },
        "negative_boundaries": {
            "sources": negative_paths(),
            "cases": negatives,
        },
        "migration_examples": migrations,
        "readability_examples": readability,
        "decisions": {
            "reference_signal": {
                "decision": "defer",
                "rationale": [
                    "The experiment prototype works on the fixed corpus only behind a dedicated resolver mode that diverges from Ada-style case-folded user-name lookup.",
                    "That prototype confirms the idea is technically feasible, but it imposes case-sensitive user-name semantics, migration churn across bindings and record fields, and nontrivial tooling/documentation cost.",
                    "PR11.7 therefore records reference-signal casing as deferred rather than admitting it into the default pre-1.0 source surface.",
                ],
            },
            "implicit_dereference": {
                "decision": implicit_decision,
                "rationale": implicit_rationale,
            },
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()

    report = finalize_deterministic_report(
        lambda: generate_report(env=ensure_sdkroot(os.environ.copy())),
        label="PR11.7 reference-surface experiments",
    )
    write_report(args.report, report)
    print(f"pr117 reference-surface experiments: OK ({display_path(args.report, repo_root=REPO_ROOT)})")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, FileNotFoundError, ValueError) as exc:
        print(f"pr117 reference-surface experiments: ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
