# Section 2 — Restrictions

1. This section specifies every feature of ISO/IEC 8652:2023 that is excluded or modified in Safe. The section is organized by the corresponding section of 8652:2023. A feature not listed here is retained as specified in 8652:2023.

2. A conforming implementation shall reject any program that uses an excluded feature. Rejection shall occur at compile time with a diagnostic that identifies the excluded construct and references this section.

---

## 2.1 Excluded Features

### 2.1.1 Section 3 — Declarations and Types

#### 3.2.4 Subtype Predicates

3. **8652:2023 Reference:** §3.2.4

4. **Legality Rule:** `Static_Predicate` and `Dynamic_Predicate` aspects are not permitted. A conforming implementation shall reject any subtype declaration bearing a `Static_Predicate` or `Dynamic_Predicate` aspect.

5. **Rationale:** Predicate aspects are excluded as contract features (D19). Subtype constraints (`range`, index constraints, discriminant constraints) provide the necessary type-level restrictions.

#### 3.4 Derived Types — Restricted

6. **8652:2023 Reference:** §3.4

7. **Legality Rule:** Derived type declarations are permitted only for non-tagged types. A derived type declaration shall not derive from a tagged type, an interface type, or a class-wide type. A conforming implementation shall reject any `type T is new Tagged_Parent ...` or type extension declaration.

8. **Note:** Simple derived types from non-tagged parents (e.g., `type Meters is new Integer range 0 .. 10_000;`) are retained.

#### 3.9 Tagged Types and Type Extensions

9. **8652:2023 Reference:** §3.9, §3.9.1, §3.9.2, §3.9.3, §3.9.4

10. **Legality Rule:** Tagged type declarations, type extensions, dispatching operations, class-wide types (`T'Class`), abstract types, abstract subprograms, and interface types are not permitted. A conforming implementation shall reject any `tagged record`, `type T is new Parent with ...`, `type T is abstract ...`, `type T is interface`, or class-wide name.

11. **Related exclusions:**
- Extension aggregates (§4.3.2) — excluded (require type extensions)
- Dispatching calls (§3.9.2) — excluded (require tagged types)
- `Tag` attribute (§13.3) — excluded
- `External_Tag` attribute (§13.3) — excluded
- `Ada.Tags` (§3.9) — excluded

#### 3.10 Access Types — Modified

12. **8652:2023 Reference:** §3.10, §3.10.1, §3.10.2

13. **Legality Rule:** Access-to-object types are retained with SPARK 2022 ownership and borrowing rules (see §2.3). Access-to-subprogram types are not permitted. A conforming implementation shall reject any `access function`, `access procedure`, or access-to-subprogram type declaration.

14. **Legality Rule:** `Unchecked_Deallocation` (§13.11.2) is not permitted. Deallocation occurs automatically when the owning object goes out of scope. A conforming implementation shall reject any instantiation of `Ada.Unchecked_Deallocation`.

15. **Legality Rule:** The `Unchecked_Access` attribute (§13.10) is not permitted. A conforming implementation shall reject any use of `.Unchecked_Access` (see §2.5 for dot notation).

16. **Related exclusions:**
- Storage pools (§13.11) — excluded
- Storage subpools (§13.11.4) — excluded
- `Storage_Pool` attribute — excluded
- `Storage_Size` attribute on access types — excluded
- User-defined storage management — excluded
- `Ada.Unchecked_Deallocation` — excluded
- `Ada.Unchecked_Conversion` — excluded (see §2.1.5)

#### 3.11 Declarative Parts — Modified

17. **8652:2023 Reference:** §3.11

18. **Modification:** Within subprogram bodies, declarations and statements may interleave freely after `begin` (D11). See Section 3 of this document for the complete specification.

---

### 2.1.2 Section 4 — Names and Expressions

#### 4.1.4 Attributes — Modified

19. **8652:2023 Reference:** §4.1.4

20. **Modification:** Ada's tick notation for attributes (`X'Attr`) is replaced by dot notation (`X.Attr`). See §2.4 for the complete specification. The apostrophe (`'`) is used only for character literals.

#### 4.1.5 User-Defined References

21. **8652:2023 Reference:** §4.1.5

22. **Legality Rule:** User-defined references (the `Implicit_Dereference` aspect) are not permitted. A conforming implementation shall reject any aspect specification for `Implicit_Dereference`.

23. **Rationale:** User-defined references require tagged types and generics, both of which are excluded.

#### 4.1.6 User-Defined Indexing

24. **8652:2023 Reference:** §4.1.6

25. **Legality Rule:** User-defined indexing (the `Constant_Indexing` and `Variable_Indexing` aspects) is not permitted. A conforming implementation shall reject any aspect specification for `Constant_Indexing` or `Variable_Indexing`.

26. **Rationale:** User-defined indexing requires tagged types and generics, both of which are excluded.

#### 4.3.2 Extension Aggregates

27. **8652:2023 Reference:** §4.3.2

28. **Legality Rule:** Extension aggregates are not permitted. A conforming implementation shall reject any `(Parent_Expression with ...)` aggregate form.

29. **Rationale:** Extension aggregates require type extensions, which require tagged types.

#### 4.3.5 Container Aggregates

30. **8652:2023 Reference:** §4.3.5

31. **Legality Rule:** Container aggregates are not permitted. A conforming implementation shall reject any aggregate using the `Aggregate` aspect.

32. **Rationale:** Container aggregates require tagged types and generics, both of which are excluded.

#### 4.5.7 Conditional Expressions — Retained

33. **8652:2023 Reference:** §4.5.7

34. **Note:** `if` expressions and `case` expressions are retained as specified in 8652:2023.

#### 4.5.8 Quantified Expressions

35. **8652:2023 Reference:** §4.5.8

36. **Legality Rule:** Quantified expressions are not permitted. A conforming implementation shall reject any `for all` or `for some` expression.

37. **Rationale:** Quantified expressions exist primarily for contract assertions and proof. With contracts excluded (D19), they serve no purpose.

#### 4.5.9 Declare Expressions

38. **8652:2023 Reference:** §4.5.9

39. **Note:** Declare expressions are retained if they are part of the SPARK 2022 subset. A conforming implementation shall support `(declare ... begin ...)` expressions.

#### 4.5.10 Reduction Expressions

40. **8652:2023 Reference:** §4.5.10

