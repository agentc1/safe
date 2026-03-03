#!/bin/bash
# Safe Language Annotated SPARK Companion
# run_gnatprove_prove.sh -- Run GNATprove in prove mode (Silver gate)
#
# Proof mode verifies functional contracts (Pre/Post), absence of runtime
# errors (AoRTE), and all verification conditions.  This corresponds to the
# Silver assurance level defined in spec/05-assurance.md.
#
# Exit codes:
#   0  -- All proofs discharged successfully
#   1  -- One or more VCs remain unproved, or the tool failed

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GPR_FILE="${REPO_ROOT}/companion/gen/companion.gpr"

if [[ ! -f "${GPR_FILE}" ]]; then
    echo "ERROR: Project file not found: ${GPR_FILE}"
    exit 1
fi

echo "================================================================"
echo "  GNATprove Proof Analysis (Silver Gate)"
echo "  Project: ${GPR_FILE}"
echo "  Level: 2"
echo "================================================================"
echo ""

# Clean previous results to ensure a fresh analysis
gnatprove -P "${GPR_FILE}" --clean 2>/dev/null || true

echo "Running: gnatprove -P ${GPR_FILE} --mode=prove --level=2 --prover=cvc5,z3,altergo --steps=0 --timeout=120 --report=all --warnings=error --checks-as-errors=on"
echo ""

if gnatprove -P "${GPR_FILE}" \
    --mode=prove \
    --level=2 \
    --prover=cvc5,z3,altergo \
    --steps=0 \
    --timeout=120 \
    --report=all \
    --warnings=error \
    --checks-as-errors=on \
    2>&1; then
    echo ""
    echo "================================================================"
    echo "  PROOF ANALYSIS: PASSED"
    echo "  All verification conditions discharged at level 2."
    echo "================================================================"
    exit 0
else
    PROVE_EXIT=$?
    echo ""
    echo "================================================================"
    echo "  PROOF ANALYSIS: FAILED (exit code ${PROVE_EXIT})"
    echo "================================================================"
    echo ""
    echo "Review the GNATprove output above for unproved VCs."
    echo "Common issues:"
    echo "  - Insufficient preconditions"
    echo "  - Postconditions that cannot be established"
    echo "  - Arithmetic overflow in intermediate expressions"
    echo "  - Prover timeout (try increasing --level or --timeout)"
    echo ""

    # Attempt to print a summary from the gnatprove output directory
    PROVE_OUT="${REPO_ROOT}/companion/gen/obj/gnatprove"
    if [[ -d "${PROVE_OUT}" ]]; then
        echo "GNATprove output directory: ${PROVE_OUT}"
        # Count unproved checks if the summary file exists
        SUMMARY_FILE="${PROVE_OUT}/gnatprove.out"
        if [[ -f "${SUMMARY_FILE}" ]]; then
            echo ""
            echo "--- Proof Summary ---"
            cat "${SUMMARY_FILE}"
        fi
    fi

    exit 1
fi
