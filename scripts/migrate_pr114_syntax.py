#!/usr/bin/env python3
"""Mechanically rewrite Safe source files to the PR11.4 syntax surface."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_ROOTS = (
    REPO_ROOT / "tests",
    REPO_ROOT / "samples",
)
DECLARATION_START_RE = re.compile(r"^\s*(?:public\s+)?(function|procedure)\b")
PROCEDURE_DECL_RE = re.compile(r"^(\s*(?:public\s+)?)procedure\b")


def split_comment(line: str) -> tuple[str, str]:
    marker = line.find("--")
    if marker < 0:
        return line, ""
    return line[:marker], line[marker:]


def rewrite_safe_source(text: str) -> str:
    lines = text.splitlines(keepends=True)
    inside_signature = False
    paren_depth = 0
    rewritten: list[str] = []

    for line in lines:
        code, comment = split_comment(line)
        stripped = code.lstrip()

        if DECLARATION_START_RE.match(code):
            inside_signature = True
            paren_depth = 0

        if PROCEDURE_DECL_RE.match(code):
            code = PROCEDURE_DECL_RE.sub(r"\1function", code, count=1)

        if inside_signature and "returns" not in code and re.search(r"\breturn\b", code):
            code = re.sub(r"\breturn\b", "returns", code, count=1)

        code = re.sub(r"\belsif\b", "else if", code)
        code = re.sub(r"\s*\.\.\s*", " to ", code)

        if inside_signature:
            paren_depth += code.count("(") - code.count(")")
            if paren_depth <= 0 and (re.search(r"\bis\b", code) or code.rstrip().endswith(";")):
                inside_signature = False
                paren_depth = 0

        rewritten.append(code + comment)

    return "".join(rewritten)


def rewrite_path(path: Path) -> bool:
    original = path.read_text(encoding="utf-8")
    updated = rewrite_safe_source(original)
    if updated == original:
        return False
    path.write_text(updated, encoding="utf-8")
    return True


def iter_safe_paths(roots: list[Path]) -> list[Path]:
    paths: list[Path] = []
    for root in roots:
        if root.is_file():
            if root.suffix == ".safe":
                paths.append(root)
            continue
        paths.extend(sorted(root.rglob("*.safe")))
    return sorted(set(paths))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", type=Path, help="optional .safe paths or directories to rewrite")
    parser.add_argument("--check", action="store_true", help="report files that would change without rewriting")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    roots = [path.resolve() for path in (args.paths or list(DEFAULT_ROOTS))]
    changed: list[Path] = []

    for path in iter_safe_paths(roots):
        original = path.read_text(encoding="utf-8")
        updated = rewrite_safe_source(original)
        if updated != original:
            changed.append(path)
            if not args.check:
                path.write_text(updated, encoding="utf-8")

    for path in changed:
        print(path.relative_to(REPO_ROOT))

    if args.check and changed:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
