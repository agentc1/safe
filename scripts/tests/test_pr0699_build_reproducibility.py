from __future__ import annotations

import sys
import unittest
from pathlib import Path


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

import run_pr0699_build_reproducibility


class Pr0699BuildReproducibilityTests(unittest.TestCase):
    def test_infer_generated_root_returns_none_for_repo_report(self) -> None:
        self.assertIsNone(
            run_pr0699_build_reproducibility.infer_generated_root(
                report_path=run_pr0699_build_reproducibility.DEFAULT_REPORT
            )
        )

    def test_infer_generated_root_derives_stage_root_for_temp_report(self) -> None:
        stage_root = Path("/tmp/gate-pipeline-stage-xyz")
        report_path = stage_root / "execution" / "reports" / "pr0699-build-reproducibility-report.json"
        self.assertEqual(
            run_pr0699_build_reproducibility.infer_generated_root(report_path=report_path),
            stage_root,
        )

    def test_canonicalize_generated_gate_result_strips_report_transport(self) -> None:
        report_path = run_pr0699_build_reproducibility.FRONTEND_SMOKE_REPORT
        result = {
            "command": [
                "python3",
                "scripts/run_frontend_smoke.py",
                "--report",
                "$TMPDIR/execution/reports/pr00-pr04-frontend-smoke.json",
            ],
            "cwd": "$REPO_ROOT",
            "returncode": 0,
            "stdout": "frontend smoke: OK ($TMPDIR/execution/reports/pr00-pr04-frontend-smoke.json)\n",
            "stderr": "",
        }
        canonical = run_pr0699_build_reproducibility.canonicalize_generated_gate_result(
            result=result,
            report_path=report_path,
        )
        self.assertEqual(
            canonical["command"],
            ["python3", "scripts/run_frontend_smoke.py"],
        )
        self.assertEqual(
            canonical["stdout"],
            "frontend smoke: OK (execution/reports/pr00-pr04-frontend-smoke.json)\n",
        )


if __name__ == "__main__":
    unittest.main()
