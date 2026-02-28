# Safe Language Reference Manual

**Working Draft**

---

## Title

Safe — A Systems Programming Language

## File Extension

`.safe`

---

## Scope

1. This document specifies the Safe programming language, a systems programming language defined subtractively from ISO/IEC 8652:2023 (Ada 2022) via the SPARK 2022 restriction profile, with additional restrictions and structural modifications.

2. Safe is not a new grammar. It is Ada 2022 with features removed and structural reorganizations. This specification references 8652:2023 normatively and states only the delta — the excluded features, the modified features, and the new features (single-file packages and channel-based concurrency).

3. The specification covers:
- The base language definition (Section 1)
- Excluded and modified features (Section 2)
- The single-file package model (Section 3)
- The task and channel concurrency model (Section 4)
- SPARK assurance guarantees (Section 5)
- Conformance requirements (Section 6)
- The retained standard library (Annex A)
- The C interface (Annex B)
- Implementation advice (Annex C)
- The complete grammar (Section 8)

---

## Normative References

4. The following documents are referenced normatively. For dated references, only the edition cited applies.

- **ISO/IEC 8652:2023** — *Information technology — Programming languages — Ada*. This is the base language from which Safe is defined. All references to "8652:2023" in this document refer to this standard.

5. The following documents are referenced informatively:

- **SPARK Reference Manual (SPARK RM)** — *SPARK 2014/2022 Language Reference Manual*, AdaCore. Provides the restriction model precedent for SPARK-specific features referenced in this specification.

- **SPARK User's Guide** — *SPARK 2014 User's Guide*, AdaCore. Provides the feature inventory for the SPARK subset of Ada.

---

## Terms and Definitions

6. For the purposes of this document, the terms and definitions given in 8652:2023 §1.3 apply, with the following additions and modifications:

### Safe program
7. A program written in the Safe language as specified by this document. A Safe program is a valid Ada 2022 program that additionally conforms to the restrictions and modifications specified herein.

### Conforming Safe program
8. A Safe program that satisfies all legality rules in this specification, including the Silver-by-construction rules (Section 2, §2.8). See Section 6, §6.2.

### Conforming implementation
9. A Safe compiler and associated tools that satisfy all requirements in Section 6. See Section 6, §6.1.

### Silver-by-construction
10. The property that a conforming Safe program, when emitted as Ada via `--emit-ada` and submitted to GNATprove, is guaranteed to pass AoRTE (Absence of Runtime Errors) proof at Silver level without user-supplied annotations. This property is guaranteed by the four language rules specified in Section 2, §2.8.

### Channel
11. A typed, bounded-capacity, blocking FIFO queue used for inter-task communication. Channels are first-class language constructs in Safe (Section 4). They are compiled to protected objects in the emitted Ada.

### Ownership
12. The SPARK 2022 model for access types in which each access value has exactly one owning object at any program point. Ownership transfers via move semantics on assignment. See Section 2, §2.3.

### Move
13. Assignment of an access value that transfers ownership from the source to the target. After a move, the source becomes null. See Section 2, §2.3.1.

### Borrow
14. Temporary mutable access to a designated object through an `in out` parameter of access type. During a borrow, the owner's access value is frozen. See Section 2, §2.3.2.

### Observe
15. Temporary read-only access to a designated object through an `in` parameter of access type. During an observation, the owner's access value is frozen against writes and moves. See Section 2, §2.3.3.

### Symbol file
16. A binary file produced by the compiler for each compiled package, containing the public interface information needed by client packages. See Section 3, §3.3 and Section 6, §6.3.2.

### Wide intermediate arithmetic
17. The evaluation model in which integer arithmetic expressions are computed in a mathematical integer type (no overflow), with range checks deferred to narrowing points. See Section 2, §2.8.1.

---

## Method of Description

18. This specification uses the method of description defined in 8652:2023 §1.1.4, with the following conventions:

19. **BNF notation:** Grammar productions use the BNF conventions of 8652:2023 §1.1.4:
- `::=` for productions
- `[ ]` for optional elements
- `{ }` for zero or more repetitions
- `|` for alternation
- Keywords in **bold** (rendered as lowercase in source code)
- Nonterminals in *italic* or `snake_case`