41. **Legality Rule:** Reduction expressions (`Reduce` attribute) are not permitted. A conforming implementation shall reject any use of the `Reduce` attribute.

42. **Rationale:** Reduction expressions are syntactic sugar requiring iterator infrastructure that depends on generics.

#### 4.6 Type Conversions — Retained

43. **8652:2023 Reference:** §4.6

44. **Note:** Type conversions are retained. View conversions for tagged types are excluded (as tagged types are excluded). Numeric type conversions, enumeration type conversions, and array type conversions are retained.

#### 4.7 Qualified Expressions — Replaced

45. **8652:2023 Reference:** §4.7

46. **Modification:** Qualified expression syntax (`T'(Expression)`) is replaced by type annotation syntax (`Expression : Type`). See §2.4.2 for the complete specification.

47. **Legality Rule:** A conforming implementation shall reject any qualified expression using tick-parenthesis notation. The type annotation form shall be used instead.

---

### 2.1.3 Section 5 — Statements

#### 5.5.1–5.5.3 Iterator Types and Generalized Iteration

48. **8652:2023 Reference:** §5.5.1, §5.5.2, §5.5.3

49. **Legality Rule:** User-defined iterator types (§5.5.1), generalized loop iteration over containers (§5.5.2), and procedural iterators (§5.5.3) are not permitted. A conforming implementation shall reject any loop using a user-defined iterator protocol.

50. **Note:** Standard `for I in Range` and `for I in T.First .. T.Last` loops are retained. Array component iteration (`for E of Array_Name`) is retained if part of the SPARK 2022 subset.

#### 5.6 Block Statements — Retained

51. **8652:2023 Reference:** §5.6

52. **Note:** Block statements are retained. Exception handlers within block statements are excluded (see §2.1.4).

#### 5.7 Exit Statements — Retained

53. **8652:2023 Reference:** §5.7

54. **Note:** Exit statements are retained as specified in 8652:2023.

#### 5.8 Goto Statements — Retained

55. **8652:2023 Reference:** §5.8

56. **Note:** Goto statements are retained as specified in 8652:2023.

---

### 2.1.4 Section 6 — Subprograms

#### 6.1.1 Preconditions and Postconditions

57. **8652:2023 Reference:** §6.1.1

58. **Legality Rule:** The `Pre`, `Pre'Class`, `Post`, `Post'Class`, and `Contract_Cases` aspects are not permitted. A conforming implementation shall reject any subprogram declaration bearing these aspects.

59. **Rationale:** Contract aspects are excluded (D19). `pragma Assert` provides runtime checking. Bronze and Silver SPARK assurance is guaranteed by compiler-generated annotations and D27 language rules.

#### 6.1.2 Global and Global'Class Aspects

60. **8652:2023 Reference:** §6.1.2

61. **Legality Rule:** Developer-written `Global` and `Global'Class` aspects are not permitted in Safe source code. A conforming implementation shall reject any subprogram declaration bearing a `Global` or `Global'Class` aspect.

62. **Note:** The `--emit-ada` backend automatically generates `Global` aspects from the compiler's name resolution analysis (D22, D26).

#### 6.3.1 Conformance Rules — Modified

63. **8652:2023 Reference:** §6.3.1

64. **Modification:** The conformance rules for matching a subprogram declaration with its body are simplified: since subprogram bodies appear at the point of declaration (D10), there is no separate specification-to-body matching. Forward declarations for mutual recursion follow the existing conformance rules of 8652:2023 §6.3.1.

#### 6.5.1 Nonreturning Subprograms — Retained

65. **8652:2023 Reference:** §6.5.1

66. **Note:** The `No_Return` aspect is retained. It is required for the runtime abort handler invoked by failed `pragma Assert`.

#### 6.6 Overloading of Operators — Excluded

67. **8652:2023 Reference:** §6.6

68. **Legality Rule:** User-defined operator declarations are not permitted. A conforming implementation shall reject any `function "+"`, `function "*"`, or other operator symbol declaration. Predefined operators for language-defined types are retained.

69. **Rationale:** Operator overloading is a form of overloading (D12). Predefined operators are retained because they are not user-declared.

#### 6.6 Subprogram Overloading — Excluded

70. **8652:2023 Reference:** §8.6 (overload resolution)

71. **Legality Rule:** Subprogram name overloading is not permitted. Each subprogram identifier shall denote exactly one subprogram within a given declarative region. A conforming implementation shall reject any declaration that would create an overloaded subprogram name within the same declarative region. Predefined operators for language-defined types are not subject to this restriction.

72. **Rationale:** Overloading is the primary obstacle to single-pass compilation (D12). Without overloading, every call resolves to exactly one entity.

---

### 2.1.5 Section 7 — Packages — Modified

73. **8652:2023 Reference:** §7.1, §7.2, §7.3, §7.3.1, §7.3.2

74. **Modification:** The package model is replaced by the single-file package model specified in Section 3 of this document (D6, D7, D8, D9, D10). The following 8652:2023 constructs are excluded:

75. **Legality Rule:** The following are not permitted:
- `package body` as a separate construct (§7.2) — the package is a single flat structure
- Package-level `begin ... end` initialization blocks (§7.2) — packages are purely declarative
- The `private` section divider (§7.3) — replaced by `public` annotation (D8)
- Private type extensions (§7.3) — require tagged types
- Type invariants (§7.3.2) — excluded as contract features (D19)
- Deferred constants (§7.4) — require separate spec and body

76. **Note:** The single-file package model is fully specified in Section 3. Child packages and hierarchical package names are retained.

#### 7.5 Limited Types — Retained

77. **8652:2023 Reference:** §7.5

78. **Note:** Limited types are retained as specified in 8652:2023. Limited types with access-type components follow the SPARK ownership rules.

#### 7.6 Assignment and Finalization

79. **8652:2023 Reference:** §7.6, §7.6.1

80. **Legality Rule:** Controlled types (`Ada.Finalization.Controlled`, `Ada.Finalization.Limited_Controlled`) are not permitted. A conforming implementation shall reject any type derivation from `Ada.Finalization.Controlled` or `Ada.Finalization.Limited_Controlled`.

81. **Rationale:** Finalization requires runtime support for finalization lists and exception handling during finalization. Access type deallocation is handled by scope-based automatic deallocation under the ownership model.

---

### 2.1.6 Section 8 — Visibility Rules

#### 8.4 Use Clauses — Modified

82. **8652:2023 Reference:** §8.4

