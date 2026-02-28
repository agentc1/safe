# Section 3 — Single-File Packages

1. This section specifies the single-file package model that replaces the 8652:2023 package specification and body model (§7.1, §7.2, §7.3). A Safe package is a single source file containing a flat sequence of declarations. There is no separate specification and body, no `package body` wrapper, no `begin...end` initialization block, and no `private` section divider. This section constitutes the complete specification of Safe's package structure; it supersedes 8652:2023 §7.1 through §7.4 except where explicitly stated otherwise.

2. Design decisions D6 (single-file packages), D7 (flat declarative structure), D8 (default-private visibility), D9 (opaque types), D10 (bodies at point of declaration), and D11 (interleaved declarations) are the basis for this section.

---

## 3.1 Syntax

3. The following productions define the structure of a Safe package. BNF notation follows 8652:2023 §1.1.4 conventions. Productions that differ from 8652:2023 are marked; those retained unchanged reference their originating section.

### 3.1.1 Compilation Unit

```
compilation_unit ::=
    context_clause package_unit

context_clause ::=
    { with_clause }

with_clause ::=
    'with' library_unit_name { ',' library_unit_name } ';'

library_unit_name ::=
    identifier { '.' identifier }
```

4. Each `.safe` source file shall contain exactly one `compilation_unit`. General `use` clauses are excluded (Section 2, §2.1.6); only `with` clauses appear in the context clause. `use type` clauses appear within the package declaration (see paragraph 8).

5. See Section 8, §8.1 for the consolidated grammar of compilation units.

### 3.1.2 Package Declaration

```
package_unit ::=
    'package' package_name 'is'
        { package_declarative_item }
    'end' package_name ';'

package_name ::=
    defining_identifier { '.' defining_identifier }

package_declarative_item ::=
    basic_declaration
  | use_type_clause
  | representation_clause
  | task_declaration
  | channel_declaration
  | pragma
```

6. The `package_name` after `end` shall lexically match the `package_name` after `package`. Child packages use dotted names (e.g., `Sensors.Calibration`); the full dotted name shall appear in both positions.

7. There is no `package body` construct, no `begin...end` initialization block, and no `private` section divider. All declarations appear in a single flat sequence. This replaces 8652:2023 §7.1 (`package_declaration`), §7.2 (`package_body`), and §7.3 (`private` part).

8. See Section 8, §8.2 for the consolidated package grammar and §8.10 for `use_type_clause`.

### 3.1.3 Declarations

```
basic_declaration ::=
    type_declaration
  | subtype_declaration
  | object_declaration
  | number_declaration
  | subprogram_declaration
  | expression_function_declaration
  | renaming_declaration
  | subunit_stub

type_declaration ::=
    [ 'public' ] full_type_declaration

full_type_declaration ::=
    'type' defining_identifier [ known_discriminant_part ] 'is' type_definition ';'
  | incomplete_type_declaration

subtype_declaration ::=
    [ 'public' ] 'subtype' defining_identifier 'is' subtype_indication ';'

object_declaration ::=
    [ 'public' ] defining_identifier_list ':' [ 'constant' ]
        subtype_indication [ ':=' expression ] ';'
  | [ 'public' ] defining_identifier_list ':' [ 'constant' ]
        array_type_definition [ ':=' expression ] ';'

number_declaration ::=
    defining_identifier_list ':' 'constant' ':=' static_expression ';'
```

9. See Section 8, §8.3 for the complete declaration grammar, §8.4 for type definitions, and §8.8 for subprogram declarations.

### 3.1.4 Opaque Type Declaration

```
private_record_type_definition ::=
    'private' 'record'
        component_list
    'end' 'record'
```

10. An opaque type is declared by combining the `public` visibility annotation with the `private record` type definition:

```ada
public type T is private record
    -- component declarations (not visible to clients)
end record;
```

11. The `private` keyword in this context modifies the record definition, not the visibility of the type. The `public` keyword controls the visibility of the type name. The combination `public type T is private record ... end record;` declares a type that is visible to clients by name but whose internal structure is hidden. See Section 8, §8.4.5 for the record type grammar.

### 3.1.5 Subprogram Declarations with Bodies

```
subprogram_declaration ::=
    [ 'public' ] subprogram_specification 'is'
        subprogram_body
  | forward_declaration

subprogram_specification ::=
    procedure_specification
  | function_specification

procedure_specification ::=
    'procedure' defining_identifier [ formal_part ]

function_specification ::=
    'function' defining_identifier [ formal_part ] 'return' subtype_mark

subprogram_body ::=
    'begin'
        sequence_of_statements
    'end' defining_identifier ';'

forward_declaration ::=
    [ 'public' ] subprogram_specification ';'

expression_function_declaration ::=
    [ 'public' ] function_specification
        'is' '(' expression ')' ';'
```

