from __future__ import annotations

import hashlib
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

from _lib import harness_common as hc


class Pr0694OutputContractStabilityTests(unittest.TestCase):
    def test_stable_emitted_artifact_sha256_normalizes_repo_paths_in_mir(self) -> None:
        remote_root = Path("/home/runner/work/safe/safe")
        local_text = (
            "{"
            f"\"path\":\"{hc.REPO_ROOT / 'tests/positive/rule4_conditional.safe'}\","
            f"\"source_path\":\"{hc.REPO_ROOT / 'tests/positive/rule4_conditional.safe'}\""
            "}"
        )
        remote_text = (
            "{"
            f"\"path\":\"{remote_root / 'tests/positive/rule4_conditional.safe'}\","
            f"\"source_path\":\"{remote_root / 'tests/positive/rule4_conditional.safe'}\""
            "}"
        )

        with tempfile.TemporaryDirectory() as temp_dir:
            temp_root = Path(temp_dir)
            mir_path = temp_root / "rule4_conditional.mir.json"
            mir_path.write_text(local_text, encoding="utf-8")

            local_hash = hc.stable_emitted_artifact_sha256(
                mir_path,
                temp_root=temp_root,
            )
            remote_hash = hashlib.sha256(
                hc.normalize_text(remote_text, repo_root=remote_root).encode("utf-8")
            ).hexdigest()

        self.assertEqual(local_hash, remote_hash)

    def test_stable_emitted_artifact_sha256_keeps_non_mir_hashes_raw(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_root = Path(temp_dir)
            typed_path = temp_root / "rule4_conditional.typed.json"
            typed_path.write_text('{"path":"unchanged"}', encoding="utf-8")

            self.assertEqual(
                hc.stable_emitted_artifact_sha256(
                    typed_path,
                    temp_root=temp_root,
                ),
                hc.sha256_text('{"path":"unchanged"}'),
            )


if __name__ == "__main__":
    unittest.main()
