# Findings — Issues Discovered in SPEC-PROMPT.md

**These findings are flagged for human review. No patches have been applied to SPEC-PROMPT.md.**

---

## F1. `abstract` in Grammar Despite Being Excluded — RESOLVED

**Location:** D18 (No Tagged Types), D23 (Retained Ada Features)

**Issue:** The 8652:2023 grammar for `record_type_definition` includes `[ 'abstract' ] 'limited'` as an optional prefix. Since abstract types are excluded by D18, the `abstract` keyword should not appear in the Safe grammar's record type productions. However, removing it creates a divergence from the 8652:2023 production structure that could confuse readers comparing the two grammars.

**Resolution:** Removed `abstract` from the `record_type_definition` production in §08 (syntax summary). The production now reads `[ 'limited' ] record_definition`. The `abstract` keyword remains reserved (per the policy that all Ada 2022 reserved words stay reserved in Safe) but no longer appears in any grammar production. The §02 paragraph 7 legality rule rejecting `abstract` type declarations is unchanged — it now serves as belt-and-suspenders reinforcement rather than the sole enforcement mechanism. This is consistent with how every other excluded feature (generics, tagged types, exceptions, etc.) was handled: productions removed from §08, legality rules in §02 for completeness.

---

## F2. `delay until` Time Type Unspecified — RESOLVED

**Location:** D23 (Retained Ada Features), D28 (section on delay in select arms)

**Issue:** `delay until` is retained and appears in the grammar and in §04 select statement delay arms. However, `delay until` in 8652:2023 requires a time value (typically `Ada.Calendar.Clock` or `Ada.Real_Time.Clock`). Both `Ada.Calendar` and `Ada.Real_Time` are excluded (Annex A). SPEC-PROMPT.md retains `delay Duration_Expression` but does not explicitly address the time type for `delay until`.

**Resolution:** Excluded `delay until` entirely. Only the relative delay `delay Duration_Expression;` is retained. Changes applied: §08 grammar (removed `'delay' 'until' expression ';'` alternative), §02 paragraph 60 (exclusion with legality rule and rationale), §02 paragraph 86 (removed implementation-defined time type note), Annex A paragraph 59 (removed shall-provide-time-type requirement), §06 (removed time type from implementation-defined items list and narrowed runtime requirement to relative `delay` only). Rationale: with both `Ada.Calendar` and `Ada.Real_Time` excluded, no language-defined time type exists for absolute delays; relative delays via `Duration` cover the primary use cases (periodic task loops, select timeouts). A future revision may reintroduce `delay until` alongside a minimal monotonic time package if absolute timing proves necessary.

---

## F3. Quantified Expressions Exclusion vs. SPARK Subset — RESOLVED (no spec change)

**Location:** D23 (Retained Ada Features), implied by "All Ada 2022 features in the SPARK 2022 subset not otherwise excluded"

**Issue:** Quantified expressions (`for all`, `for some`) are part of the SPARK 2022 subset. D23 states "All Ada 2022 features in the SPARK 2022 subset not otherwise excluded" are retained. However, quantified expressions are primarily useful in contracts, which are excluded (D19). The generated spec excludes them (§02 paragraph 22), but SPEC-PROMPT.md does not explicitly list them as excluded.

