# Safe Language Specification — Revision Task Prompt

## For use with Claude Code CLI (1M context window)

---

## Your Role

You are a standards editor and language specification engineer. Your task is to apply a prioritized set of patches to the Safe language specification (`safe-spec-prompt.md`) based on the findings of two independent technical reviews:

1. **SPARK 2022 Faithfulness Review** — verified Safe's claims against actual SPARK 2022 / GNATprove capabilities.
2. **Standards Readiness Review** — assessed fitness for eventual ECMA submission, cross-file consistency, and multi-agent implementation ambiguity.

Both reviews converged on the same core issues. Your job is to apply the combined fixes in priority order, preserving the spec's voice and structure.

---

## Context: What Safe Is

Safe is a systems programming language defined *subtractively* from ISO/IEC 8652:2023 (Ada 2022) via the SPARK 2022 restriction profile, with further restrictions and a small number of structural changes (single-file packages, dot-notation attributes, type-annotation syntax, static tasks and typed channels).

The specification is a drafter prompt (`safe-spec-prompt.md`) that defines 29 binding design decisions (D1–D29) plus section-by-section drafting instructions for an LRM structured as:

- `00-front-matter.md` — scope, normative references, conformance overview
- `01-base-definition.md` — Ada-delta type system, expressions, statements
- `02-restrictions.md` — excluded Ada features (exhaustive list)
- `03-single-file-packages.md` — package model
- `04-tasks-and-channels.md` — concurrency
- `05-spark-assurance.md` — Bronze/Silver guarantees
- `06-conformance.md` — what constitutes conforming implementation/program
- `07-annex-a-retained-library.md` — retained standard library
- `07-annex-b-impl-advice.md` — implementation advice
- `08-syntax-summary.md` — authoritative consolidated BNF

The spec currently lives as a single file. Treat the entire file as the working document.

---

## The Problem: Combined Findings from Both Reviews

### P0 — Must Fix (contradictions and missing requirements that break claimed semantics)

#### P0-1. Task Termination vs. Jorvik Profile

**The contradiction:** D28 explicitly says "Tasks may terminate via `return`" and "This goes beyond Ravenscar (which requires tasks to run forever) but stays within Jorvik's capabilities." This claim is **false**. GNAT's documentation for the Jorvik profile shows that `No_Task_Termination` remains part of the profile restriction set — Jorvik removes some Ravenscar restrictions but does NOT remove `No_Task_Termination`. Both reviews independently confirmed this.

Specifically, Jorvik removes these Ravenscar restrictions:
- `Max_Entry_Queue_Length => 1` (allows multiple queued callers)
- `Max_Protected_Entries => 1` (allows multiple entries per PO)
- `Simple_Barriers` (replaced with `Pure_Barriers`)
- `No_Implicit_Heap_Allocations`
- `No_Relative_Delay`
- `No_Dependence => Ada.Calendar`
- `No_Dependence => Ada.Synchronous_Task_Control`

Jorvik RETAINS:
- `Max_Task_Entries => 0`
- `No_Select_Statements`
- `No_Requeue_Statements`
- **`No_Task_Termination`** ← this is the one that matters

**Required fix:** Remove task termination. Prohibit `return` in task bodies. Require non-terminating control structure in every task body. Remove the "Task Termination" subsection (§4.8 content) or replace it with a "reserved" note. Update all downstream references to task termination (the "terminated task" discussion in D28 about owned variables becoming inaccessible, channel endpoints after receiver terminates, etc.).

**Locations to patch in the spec:**
- D28 text: "Tasks may terminate via `return`" → remove/replace
- D28 text: "This goes beyond Ravenscar... but stays within Jorvik's capabilities" → fix the Jorvik characterization
- D28 "Task termination" subsection → replace with non-termination requirement
- Section 04 drafting instructions (§4.8, §4.12, §4.13)
- Any examples showing task `return`

