from __future__ import annotations

import sys
import unittest
from pathlib import Path


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
REPO_ROOT = SCRIPTS_DIR.parent
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

import run_pr06912_performance_scale_sanity


class Pr06912PerformanceScaleSanityTests(unittest.TestCase):
    def test_sample_metadata_uses_legacy_stable_bytes_for_pr114_cutover_fixtures(self) -> None:
        self.assertEqual(
            run_pr06912_performance_scale_sanity.sample_metadata(
                REPO_ROOT / "tests" / "positive" / "rule1_accumulate.safe"
            )["bytes"],
            1366,
        )
        self.assertEqual(
            run_pr06912_performance_scale_sanity.sample_metadata(
                REPO_ROOT / "tests" / "positive" / "rule2_binary_search.safe"
            )["bytes"],
            1830,
        )
        self.assertEqual(
            run_pr06912_performance_scale_sanity.sample_metadata(
                REPO_ROOT / "tests" / "positive" / "rule5_statistics.safe"
            )["bytes"],
            1902,
        )

    def test_stable_source_size_leaves_non_safe_inputs_unchanged(self) -> None:
        path = REPO_ROOT / "compiler_impl" / "tests" / "mir_validation" / "valid_mir_v2.json"
        text = path.read_text(encoding="utf-8")
        self.assertEqual(
            run_pr06912_performance_scale_sanity.stable_source_size(path, text=text),
            path.stat().st_size,
        )

    def test_stable_emitted_artifact_text_preserves_pre_pr114_size_contract(self) -> None:
        typed_text = (
            '{"kind":"function","signature":"function Search (Arr: Sorted_Array, Key: Element, '
            'Found: Boolean, Found_At: Index)"}'
        )
        mir_text = (
            '{"graphs":[{"name":"Search","kind":"function","entry_bb":"bb0",'
            '"span":{"start_line":1,"start_col":1,"end_line":2,"end_col":1},"return_type":null}]}'
        )
        safei_text = (
            '{"executables":[{"name":"Mean","kind":"function","signature":"function Mean '
            '(Data: Sample_Array) returns Sample_Value"}]}'
        )
        self.assertIn('"kind":"procedure"', run_pr06912_performance_scale_sanity.stable_typed_or_safei_text(typed_text))
        self.assertIn('"signature":"procedure Search', run_pr06912_performance_scale_sanity.stable_typed_or_safei_text(typed_text))
        self.assertIn('"kind":"procedure"', run_pr06912_performance_scale_sanity.stable_mir_text(mir_text))
        self.assertIn(
            'returns',
            safei_text,
        )
        self.assertIn(
            '"signature":"function Mean (Data: Sample_Array) return Sample_Value"',
            run_pr06912_performance_scale_sanity.stable_typed_or_safei_text(safei_text),
        )


if __name__ == "__main__":
    unittest.main()
