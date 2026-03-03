#!/bin/bash
# Safe Language Annotated SPARK Companion
# spec2spark.sh -- Placeholder for future code generation from spec to SPARK
#
# This script will eventually generate Ada/SPARK source files from the
# Safe language specification.  For now it validates the commit SHA argument
# and reports that generation is not yet implemented.
#
# Usage: scripts/spec2spark.sh <commit-sha>

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [[ $# -lt 1 ]]; then
    echo "ERROR: spec2spark.sh requires a commit SHA argument."
    echo "Usage: $0 <commit-sha>"
    exit 1
fi

SPEC_SHA="$1"
FROZEN_SHA="$(cat "${REPO_ROOT}/meta/commit.txt" | tr -d '[:space:]')"

echo "spec2spark v0.1.0"
echo "  Spec commit (requested): ${SPEC_SHA}"
echo "  Spec commit (frozen):    ${FROZEN_SHA}"

if [[ "${SPEC_SHA}" != "${FROZEN_SHA}" && "${SPEC_SHA}" != "${FROZEN_SHA:0:7}" ]]; then
    echo "WARNING: Requested SHA does not match frozen commit."
    echo "         Proceeding, but generated artifacts may be inconsistent."
fi

echo ""
echo "NOTE: Code generation from spec to SPARK is not yet implemented."
echo "      The companion/spark/ directory contains hand-written SPARK sources"
echo "      that were authored to match the specification at commit ${FROZEN_SHA:0:7}."
echo ""
echo "      Future versions of this script will:"
echo "        1. Parse spec/*.md to extract normative clauses"
echo "        2. Generate Safe_Model and Safe_PO Ada/SPARK packages"
echo "        3. Embed clause IDs and assumption references in headers"
echo ""
echo "spec2spark: OK (placeholder -- no files generated)"
exit 0