#### P0-2. `access all` in Grammar but Not in Ownership Rules

**The contradiction:** The grammar instructions for `08-syntax-summary.md` include `access_type_definition` which would include `'access' 'all' subtype_indication` (following Ada's grammar). But D17's ownership mapping table only shows `type T_Ptr is access T;` (pool-specific access types). No legality rule addresses `access all` types. SPARK 2022 supports general access types under ownership, but Safe's intentional conservatism (no anonymous access, no access-to-constant, no access-to-subprogram) suggests `access all` should also be excluded.

**Required fix:** Add an explicit exclusion of `access all` types (general access types) to D17 or to the restrictions section. Add a legality rule: "A conforming implementation shall reject access type definitions that include the reserved word `all`." Add rationale: general access types interact with aliased objects and `'Access` attributes, both of which Safe excludes; pool-specific access types are sufficient for Safe's ownership model.

**Locations to patch:**
- D17 "Restrictions vs. full SPARK ownership" bullet list — add `access all` exclusion
- Section 02 (restrictions) drafting instructions — mention in access type restrictions
- Section 08 (grammar) drafting instructions — ensure grammar note reflects this

#### P0-3. Silver Guarantee Not Closed as a Conformance Rule

**The contradiction:** D26 and the §05 section instructions assert "every conforming Safe program is Silver-by-construction." But §05 also says "if a range check cannot be proved from types alone, the developer must restructure the computation to use tighter types or add a conditional guard." This implies the program *could* be accepted in a non-Silver state. The SPARK faithfulness review also identified that D27's claim that GNATprove "trivially discharges" intermediate arithmetic checks for `Wide_Integer` is not universally true — intermediate products of large-range types can approach `Wide_Integer`'s bounds.

**Required fix:** Make the Silver guarantee a hard rejection rule. If a conforming implementation cannot establish absence of a required runtime check failure from the specification's rules, the program is nonconforming and the implementation shall reject it with a diagnostic. Remove the "developer must restructure" language from the normative requirement and move it to implementation advice (informative). Also qualify the "trivially discharged" claim for `Wide_Integer` intermediates — add a note that if intermediate `Wide_Integer` subexpressions could overflow (e.g., products of large-range types), the implementation shall reject the expression.

**Locations to patch:**
- D26 text about developer restructuring
- D27 Rule 1 text about "trivially discharged"
- Section 05 drafting instructions (¶33 equivalent)
- Section 06 drafting instructions (conforming program definition)

#### P0-4. Try\_Send / Try\_Receive Signature Mismatch

**The contradiction:** D28 defines `try_send` and `try_receive` as statements with an out-parameter Boolean:
```
try_send Ch, Value, Success;        -- non-blocking: Success is Boolean
try_receive Ch, Variable, Success;  -- non-blocking: Success is Boolean
```

But the §07-annex-b implementation advice drafting instructions describe the emitted protected object pattern with `Try_Send` / `Try_Receive` as **functions returning Boolean**. SPARK has restrictions on functions with out parameters (they're not allowed in SPARK). The statement syntax with a Boolean out-parameter maps naturally to a **procedure** with an out-parameter in the emitted Ada.

**Required fix:** The emitted Ada pattern must use procedures, not functions. Update the implementation advice section to specify:
```ada
procedure Try_Send (Item : in Element_Type; Success : out Boolean);
procedure Try_Receive (Item : out Element_Type; Success : out Boolean);
```

**Location to patch:**
- Section 07-annex-b drafting instructions (emitted protected object pattern)

#### P0-5. Symbol File Format Contradiction

**The contradiction:** Section 06 conformance drafting instructions say "binary symbol file" in one place and "text-based (UTF-8, line-oriented, versioned header)" in another. Section 07-annex-b also specifies symbol file format details. These are mutually inconsistent.

**Required fix:** From a standards perspective, symbol file format should be implementation-defined. Move all symbol file format details to implementation advice (§07-annex-b) as a recommended practice. In §06, state only that a conforming implementation shall provide a mechanism for separate compilation; symbol files are one permitted mechanism and their format is implementation-defined.

**Locations to patch:**
- Section 06 drafting instructions (symbol file paragraphs)
- Section 07-annex-b drafting instructions (make it the single home for format details)

### P1 — Should Fix (standards editorial structure and missing requirements)

#### P1-1. Normative/Informative Split — Remove Toolchain Coupling from Conformance

**The problem:** The conformance section (§06) currently defines conformance in terms of GNAT/GNATprove: "emitted Ada compiles with GNAT," "passes GNATprove," "compiler written in SPARK at Silver level." ISO Ada explicitly does NOT specify translation means, tool invocation, or output formats. An ECMA-track language standard should define conformance using language properties and legality rules, not specific vendor tools.

**Required fix:** Restructure §06 drafting instructions:
- Conforming implementation requirements: accept all conforming programs, reject all non-conforming programs, implement dynamic semantics correctly. No mention of specific compilers/provers.
- D29 (compiler written in SPARK) is a project requirement, not a language conformance requirement. Move it to implementation advice or a separate "Reference Implementation Profile" section.
- Add a note in the front matter: "Toolchain profiles (e.g., GNAT/GNATprove guidance) are informative and belong in a companion document or informative annex."
- Preserve the GNAT/GNATprove details in §07-annex-b as informative implementation guidance (this information is valuable — don't delete it, relocate it).

**Locations to patch:**
- Front matter (Compatibility Note or new Conformance Note)
- Section 06 drafting instructions
- D29 decision text (relabel as project requirement, not language conformance)
- Section 07-annex-b (receive relocated toolchain material)

#### P1-2. Partition\_Elaboration\_Policy(Sequential) Requirement

**The problem:** D28 promises "Tasks begin executing when the program starts, after all package-level initialization is complete." Ada's default elaboration behavior can activate library tasks before all elaboration completes. SPARK explicitly requires `Partition_Elaboration_Policy(Sequential)` for task/protected usage under Ravenscar/Jorvik to prevent elaboration-time races. The spec doesn't mention this pragma.

**Required fix:** Add `pragma Partition_Elaboration_Policy(Sequential)` to the required emitted Ada configuration. This should appear in:
- D28's SPARK emission description
- Section 04 drafting instructions (implementation requirements)
- Section 07-annex-b (emitted Ada conventions)

The spec should also state the *language-level* requirement independently of the Ada mapping: "All package-level declarations and initializations complete before any task begins execution. The order of package initialization is implementation-defined but deterministic for a given program."

**Locations to patch:**
- D28 "SPARK emission" subsection
- Section 04 drafting instructions
- Section 07-annex-b drafting instructions

#### P1-3. `Wide_Integer` Intermediate Overflow Qualification

**The problem (from SPARK faithfulness review):** D27 Rule 1 states: "All integer subexpressions are lifted to `Wide_Integer` before evaluation... GNATprove discharges intermediate arithmetic trivially because `Wide_Integer` cannot overflow for any operation on narrower types."

This is mostly true but not universally so. For types with ranges approaching 32 bits, products of two values can be large, and chained operations like `A * B + C * D` can approach `Wide_Integer`'s ceiling. The claim "cannot overflow for any operation on narrower types" is misleading for multiplication of large-range types.

**Required fix:** Qualify D27 Rule 1:
- Keep the `Wide_Integer` lifting strategy.
- Replace "cannot overflow" with a more precise statement: "For types whose range fits within 32 bits, intermediate `Wide_Integer` arithmetic cannot overflow for single operations. For chained operations or types with larger ranges, the implementation shall verify that intermediate results remain within `Wide_Integer` range and shall reject expressions where this cannot be established."
- Add a legality rule: if the compiler's analysis determines that any intermediate `Wide_Integer` subexpression could overflow, the expression is rejected with a diagnostic.

**Location to patch:**
- D27 Rule 1 text

#### P1-4. Deallocation Emission Implementation Note

**The problem (from SPARK faithfulness review):** D17 specifies "deallocation occurs automatically when the owning object goes out of scope." The emitted Ada must use `Ada.Unchecked_Deallocation`, which is a generic instantiation. Safe excludes generics from Safe source (D16), but the *emitted Ada* must use them. Also, deallocation must be emitted at every scope exit point (normal exit, `return`, loop `exit`), not just the textual end of the scope.

**Required fix:** Add implementation notes to D17 or section 06/07-annex-b:
- The emitted Ada uses `Ada.Unchecked_Deallocation` generic instantiations. The exclusion of generics (D16) applies to Safe source, not emitted Ada.
- Deallocation must be emitted at every scope exit point including early returns and loop exits.
- GNATprove's leak checking on the emitted Ada provides independent verification of the compiler's deallocation logic.

**Locations to patch:**
- D17 text (add implementation note)
- Section 07-annex-b drafting instructions

### P2 — Nice to Have (additional clarifications)

#### P2-1. TBD Register

Add a TBD register to the front matter listing unresolved items:
- Target platform constraints beyond "Ada compiler exists"
- Performance targets (compile time, proof time, code size)
- Memory model constraints (stack bounds, heap bounds, allocation failure handling)
- Floating-point semantics beyond inheriting Ada's
- Diagnostic catalog and localization
- `Constant_After_Elaboration` aspect — verify whether GNATprove requires it for concurrency analysis of emitted Ada; generate if needed
- Abort handler behavior (language-defined or implementation-defined)
- AST/IR interchange format (if any)

#### P2-2. `Depends` Over-Approximation Note

Add a note to §05 drafting instructions: the compiler-generated `Depends` contracts may be conservatively over-approximate (listing more dependencies than actually exist). This is acceptable for Bronze — GNATprove accepts `Depends` contracts that are supersets of actual dependencies. An implementation may refine precision over time.

#### P2-3. Conformance Levels

Consider adding conformance levels to preserve the safety story through standards refactoring:
- **Safe/Core**: language rules and legality checking only.
- **Safe/Assured**: language rules + verification that every conforming program is free of runtime errors (the Silver guarantee expressed as a language property, validatable by any suitable method).

This prevents the standards-shape refactor from losing the safety guarantee entirely.

#### P2-4. `select` Emission Pattern Latency Note

The polling-with-sleep emission pattern for `select` is pragmatically correct but not zero-overhead — it introduces latency equal to the sleep interval. Add an informative note acknowledging this tradeoff and that implementations may use more efficient patterns (e.g., POSIX `select`-style multiplexing where the target runtime supports it). The spec already says "The implementation may use alternative emission patterns" which covers this, but an explicit note about the latency tradeoff would help implementers.

---

## Execution Instructions

### Step 1: Read the Current Spec

Read `safe-spec-prompt.md` in its entirety. Understand the structure, voice, and editorial conventions.

### Step 2: Apply P0 Patches

Apply all five P0 patches. For each:
1. Identify every location in the file that needs to change.
2. Make the change, preserving the surrounding prose style.
3. Ensure internal consistency — if you change D28 to prohibit task termination, make sure every downstream reference (examples, emission descriptions, conformance) is updated.
4. Do NOT delete rationale text wholesale. Rewrite it to match the new technical position.

### Step 3: Apply P1 Patches

Apply all four P1 patches. The P1-1 (normative/informative split) is the largest structural change:
- Do NOT delete the GNAT/GNATprove material. Relocate it.
- The conformance section drafting instructions should define language conformance in terms of language properties.
- The implementation advice section should receive the relocated toolchain guidance.
- D29 should be reframed: the spec can recommend that a reference implementation be written in SPARK, but this is not a language conformance requirement.

### Step 4: Apply P2 Patches

Apply all four P2 items. These are additive (new notes, new sections, new register).

### Step 5: Consistency Pass

After all patches:
1. Search for any remaining references to task termination, `return` in task bodies, or terminated-task semantics. Remove or update them.
2. Search for "GNATprove" in normative requirements (not in informative advice). Ensure all remaining GNATprove references are in informative/implementation-advice sections.
3. Search for "binary symbol file" — should not appear.
4. Verify the grammar instructions in §08 are consistent with all restriction changes.
5. Verify D28 examples don't show tasks terminating.
6. Verify the D17 ownership table is consistent with the `access all` exclusion.
7. Verify D26/D27 are consistent with the hardened Silver rejection rule.

### Step 6: Output

Produce the revised `safe-spec-prompt.md` as a single file. Also produce a `CHANGELOG.md` summarizing every change made, organized by priority tier (P0/P1/P2), with before/after for each substantive change.

---

## Acceptance Criteria

The revised spec must:

1. **Contain no internal contradictions.** No paragraph shall assert X while another asserts ¬X.
2. **Be faithful to SPARK 2022 capabilities.** Every claim about what Jorvik allows/prohibits, what GNATprove proves, and how ownership works must be verifiable against SPARK 2022 documentation.
3. **Be standards-shaped.** Language conformance must be defined in terms of language properties, not specific tools. Toolchain guidance must be clearly separated as informative.
4. **Preserve the safety story.** The Silver guarantee must survive the refactoring — as a language property with a hard rejection rule, not as a tool invocation.
5. **Be unambiguous for multi-agent implementation.** Two independent compiler teams reading the spec must arrive at the same language semantics (modulo implementation-defined items, which must be explicitly labeled).
6. **Preserve the existing voice and structure.** The spec is well-written. Don't rewrite for style — patch for correctness and completeness.

---

## Key Technical References

When verifying SPARK/Jorvik claims, these are the authoritative sources:

- **Jorvik profile restrictions:** Jorvik removes `Max_Entry_Queue_Length => 1`, `Max_Protected_Entries => 1`, `Simple_Barriers`, `No_Implicit_Heap_Allocations`, `No_Relative_Delay`, `No_Dependence => Ada.Calendar`, `No_Dependence => Ada.Synchronous_Task_Control` from Ravenscar. It RETAINS `No_Task_Termination`, `Max_Task_Entries => 0`, `No_Select_Statements`, `No_Requeue_Statements`.

- **SPARK ownership model:** Pool-specific access types (`access T`) — subject to ownership. General access types (`access all T`) — subject to ownership. Access-to-constant (`access constant T`) — NOT subject to ownership. Anonymous access-to-variable — subject to ownership. Access-to-subprogram — NOT subject to ownership. `Unchecked_Deallocation` — supported with leak verification.

- **SPARK partition elaboration:** SPARK requires `Partition_Elaboration_Policy(Sequential)` for programs using tasks or protected objects. This defers library-level task activation until all library units are elaborated.

- **GNATprove proof levels:** Bronze = `--mode=flow` (flow analysis). Silver = `--mode=prove` (AoRTE — absence of runtime errors). Provers: Alt-Ergo, CVC4, Z3, COLIBRI. `--level=0..4` controls prover effort.

- **AoRTE definition:** Absence of Run-Time Errors — proves that runtime checks (overflow, range, index, division-by-zero, null dereference, discriminant) will never fail, enabling safe removal of runtime checks.

---

## What NOT to Change

- Do not change the overall document structure (the section breakdown 00–08).
- Do not change the BNF notation conventions.
- Do not change D1–D16, D18–D24 (these are unaffected by the reviews).
- Do not add features. This is a correction pass, not a feature pass.
- Do not change the editorial conventions section.
- Do not change the reference documents section.
- Do not rewrite examples that are unrelated to the patches (e.g., the "What Safe Looks Like" section is fine unless it shows task termination).
