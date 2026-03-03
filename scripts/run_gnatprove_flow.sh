#!/bin/bash
# Safe Language Annotated SPARK Companion
# run_gnatprove_flow.sh -- Run GNATprove in flow analysis mode (Bronze gate)
#
# Flow analysis checks data dependencies, initialization, and Global/Depends
# contracts.  This corresponds to the Bronze assurance level defined in
# spec/05-assurance.md.
#
# Exit codes:
#   0  -- Flow analysis passed with no errors
#   1  -- Flow analysis reported errors or the tool failed to run

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GPR_FILE="${REPO_ROOT}/companion/gen/companion.gpr"

if [[ ! -f "${GPR_FILE}" ]]; then
    echo "ERROR: Project file not found: ${GPR_FILE}"
    exit 1
fi

echo "================================================================"
echo "  GNATprove Flow Analysis (Bronze Gate)"
echo "  Project: ${GPR_FILE}"
echo "================================================================"
echo ""

# Clean previous results to ensure a fresh analysis
gnatprove -P "${GPR_FILE}" --clean 2>/dev/null || true

echo "Running: gnatprove -P ${GPR_FILE} --mode=flow --report=all --warnings=error"
echo ""

if gnatprove -P "${GPR_FILE}" \
    --mode=flow \
    --report=all \
    --warnings=error \
    2>&1; then
    echo ""
    echo "================================================================"
    echo "  FLOW ANALYSIS: PASSED"
    echo "================================================================"
    exit 0
else
    FLOW_EXIT=$?
    echo ""
    echo "================================================================"
    echo "  FLOW ANALYSIS: FAILED (exit code ${FLOW_EXIT})"
    echo "================================================================"
    echo ""
    echo "Review the GNATprove output above for flow analysis errors."
    echo "Common issues:"
    echo "  - Missing Global contracts"
    echo "  - Uninitialized variables"
    echo "  - Incorrect Depends contracts"
    exit 1
fi
