# Section 8 — Syntax Summary

1. This section provides the complete consolidated grammar for Safe. All productions use the BNF notation conventions of 8652:2023 §1.1.4:

- `::=` for productions
- `[ ]` for optional elements
- `{ }` for zero or more repetitions
- `|` for alternation
- **bold** for keywords (rendered as lowercase in source code)
- *italic* or `snake_case` for nonterminal symbols

2. This grammar is authoritative. Where it differs from 8652:2023, this grammar takes precedence for Safe programs. Productions retained unchanged from 8652:2023 are included for completeness and reference the originating section.

---

## 8.1 Compilation Units

```
compilation ::=
    { compilation_unit }

compilation_unit ::=
    context_clause package_unit

context_clause ::=
    { with_clause }

with_clause ::=
    'with' library_unit_name { ',' library_unit_name } ';'

library_unit_name ::=
    identifier { '.' identifier }
```

3. **Note:** Each `.safe` source file contains exactly one `compilation_unit`. `use` clauses do not appear in context clauses — only `with` clauses are permitted at the compilation unit level. `use type` clauses appear within package declarations.

---

## 8.2 Packages

```
package_unit ::=
    'package' defining_identifier { '.' defining_identifier } 'is'
        { package_declarative_item }
    'end' defining_identifier { '.' defining_identifier } ';'

package_declarative_item ::=
    basic_declaration
  | use_type_clause
  | representation_clause
  | task_declaration
  | channel_declaration
  | pragma
```

4. **Note:** There is no `package body` construct, no `begin ... end` initialization block, and no `private` section divider. All declarations appear in a flat sequence. Visibility is controlled by the `public` keyword on individual declarations.

---

## 8.3 Declarations

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

type_definition ::=
    enumeration_type_definition
  | signed_integer_type_definition
  | modular_type_definition
  | floating_point_definition
  | ordinary_fixed_point_definition
  | decimal_fixed_point_definition
  | array_type_definition
  | record_type_definition
  | private_record_type_definition
  | access_type_definition
  | derived_type_definition

subtype_declaration ::=
    [ 'public' ] 'subtype' defining_identifier 'is' subtype_indication ';'

object_declaration ::=
    [ 'public' ] defining_identifier_list ':' [ 'constant' ]
        subtype_indication [ ':=' expression ] ';'
  | [ 'public' ] defining_identifier_list ':' [ 'constant' ]
        array_type_definition [ ':=' expression ] ';'

number_declaration ::=
    defining_identifier_list ':' 'constant' ':=' static_expression ';'

defining_identifier_list ::=
    defining_identifier { ',' defining_identifier }
```

---

## 8.4 Types

### 8.4.1 Enumeration Types

```
enumeration_type_definition ::=
    '(' enumeration_literal { ',' enumeration_literal } ')'

enumeration_literal ::=
    defining_identifier | defining_character_literal

defining_character_literal ::=
    character_literal
```

### 8.4.2 Integer Types

```
signed_integer_type_definition ::=
    'range' simple_expression '..' simple_expression

modular_type_definition ::=
    'mod' static_expression
```

### 8.4.3 Real Types

```
floating_point_definition ::=
    'digits' static_expression [ real_range_specification ]

ordinary_fixed_point_definition ::=
    'delta' static_expression real_range_specification

decimal_fixed_point_definition ::=
    'delta' static_expression 'digits' static_expression
        [ real_range_specification ]

real_range_specification ::=
    'range' simple_expression '..' simple_expression
```

### 8.4.4 Array Types

```
array_type_definition ::=
    unconstrained_array_definition
  | constrained_array_definition

unconstrained_array_definition ::=
    'array' '(' index_subtype_definition { ',' index_subtype_definition } ')'
        'of' component_definition

constrained_array_definition ::=
    'array' '(' discrete_subtype_definition { ',' discrete_subtype_definition } ')'
        'of' component_definition

index_subtype_definition ::=
    subtype_mark 'range' '<>'

discrete_subtype_definition ::=
    subtype_indication | range

component_definition ::=
    [ 'aliased' ] subtype_indication
  | [ 'aliased' ] access_definition
```

### 8.4.5 Record Types

```
record_type_definition ::=
    [ [ 'abstract' ] 'limited' ] record_definition

record_definition ::=
    'record'
        component_list
    'end' 'record'
  | 'null' 'record'

private_record_type_definition ::=
    'private' 'record'
        component_list
    'end' 'record'