12. Subprogram bodies appear at the point of declaration (D10). A subprogram is declared and defined in a single construct. The `subprogram_body` follows directly after `is`, with no intervening declarative part before `begin`. Declarations within the body are interleaved with statements after `begin` (see paragraph 13).

13. See Section 8, §8.8 for the consolidated subprogram grammar.

### 3.1.6 Interleaved Declarations and Statements

```
sequence_of_statements ::=
    statement { statement }

statement ::=
    { label } simple_statement
  | { label } compound_statement
  | basic_declaration
```

14. Within a subprogram body (after `begin`), declarations and statements may appear in any order (D11). A `basic_declaration` appearing as a `statement` is a local declaration. Its scope extends from the point of declaration to the end of the enclosing `sequence_of_statements`.

15. This modifies 8652:2023 §3.11, which requires all declarations to appear before `begin` in a declarative part. In Safe, the declarative part before `begin` does not exist for subprogram bodies; all local declarations appear after `begin`, interleaved with statements. Block statements (`declare ... begin ... end;`) are retained and may also contain interleaved declarations after their `begin`.

16. See Section 8, §8.7 for the consolidated statement grammar.

---

## 3.2 Legality Rules

### 3.2.1 Matching End Identifier

17. **Legality Rule:** The `package_name` appearing after `end` in a `package_unit` shall be identical to the `package_name` appearing after `package`. A conforming implementation shall reject any `package_unit` where the two names do not match.

18. **Legality Rule:** The `defining_identifier` appearing after `end` in a `subprogram_body` shall be identical to the `defining_identifier` in the `subprogram_specification` of the enclosing `subprogram_declaration`. A conforming implementation shall reject any `subprogram_body` where the identifiers do not match.

19. These rules correspond to the matching rules of 8652:2023 §7.1(3) for packages and §6.3(5) for subprograms, adapted for the single-file model.

### 3.2.2 Declaration-Before-Use

20. **Legality Rule:** Every identifier shall be declared before it is referenced. At the point of a name's occurrence, the declaration of the entity denoted by that name shall appear earlier in the source text, either:

- (a) at an earlier position in the enclosing `package_unit`'s sequence of `package_declarative_item`s, or
- (b) at an earlier position in the enclosing `sequence_of_statements` (for local declarations within a subprogram body), or
- (c) in a package named in a `with_clause` of the enclosing `compilation_unit`, or
- (d) as a language-defined entity (predefined types, predefined operators, predefined attributes).

21. A conforming implementation shall reject any reference to an identifier that is not visible at the point of reference under the rules of paragraph 20.

22. This rule enables single-pass compilation (D3). The compiler processes declarations in source order and resolves every name immediately upon encountering it. The only exception is forward declarations for mutual recursion (paragraph 23).

### 3.2.3 Forward Declarations for Mutual Recursion

23. **Legality Rule:** A `forward_declaration` may appear before the full `subprogram_declaration` that it declares. The `forward_declaration` consists of the `subprogram_specification` followed by a semicolon, with no body. The corresponding full declaration, which includes the body, shall appear later in the same `package_unit`.

24. **Legality Rule:** The `subprogram_specification` in a full `subprogram_declaration` that completes a `forward_declaration` shall conform to the `subprogram_specification` of the `forward_declaration` according to the conformance rules of 8652:2023 §6.3.1 (mode conformance for parameters, subtype conformance for result types).

25. **Legality Rule:** A `forward_declaration` shall be completed by a full `subprogram_declaration` in the same `package_unit`. A conforming implementation shall reject a `forward_declaration` that has no corresponding completion.

26. **Legality Rule:** Forward declarations shall be used only when mutual recursion requires it. A conforming implementation may issue a warning (but shall not reject) a `forward_declaration` whose declared subprogram is not part of a mutually recursive call chain.

27. The `public` keyword on a `forward_declaration` controls the visibility of the subprogram. If the `forward_declaration` bears `public`, the completing full declaration shall also bear `public`, and vice versa. A conforming implementation shall reject any mismatch.

### 3.2.4 No Package-Level Statements

28. **Legality Rule:** A `package_unit` shall contain only `package_declarative_item`s. Statements shall not appear at the package level. A conforming implementation shall reject any statement that appears directly within the `package_declarative_item` sequence of a `package_unit`.

29. This rule implements D7 (purely declarative packages). All executable code resides within subprogram bodies or task bodies. Package-level variable initialization uses expressions at the point of declaration (see §3.4, Dynamic Semantics).

