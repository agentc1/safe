from __future__ import annotations

import sys
import unittest
from pathlib import Path


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

import migrate_pr1162_legacy_syntax


class MigratePr1162LegacySyntaxTests(unittest.TestCase):
    def test_rewrite_safe_source_hoists_simple_tail_declare_block(self) -> None:
        original = (
            "package Demo\n"
            "\n"
            "   function Build returns Integer\n"
            "\n"
            "      declare\n"
            "         Temp : Integer = 1;\n"
            "      begin\n"
            "         return Temp;\n"
            "      end;\n"
        )
        rewritten = migrate_pr1162_legacy_syntax.rewrite_safe_source(original)
        self.assertIn("      var Temp : Integer = 1;\n", rewritten)
        self.assertIn("      return Temp;\n", rewritten)
        self.assertNotIn("declare\n", rewritten)
        self.assertNotIn("      begin\n", rewritten)
        self.assertNotIn("      end;\n", rewritten)

    def test_rewrite_safe_source_removes_null_statement(self) -> None:
        original = (
            "package Demo\n"
            "\n"
            "   function Consume\n"
            "\n"
            "      null;\n"
        )
        rewritten = migrate_pr1162_legacy_syntax.rewrite_safe_source(original)
        self.assertIn("   function Consume\n", rewritten)
        self.assertNotIn("null;", rewritten)

    def test_rewrite_safe_source_refuses_non_tail_declare_block(self) -> None:
        original = (
            "package Demo\n"
            "\n"
            "   function Build returns Integer\n"
            "\n"
            "      declare\n"
            "         Temp : Integer = 1;\n"
            "      begin\n"
            "         return Temp;\n"
            "      end;\n"
            "      return 0;\n"
        )
        with self.assertRaises(migrate_pr1162_legacy_syntax.LegacySyntaxMigrationError):
            migrate_pr1162_legacy_syntax.rewrite_safe_source(original)


if __name__ == "__main__":
    unittest.main()