component_list ::=
    component_item { component_item }
  | { component_item } variant_part
  | 'null' ';'

component_item ::=
    component_declaration
  | representation_clause

component_declaration ::=
    defining_identifier_list ':' component_definition
        [ ':=' default_expression ] ';'

variant_part ::=
    'case' discriminant_direct_name 'is'
        variant { variant }
    'end' 'case' ';'

variant ::=
    'when' discrete_choice_list '=>'
        component_list

discrete_choice_list ::=
    discrete_choice { '|' discrete_choice }

discrete_choice ::=
    choice_expression
  | discrete_subtype_indication
  | range
  | 'others'
```

### 8.4.6 Discriminants

```
known_discriminant_part ::=
    '(' discriminant_specification { ';' discriminant_specification } ')'

discriminant_specification ::=
    defining_identifier_list ':' subtype_mark
        [ ':=' default_expression ]
```

5. **Note:** Discriminants are restricted to discrete types with static constraints. Access discriminants are excluded.

### 8.4.7 Access Types

```
access_type_definition ::=
    [ 'not' 'null' ] access_to_object_definition

access_to_object_definition ::=
    'access' [ general_access_modifier ] subtype_indication

general_access_modifier ::=
    'all' | 'constant'

access_definition ::=
    [ 'not' 'null' ] 'access' [ 'all' ] subtype_mark
  | [ 'not' 'null' ] 'access' [ 'constant' ] subtype_mark

incomplete_type_declaration ::=
    'type' defining_identifier [ known_discriminant_part ] ';'
```

6. **Note:** Access-to-subprogram definitions are excluded. The SPARK 2022 ownership and borrowing rules apply to all access types (Section 2, §2.3).

### 8.4.8 Derived Types

```
derived_type_definition ::=
    [ 'abstract' ] [ 'limited' ] 'new' subtype_indication
```

7. **Note:** Only derivation from non-tagged types is permitted. Type extensions (`with record ...`) are excluded.

---

## 8.5 Subtype Indications

```
subtype_indication ::=
    [ 'not' 'null' ] subtype_mark [ constraint ]

subtype_mark ::=
    name

constraint ::=
    range_constraint
  | index_constraint
  | discriminant_constraint

range_constraint ::=
    'range' range

range ::=
    simple_expression '..' simple_expression
  | name '.' 'Range' [ '(' expression ')' ]

index_constraint ::=
    '(' discrete_range { ',' discrete_range } ')'

discrete_range ::=
    subtype_indication | range

discriminant_constraint ::=
    '(' discriminant_association { ',' discriminant_association } ')'

discriminant_association ::=
    [ selector_name { '|' selector_name } '=>' ] expression
```

---

## 8.6 Names and Expressions

### 8.6.1 Names

```
name ::=
    direct_name
  | indexed_component
  | slice
  | selected_component
  | attribute_reference
  | type_conversion
  | function_call
  | explicit_dereference

direct_name ::=
    identifier

indexed_component ::=
    name '(' expression { ',' expression } ')'

slice ::=
    name '(' discrete_range ')'

selected_component ::=
    name '.' selector_name

selector_name ::=
    identifier | character_literal

attribute_reference ::=
    name '.' attribute_designator

attribute_designator ::=
    identifier [ '(' expression { ',' expression } ')' ]
```

8. **Note:** Attribute references use dot notation (`X.First`, `T.Image(42)`) rather than tick notation. The parser resolves `name '.' identifier` as either a selected component or an attribute reference based on the type of the prefix (§2.4.1).

```
explicit_dereference ::=
    name '.' 'all'

type_conversion ::=
    subtype_mark '(' expression ')'

function_call ::=
    name [ actual_parameter_part ]

actual_parameter_part ::=
    '(' parameter_association { ',' parameter_association } ')'

parameter_association ::=
    [ selector_name '=>' ] expression
```

### 8.6.2 Expressions

```
expression ::=
    relation { 'and' relation }
  | relation { 'and' 'then' relation }
  | relation { 'or' relation }
  | relation { 'or' 'else' relation }
  | relation { 'xor' relation }

relation ::=
    simple_expression [ relational_operator simple_expression ]
  | simple_expression [ 'not' ] 'in' membership_choice_list

membership_choice_list ::=
    membership_choice { '|' membership_choice }

membership_choice ::=
    choice_simple_expression | range | subtype_mark

simple_expression ::=
    [ unary_adding_operator ] term { binary_adding_operator term }

