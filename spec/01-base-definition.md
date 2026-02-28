# Section 1 — Base Language Definition

1. The Safe language is defined as ISO/IEC 8652:2023 (Ada 2022), as restricted by Section 2 and modified by Sections 3–4 of this document.

2. All syntax, legality rules, static semantics, dynamic semantics, and implementation requirements of 8652:2023 apply except where explicitly excluded or modified by this specification.

3. Where this specification is silent on a language feature, the rules of 8652:2023 govern. A feature that is neither excluded (Section 2) nor modified (Sections 3–4) is retained exactly as specified in 8652:2023.

4. The retained feature set corresponds to the SPARK 2022 subset of Ada 2022, with additional restrictions (Section 2, §2.1), four new legality rules for Silver-by-construction guarantees (Section 2, §2.8), structural modifications for single-file packages (Section 3), and a channel-based concurrency model replacing full Ada tasking (Section 4).

5. The following sections of 8652:2023 are modified or replaced by this specification:

| 8652:2023 Section | Status in Safe | This Specification |
|---|---|---|
| §3.9 Tagged Types | Excluded | Section 2, §2.1.1 |
| §3.10 Access Types | Modified (ownership) | Section 2, §2.3 |
| §4.1.4 Attributes | Modified (dot notation) | Section 2, §2.4.1 |
| §4.5 Operators | Modified (wide intermediates) | Section 2, §2.8.1 |
| §4.7 Qualified Expressions | Replaced (type annotations) | Section 2, §2.4.2 |
| §6.6 Operator Overloading | Excluded | Section 2, §2.1.4 |
| §7 Packages | Modified (single-file) | Section 3 |
| §8.4 Use Clauses | Modified (use type only) | Section 2, §2.1.6 |
| §8.6 Overload Resolution | Simplified | Section 2, §2.1.6 |
| §9 Tasks and Synchronization | Replaced (channels) | Section 4 |
| §11 Exceptions | Excluded | Section 2, §2.1.9 |
| §12 Generic Units | Excluded | Section 2, §2.1.10 |

6. All other sections of 8652:2023 apply as written, subject to the individual construct exclusions detailed in Section 2.