**Resolution:** The generated spec correctly excludes quantified expressions in §02 paragraph 22 with appropriate rationale, and §08 contains no `quantified_expression` production. The spec is internally consistent. The gap is in SPEC-PROMPT.md only (quantified expressions should be added to D19's exclusion list for clarity). No spec changes required. While `for all`/`for some` can technically appear in ordinary boolean expressions, their primary utility is in contracts, type predicates, and loop invariants — all excluded. Their marginal value in ordinary `if` conditions does not justify the compiler complexity of implicit iteration in expression position.

---

## F4. D17 Ownership Table Column for Emitted Ada — RESOLVED (no spec change)

**Location:** D17 Ownership model summary table

**Issue:** The D17 table in SPEC-PROMPT.md has two columns: "Safe construct" and "Ownership semantics." Previous revisions (per CHANGELOG.md) removed the "Emitted Ada" column as part of the tool-independence refactoring. However, the table entry for `procedure P (A : in T_Ptr)` says "Read-only access: caller's ownership frozen" — this is described as "observing" in §2.3 but the table says "Read-only access." The terminology is inconsistent between the table summary and the detailed ownership rules.

**Resolution:** The generated spec's §02 §2.3 ownership table (paragraph 95) and detailed rules (§2.3.2–§2.3.4) use consistent terminology throughout: "Owner," "Local borrower," "Local observer," "borrow," "observe," "move." The terminology inconsistency exists only in SPEC-PROMPT.md's D17 summary table, not in the generated spec. SPEC-PROMPT.md should align its D17 table with the formal terms for clarity, but no spec changes are required.

---

## F5. `Convention` Pragma Listed in Both Retained and Excluded — RESOLVED

**Location:** §02 Pragma Inventory generation

**Issue:** SPEC-PROMPT.md §D24 excludes all foreign language interface including `pragma Convention`. However, `Convention` could be argued as retained for the `Convention(Ada, ...)` case, which is the default. The generated spec listed it as excluded (under paragraph 84, Annex B exclusion), but it also appeared in the retained pragmas table (§2.6.1 paragraph 121) with a cross-reference "Excluded — see paragraph 84," which was confusing.

**Resolution:** Removed `Convention` and `Linker_Options` from the retained pragma table (§2.6.1) and added them to the excluded pragma table (§2.6.2) with rationale "Requires foreign language interface." `Convention(Ada, ...)` is the default convention and never needs explicit statement — Ada types have Ada convention automatically. There is no use case for the pragma in Safe source. Each pragma now appears in exactly one table.

---

## F6. `Normalize_Scalars` Ambiguity — RESOLVED (no spec change)

**Location:** Pragma inventory

**Issue:** The prior spec-analysis.md noted that `Normalize_Scalars` appeared in both retained and excluded categories in a previous generation. SPEC-PROMPT.md does not explicitly classify it. Annex H is mostly excluded (§02 paragraph 90), but `Normalize_Scalars` is a standalone pragma (§H.1) that could be useful for initialisation safety.

**Resolution:** The generated spec correctly excludes `Normalize_Scalars` in §02 §2.6.2 (paragraph 122) with rationale: "Implementation concern; may mask uninitialised reads." This is the right call — `Normalize_Scalars` silently initialises variables to out-of-range trap values, which masks the uninitialised-read bugs that Safe's Silver guarantee is designed to catch statically. The pragma appears in exactly one table (excluded). SPEC-PROMPT.md should add this to its explicit exclusion list for clarity, but no spec changes are required.

---

## F7. `from` as Reserved Word — RESOLVED

**Location:** D28 grammar additions, Reserved Words section

**Issue:** SPEC-PROMPT.md's reserved words section lists `public`, `channel`, `send`, `receive`, `try_send`, `try_receive`, `capacity` as new reserved words. However, the D28 grammar for `channel_arm` uses `from` as a keyword: `'when' identifier ':' type_mark 'from' channel_name`. The reserved words section does not list `from` as a new reserved word. `from` is not an Ada 2022 reserved word either (it does not appear in 8652:2023 §2.9).

**Resolution:** Added `from` to the Safe additional reserved words list in both §02 paragraph 3 and §08 §8.15. The list now reads: `public`, `channel`, `send`, `receive`, `try_send`, `try_receive`, `capacity`, `from`. SPEC-PROMPT.md should also be updated to include `from` in its reserved words section.

---

## F8. Subprogram Forward Declaration `public` Placement — RESOLVED

**Location:** D10 (Subprogram Bodies at Point of Declaration)

**Issue:** SPEC-PROMPT.md states forward declarations are permitted for mutual recursion but does not specify whether the `public` keyword appears on the forward declaration, the completing body, or both. The generated spec resolved this in §03 paragraph 14 but the original wording was ambiguous.

**Resolution:** Clarified §03 paragraph 14 to state unambiguously: `public` appears on the forward declaration only; the completing body shall not repeat `public`; a conforming implementation shall reject a completing body bearing `public` when a forward declaration exists. This matches the principle that visibility is established at first declaration. SPEC-PROMPT.md should add this clarification to D10.

---

## F9. Task Body Declarative Part Placement — RESOLVED (no spec change)

**Location:** D28 task declaration grammar

**Issue:** SPEC-PROMPT.md's D28 grammar has no `declarative_part` before `begin` in the task declaration, but D28 prose says "Declarations may precede the loop" and the non-termination rule says "Declarations may precede the outermost loop."

**Resolution:** The generated spec grammar (§08 §8.12) includes `[ declarative_part ]` before `begin` in the task declaration, matching the pattern used for subprogram bodies. This gives task bodies the same structure as subprogram bodies: an optional pre-`begin` declarative part plus interleaved declarations after `begin` (per D11). The spec is internally consistent. SPEC-PROMPT.md's D28 grammar should be updated to include `[ declarative_part ]` for consistency with the prose, but no spec changes are required.

---

## F10. Allocation Failure Semantics — RESOLVED

**Location:** D17, D27

**Issue:** SPEC-PROMPT.md specifies automatic deallocation but does not address what happens when `new` fails to allocate memory. In 8652:2023, this raises `Storage_Error`, which is an exception — and exceptions are excluded. The Silver guarantee (D27) does not address allocation failure.

**Resolution:** Added normative paragraph 103a to §02 §2.3.5 specifying that allocation failure invokes the runtime abort handler with a source location diagnostic, consistent with the error model for `pragma Assert` failure. Both are non-recoverable conditions that terminate the program. This replaces 8652:2023's `Storage_Error` exception with a hard abort. TBD-03 remains open for future work on static allocation bounding as a potential Safe/Assured enhancement.

---

## F11. `Channel_Id.Range` Attribute — RESOLVED (false positive)

**Location:** Quick Reference example in SPEC-PROMPT.md

**Issue:** The quick reference example uses `Channel_Id.Range` as an attribute in a for loop: `for I in Channel_Id.Range loop`. The finding claimed that `Range` is an attribute of array types only (§3.6.2), not of scalar types.

**Resolution:** This finding is incorrect. 8652:2023 §3.5(14) explicitly defines `S'Range` for any scalar subtype S as equivalent to `S'First .. S'Last`. The generated spec's retained attribute table (§02 §2.5) correctly lists `Range` with references to both §3.5(14) (scalar types) and §3.6.2(7) (array types). `Channel_Id.Range` (in Safe dot notation) is valid Ada and valid Safe. No changes required.

---

## F12. Missing D3/D4/D5/D25/D29 in Specification — RESOLVED

**Location:** SPEC-PROMPT.md Design Decisions

**Issue:** SPEC-PROMPT.md defines decisions D1, D2, D6–D28 in the main Design Decisions section. D3, D4, D5, D25, and D29 were moved to DEFERRED-IMPL-CONTENT.md as implementation-profile decisions, creating numbering gaps that could confuse readers.

**Resolution:** Added an explanatory note to §00 paragraph 26 identifying the missing decision numbers (D3, D4, D5, D25, D29) as reclassified implementation-profile decisions, stating the gaps are intentional and preserved for traceability. Renumbering was not chosen because it would break cross-references in DEFERRED-IMPL-CONTENT.md, CHANGELOG.md, and any external documents referencing the original D-numbers.