term ::=
    factor { multiplying_operator factor }

factor ::=
    primary [ '**' primary ]
  | 'abs' primary
  | 'not' primary

primary ::=
    numeric_literal
  | string_literal
  | character_literal
  | 'null'
  | name
  | allocator
  | aggregate
  | conditional_expression
  | declare_expression
  | '(' expression ')'
  | annotated_expression

annotated_expression ::=
    '(' expression ':' subtype_mark ')'

conditional_expression ::=
    if_expression | case_expression

if_expression ::=
    'if' condition 'then' expression
    { 'elsif' condition 'then' expression }
    'else' expression

case_expression ::=
    'case' expression 'is'
        case_expression_alternative { ',' case_expression_alternative }

case_expression_alternative ::=
    'when' discrete_choice_list '=>' expression

declare_expression ::=
    'declare' { object_declaration }
    'begin' expression

choice_expression ::=
    choice_relation { 'and' choice_relation }
  | choice_relation { 'or' choice_relation }

choice_simple_expression ::=
    [ unary_adding_operator ] term { binary_adding_operator term }

choice_relation ::=
    simple_expression [ relational_operator simple_expression ]

condition ::=
    expression
```

9. **Note:** Qualified expressions (`T'(Expr)`) are excluded. Type annotation syntax (`(Expr : T)`) is used instead, specified as `annotated_expression`.

### 8.6.3 Operators

```
relational_operator ::=
    '=' | '/=' | '<' | '<=' | '>' | '>='

binary_adding_operator ::=
    '+' | '-' | '&'

unary_adding_operator ::=
    '+' | '-'

multiplying_operator ::=
    '*' | '/' | 'mod' | 'rem'
```

### 8.6.4 Aggregates

```
aggregate ::=
    record_aggregate
  | array_aggregate
  | delta_aggregate

record_aggregate ::=
    '(' record_component_association_list ')'

record_component_association_list ::=
    record_component_association { ',' record_component_association }
  | 'null' 'record'

record_component_association ::=
    [ component_choice_list '=>' ] expression
  | component_choice_list '=>' '<>'

component_choice_list ::=
    selector_name { '|' selector_name }
  | 'others'

array_aggregate ::=
    positional_array_aggregate
  | named_array_aggregate

positional_array_aggregate ::=
    '(' expression ',' expression { ',' expression } ')'
  | '(' expression { ',' expression } ',' 'others' '=>' expression ')'
  | '(' expression { ',' expression } ',' 'others' '=>' '<>' ')'

named_array_aggregate ::=
    '(' array_component_association { ',' array_component_association } ')'

array_component_association ::=
    discrete_choice_list '=>' expression
  | discrete_choice_list '=>' '<>'

delta_aggregate ::=
    '(' expression 'with' 'delta'
        record_component_association_list ')'
  | '(' expression 'with' 'delta'
        array_component_association { ',' array_component_association } ')'
```

### 8.6.5 Allocators

```
allocator ::=
    'new' subtype_indication
  | 'new' subtype_indication '(' expression ')'
```

10. **Note:** Allocators create owning access values under the SPARK ownership model (§2.3).

---

## 8.7 Statements

```
sequence_of_statements ::=
    statement { statement }

statement ::=
    { label } simple_statement
  | { label } compound_statement
  | basic_declaration

label ::=
    '<<' identifier '>>'

simple_statement ::=
    null_statement
  | assignment_statement
  | procedure_call_statement
  | return_statement
  | goto_statement
  | exit_statement
  | delay_statement
  | send_statement
  | receive_statement
  | try_send_statement
  | try_receive_statement
  | pragma

compound_statement ::=
    if_statement
  | case_statement
  | loop_statement
  | block_statement
  | extended_return_statement
  | select_statement

null_statement ::=
    'null' ';'

assignment_statement ::=
    name ':=' expression ';'

procedure_call_statement ::=
    name [ actual_parameter_part ] ';'

return_statement ::=
    'return' [ expression ] ';'

goto_statement ::=
    'goto' identifier ';'

exit_statement ::=
    'exit' [ identifier ] [ 'when' condition ] ';'

delay_statement ::=
    'delay' expression ';'
  | 'delay' 'until' expression ';'
```

11. **Note:** Inside subprogram bodies (after `begin`), `basic_declaration` is permitted as a statement, enabling interleaved declarations and statements (D11). A declaration is visible from its point of declaration to the end of the enclosing scope.