83. **Legality Rule:** General `use` clauses (`use Package_Name;`) are not permitted. A conforming implementation shall reject any `use` clause that is not a `use type` clause.

84. **Note:** `use type` clauses (`use type Package_Name.Type_Name;`) are retained. They make predefined operators available in operator notation without importing all visible declarations.

#### 8.5.2 Exception Renaming Declarations

85. **8652:2023 Reference:** §8.5.2

86. **Legality Rule:** Exception renaming declarations are not permitted (exceptions are excluded; see §2.1.8).

#### 8.5.5 Generic Renaming Declarations

87. **8652:2023 Reference:** §8.5.5

88. **Legality Rule:** Generic renaming declarations are not permitted (generics are excluded; see §2.1.9).

#### 8.6 Overload Resolution — Simplified

89. **8652:2023 Reference:** §8.6

90. **Modification:** The overload resolution rules of 8652:2023 §8.6 are simplified to: each identifier in a given declarative region denotes at most one entity (excluding predefined operators). The complex overload resolution algorithm of §8.6 is not required.

---

### 2.1.7 Section 9 — Tasks and Synchronization — Replaced

#### 9.1–9.11 Full Ada Tasking

91. **8652:2023 Reference:** Sections 9.1 through 9.11

92. **Legality Rule:** The following are not permitted:
- Task type declarations (§9.1) — `task type T is ...`
- Task entries (§9.5.2) — `entry E ...`
- Accept statements (§9.5.2) — `accept E do ...`
- All forms of select on entries (§9.7.1, §9.7.2, §9.7.3) — `selective_accept`, timed/conditional entry calls
- Abort statements (§9.8) — `abort T;`
- Requeue statements (§9.5.4) — `requeue E;`
- User-declared protected types and objects (§9.4) — `protected type T is ...`, `protected P is ...`
- Asynchronous transfer of control (§9.7.4) — `select ... then abort ...`
- Dynamic task creation — allocators of task types

93. A conforming implementation shall reject any `task_type_declaration`, `entry_declaration`, `accept_statement`, `selective_accept`, `abort_statement`, `requeue_statement`, `protected_type_declaration`, `protected_body_declaration`, or `asynchronous_select`.

94. **Note:** Safe provides a restricted concurrency model via static task declarations and typed channels (Section 4 of this document, D28), which maps to Jorvik-profile SPARK tasking in emitted Ada.

95. **Retained from Section 9:**
- `delay` statements (§9.6) — retained for use in task bodies and select timeouts
- Delay alternatives in Safe's channel-based `select` — specified in Section 4

96. **Related exclusions:**
- Real-time annexes D.1–D.14 — excluded, except task priorities (see Annex A)
- `Ada.Task_Identification` — excluded
- `Ada.Synchronous_Task_Control` — excluded (channels replace suspension objects)
- `Ada.Synchronous_Barriers` — excluded
- `Ada.Task_Attributes` — excluded

---

### 2.1.8 Section 10 — Program Structure — Modified

#### 10.1 Separate Compilation

97. **8652:2023 Reference:** §10.1, §10.1.1, §10.1.2, §10.1.3

98. **Modification:** The compilation unit model is modified to reflect single-file packages (Section 3). Each source file (`.safe`) constitutes one compilation unit. The `with` clause mechanism (§10.1.2) is retained for inter-package dependencies. Subunits (`is separate`, §10.1.3) are retained.

99. **Legality Rule:** A library unit shall be a package. Library-level subprograms are not permitted as compilation units. The main program entry point is implementation-defined.

#### 10.2.1 Elaboration Control

100. **8652:2023 Reference:** §10.2.1

101. **Legality Rule:** The following elaboration control pragmas are not permitted:
- `pragma Elaborate` — not needed (purely declarative packages)
- `pragma Elaborate_All` — not needed
- `pragma Elaborate_Body` — not needed (no separate body)

102. **Rationale:** Purely declarative packages (D7) eliminate elaboration ordering as a concept. Variable initialization uses expressions evaluated at load time; there are no elaboration-time executable statements.

---

### 2.1.9 Section 11 — Exceptions — Excluded

103. **8652:2023 Reference:** Sections 11.1 through 11.6

104. **Legality Rule:** The entire exceptions mechanism is excluded. The following are not permitted:
- Exception declarations (§11.1) — `E : exception;`
- Exception handlers (§11.2) — `when E => ...`
- Raise statements (§11.3) — `raise E;`
- Raise expressions (§11.3) — `(raise E)`
- `Ada.Exceptions` (§11.4.1) — excluded
- Exception information queries — excluded

105. A conforming implementation shall reject any `exception_declaration`, `exception_handler`, `raise_statement`, or `raise_expression`.

106. **Note:** `pragma Assert` (§11.4.2) is retained. A failed assertion invokes the runtime abort handler with source location information. `Assertion_Policy` is not supported — assertions are always enabled.

107. **Retained from Section 11:**
- `pragma Assert` (§11.4.2)
- Check suppression via `pragma Suppress` — retained for implementation flexibility, though conforming programs should not depend on suppression for correctness

---

### 2.1.10 Section 12 — Generic Units — Excluded

108. **8652:2023 Reference:** Sections 12.1 through 12.8

109. **Legality Rule:** The entire generics mechanism is excluded. The following are not permitted:
- Generic declarations (§12.1) — `generic ... package P is ...`
- Generic bodies (§12.2)
- Generic instantiations (§12.3) — `package I is new G (...);`
- All formal parameter forms (§12.4–§12.7)

110. A conforming implementation shall reject any `generic_declaration`, `generic_body`, or `generic_instantiation`.

111. **Rationale:** Generics require instantiation, which is effectively a second compilation pass (D16). The resulting language requires monomorphic code.

---

### 2.1.11 Section 13 — Representation Issues — Modified

#### 13.1 Aspect Specifications — Modified

112. **8652:2023 Reference:** §13.1, §13.1.1

113. **Modification:** Aspect specifications are retained for the following aspects only:
- `Size`, `Object_Size`, `Alignment`, `Component_Size` — representation aspects
- `Pack` (also available as `pragma Pack`)
- `Convention`, `Import`, `Export` — C interface aspects (also available as pragmas)
- `No_Return` — subprogram aspect
- `Inline` — subprogram aspect (also available as `pragma Inline`)
- `Priority` — task aspect (Section 4)