20. The complete consolidated grammar for Safe is provided in Section 8.

21. **Section structure:** Each language feature is described using the following subsections, consistent with 8652:2023:
- **Syntax** — BNF grammar productions
- **Legality Rules** — compile-time requirements ("shall")
- **Static Semantics** — meaning established at compile time
- **Dynamic Semantics** — meaning established at run time
- **Implementation Requirements** — requirements on the implementation
- **Examples** — illustrative code (non-normative)

22. **Normative voice:**
- "shall" — a binding requirement
- "may" — a permission
- "should" — a recommendation (non-normative)

23. **Paragraph numbering:** Every normative paragraph is numbered sequentially within each section.

24. **Cross-references:** References to 8652:2023 use the form "8652:2023 §N.N(P)" where N.N is the section number and P is the paragraph number. References within this specification use the form "Section N, §N.N".

---

## Document Structure

25. This specification consists of the following sections:

| Section | Title | Description |
|---|---|---|
| 0 | Front Matter | This section: scope, references, terms, conventions |
| 1 | Base Definition | Safe as a delta from 8652:2023 |
| 2 | Restrictions | Excluded and modified features, Silver-by-construction rules |
| 3 | Single-File Packages | Package model, visibility, dot notation, type annotations |
| 4 | Tasks and Channels | Concurrency model replacing Ada Section 9 |
| 5 | SPARK Assurance | Bronze and Silver guarantees, concurrency assurance |
| 6 | Conformance | Implementation requirements, backends, compiler verification |
| A | Retained Library | Annex A library unit classification |
| B | C Interface | Annex B interface to C |
| C | Implementation Advice | Non-normative guidance |
| 8 | Syntax Summary | Complete consolidated BNF grammar |

---

## Summary of Design Decisions

26. The Safe language design is governed by 29 design decisions, documented in full in the Safe Language Specification Drafter Prompt. The following table summarizes each decision:

| ID | Decision | Key Effect |
|---|---|---|
| D1 | Subtractive definition from 8652:2023 | ~80–110 page spec, not 300+ |
| D2 | SPARK 2022 as restriction baseline | Proven subset, ownership for access types |
| D3 | Single-pass recursive descent compiler | ~12,000–17,000 LOC compiler |
| D4 | C99 as primary code generation target | Platform-independent compiler |
| D5 | OpenBSD as initial target | Strict security, self-contained toolchain |
| D6 | Single-file packages (no .ads/.adb split) | Compiler extracts interface |
| D7 | Flat, purely declarative packages | No elaboration ordering |
| D8 | Default-private, `public` annotation | Secure-by-default visibility |
| D9 | Opaque types via `private record` | Information hiding without separate spec |
| D10 | Subprogram bodies at point of declaration | No signature duplication |
| D11 | Interleaved declarations and statements | Declare at point of use |
| D12 | No overloading | Unambiguous name resolution |
| D13 | No general `use` clauses; `use type` retained | No name pollution |
| D14 | No exceptions | No hidden control flow |
| D15 | Restricted tasking — static tasks and channels | Provable concurrency |
| D16 | No generics | No instantiation pass |
| D17 | Access types with SPARK ownership | Safe dynamic data structures |
| D18 | No tagged types or dynamic dispatch | All calls resolve statically |
| D19 | No contracts — `pragma Assert` instead | Simplicity; Bronze/Silver automatic |
| D20 | Dot notation for attributes (no tick) | Universal, simpler lexer |
| D21 | Type annotation syntax (no qualified expressions) | Left-to-right reading |
| D22 | Eliminated SPARK verification-only aspects | Auto-generated by `--emit-ada` |
| D23 | Retained Ada features | Rich type system, FFI, goto |
| D24 | System sublanguage — deferred | Safe floor first |
| D25 | Ada emission as secondary backend | Full Ada ecosystem access |
| D26 | Guaranteed Bronze and Silver SPARK assurance | Zero-annotation verification |
| D27 | Silver-by-construction rules | Wide arithmetic, strict indexing, nonzero division, not-null dereference |
| D28 | Static tasks and typed channels | Channel-based concurrency, Jorvik mapping |
| D29 | Compiler written in Silver-level SPARK | Verifiable compiler |