### 8.7.1 Compound Statements

```
if_statement ::=
    'if' condition 'then'
        sequence_of_statements
    { 'elsif' condition 'then'
        sequence_of_statements }
    [ 'else'
        sequence_of_statements ]
    'end' 'if' ';'

case_statement ::=
    'case' expression 'is'
        case_statement_alternative { case_statement_alternative }
    'end' 'case' ';'

case_statement_alternative ::=
    'when' discrete_choice_list '=>'
        sequence_of_statements

loop_statement ::=
    [ identifier ':' ]
    [ iteration_scheme ] 'loop'
        sequence_of_statements
    'end' 'loop' [ identifier ] ';'

iteration_scheme ::=
    'while' condition
  | 'for' defining_identifier 'in' [ 'reverse' ] discrete_subtype_definition
  | 'for' defining_identifier 'of' [ 'reverse' ] name

block_statement ::=
    [ identifier ':' ]
    [ 'declare'
        { basic_declaration } ]
    'begin'
        sequence_of_statements
    'end' [ identifier ] ';'

extended_return_statement ::=
    'return' defining_identifier ':' [ 'constant' ] subtype_indication
        [ ':=' expression ]
    [ 'do'
        sequence_of_statements
    'end' 'return' ] ';'
```

12. **Note:** Exception handlers are excluded from block statements and subprogram bodies. The `for E of Array_Name` form of iteration is retained for array component iteration.

---

## 8.8 Subprograms

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

formal_part ::=
    '(' parameter_specification { ';' parameter_specification } ')'

parameter_specification ::=
    defining_identifier_list ':' [ 'aliased' ] parameter_mode
        subtype_mark [ ':=' default_expression ]

parameter_mode ::=
    [ 'in' ] | 'in' 'out' | 'out'

default_expression ::=
    expression

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

13. **Note:** Subprogram bodies appear at the point of declaration (D10). There is no separate `subprogram_body` construct at the package level — the body is part of the declaration. Forward declarations are permitted only for mutual recursion.

---

## 8.9 Renaming and Separate Bodies

```
renaming_declaration ::=
    object_renaming_declaration
  | package_renaming_declaration
  | subprogram_renaming_declaration

object_renaming_declaration ::=
    defining_identifier ':' [ 'not' 'null' ] subtype_mark
        'renames' name ';'

package_renaming_declaration ::=
    'package' defining_identifier 'renames' name ';'

subprogram_renaming_declaration ::=
    subprogram_specification 'renames' name ';'

subunit_stub ::=
    subprogram_specification 'is' 'separate' ';'

subunit ::=
    'separate' '(' library_unit_name ')'
        subprogram_specification 'is'
        subprogram_body
```

14. **Note:** Exception renaming declarations and generic renaming declarations are excluded.

---

## 8.10 Use Type Clauses

```
use_type_clause ::=
    'use' 'type' subtype_mark { ',' subtype_mark } ';'
```

15. **Note:** General `use` clauses (`use Package_Name;`) are excluded. Only `use type` clauses are permitted.

---

## 8.11 Representation Clauses

```
representation_clause ::=
    attribute_definition_clause
  | enumeration_representation_clause
  | record_representation_clause
  | aspect_specification_declaration

attribute_definition_clause ::=
    'for' name 'use' expression ';'

enumeration_representation_clause ::=
    'for' defining_identifier 'use' aggregate ';'

record_representation_clause ::=
    'for' defining_identifier 'use' 'record' [ 'at' 'mod' expression ';' ]
        { component_clause }
    'end' 'record' ';'

component_clause ::=
    component_name 'at' expression 'range'
        simple_expression '..' simple_expression ';'

aspect_specification_declaration ::=
    'for' name 'use' aspect_mark '=>' expression ';'

aspect_mark ::=
    identifier
```

---

## 8.12 Tasks and Channels

```
task_declaration ::=
    'task' defining_identifier [ task_aspect_clause ] 'is'
    'begin'
        sequence_of_statements
    'end' defining_identifier ';'

task_aspect_clause ::=
    'with' 'Priority' '=>' static_expression

channel_declaration ::=
    [ 'public' ] 'channel' defining_identifier ':' subtype_mark
        'capacity' static_expression ';'

send_statement ::=
    'send' channel_name ',' expression ';'

receive_statement ::=
    'receive' channel_name ',' name ';'

try_send_statement ::=
    'try_send' channel_name ',' expression ',' name ';'

try_receive_statement ::=
    'try_receive' channel_name ',' name ',' name ';'

channel_name ::=
    name

select_statement ::=
    'select'
        select_arm
    { 'or' select_arm }
    'end' 'select' ';'

select_arm ::=
    channel_receive_arm
  | delay_arm

channel_receive_arm ::=
    'when' defining_identifier ':' subtype_mark 'from' channel_name '=>'
        sequence_of_statements

delay_arm ::=
    'delay' expression '=>'
        sequence_of_statements
```