114. **Legality Rule:** Aspect specifications for any aspect not in the list above are not permitted. A conforming implementation shall reject aspect specifications for excluded aspects.

#### 13.3 Representation Attributes — Modified

115. **8652:2023 Reference:** §13.3

116. **Note:** Representation attributes `Size`, `Object_Size`, `Alignment`, `Component_Size`, `Bit_Order`, `Position`, `First_Bit`, `Last_Bit` are retained (using dot notation, see §2.4). Attributes related to excluded features are excluded (see §2.5).

#### 13.5 Record Layout — Retained

117. **8652:2023 Reference:** §13.5, §13.5.1, §13.5.2, §13.5.3

118. **Note:** Record representation clauses are retained for hardware register mapping and C interface compatibility.

#### 13.7 The Package System — Retained

119. **8652:2023 Reference:** §13.7

120. **Note:** `System.Address`, `System.Storage_Unit`, `System.Word_Size`, `System.Bit_Order`, `System.Max_Alignment_For_Allocation` are retained.

#### 13.8 Machine Code Insertions — Excluded

121. **8652:2023 Reference:** §13.8

122. **Legality Rule:** Machine code insertions are not permitted. A conforming implementation shall reject any code statement.

123. **Rationale:** Deferred to the system sublanguage (D24).

#### 13.9 Unchecked Type Conversions — Excluded

124. **8652:2023 Reference:** §13.9

125. **Legality Rule:** `Ada.Unchecked_Conversion` is not permitted. A conforming implementation shall reject any instantiation of `Ada.Unchecked_Conversion`.

126. **Rationale:** Unchecked conversions bypass the type system. Deferred to the system sublanguage (D24).

#### 13.10 Unchecked Access Value Creation — Excluded

127. **8652:2023 Reference:** §13.10

128. **Legality Rule:** The `Unchecked_Access` attribute is not permitted. A conforming implementation shall reject any use of `.Unchecked_Access`.

#### 13.11 Storage Management — Modified

129. **8652:2023 Reference:** §13.11, §13.11.1, §13.11.2, §13.11.3, §13.11.4, §13.11.5

130. **Legality Rule:** User-defined storage pools, storage subpools, and `Unchecked_Deallocation` are not permitted. Storage management is handled by the implementation under the ownership model: allocation occurs via allocators (`new`), deallocation occurs automatically at owner scope exit.

#### 13.12 Pragma Restrictions — Retained

131. **8652:2023 Reference:** §13.12, §13.12.1

132. **Note:** `pragma Restrictions` is retained. A conforming implementation may use restrictions internally. The language itself imposes a fixed set of restrictions that subsumes many Ada restriction identifiers.

#### 13.13 Streams — Excluded

133. **8652:2023 Reference:** §13.13, §13.13.1, §13.13.2

134. **Legality Rule:** Stream types, stream-oriented attributes (`Input`, `Output`, `Read`, `Write`), and the streams subsystem are not permitted. A conforming implementation shall reject any stream-related declaration or attribute use.

135. **Rationale:** Streams require tagged types (for dispatching on stream operations), controlled types (for stream element management), and extensive runtime support.

---

### 2.1.12 Annexes — Exclusions

#### Annex C — Systems Programming

136. **8652:2023 Reference:** Annex C

137. **Legality Rule:** Annex C features are excluded except:
- `pragma Convention` (C.1) — retained for C interface
- `pragma Import` (B.1) — retained
- `pragma Export` (B.1) — retained
- Representation clauses — retained (see §2.1.11)