30. As a consequence of this rule, the elaboration control pragmas `Elaborate`, `Elaborate_All`, and `Elaborate_Body` are not needed and are excluded (Section 2, §2.1.8).

### 3.2.5 Visibility — The `public` Keyword

31. **Legality Rule:** All declarations within a `package_unit` are private by default. A declaration is visible to client packages only if it bears the `public` keyword. A conforming implementation shall not make any declaration without the `public` keyword visible outside the declaring package.

32. **Legality Rule:** The `public` keyword may appear on the following declarations:
- Type declarations (`public type T is ...`)
- Subtype declarations (`public subtype S is ...`)
- Object declarations (`public X : T := ...`)
- Subprogram declarations (`public procedure P ...`, `public function F ...`)
- Expression function declarations (`public function F ... is (...)`)
- Forward declarations (`public procedure P;`)
- Channel declarations (`public channel C : T capacity N;`)

33. **Legality Rule:** The `public` keyword shall not appear on:
- Number declarations (these are always private; clients that need the value shall use a public constant)
- `use type` clauses
- Representation clauses
- Pragmas
- Task declarations (tasks are package-internal execution entities)
- Incomplete type declarations (these are completion-requiring forward references for access type declarations; only the full type declaration may bear `public`)

34. A conforming implementation shall reject any `public` keyword appearing on a declaration kind not listed in paragraph 32.

35. Within the declaring package, all declarations (public and private) are visible from their point of declaration to the end of the `package_unit`.

36. This rule replaces 8652:2023's `private` section model (§7.3). There is no section divider that separates visible and private parts. Each declaration individually controls its own visibility. The default is private, following D8.

### 3.2.6 Opaque Types

37. **Legality Rule:** A type declaration of the form `public type T is private record ... end record;` declares an opaque type. The type name `T` is visible to client packages. The component declarations within the record are not visible to clients.

38. **Legality Rule:** An opaque type declaration shall bear the `public` keyword. A `private record` type definition without `public` is permitted (it declares a fully private type with a private record structure, accessible only within the declaring package) but does not constitute an opaque type — it is simply a private type.

39. **Legality Rule:** Client packages shall not access the components of an opaque type through selected component notation. A conforming implementation shall reject any selected component reference to a component name of an opaque type from outside the declaring package.

40. **Legality Rule:** Client packages may:
- Declare objects of an opaque type.
- Pass objects of an opaque type as parameters.
- Assign objects of an opaque type (subject to limited type rules of 8652:2023 §7.5 if the type is also limited).
- Compare objects of an opaque type for equality (if the type is not limited).

41. The implementation exports sufficient information in the symbol file to enable clients to allocate objects of an opaque type (see §3.3, Static Semantics, paragraph 56).

42. This rule implements D9, providing Ada's information-hiding capability without requiring a separate specification file.

### 3.2.7 Dot Notation for Attributes

43. **Legality Rule:** Attribute references use dot notation. Where 8652:2023 specifies `X'Attr`, Safe uses `X.Attr`. The tick character (`'`) shall not appear in attribute references; it is reserved for character literals only. A conforming implementation shall reject any tick-based attribute reference.

44. See Section 2, §2.4.1 for the complete notation change specification and §2.5 for the retained attribute inventory.

45. **Resolution Rule:** When `name '.' identifier` appears in source text, the compiler shall resolve it as follows:

- (a) If the prefix `name` denotes a record type or an object of a record type, and `identifier` is a declared component of that record type, the construct is a selected component (record field access) per 8652:2023 §4.1.3.
- (b) Otherwise, if `identifier` is a language-defined attribute applicable to the type or object denoted by `name`, the construct is an attribute reference.
- (c) Otherwise, if the prefix `name` denotes a package, the construct is an expanded name per 8652:2023 §4.1.3 — a reference to a declaration within that package.
- (d) If none of the above applies, the construct is illegal and the implementation shall reject it.

46. **Legality Rule:** The cases in paragraph 45 are mutually exclusive for record types. A record type shall not declare a component whose `defining_identifier` matches the `identifier` of a language-defined attribute applicable to the type or to objects of the type. A conforming implementation shall reject such a component declaration.

47. **Note:** The mutual exclusion rule of paragraph 46 applies only to attributes that are applicable to the specific type or its objects. For example, a record type may not have a component named `Size` (because `Size` is applicable to all types per 8652:2023 §13.3) or `First` (if the record has a discriminant that makes `First` applicable). The complete list of reserved component names for a given type is derived from the retained attribute inventory (Section 2, §2.5) filtered by applicability.

48. **Parameterized attributes:** Attributes that take parameters use function-call syntax with dot notation:

```ada
T.Image(42)        -- equivalent of T'Image(42) in Ada
T.Value("123")     -- equivalent of T'Value("123") in Ada
T.Pos(E)           -- equivalent of T'Pos(E) in Ada
A.First(2)         -- first index of second dimension
```

49. The resolution of parameterized attribute references follows paragraph 45: the `identifier` after the dot is matched against applicable attributes. The parenthesized arguments are then checked against the attribute's parameter profile.

### 3.2.8 Type Annotation Syntax

50. **Legality Rule:** Qualified expression syntax (`T'(Expression)` in 8652:2023 §4.7) is replaced by type annotation syntax. A conforming implementation shall reject any qualified expression using tick-parenthesis notation.

51. See Section 2, §2.4.2 for the notation change specification.

52. The grammar production is:

```
annotated_expression ::=
    '(' expression ':' subtype_mark ')'
```

53. **Precedence:** The `:` in an annotated expression binds at the lowest precedence level within the parenthesized form. The parentheses are part of the syntax and are always required. An `annotated_expression` is a `primary` (see Section 8, §8.6.2).

54. **Legality Rule:** Parentheses are syntactically required around an annotated expression. The annotated expression may appear anywhere a `primary` may appear. When used as a subprogram argument, the outer parentheses of the annotated expression are distinct from the parentheses of the argument list:

```ada
Foo ((others => 0) : Buffer_Type);     -- annotated expression as argument
X := ((1, 2, 3) : Triple);             -- annotated expression in assignment
```

55. Type annotation serves the same purpose as Ada's qualified expression: disambiguating the type of aggregates and other context-dependent expressions. Since Safe has no overloading (Section 2, §2.1.4), type annotation is needed only for aggregate disambiguation.

---

## 3.3 Static Semantics

### 3.3.1 Symbol File Contents

56. A conforming implementation shall produce a symbol file for each compiled `package_unit`. The symbol file shall contain sufficient information for a client package (one that names the compiled package in a `with_clause`) to compile without access to the source text of the compiled package. At minimum, the symbol file shall contain:

- (a) The `package_name` of the compiled package.
- (b) For each `public` type declaration: the `defining_identifier`, the type category (enumeration, integer, modular, float, fixed, array, record, access, derived), and the full type definition — except that for opaque types (paragraph 37), only the size, alignment, and whether the type is limited are exported; the component list is not exported.
- (c) For each `public` subtype declaration: the `defining_identifier` and the subtype indication.
- (d) For each `public` object declaration: the `defining_identifier`, the subtype, and whether it is a constant.
- (e) For each `public` subprogram declaration: the `defining_identifier`, the parameter profile (parameter names, modes, and subtypes), and the return type (for functions).
- (f) For each `public` expression function declaration: the same information as subprogram declarations; the expression body is not exported (the function is called through the compiled object code).
- (g) For each `public` channel declaration: the `defining_identifier`, the element subtype, and the capacity.
- (h) For each `public` subtype of an access type: whether it is `not null`.

57. Private declarations (those without the `public` keyword) shall not appear in the symbol file. A client package shall have no means of referencing a private declaration.

58. The format of the symbol file is implementation-defined. See Annex C (Implementation Advice) for recommended formats.

### 3.3.2 Client Visibility

59. A client package that names a package `P` in a `with_clause` sees only the public declarations of `P`. All references to entities in `P` use expanded name notation: `P.Identifier`.

60. This replaces the Ada model where a `with` clause provides visibility of the package spec's visible part (8652:2023 §10.1.2). In Safe, the `with` clause provides visibility of all declarations bearing `public` in the named package's symbol file.

61. `use type` clauses within a client package may name a type from a `with`'d package to make that type's predefined operators directly visible (8652:2023 §8.4(5)), following the rules retained from 8652:2023 as specified in Section 2, §2.1.6.

### 3.3.3 Opaque Type Visibility

62. When a client package references an opaque type `P.T`:

- (a) The type name `P.T` is visible. The client may declare objects of type `P.T`, pass them as parameters, assign them (if not limited), and compare them for equality (if not limited).
- (b) The component names of `P.T` are not visible. The client shall not use selected component notation to access components of `P.T`.
- (c) The size and alignment of `P.T` are available to the implementation for object allocation and parameter passing. They are not required to be syntactically visible to the programmer (they are internal to the compiler's representation), though a client may query `P.T.Size` and `P.T.Alignment` using the retained attributes.
- (d) Operations declared `public` in `P` that take or return `P.T` are the client's means of manipulating values of the type.

63. This model is equivalent to Ada's private types (8652:2023 §7.3) but does not require a separate specification file. The symbol file carries the role of the private type's "partial view."

### 3.3.4 Child Packages

64. Child packages (8652:2023 §10.1.1) are retained. A child package `P.Q` is a separate source file (e.g., `p-q.safe` or `p.q.safe`, as determined by the implementation's file naming convention).

65. A child package has visibility into the public declarations of its parent package as if a `with` clause for the parent were present. A child package does not have visibility into the private declarations of its parent package.

66. **Note:** In 8652:2023, a private child has visibility into the parent's private part (§10.1.1(12)). In Safe, there is no `private` part and no `private` children. All child packages are public children. A child package sees only the parent's `public` declarations plus any declarations it `with`s.

### 3.3.5 Name Resolution Within a Package

67. Names within a `package_unit` are resolved by the following rules, applied in order at each point of reference:

- (a) Local declarations in the enclosing scope (for references within subprogram bodies, this includes interleaved declarations preceding the reference).
- (b) Package-level declarations preceding the reference in the `package_unit`.
- (c) Public declarations from packages named in `with_clauses`, accessed via expanded name notation (`P.Identifier`).
- (d) Declarations made directly visible by `use type` clauses (predefined operators only).
- (e) Language-defined entities (predefined types, predefined operators, predefined attributes).

68. Since overloading is excluded (Section 2, §2.1.4), each identifier in a given scope denotes at most one entity (excluding predefined operators made visible by `use type`). Name resolution is therefore unambiguous and can be performed in a single pass.

---

## 3.4 Dynamic Semantics

### 3.4.1 Package-Level Variable Initialization

69. Package-level variable declarations with initialization expressions are evaluated at program load time, in the order in which they appear in the source text (declaration order).

70. The initialization expression for a package-level variable shall be an expression that can be evaluated at load time. This includes:

- (a) Static expressions (8652:2023 §4.9).
- (b) Calls to functions declared within the same package that have already been elaborated (i.e., whose declarations precede the variable declaration).
- (c) Calls to public functions from `with`'d packages.
- (d) Aggregates composed of the above.
- (e) Allocators.

71. The order of initialization across packages follows the dependency order implied by `with_clauses`. If package `A` names package `B` in a `with_clause`, all of `B`'s variable initializers are evaluated before any of `A`'s variable initializers. A conforming implementation shall determine a valid initialization order from the `with_clause` dependency graph; if the graph contains a cycle (mutual `with_clauses`), the implementation shall reject the program.

72. This rule eliminates Ada's elaboration ordering problem (8652:2023 §10.2). There is no elaboration code, no `Elaborate` or `Elaborate_All` pragma, and no elaboration check at call sites.

### 3.4.2 No Elaboration-Time Code

73. A `package_unit` shall contain no executable statements at the package level (paragraph 28). The only code executed at load time is the evaluation of variable initialization expressions (paragraph 69). This evaluation is conceptually simultaneous with allocation and does not constitute "elaboration-time code" in the Ada sense — there is no `begin...end` block, no procedure call sequence, and no elaboration check.

74. Within subprogram bodies, all code executes when the subprogram is called, not when the package is loaded. Subprogram elaboration in the 8652:2023 sense consists only of recording the subprogram's existence in the symbol table.

### 3.4.3 Interleaved Declarations at Runtime

75. Within a subprogram body, a `basic_declaration` appearing as a `statement` is elaborated when control reaches it during execution. If the declaration includes an initialization expression, that expression is evaluated at the point of elaboration.

76. **Dynamic Semantics:** The lifetime of an object declared within a `sequence_of_statements` begins when control reaches the declaration and ends when control leaves the enclosing scope. For an access type object, automatic deallocation of the designated object (Section 2, §2.3.4) occurs at the end of the object's lifetime.

77. This corresponds to the semantics of C99 block-scoped declarations and is straightforward for the C99 code emitter.

---

## 3.5 Implementation Requirements

### 3.5.1 Symbol File Emission

78. A conforming implementation shall emit a symbol file for every successfully compiled `package_unit`. The symbol file shall contain the information specified in §3.3.1 and shall be sufficient for separate compilation of client packages.

79. The implementation shall update the symbol file only if its contents would differ from the existing symbol file for the same package (if any). This enables incremental recompilation: if a package's public interface has not changed, its symbol file does not change, and clients that depend only on the public interface need not be recompiled.

### 3.5.2 The `--emit-ada` Backend

80. When invoked with `--emit-ada`, a conforming implementation shall produce valid 8652:2023 source in the form of an `.ads` (specification) and `.adb` (body) file pair for each `package_unit`.

81. The emitted `.ads` file shall contain:
- (a) The `with` clauses from the Safe source, translated to Ada `with` and (if needed) `use type` clauses.
- (b) A `package P is ... end P;` declaration containing all `public` declarations from the Safe source.
- (c) For opaque types: a `type T is private;` declaration in the visible part and the full `type T is record ... end record;` declaration in a `private` part.
- (d) Subprogram specifications for all `public` subprograms.
- (e) Automatically generated `SPARK_Mode`, `Global`, `Depends`, and `Initializes` aspects (see Section 5).

82. The emitted `.adb` file shall contain:
- (a) A `package body P is ... end P;` containing subprogram bodies for all subprograms declared in the package (public and private).
- (b) An `Initializes` elaboration block (within `begin...end`) if the package has variable declarations with initialization expressions, translating the sequential initialization model of §3.4.1 to Ada's elaboration model.

83. The emitted Ada shall compile under GNAT with `SPARK_Mode` enabled and shall pass GNATprove at Bronze level (flow analysis) and Silver level (Absence of Runtime Errors) with no user-supplied annotations. See Section 5 for the complete SPARK assurance specification.

### 3.5.3 The `--emit-c` Backend

84. When invoked with `--emit-c` (or by default), the implementation shall produce C99 source code. Package-level declarations map to file-scope C declarations. `public` declarations shall have external linkage; private declarations shall have `static` (internal) linkage.

85. Package-level variable initializers shall be emitted as assignments in an initialization function called before `main`. The initialization order shall respect the `with_clause` dependency order (paragraph 71).

86. Interleaved declarations within subprogram bodies shall be emitted as C99 block-scoped declarations at the corresponding point within the function body.

### 3.5.4 Incremental Recompilation

87. A conforming implementation should support incremental recompilation. The implementation shall track dependencies between compilation units via `with_clauses`. When a source file is modified:

- (a) The modified file shall be recompiled.
- (b) If the resulting symbol file differs from the previous symbol file, all compilation units that name the modified package in a `with_clause` shall be recompiled (transitively).
- (c) If the resulting symbol file is identical to the previous symbol file (i.e., the public interface did not change), dependent compilation units need not be recompiled.

88. This is a consequence of the symbol file model: the symbol file is the unit of interface description, and its content hash determines recompilation necessity.

---

## 3.6 Examples

### 3.6.1 A Simple Package with Public Types and Functions

89. The following package declares a numeric type, a subtype, and arithmetic functions. Public declarations are marked; private declarations are accessible only within the package.

```ada
-- file: temperatures.safe

package Temperatures is

    public type Kelvin is digits 6 range 0.0 .. 10_000.0;

    public subtype Room_Temp is Kelvin range 273.15 .. 373.15;

    Absolute_Zero : constant Kelvin := 0.0;

    public function To_Celsius (K : Kelvin) return Kelvin is
    begin
        return K - 273.15;
    end To_Celsius;

    public function To_Fahrenheit (K : Kelvin) return Kelvin is
    begin
        Celsius : Kelvin := To_Celsius (K);
        return Celsius * 1.8 + 32.0;
    end To_Fahrenheit;

    public function Is_Room_Temperature (K : Kelvin) return Boolean
    is (K in Room_Temp);

end Temperatures;
```

90. In this example, `Kelvin`, `Room_Temp`, `To_Celsius`, `To_Fahrenheit`, and `Is_Room_Temperature` are visible to clients. `Absolute_Zero` is private and accessible only within the package.

### 3.6.2 A Package with Opaque Types

91. The following package declares an opaque type whose internal structure is hidden from clients.

```ada
-- file: buffers.safe

package Buffers is

    public type Byte is mod 256;

    public type Buffer_Size is range 1 .. 4096;

    public type Buffer is private record
        Data  : array (1 .. 4096) of Byte := (others => 0);
        Len   : Buffer_Size := 1;
        Read  : Buffer_Size := 1;
        Write : Buffer_Size := 1;
    end record;

    public function Create (Size : Buffer_Size) return Buffer is
    begin
        return (Data  => (others => 0),
                Len   => Size,
                Read  => 1,
                Write => 1);
    end Create;

    public function Length (B : Buffer) return Buffer_Size
    is (B.Len);

    public function Is_Empty (B : Buffer) return Boolean
    is (B.Read = B.Write);

    public procedure Put (B : in out Buffer; Item : Byte) is
    begin
        B.Data (B.Write) := Item;
        Next : Buffer_Size := B.Write + 1;
        if Next > B.Len then
            Next := 1;
        end if;
        B.Write := Next;
    end Put;

    public function Get (B : in out Buffer) return Byte is
    begin
        Result : Byte := B.Data (B.Read);
        Next : Buffer_Size := B.Read + 1;
        if Next > B.Len then
            Next := 1;
        end if;
        B.Read := Next;
        return Result;
    end Get;

end Buffers;
```

92. Clients of `Buffers` can declare objects of type `Buffer`, call `Create`, `Length`, `Is_Empty`, `Put`, and `Get`, but cannot access the `Data`, `Len`, `Read`, or `Write` components directly:

```ada
-- client code:
with Buffers;
-- ...
Buf : Buffers.Buffer := Buffers.Create (256);
Buffers.Put (Buf, 42);
-- Buf.Data(1) := 0;  -- ILLEGAL: Data is not visible (opaque type)
```

### 3.6.3 Two Packages with Inter-Package Dependency

93. The following pair of packages demonstrates the `with_clause` dependency mechanism.

```ada
-- file: units.safe

package Units is

    public type Meters is range 0 .. 1_000_000;

    public type Seconds is range 1 .. 86_400;

    public type Velocity is range 0 .. 1_000_000;

    public function Speed (D : Meters; T : Seconds) return Velocity is
    begin
        -- T is of type Seconds (range 1..86400), which excludes zero.
        -- Division is Silver-provable per Section 2, §2.8.3.
        return Velocity (D / T);
    end Speed;

end Units;
```

```ada
-- file: navigation.safe

with Units;

package Navigation is

    public type Heading is mod 360;

    public type Waypoint is record
        Distance : Units.Meters  := 0;
        Bearing  : Heading       := 0;
        ETA      : Units.Seconds := 1;
    end record;

    public function Time_To_Arrival
        (W : Waypoint; Current_Speed : Units.Velocity) return Units.Seconds
    is
    begin
        if Current_Speed = 0 then
            return Units.Seconds.Last;
        end if;
        -- Current_Speed is non-zero here; but the type Velocity includes 0.
        -- We must narrow to a non-zero subtype for division.
        subtype Nonzero_Velocity is Units.Velocity range 1 .. Units.Velocity.Last;
        V : Nonzero_Velocity := Nonzero_Velocity (Current_Speed);
        return Units.Seconds (W.Distance / V);
    end Time_To_Arrival;

    Default_Waypoint : constant Waypoint :=
        (Distance => 0, Bearing => 0, ETA => 1);

    public function Is_Arrived (W : Waypoint) return Boolean
    is (W.Distance = 0);

end Navigation;
```

94. `Navigation` names `Units` in its `with_clause`. All references to entities declared in `Units` use expanded name notation: `Units.Meters`, `Units.Seconds`, `Units.Velocity`, `Units.Seconds.Last`. The `with_clause` establishes a compilation dependency: `Units` must be compiled before `Navigation`, and the symbol file for `Units` must be available when compiling `Navigation`.

95. Note the subtype declaration for `Nonzero_Velocity` interleaved within the subprogram body. This subtype is local and visible only from its point of declaration to the end of `Time_To_Arrival`. The division `W.Distance / V` is Silver-provable because `V` is of type `Nonzero_Velocity`, whose range excludes zero (Section 2, §2.8.3).

### 3.6.4 Interleaved Declarations, Dot Notation, and Type Annotation

96. The following package demonstrates interleaved declarations in subprogram bodies, dot notation for attributes, and type annotation syntax.

```ada
-- file: sensors.safe

with Interfaces;

package Sensors is

    public type Reading is range 0 .. 4095;

    public type Channel_Id is range 0 .. 7;

    public subtype Channel_Count is Integer range 1 .. 8;

    type Calibration is record
        Offset : Reading := 0;
        Scale  : Integer := 100;   -- percentage, e.g. 100 = 1.0x
    end record;

    Cal_Table : array (Channel_Id) of Calibration :=
        (others => (Offset => 0, Scale => 100));

    -- Forward declarations for mutual recursion
    public function Raw_Reading (Ch : Channel_Id) return Reading;
    function Apply_Calibration (R : Reading; C : Calibration) return Reading;

    -- Full declaration completing the forward declaration
    public function Raw_Reading (Ch : Channel_Id) return Reading is
    begin
        -- Dot notation for attribute: Channel_Id.First is an attribute reference
        -- (equivalent to Channel_Id'First in Ada).
        pragma Assert (Ch in Channel_Id.First .. Channel_Id.Last);

        -- Interleaved declaration: local variable declared after pragma Assert
        Adc_Value : Interfaces.Unsigned_16 := Read_Hardware_Register (Ch);

        -- Type annotation syntax for disambiguating aggregate type.
        -- Parentheses are required around the annotated expression.
        Default : Reading := (0 : Reading);

        -- Dot notation for attribute: Reading.Last is an attribute reference.
        if Adc_Value > Interfaces.Unsigned_16 (Reading.Last) then
            return Default;
        end if;

        -- Interleaved declaration after if-statement
        Raw : Reading := Reading (Adc_Value);
        return Apply_Calibration (Raw, Cal_Table (Ch));
    end Raw_Reading;

    function Apply_Calibration (R : Reading; C : Calibration) return Reading is
    begin
        -- Wide intermediate arithmetic (Section 2, §2.8.1):
        -- Integer(R) * C.Scale computes in wide integers.
        -- No overflow on intermediate; narrowing at assignment point.
        Scaled : Integer := Integer (R) * C.Scale / 100;

        -- Interleaved declaration after arithmetic
        Adjusted : Integer := Scaled + Integer (C.Offset);

        -- Dot notation for parameterized attribute: Reading.First
        if Adjusted < Integer (Reading.First) then
            return Reading.First;
        elsif Adjusted > Integer (Reading.Last) then
            return Reading.Last;
        end if;

        return Reading (Adjusted);
    end Apply_Calibration;

    public function Average (Count : Channel_Count) return Reading is
    begin
        Total : Integer := 0;

        -- Dot notation for attribute: Channel_Id.First
        for I in Channel_Id.First .. Channel_Id (Count - 1) loop
            -- Interleaved declaration inside loop
            R : Reading := Raw_Reading (I);
            Total := Total + Integer (R);
        end loop;

        -- Count is Channel_Count (1..8), excludes zero.
        -- Division by Count is Silver-provable (Section 2, §2.8.3).
        return Reading (Total / Count);
    end Average;

    function Read_Hardware_Register
        (Ch : Channel_Id) return Interfaces.Unsigned_16 is separate;

end Sensors;
```

97. This example demonstrates:

- **Interleaved declarations** (D11): `Adc_Value`, `Default`, `Raw`, `Scaled`, `Adjusted`, `R`, and `Total` are all declared within subprogram bodies after `begin`, interleaved with statements. Each is visible from its point of declaration to the end of the enclosing subprogram body (or loop body, for `R`).

- **Dot notation for attributes** (D20): `Channel_Id.First`, `Channel_Id.Last`, `Reading.Last`, and `Reading.First` are attribute references using dot notation. The compiler resolves these as attributes because `Channel_Id` and `Reading` are scalar types (not record types), and `First`, `Last` are applicable attributes per 8652:2023 §3.5(12–13). There is no ambiguity with record field access because scalar types have no components.

- **Type annotation syntax** (D21): The expression `(0 : Reading)` is an annotated expression. The parentheses are syntactically required. The `:` binds at the lowest precedence inside the parentheses, so the subexpression `0` is the full expression being annotated with type `Reading`.

- **Forward declarations** (D10): `Raw_Reading` and `Apply_Calibration` are forward-declared because `Raw_Reading` calls `Apply_Calibration` and both need to be visible at their call sites. The forward declarations provide the signatures; the completing declarations provide the bodies.

- **`is separate`** (8652:2023 §10.1.3): `Read_Hardware_Register` has its body in a separate file (a subunit), demonstrating that the single-file model supports subunits for physical isolation of platform-specific code.

---

## 3.7 Relationship to 8652:2023

98. The following table summarizes which 8652:2023 package-related sections are retained, modified, or excluded by this section.

| 8652:2023 Section | Topic | Status in Safe |
|---|---|---|
| §7.1 | Package Specifications | Replaced by `package_unit` (§3.1.2) |
| §7.2 | Package Bodies | Excluded — no separate body (§3.2.4) |
| §7.3 | Private Types and Private Extensions | Replaced by `public`/opaque model (§3.2.5, §3.2.6) |
| §7.3.1 | Private Operations | Retained in principle; private declarations are accessible within the package |
| §7.3.2 | Type Invariants | Excluded (Section 2, §2.1.5) |
| §7.4 | Deferred Constants | Excluded — no separate spec and body |
| §7.5 | Limited Types | Retained (Section 2, §2.1.5) |
| §7.6 | Assignment and Finalization | Controlled types excluded; assignment retained (Section 2, §2.1.5) |
| §10.1 | Separate Compilation | Modified — single-file model (§3.1.1) |
| §10.1.1 | Compilation Units — Library Units | Modified — child packages retained (§3.3.4) |
| §10.1.2 | Context Clauses — With Clauses | Retained with modifications (§3.1.1) |
| §10.1.3 | Subunits | Retained |
| §10.2 | Program Execution | Modified — no elaboration ordering (§3.4.1) |
| §10.2.1 | Elaboration Control | Excluded — not needed (§3.2.4) |