16. **Note:** Task declarations create exactly one static task each. Channel element types must be definite. Channel capacity is a static expression. The `select` statement multiplexes across channel receive operations and delay timeouts only — no send arms.

---

## 8.13 Pragmas

```
pragma ::=
    'pragma' identifier [ '(' pragma_argument_association
        { ',' pragma_argument_association } ')' ] ';'

pragma_argument_association ::=
    [ identifier '=>' ] expression
  | [ identifier '=>' ] name
```

17. **Note:** Only retained pragmas are permitted (§2.6). A conforming implementation shall reject any pragma not listed as retained.

---

## 8.14 Lexical Elements

```
identifier ::=
    letter { [ '_' ] letter_or_digit }

letter_or_digit ::=
    letter | digit

letter ::=
    'A' .. 'Z' | 'a' .. 'z'

digit ::=
    '0' .. '9'

numeric_literal ::=
    decimal_literal | based_literal

decimal_literal ::=
    numeral [ '.' numeral ] [ exponent ]

numeral ::=
    digit { [ '_' ] digit }

exponent ::=
    'E' [ '+' | '-' ] numeral

based_literal ::=
    numeral '#' based_numeral [ '.' based_numeral ] '#' [ exponent ]

based_numeral ::=
    extended_digit { [ '_' ] extended_digit }

extended_digit ::=
    digit | 'A' .. 'F' | 'a' .. 'f'

character_literal ::=
    ''' graphic_character '''

string_literal ::=
    '"' { string_element } '"'

string_element ::=
    graphic_character | '""'

static_expression ::=
    expression
```

18. **Note:** `static_expression` is syntactically identical to `expression` but is subject to the static evaluation rules of 8652:2023 §4.9.

---

## 8.15 Reserved Words

19. The following identifiers are reserved words in Safe. They include all Ada 2022 reserved words that are relevant to retained features, plus the Safe-specific keywords.

### Ada 2022 Reserved Words — Retained

```
abort        -- excluded by restriction, but remains reserved
abs          abstract     accept       -- excluded, reserved
access       aliased      all          and
array        at

begin        body         -- excluded contextually, reserved

case         constant

declare      delay        delta        digits
do

else         elsif        end          entry        -- excluded, reserved
exception    -- excluded, reserved
exit

for          function

generic      -- excluded, reserved
goto

if           in           is

limited      loop

mod

new          not          null

of           or           others       out
overriding   -- excluded, reserved

package      pragma       private      procedure

raise        -- excluded, reserved
range        record       rem          renames
return       reverse

select       separate     subtype

task         terminate    -- excluded, reserved
then         type

until        use

when         while        with

xor
```

### Safe-Specific Keywords

```
public       -- visibility annotation (D8)
channel      -- channel declaration (D28)
send         -- channel send statement (D28)
receive      -- channel receive statement (D28)
try_send     -- non-blocking send (D28)
try_receive  -- non-blocking receive (D28)
from         -- select arm channel source (D28)
capacity     -- channel buffer size (D28)
```

20. **Note:** Safe-specific keywords are reserved words. An identifier matching any of these words is reserved and cannot be used as a user-defined identifier.

---

## 8.16 Production Count

21. This grammar contains approximately 148 productions, organized as follows:

| Category | Productions | Count |
|---|---|---|
| Compilation units | §8.1 | 5 |
| Packages | §8.2 | 2 |
| Declarations | §8.3 | 8 |
| Types | §8.4 | 32 |
| Subtype indications | §8.5 | 8 |
| Names and expressions | §8.6 | 36 |
| Statements | §8.7 | 21 |
| Subprograms | §8.8 | 13 |
| Renaming and subunits | §8.9 | 6 |
| Use type clauses | §8.10 | 1 |
| Representation | §8.11 | 6 |
| Tasks and channels | §8.12 | 12 |
| Pragmas | §8.13 | 2 |
| Lexical elements | §8.14 | 14 |
| **Total** | | **~148** |