138. **Excluded:** Interrupt handling (C.3), preelaborate requirements (C.4 — replaced by D7's model), shared variable control (C.6 — no shared mutable state between tasks), `Machine_Code` package (C.1).

#### Annex D — Real-Time Systems

139. **8652:2023 Reference:** Annex D

140. **Legality Rule:** Annex D is excluded except for task priorities. The `Priority` aspect on task declarations (Section 4) is the sole retained real-time feature.

141. **Excluded:** D.1 (Task Priorities — partially retained via task declarations), D.2 (Priority Scheduling), D.2.1–D.2.6 (scheduling policies), D.3 (Priority Ceiling Protocol — enforced internally by the compiler for channel-backing protected objects), D.4 (Entry Queuing Policies), D.5 (Dynamic Priorities), D.6 (Preemptive Abort), D.7 (Tasking Restrictions), D.8 (Monotonic Time), D.9 (Delay Accuracy), D.10 (Synchronous Task Control), D.11 (Asynchronous Task Control), D.12 (Other Optimizations), D.13 (The Ravenscar and Jorvik Profiles), D.14 (Execution Time).

#### Annex E — Distributed Systems

142. **8652:2023 Reference:** Annex E

143. **Legality Rule:** Annex E is excluded in its entirety.

#### Annex F — Information Systems

144. **8652:2023 Reference:** Annex F

145. **Legality Rule:** Annex F is excluded in its entirety.

#### Annex H — High Integrity Systems

146. **8652:2023 Reference:** Annex H

147. **Note:** Annex H requirements are subsumed by Safe's restrictions. The `Restrictions` pragma is retained (§2.1.11). `pragma Normalize_Scalars` is excluded (the implementation provides deterministic default initialization).

#### Annex J — Obsolescent Features

148. **8652:2023 Reference:** Annex J

149. **Legality Rule:** All obsolescent features (Annex J) are excluded in their entirety. This includes:
- `delta` constraint on ordinary fixed point types (J.3)
- ASCII package (J.5)
- Numeric_Error rename (J.6)
- `at` clauses (J.7.1)
- `mod` clauses (J.8)
- The `Storage_Size` clause form (J.9)
- Specific special-need annexes marked obsolescent

---

## 2.2 SPARK Verification-Only Aspects — Excluded

150. **8652:2023 Reference:** N/A (SPARK-specific)

151. **Legality Rule:** The following SPARK-specific aspects are not permitted in Safe source code. A conforming implementation shall reject any declaration bearing these aspects:

| Aspect | SPARK RM Reference | Rationale |
|---|---|---|
| `Global` | SPARK RM §6.1.4 | Auto-generated by `--emit-ada` (D22) |
| `Depends` | SPARK RM §6.1.5 | Auto-generated by `--emit-ada` (D22) |
| `Refined_Global` | SPARK RM §6.1.4 | Verification-only (D22) |
| `Refined_Depends` | SPARK RM §6.1.5 | Verification-only (D22) |
| `Refined_State` | SPARK RM §7.2.2 | Verification-only (D22) |
| `Abstract_State` | SPARK RM §7.1.4 | Verification-only (D22) |
| `Initializes` | SPARK RM §7.1.5 | Auto-generated by `--emit-ada` (D22) |
| `Ghost` | SPARK RM §6.9 | Verification-only (D22) |
| `SPARK_Mode` | SPARK RM §1.3 | Entire language is the mode (D22) |
| `Relaxed_Initialization` | SPARK RM §6.10 | Verification-only (D22) |
| `Always_Terminates` | SPARK RM §6.11 | Verification-only |
| `Subprogram_Variant` | SPARK RM §6.1.3 | Verification-only |

152. **Note:** These aspects are not discarded — the `--emit-ada` backend automatically generates `Global`, `Depends`, and `Initializes` from compiler analysis. See Section 5 for the complete SPARK assurance specification.

---

## 2.3 Access Types — SPARK Ownership and Borrowing Model

153. Access-to-object types are retained with the following ownership and borrowing rules, derived from the SPARK 2022 ownership model.

### 2.3.1 Ownership

154. Each access value has exactly one owning object at any program point. The owning object is the variable, component, or parameter that holds the access value.

155. **Move semantics:** Assignment of an access value is a **move**. After the assignment `Target := Source;`:
- `Target` receives ownership of the designated object.
- `Source` becomes `null`.
- Any subsequent read of `Source` (other than a null comparison) before reassignment is illegal.

156. **Legality Rule:** A conforming implementation shall reject any read of a moved access value (other than comparison with `null`) before the value is reassigned.

### 2.3.2 Borrowing

157. A parameter of mode `in out` with an access type **borrows** the designated object for the duration of the call:
- The caller's access value is frozen (cannot be read, written, or moved) for the duration of the call.
- The callee has temporary mutable access to the designated object.
- On return, the caller's access value is unfrozen and retains ownership.

158. **Legality Rule:** A conforming implementation shall reject any use of a frozen access value during a borrow.

### 2.3.3 Observing

159. A parameter of mode `in` with an access type **observes** the designated object for the duration of the call:
- The caller's access value is frozen (cannot be written or moved, but may be read) for the duration of the call.
- The callee has temporary read-only access to the designated object.
- On return, the caller's access value is unfrozen.

160. **Legality Rule:** A conforming implementation shall reject any modification of an observed designated object during the call.

### 2.3.4 Automatic Deallocation

161. When an owning object goes out of scope and its access value is not null, the designated object is automatically deallocated. There is no user-callable deallocation primitive.

162. **Dynamic Semantics:** At the end of the scope containing the owning object's declaration, if the access value is non-null, the implementation calls the equivalent of `Unchecked_Deallocation` automatically.

### 2.3.5 Allocators

163. Allocators (`new T`, `new T'(...)`) are retained. Each allocator creates a new object and returns an owning access value. The allocator expression using the type annotation syntax is `new T'(Expr)` in Ada notation; in Safe this is written `new (Expr) : T_Ptr` when disambiguation is needed (see §2.4.2).

### 2.3.6 Excluded Access Type Features

164. The following are not permitted:
- Access-to-subprogram types
- `Unchecked_Deallocation`
- `Unchecked_Access` attribute
- `Address` attribute on access objects (deferred to system sublanguage)
- User-defined storage pools
- Storage pool attributes (`Storage_Pool`, `Storage_Size` on access types)
- Access discriminants

---

## 2.4 Notation Changes

### 2.4.1 Dot Notation for Attributes

165. All 8652:2023 attribute references using tick notation (`X'Attr`) are replaced by dot notation (`X.Attr`) in Safe. The apostrophe character (`'`) is used only for character literals (`'A'`, `'0'`).

166. **Resolution rule:** When `X.Name` appears in a context where `X` denotes an object or type:
- If `X` is a record type and `Name` is a component name, it is a selected component (record field access).
- Otherwise, if `Name` is a language-defined attribute applicable to `X`, it is an attribute reference.
- The two cases are mutually exclusive: record component names cannot collide with attribute names because attribute names are reserved in this context.

167. **Legality Rule:** A record type shall not declare a component whose name matches a language-defined attribute name that is applicable to the type or its objects. A conforming implementation shall reject such a declaration.

168. **Parameterized attributes:** Attributes that take parameters use function call syntax: `T.Image(42)`, `T.Value("123")`, `T.Pos(E)`.

### 2.4.2 Type Annotation Syntax

169. Qualified expression syntax (`T'(Expression)`) is replaced by type annotation syntax (`Expression : Type`).

170. **Syntax:**

```
annotated_expression ::= expression ':' subtype_mark
```

171. **Precedence:** The `:` operator binds at the lowest precedence level. In contexts where an annotated expression appears within a larger expression (e.g., as a subprogram argument), parentheses are required:

```ada
Foo ((others => 0) : Buffer_Type);    -- parentheses required in argument position
X := (Value : My_Type);               -- parentheses around the annotated expression
```

172. **Legality Rule:** A conforming implementation shall reject any qualified expression using tick-parenthesis notation.

---

## 2.5 Attribute Inventory

173. The following table lists all language-defined attributes from 8652:2023 with their retention status. All retained attributes use dot notation (`X.Attr` instead of `X'Attr`).

### Retained Attributes

| Attribute | 8652:2023 Reference | Safe Notation | Notes |
|---|---|---|---|
| `Address` | §13.3(11) | `X.Address` | Objects and subprograms |
| `Adjacent` | §A.5.3(48) | `T.Adjacent(X,Y)` | Float types |
| `Aft` | §3.5.10(5) | `T.Aft` | Fixed point types |
| `Alignment` | §13.3(23) | `X.Alignment` | Types and objects |
| `Base` | §3.5(15) | `T.Base` | Scalar types |
| `Bit_Order` | §13.5.3(4) | `T.Bit_Order` | Record types |
| `Ceiling` | §A.5.3(33) | `T.Ceiling(X)` | Float types |
| `Component_Size` | §13.3(69) | `T.Component_Size` | Array types |
| `Compose` | §A.5.3(24) | `T.Compose(X,Y)` | Float types |
| `Constrained` | §3.7.2(3) | `X.Constrained` | Discriminated types |
| `Copy_Sign` | §A.5.3(51) | `T.Copy_Sign(X,Y)` | Float types |
| `Definite` | §12.5.1(23) | — | Excluded (requires generics) |
| `Delta` | §3.5.10(3) | `T.Delta` | Fixed point types |
| `Denorm` | §A.5.3(9) | `T.Denorm` | Float types |
| `Digits` | §3.5.8(2) | `T.Digits` | Float types |
| `Enum_Rep` | §13.4(7.1) | `E.Enum_Rep` | Enumeration values |
| `Enum_Val` | §13.4(7.3) | `T.Enum_Val(N)` | Enumeration types |
| `Exponent` | §A.5.3(18) | `T.Exponent(X)` | Float types |
| `First` | §3.5(12) | `T.First` | Scalar and array types |
| `First(N)` | §3.6.2(3) | `A.First(N)` | Multi-dimensional arrays |
| `First_Valid` | §3.5.5(7.1) | `T.First_Valid` | Discrete types with holes |
| `Floor` | §A.5.3(30) | `T.Floor(X)` | Float types |
| `Fore` | §3.5.10(4) | `T.Fore` | Fixed point types |
| `Fraction` | §A.5.3(21) | `T.Fraction(X)` | Float types |
| `Image` | §3.5(35) | `T.Image(X)` | Scalar types |
| `Last` | §3.5(13) | `T.Last` | Scalar and array types |
| `Last(N)` | §3.6.2(5) | `A.Last(N)` | Multi-dimensional arrays |
| `Last_Valid` | §3.5.5(7.3) | `T.Last_Valid` | Discrete types with holes |
| `Leading_Part` | §A.5.3(54) | `T.Leading_Part(X,Y)` | Float types |
| `Length` | §3.6.2(9) | `A.Length` | Array types |
| `Length(N)` | §3.6.2(10) | `A.Length(N)` | Multi-dimensional arrays |
| `Machine` | §A.5.3(60) | `T.Machine(X)` | Float types |
| `Machine_Emax` | §A.5.3(8) | `T.Machine_Emax` | Float types |
| `Machine_Emin` | §A.5.3(7) | `T.Machine_Emin` | Float types |
| `Machine_Mantissa` | §A.5.3(6) | `T.Machine_Mantissa` | Float types |
| `Machine_Overflows` | §A.5.3(12) | `T.Machine_Overflows` | Float types |
| `Machine_Radix` | §A.5.3(2) | `T.Machine_Radix` | Float types |
| `Machine_Rounds` | §A.5.3(11) | `T.Machine_Rounds` | Float types |
| `Max` | §3.5(19) | `T.Max(X,Y)` | Scalar types |
| `Max_Alignment_For_Allocation` | §13.11.1(3.3) | `T.Max_Alignment_For_Allocation` | Access types |
| `Max_Size_In_Storage_Elements` | §13.11.1(3) | `T.Max_Size_In_Storage_Elements` | Types |
| `Min` | §3.5(16) | `T.Min(X,Y)` | Scalar types |
| `Mod` | §3.5.4(17) | `T.Mod(N)` | Modular types |
| `Model` | §A.5.3(68) | `T.Model(X)` | Float types |
| `Model_Emin` | §A.5.3(65) | `T.Model_Emin` | Float types |
| `Model_Epsilon` | §A.5.3(66) | `T.Model_Epsilon` | Float types |
| `Model_Mantissa` | §A.5.3(64) | `T.Model_Mantissa` | Float types |
| `Model_Small` | §A.5.3(67) | `T.Model_Small` | Float types |
| `Modulus` | §3.5.4(4) | `T.Modulus` | Modular types |
| `Object_Size` | §13.3(58) | `T.Object_Size` | Types |
| `Pos` | §3.5.5(2) | `T.Pos(E)` | Discrete types |
| `Pred` | §3.5(25) | `T.Pred(X)` | Scalar types |
| `Range` | §3.5(14) | `T.Range` | Scalar and array types |
| `Range(N)` | §3.6.2(7) | `A.Range(N)` | Multi-dimensional arrays |
| `Remainder` | §A.5.3(45) | `T.Remainder(X,Y)` | Float types |
| `Round` | §3.5.10(12) | `T.Round(X)` | Fixed point types |
| `Rounding` | §A.5.3(36) | `T.Rounding(X)` | Float types |
| `Scale` | §3.5.10(11) | `T.Scale` | Decimal fixed point types |
| `Scaling` | §A.5.3(27) | `T.Scaling(X,Y)` | Float types |
| `Signed_Zeros` | §A.5.3(13) | `T.Signed_Zeros` | Float types |
| `Size` | §13.3(40) | `X.Size` | Types and objects |
| `Small` | §3.5.10(2) | `T.Small` | Fixed point types |
| `Succ` | §3.5(22) | `T.Succ(X)` | Scalar types |
| `Truncation` | §A.5.3(42) | `T.Truncation(X)` | Float types |
| `Unbiased_Rounding` | §A.5.3(39) | `T.Unbiased_Rounding(X)` | Float types |
| `Val` | §3.5.5(5) | `T.Val(N)` | Discrete types |
| `Valid` | §13.9.2(3) | `X.Valid` | Scalar objects |
| `Value` | §3.5(52) | `T.Value(S)` | Scalar types |
| `Wide_Image` | §3.5(28) | `T.Wide_Image(X)` | Scalar types |
| `Wide_Value` | §3.5(40) | `T.Wide_Value(S)` | Scalar types |
| `Wide_Wide_Image` | §3.5(27.1) | `T.Wide_Wide_Image(X)` | Scalar types |
| `Wide_Wide_Value` | §3.5(39.1) | `T.Wide_Wide_Value(S)` | Scalar types |
| `Width` | §3.5.5(8) | `T.Width` | Discrete types |
| `Wide_Width` | §3.5.5(9) | `T.Wide_Width` | Discrete types |
| `Wide_Wide_Width` | §3.5.5(10) | `T.Wide_Wide_Width` | Discrete types |

### Excluded Attributes

| Attribute | 8652:2023 Reference | Reason for Exclusion |
|---|---|---|
| `Access` | §3.10.2(24) | Named access types only; use allocators |
| `Body_Version` | §E.3(4) | Distributed systems excluded |
| `Callable` | §9.9(2) | Task entries excluded |
| `Caller` | §C.7.1(14) | Protected entries excluded |
| `Class` | §3.9(14) | Tagged types excluded |
| `Count` | §9.9(5) | Task/protected entries excluded |
| `Definite` | §12.5.1(23) | Generics excluded |
| `External_Tag` | §13.3(75) | Tagged types excluded |
| `Has_Same_Storage` | §13.3(73.2) | Low-level; deferred to system sublanguage |
| `Identity` | §C.7.1(12) | Task identity excluded |
| `Input` | §13.13.2(22) | Streams excluded |
| `Old` | §6.1.1(26) | Postconditions excluded |
| `Output` | §13.13.2(19) | Streams excluded |
| `Overlaps_Storage` | §13.3(73.4) | Low-level; deferred to system sublanguage |
| `Parallel_Reduce` | §4.5.10(19) | Reduction expressions excluded |
| `Priority` | §D.5.2(3) | Dynamic priorities excluded (static priority via task declaration) |
| `Put_Image` | §4.10(3) | Requires tagged types |
| `Read` | §13.13.2(7) | Streams excluded |
| `Reduce` | §4.5.10(5) | Reduction expressions excluded |
| `Result` | §6.1.1(28) | Postconditions excluded |
| `Storage_Pool` | §13.11(13) | User storage pools excluded |
| `Storage_Size` (access) | §13.11(14) | User storage pools excluded |
| `Storage_Size` (task) | §J.9(2) | Task types excluded |
| `Stream_Size` | §13.13.2(1.2) | Streams excluded |
| `Tag` | §3.9(18) | Tagged types excluded |
| `Terminated` | §9.9(3) | Task entries excluded |
| `Unchecked_Access` | §13.10(3) | Excluded (§2.1.11) |
| `Version` | §E.3(3) | Distributed systems excluded |
| `Write` | §13.13.2(3) | Streams excluded |

---

## 2.6 Pragma Inventory

174. The following table lists all language-defined pragmas from 8652:2023 with their retention status.

### Retained Pragmas

| Pragma | 8652:2023 Reference | Notes |
|---|---|---|
| `Assert` | §11.4.2 | Primary assertion mechanism |
| `Convention` | §B.1 | C interface |
| `Export` | §B.1 | C interface |
| `Import` | §B.1 | C interface |
| `Inline` | §6.3.2 | Subprogram inlining hint |
| `Linker_Options` | §B.1 | Linking with C libraries |
| `List` | §2.8(21) | Listing control |
| `No_Return` | §6.5.1 | Also available as aspect |
| `Normalize_Scalars` | §H.1 | Excluded — see note |
| `Optimize` | §2.8(23) | Optimization control |
| `Pack` | §13.2 | Component packing |
| `Page` | §2.8(22) | Listing control |
| `Preelaborate` | §10.2.1 | Retained for library compatibility |
| `Priority` | §D.1 | Task priority (see Section 4) |
| `Pure` | §10.2.1 | Retained for library compatibility |
| `Restrictions` | §13.12 | Implementation restrictions |
| `Suppress` | §11.5 | Check suppression |
| `Unsuppress` | §11.5 | Check unsuppression |

### Excluded Pragmas

| Pragma | 8652:2023 Reference | Reason |
|---|---|---|
| `All_Calls_Remote` | §E.2.3 | Distributed systems excluded |
| `Asynchronous` | §E.4.1 | Distributed systems excluded |
| `Atomic` | §C.6 | Deferred to system sublanguage |
| `Atomic_Components` | §C.6 | Deferred to system sublanguage |
| `Attach_Handler` | §C.3.1 | Interrupt handling excluded |
| `Controlled` | §13.11.3 | Storage pools excluded |
| `Default_Storage_Pool` | §13.11.3 | Storage pools excluded |
| `Detect_Blocking` | §H.5 | Full tasking excluded |
| `Discard_Names` | §C.5 | Systems programming annex; deferred |
| `Elaborate` | §10.2.1 | Not needed (D7) |
| `Elaborate_All` | §10.2.1 | Not needed (D7) |
| `Elaborate_Body` | §10.2.1 | Not needed (D7) |
| `Independent` | §C.6 | Deferred to system sublanguage |
| `Independent_Components` | §C.6 | Deferred to system sublanguage |
| `Inspection_Point` | §H.3.2 | High integrity annex; deferred |
| `Interrupt_Handler` | §C.3.1 | Interrupt handling excluded |
| `Interrupt_Priority` | §D.1 | Interrupt handling excluded |
| `Locking_Policy` | §D.3 | Enforced internally by compiler |
| `No_Return` | §J.15.2 | Retained as aspect; pragma form also retained |
| `Partition_Elaboration_Policy` | §H.6 | Not needed (D7) |
| `Preelaborable_Initialization` | §10.2.1 | Not needed (D7) |
| `Profile` | §13.12.1 | Compiler enforces its own profile |
| `Queuing_Policy` | §D.4 | Entry queuing excluded |
| `Ravenscar` | §D.13 | Compiler enforces Jorvik internally |
| `Remote_Call_Interface` | §E.2.3 | Distributed systems excluded |
| `Remote_Types` | §E.2.2 | Distributed systems excluded |
| `Reviewable` | §H.3.1 | High integrity annex; deferred |
| `Shared_Passive` | §E.2.1 | Distributed systems excluded |
| `Task_Dispatching_Policy` | §D.2.2 | Full tasking excluded |
| `Volatile` | §C.6 | Deferred to system sublanguage |
| `Volatile_Components` | §C.6 | Deferred to system sublanguage |

---

## 2.7 Contract Exclusions

175. The following contract-related aspects and pragmas from 8652:2023 and the SPARK Reference Manual are excluded:

| Aspect/Pragma | Reference | Replacement |
|---|---|---|
| `Pre` | §6.1.1 | `pragma Assert` |
| `Pre'Class` | §6.1.1 | Not applicable (no tagged types) |
| `Post` | §6.1.1 | `pragma Assert` |
| `Post'Class` | §6.1.1 | Not applicable (no tagged types) |
| `Contract_Cases` | §6.1.1 | `pragma Assert` |
| `Type_Invariant` | §7.3.2 | Not applicable |
| `Type_Invariant'Class` | §7.3.2 | Not applicable (no tagged types) |
| `Default_Initial_Condition` | SPARK RM §3.1 | Mandatory initialization (D7) |
| `Dynamic_Predicate` | §3.2.4 | Subtype constraints |
| `Static_Predicate` | §3.2.4 | Subtype constraints |
| `Loop_Invariant` | §5.5.1.1 | Not needed (verification-only) |
| `Loop_Variant` | §5.5.1.1 | Not needed (verification-only) |
| `Assertion_Policy` | §11.4.2 | Assertions always enabled |

176. **Rationale:** Contract aspects are replaced by `pragma Assert` for runtime defensive checks (D19). Bronze and Silver SPARK assurance is guaranteed by compiler-generated annotations and D27 language rules without developer-written contracts.

---

## 2.8 Silver-by-Construction Rules

177. The following legality and semantic rules have no 8652:2023 precedent. They are new rules that guarantee every conforming Safe program is Silver-provable (Absence of Runtime Errors) when emitted as Ada via `--emit-ada`.

### 2.8.1 Rule 1 — Wide Intermediate Arithmetic

178. **Modification to 8652:2023 §4.5:** All integer arithmetic expressions are evaluated in a mathematical integer type with no overflow. The dynamic semantics of integer operators `+`, `-`, `*`, `/`, `mod`, `rem`, `**`, and `abs` as defined in 8652:2023 §4.5.3–§4.5.6 are modified: intermediate results are computed in a type whose range is sufficient to hold any result of the operation without overflow.

179. **Narrowing points:** Range checks are performed only when a value is:
- Assigned to an object (§5.2)
- Passed as a parameter (§6.4)
- Returned from a function (§6.5)
- Used in a type conversion to a narrower type (§4.6)

180. **Implementation:** The compiler emits C99 code using `int64_t` (or `__int128` if necessary) for intermediate computations. Range checks are emitted as explicit bounds tests at narrowing points.

181. **Effect on SPARK emission:** The `--emit-ada` backend emits intermediate expressions using a wide integer type. GNATprove discharges intermediate overflow checks trivially because the wide type cannot overflow for the operations performed. Narrowing checks at assignment/return/parameter points are dischargeable via interval analysis on the wide result.

### 2.8.2 Rule 2 — Strict Index Typing

182. **New Legality Rule (modifying §4.1.1):** The index expression in an `indexed_component` shall be of a type or subtype that is the same as, or a statically known subtype of, the array's index type. A conforming implementation shall reject any `indexed_component` where the index expression's type is not the same as or a subtype of the array's index type.

183. **Effect:** Every array index check is dischargeable by the prover — the index value is constrained by its type to be within the array bounds.

184. **Example:**

```ada
public type Channel_Id is range 0 .. 7;
Table : array (Channel_Id) of Integer;

-- Legal: index type matches array index type
public function Lookup (Ch : Channel_Id) return Integer is
begin
    return Table(Ch);  -- Silver-provable: Ch in 0..7 by type
end Lookup;

-- ILLEGAL: Integer is wider than Channel_Id
public function Bad_Lookup (N : Integer) return Integer is
begin
    return Table(N);  -- compile error: Integer is not a subtype of Channel_Id
end Bad_Lookup;
```

### 2.8.3 Rule 3 — Division by Nonzero Type

185. **New Legality Rule (modifying §4.5.5):** The right operand of the operators `/`, `mod`, and `rem` shall be of a type or subtype whose static range does not include zero. A conforming implementation shall reject any division, `mod`, or `rem` operation where the right operand's type or subtype range includes zero.

186. **Standard nonzero subtypes:** The language provides the following predefined subtypes:

```ada
subtype Positive is Integer range 1 .. Integer.Last;
subtype Negative is Integer range Integer.First .. -1;
```

187. **Effect:** Every division-by-zero check is dischargeable by the prover — the divisor value is constrained by its type to be nonzero.

188. **Example:**

```ada
public type Seconds is range 1 .. 3600;

-- Legal: Seconds excludes zero
public function Rate (Distance : Meters; Time : Seconds) return Integer is
begin
    return Distance / Time;  -- Silver-provable: Time >= 1 by type
end Rate;

-- ILLEGAL: Integer includes zero
public function Bad_Divide (A, B : Integer) return Integer is
begin
    return A / B;  -- compile error: Integer range includes zero
end Bad_Divide;
```

### 2.8.4 Rule 4 — Not-Null Dereference

189. **New Legality Rule (modifying §3.10, §4.1):** Dereference of an access value — whether explicit (`.all`) or implicit (selected component through an access value) — shall require the access subtype to be `not null`. A conforming implementation shall reject any dereference where the access subtype at the point of dereference does not exclude null.

190. **Standard pattern:** Every access type declaration produces two usable forms:

```ada
public type Node_Ptr is access Node;          -- nullable, for storage
public subtype Node_Ref is not null Node_Ptr; -- non-null, for dereference
```

191. **Permitted operations on nullable access values:**
- Null comparison (`= null`, `/= null`) — always legal
- Assignment (subject to ownership rules) — always legal
- Conversion to `not null` subtype after null check — legal within the checked branch

192. **Effect:** Every null dereference check is dischargeable by the prover — the access subtype at the dereference point excludes null.

193. **Example:**

```ada
-- Legal: Node_Ref excludes null
public function Value_Of (N : Node_Ref) return Integer
is (N.Value);

-- ILLEGAL: Node_Ptr includes null
public function Bad_Value (N : Node_Ptr) return Integer
is (N.Value);  -- compile error: dereference of nullable access type

-- Narrowing after null check:
public function Safe_Value (N : Node_Ptr; Default : Integer) return Integer is
begin
    if N /= null then
        Ref : Node_Ref := Node_Ref(N);  -- conversion valid inside checked branch
        return Ref.Value;
    else
        return Default;
    end if;
end Safe_Value;
```

### 2.8.5 Combined Effect

194. These four rules ensure that the six categories of runtime check are all dischargeable by GNATprove from type information alone:

| Check Category | How Discharged |
|---|---|
| Integer overflow | Impossible — wide intermediate arithmetic (Rule 1) |
| Range on assignment/return/parameter | Interval analysis on wide intermediates (Rule 1) |
| Array index out of bounds | Index type matches array index type (Rule 2) |
| Division by zero | Divisor type excludes zero (Rule 3) |
| Null dereference | Access subtype is `not null` at every dereference (Rule 4) |
| Discriminant check | Discriminant type is discrete and static (retained feature) |

195. **Note:** Range checks at narrowing points (assignment, parameter, return) are not eliminated by these rules — they are made *provable*. The prover uses interval analysis on the wide intermediate result to determine whether the value fits the target type. If the programmer's arithmetic is correct, the check is discharged. If not, GNATprove reports it as unproven, which indicates a genuine range error in the program.
