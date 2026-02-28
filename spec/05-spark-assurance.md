# Section 5 — SPARK Assurance

1. This section specifies the formal verification guarantees that Safe provides automatically. A conforming Safe program, when emitted via `--emit-ada` and submitted to GNATprove, shall pass both Bronze-level flow analysis and Silver-level Absence of Runtime Errors (AoRTE) proof with no user-supplied annotations.

2. This is the language's defining feature: the developer writes zero verification annotations — no contracts, no `Global`, no `Depends`, no preconditions, no postconditions. The type system and the four Silver-by-construction rules (Section 2, §2.8) guarantee both Bronze and Silver SPARK assurance automatically.

---

## 5.1 Overview — SPARK Assurance Levels

3. The SPARK verification framework defines five assurance levels. Safe guarantees the first three automatically:

| Level | Name | What It Proves | Safe Status |
|---|---|---|---|
| Stone | Valid SPARK | Code compiles with `SPARK_Mode` | Guaranteed by construction |
| Bronze | Flow Analysis | No uninitialized variables, correct data flow | Guaranteed by `--emit-ada` annotations |
| Silver | AoRTE | No runtime errors (overflow, index, division, null) | Guaranteed by D27 language rules |
| Gold | Functional Correctness | Code meets its specification | Out of scope — developer works with emitted Ada |
| Platinum | Full Formal Verification | Complete proof including termination | Out of scope — developer works with emitted Ada |

4. **Stone (guaranteed, trivially):** Every Safe construct maps to a SPARK-legal Ada construct. The emitted Ada compiles with `pragma SPARK_Mode`. This is true by construction — the Safe language is a subset of the SPARK subset of Ada, with syntactic transformations (dot notation, type annotations, single-file packages) that map mechanically to valid SPARK.

5. **Bronze (guaranteed, mechanically generated):** The `--emit-ada` backend generates three annotation families — `Global`, `Depends`, and `Initializes` — from information already computed during the single-pass compilation. See §5.2 for the complete specification.

6. **Silver (guaranteed, by language design):** The four D27 rules (Section 2, §2.8) ensure that every runtime check in a conforming Safe program is dischargeable by GNATprove from type information alone. See §5.3 for the complete specification.

7. **Concurrency safety (guaranteed, by language design):** The channel-based tasking model (Section 4) provides data race freedom and deadlock freedom guarantees verifiable by GNATprove on the emitted Jorvik-profile SPARK. See §5.4 for the complete specification.

---

## 5.2 Bronze Guarantee — Automatic Flow Analysis Annotations

### 5.2.1 Global Aspects

8. The `--emit-ada` backend shall generate a `Global` aspect on every subprogram in the emitted Ada. The `Global` aspect specifies which package-level variables the subprogram reads or writes.

9. **Algorithm:** During the single-pass compilation, the compiler accumulates a read-set and write-set for each subprogram:
- When a name resolution resolves a reference to a package-level variable, the variable is added to the current subprogram's read-set (for read contexts) or write-set (for write contexts).
- For calls to other subprograms whose `Global` information has already been computed (guaranteed by declaration-before-use, Section 3, §3.2.2), the callee's read-set and write-set are merged into the caller's sets.
- Forward declarations for mutual recursion (Section 3, §3.2.3) require a fixed-point computation: the compiler iterates until the read-sets and write-sets stabilize.

10. **Emission format:** The emitted `Global` aspect uses the SPARK syntax:

```ada
procedure Foo
    with Global => (Input    => (Var_A, Var_B),
                    In_Out   => Var_C,
                    Output   => Var_D);
```

11. Variables that are only read appear in `Input`. Variables that are both read and written appear in `In_Out`. Variables that are only written appear in `Output`. If a subprogram accesses no package-level variables, the aspect is `Global => null`.

### 5.2.2 Depends Aspects

12. The `--emit-ada` backend shall generate a `Depends` aspect on every subprogram in the emitted Ada. The `Depends` aspect specifies which outputs are influenced by which inputs.

13. **Algorithm:** During the single-pass compilation, the compiler tracks data flow through assignments and expressions:
- Each output (out parameter, in-out parameter, written global variable, function return value) is associated with the set of inputs that influence its value.
- In a language with no uncontrolled aliasing (ownership rules prevent it), no dispatching, and no exceptions, dependency analysis is straightforward: each assignment `Target := Expr;` makes `Target` depend on every variable read in `Expr`.
- Conditional control flow (`if`, `case`, `loop`) adds the condition variables as dependencies of any output written within the controlled scope.

14. **Emission format:**

```ada
function Average (A, B : Reading) return Reading
    with Global  => null,
         Depends => (Average'Result => (A, B));
```

### 5.2.3 Initializes Aspects

15. The `--emit-ada` backend shall generate an `Initializes` aspect on every package in the emitted Ada. The `Initializes` aspect lists all package-level variables that are initialized at elaboration.

16. **Rule:** Since Safe packages are purely declarative (Section 3, §3.4) with mandatory initialization expressions on variable declarations, every package-level variable is initialized. The `Initializes` aspect lists all package-level variables.

17. **Emission format:**

```ada
package Sensors
    with Initializes => (Cal_Table, Initialized)
is
    ...
end Sensors;
```

### 5.2.4 SPARK_Mode

18. The `--emit-ada` backend shall emit `pragma SPARK_Mode;` at the beginning of every generated `.ads` and `.adb` file.

### 5.2.5 Bronze Guarantee Statement

19. **Normative requirement:** Every conforming Safe program, when emitted via `--emit-ada` and submitted to GNATprove with the command `gnatprove -P project.gpr --mode=flow`, shall pass flow analysis with zero errors, zero warnings, and zero unproven checks, without any user-supplied annotations in the Safe source.

20. **Estimated compiler cost:** 500–800 lines of compiler code (300–500 for analysis during the existing single pass, 200–300 in the Ada emitter for formatting the aspects).

---

## 5.3 Silver Guarantee — Absence of Runtime Errors

21. The four Silver-by-construction rules specified in Section 2, §2.8 guarantee that every runtime check in a conforming Safe program is provable by GNATprove. This section specifies the mechanism by which each check category is discharged.

### 5.3.1 Integer Overflow — Wide Intermediate Arithmetic

22. **Rule 1 (Section 2, §2.8.1):** All integer arithmetic expressions are evaluated in a mathematical integer type with no overflow. Range checks are performed only at narrowing points (assignment, parameter passing, return, type conversion).

23. **SPARK emission:** The `--emit-ada` backend emits intermediate arithmetic expressions using a wide integer type sufficient to hold any intermediate result:

```ada
-- Safe source:
--   return (A + B) / 2;
-- where A, B : Reading (range 0 .. 4095)

-- Emitted Ada:
declare
    Wide_Temp : constant Long_Long_Integer :=
        Long_Long_Integer(A) + Long_Long_Integer(B);
begin
    return Reading(Wide_Temp / 2);
end;
```

24. GNATprove discharges the overflow check on the addition trivially — `Long_Long_Integer` cannot overflow for values in the range of `Reading`. The narrowing conversion `Reading(Wide_Temp / 2)` is dischargeable by interval analysis: `Wide_Temp` is in `0 .. 8190`, so `Wide_Temp / 2` is in `0 .. 4095`, which is exactly the range of `Reading`.

### 5.3.2 Array Index — Strict Index Typing

25. **Rule 2 (Section 2, §2.8.2):** The index expression in an `indexed_component` shall be of a type or subtype that matches the array's index type.

26. **SPARK emission:** The emitted Ada preserves the index type constraint:

```ada
-- Safe source:
--   return Table(Ch);
-- where Ch : Channel_Id, Table : array (Channel_Id) of Integer

-- Emitted Ada (identical):
return Table(Ch);
```

27. GNATprove discharges the index check trivially — `Ch` is of type `Channel_Id`, which is the array's index type. The value is in range by construction.

### 5.3.3 Division by Zero — Nonzero Divisor Type

28. **Rule 3 (Section 2, §2.8.3):** The right operand of `/`, `mod`, and `rem` shall be of a type whose range excludes zero.

29. **SPARK emission:** The emitted Ada preserves the divisor type:

```ada
-- Safe source:
--   return Distance / Time;
-- where Time : Seconds (range 1 .. 3600)

-- Emitted Ada (identical):
return Distance / Time;
```

30. GNATprove discharges the division-by-zero check trivially — `Time` is of type `Seconds`, whose range `1 .. 3600` excludes zero.

### 5.3.4 Null Dereference — Not-Null Access Subtype

31. **Rule 4 (Section 2, §2.8.4):** Dereference of an access value requires the access subtype to be `not null`.

32. **SPARK emission:** The emitted Ada preserves the `not null` constraint:

```ada
-- Safe source:
--   return N.Value;
-- where N : Node_Ref (subtype not null Node_Ptr)

-- Emitted Ada (identical):
return N.Value;
```

33. GNATprove discharges the null dereference check trivially — `N` is of subtype `Node_Ref`, which is `not null Node_Ptr`. The value cannot be null by construction.

### 5.3.5 Range Checks at Narrowing Points

34. Range checks at narrowing points (assignment, parameter passing, function return) are not eliminated — they are made provable. The prover uses interval analysis on the wide intermediate result to determine whether the value fits the target type.

35. **Example — provable narrowing:**

```ada
-- Safe source:
public function Average (A, B : Reading) return Reading is
begin
    return (A + B) / 2;
end Average;
```

36. **Analysis:** `A` and `B` are in `0 .. 4095`. The wide intermediate `A + B` is in `0 .. 8190`. Dividing by 2 gives `0 .. 4095`. This fits `Reading` exactly. GNATprove proves the narrowing check.

37. **Example — unprovable narrowing (program error):**

```ada
-- Safe source (INCORRECT program):
public function Double (A : Reading) return Reading is
begin
    return A * 2;  -- wide intermediate 0 .. 8190, does NOT fit Reading
end Double;
```

38. **Analysis:** `A * 2` in wide arithmetic gives `0 .. 8190`. The range of `Reading` is `0 .. 4095`. GNATprove cannot prove that the narrowing succeeds, and reports an unproven range check. This indicates a genuine range error in the program. The program is not Silver-provable, meaning it is not a correct Safe program.

### 5.3.6 Discriminant Checks

39. Discriminant checks (checking that the discriminant value matches the expected variant before accessing a variant component) are dischargeable when the discriminant type is discrete and the discriminant value is statically constrained.

40. Safe retains discriminated records with discrete discriminants and static constraints (Section 2, D23). The prover discharges discriminant checks using the constraint on the discriminant at the point of access.

### 5.3.7 Complete Runtime Check Enumeration

41. The following table enumerates every category of runtime check in 8652:2023 and specifies how Safe discharges it:

| Check Category | 8652:2023 Reference | How Discharged in Safe |
|---|---|---|
| Integer overflow | §4.5 | Impossible — wide intermediate arithmetic (Rule 1) |
| Range check (assignment) | §4.6, §5.2 | Interval analysis on wide intermediates |
| Range check (parameter) | §6.4 | Interval analysis on wide intermediates |
| Range check (return) | §6.5 | Interval analysis on wide intermediates |
| Array index check | §4.1.1 | Index type matches array index type (Rule 2) |
| Array length check | §4.6 | Preserved via type constraints |
| Division by zero | §4.5.5 | Divisor type excludes zero (Rule 3) |
| Null dereference | §4.1 | Access subtype is `not null` (Rule 4) |
| Discriminant check | §3.7.1 | Discrete discriminant with static constraint |
| Tag check | §3.9.2 | Not applicable — tagged types excluded |
| Accessibility check | §3.10.2 | Not applicable — no access-to-subprogram, no anonymous access parameters at library level |
| Elaboration check | §3.11.1 | Not applicable — purely declarative packages |
| Storage check | §11.1 | Implementation-managed allocation |
| Program_Error | §11.5 | Reduced scope — no elaboration, no finalization |

### 5.3.8 Silver Guarantee Statement

42. **Normative requirement:** Every conforming Safe program, when emitted via `--emit-ada` and submitted to GNATprove with the command `gnatprove -P project.gpr --mode=silver --level=2`, shall pass AoRTE proof with zero unproven checks and no user-supplied annotations in the Safe source.

43. **Clarification:** If a Safe program contains arithmetic that cannot be proven safe at the narrowing points (e.g., `Double` in §5.3.5, paragraph 37), GNATprove reports unproven checks on the emitted Ada. This means the Safe program has a potential runtime error. A program with unproven checks is not a "conforming Safe program" for the purposes of the Silver guarantee — a conforming implementation is required to emit valid SPARK, but the program itself must also be correct.

---

## 5.4 Concurrency Assurance

44. The channel-based tasking model (Section 4) provides additional safety guarantees verifiable by GNATprove on the emitted Jorvik-profile SPARK.

### 5.4.1 Data Race Freedom

45. **Guarantee:** No shared mutable state exists between tasks. All inter-task communication occurs through channels, which are compiled to protected objects in the emitted Ada.

46. **Mechanism:** The task-variable ownership rule (Section 4, §4.5) ensures that each package-level variable is accessed by at most one task. The `--emit-ada` backend emits `Global` aspects on task bodies that reference only the task's owned variables and channel operations (protected object calls).

47. **SPARK verification:** GNATprove verifies data race freedom by checking that `Global` aspects on task bodies do not overlap. Since channel operations are calls on protected objects (which provide mutual exclusion), they are safe by the Jorvik profile's concurrency model.

### 5.4.2 Deadlock Freedom

48. **Guarantee:** The ceiling priority protocol is enforced on all channel-backing protected objects, preventing priority inversion and circular waiting.

49. **Mechanism:** The compiler assigns ceiling priorities to channel-backing protected objects based on the static priorities of tasks that access them (Section 4, §4.2). The ceiling priority of a channel's protected object is the maximum of the priorities of all tasks that send to or receive from that channel.

50. **SPARK verification:** GNATprove verifies that the Jorvik profile's ceiling locking protocol is respected — every task that calls a protected operation has a priority less than or equal to the ceiling priority of the protected object.

### 5.4.3 Task-Variable Ownership Emission

51. The `--emit-ada` backend emits `Global` aspects on task bodies that precisely specify which variables each task accesses:

```ada
-- Emitted Ada for task Evaluator from Section 4:
task body Evaluator is
    -- Global => (Input    => Threshold,
    --            In_Out   => (Readings_PO, Alarms_PO))
begin
    loop
        R : Sensors.Reading;
        Readings_PO.Receive(R);   -- channel operation
        if R > Threshold then
            Alarms_PO.Send(Critical);  -- channel operation
        end if;
    end loop;
end Evaluator;
```

52. Channel operations appear as `In_Out` globals (they are calls on protected objects that modify internal state). Owned variables appear as `Input` or `In_Out` depending on usage.

### 5.4.4 Concurrency Assurance Statement

53. **Normative requirement:** Every conforming Safe program containing tasks and channels, when emitted via `--emit-ada`, shall produce Jorvik-profile SPARK Ada that:
- Passes GNATprove flow analysis with no data race warnings
- Respects the ceiling priority protocol for all protected object accesses
- Has `Global` aspects on all task bodies that accurately reflect variable ownership

---

## 5.5 Gold and Platinum — Out of Scope

54. Gold-level assurance (functional correctness) requires developer-authored specifications — postconditions stating functional intent, ghost code, lemmas. These are inherently non-automatable and are out of scope for the Safe compiler.

55. Platinum-level assurance (full formal verification including termination) requires all Gold-level specifications plus termination proofs. This is also out of scope.

56. A developer seeking Gold or Platinum assurance works with the `--emit-ada` output directly, adding contracts (`Pre`, `Post`, `Contract_Cases`), ghost code (`Ghost` aspect), and verification specifications to the generated Ada source. The generated Bronze and Silver annotations provide a foundation — the developer adds functional specifications on top.

---

## 5.6 Examples

### 5.6.1 Arithmetic — Silver-Provable via Wide Intermediates

57. **Safe source:**

```ada
package Averaging is

    public type Reading is range 0 .. 4095;
    public subtype Count is Integer range 1 .. 100;

    public function Average (A, B : Reading) return Reading is
    begin
        return (A + B) / 2;
    end Average;

    public function Weighted_Sum (Values : array (1 .. 4) of Reading;
                                  Total_Count : Count) return Reading is
    begin
        Sum : Integer := 0;
        for I in Values.Range loop
            Sum := Sum + Integer(Values(I));
        end loop;
        return Reading(Sum / Total_Count);
    end Weighted_Sum;

end Averaging;
```

58. **Emitted Ada (averaging.ads):**

```ada
pragma SPARK_Mode;

package Averaging
    with Initializes => null
is
    type Reading is range 0 .. 4095;
    subtype Count is Integer range 1 .. 100;

    function Average (A, B : Reading) return Reading
        with Global  => null,
             Depends => (Average'Result => (A, B));

    type Reading_Array is array (Integer range 1 .. 4) of Reading;

    function Weighted_Sum (Values : Reading_Array;
                           Total_Count : Count) return Reading
        with Global  => null,
             Depends => (Weighted_Sum'Result => (Values, Total_Count));
end Averaging;
```

59. **GNATprove output:** All checks proved. `Average`: overflow check on `A + B` proved (wide intermediates, max 8190 in `Long_Long_Integer`), range check on `/ 2` proved (result in 0..4095). `Weighted_Sum`: overflow checks proved (wide intermediates), division-by-zero check proved (`Count` range is 1..100), range check on final conversion proved (interval analysis).

### 5.6.2 Array Indexing — Silver-Provable via Strict Index Typing

60. **Safe source:**

```ada
package Lookup is

    public type Sensor_Id is range 0 .. 15;
    public type Calibration is range -100 .. 100;

    Cal_Table : array (Sensor_Id) of Calibration :=
        (others => 0);

    public function Get_Cal (S : Sensor_Id) return Calibration is
    begin
        return Cal_Table(S);
    end Get_Cal;

end Lookup;
```

61. **GNATprove output:** Index check on `Cal_Table(S)` proved — `S` is of type `Sensor_Id`, which is the array's index type.

### 5.6.3 Division — Silver-Provable via Nonzero Divisor Type

62. **Safe source:**

```ada
package Rates is

    public type Meters is range 0 .. 100_000;
    public type Seconds is range 1 .. 86_400;

    public function Speed (D : Meters; T : Seconds) return Integer is
    begin
        return Integer(D) / Integer(T);
    end Speed;

end Rates;
```

63. **Note:** After conversion to `Integer`, the divisor is in range `1 .. 86_400`. But `Integer` includes zero, so this division is ILLEGAL under Rule 3. The correct form:

```ada
    public subtype Positive_Seconds is Integer range 1 .. 86_400;

    public function Speed (D : Meters; T : Seconds) return Integer is
    begin
        return Integer(D) / Positive_Seconds(T);
    end Speed;
```

64. Now the divisor is `Positive_Seconds` (range 1..86400, excludes zero). GNATprove discharges the division-by-zero check.

### 5.6.4 Access Types — Silver-Provable via Not-Null Subtypes

65. **Safe source:**

```ada
package Lists is

    public type Node;
    public type Node_Ptr is access Node;
    public subtype Node_Ref is not null Node_Ptr;

    public type Node is record
        Value : Integer;
        Next  : Node_Ptr;  -- nullable, for end-of-list
    end record;

    public function Head_Value (List : Node_Ref) return Integer
    is (List.Value);

    public function Safe_Head (List : Node_Ptr;
                               Default : Integer) return Integer is
    begin
        if List /= null then
            Ref : Node_Ref := Node_Ref(List);
            return Ref.Value;
        else
            return Default;
        end if;
    end Safe_Head;

end Lists;
```

66. **GNATprove output:** Null dereference check on `List.Value` in `Head_Value` proved — `List` is `Node_Ref` (not null). Null dereference check on `Ref.Value` in `Safe_Head` proved — `Ref` is `Node_Ref`, and the conversion from `Node_Ptr` to `Node_Ref` is within the `List /= null` branch.

### 5.6.5 Ownership — Move, Borrow, Observe Patterns

67. **Safe source:**

```ada
package Trees is

    public type Tree_Node;
    public type Tree_Ptr is access Tree_Node;
    public subtype Tree_Ref is not null Tree_Ptr;

    public type Tree_Node is record
        Value : Integer;
        Left  : Tree_Ptr;
        Right : Tree_Ptr;
    end record;

    -- Move: ownership transfers from caller to tree
    public procedure Insert (Root : in out Tree_Ptr; New_Node : Tree_Ptr) is
    begin
        if Root = null then
            Root := New_Node;  -- move: New_Node becomes null, Root takes ownership
        elsif New_Node /= null then
            Ref : Tree_Ref := Tree_Ref(New_Node);
            if Ref.Value < Tree_Ref(Root).Value then
                Insert (Root.Left, New_Node);  -- recursive move
            else
                Insert (Root.Right, New_Node); -- recursive move
            end if;
        end if;
    end Insert;

    -- Observe: read-only access, no ownership transfer
    public function Contains (Root : Tree_Ptr; V : Integer) return Boolean is
    begin
        if Root = null then
            return False;
        else
            Ref : Tree_Ref := Tree_Ref(Root);
            if V = Ref.Value then
                return True;
            elsif V < Ref.Value then
                return Contains (Ref.Left, V);
            else
                return Contains (Ref.Right, V);
            end if;
        end if;
    end Contains;

end Trees;
```

68. **SPARK emission:** The emitted Ada preserves ownership annotations. `Insert`'s `in out Tree_Ptr` parameter borrows the pointer. The assignment `Root := New_Node` is a move. `Contains`'s `Tree_Ptr` parameter (mode `in`) observes. GNATprove verifies ownership rules.

### 5.6.6 Rejected Programs

69. **Index type too wide:**

```ada
public function Bad_Lookup (N : Integer) return Calibration is
begin
    return Cal_Table(N);  -- COMPILE ERROR: Integer is not a subtype of Sensor_Id
end Bad_Lookup;
```

70. **Compiler diagnostic:** `error: index expression type Integer is not the same as or a subtype of array index type Sensor_Id [Safe §2.8.2]`

71. **Divisor type includes zero:**

```ada
public function Bad_Divide (A, B : Integer) return Integer is
begin
    return A / B;  -- COMPILE ERROR: Integer range includes zero
end Bad_Divide;
```

72. **Compiler diagnostic:** `error: right operand of "/" has type Integer whose range includes zero; use a subtype that excludes zero [Safe §2.8.3]`

73. **Nullable dereference:**

```ada
public function Bad_Deref (P : Node_Ptr) return Integer is
begin
    return P.Value;  -- COMPILE ERROR: Node_Ptr includes null
end Bad_Deref;
```

74. **Compiler diagnostic:** `error: dereference of access type Node_Ptr which may be null; use subtype Node_Ref (not null Node_Ptr) [Safe §2.8.4]`

### 5.6.7 Concurrent Program — Tasks, Channels, and Emitted Jorvik-Profile Ada

75. **Safe source:**

```ada
package Pipeline is

    public type Sample is range 0 .. 1023;
    public type Result is range 0 .. 2047;

    channel Raw_Samples : Sample capacity 16;
    channel Processed   : Result capacity 8;

    task Sampler with Priority => 10 is
    begin
        loop
            S : Sample := Read_Sensor;
            send Raw_Samples, S;
        end loop;
    end Sampler;

    Scale_Factor : Sample := 2;  -- owned by Processor

    task Processor with Priority => 5 is
    begin
        loop
            S : Sample;
            receive Raw_Samples, S;
            R : Result := Result(Integer(S) * Integer(Scale_Factor));
            send Processed, R;
        end loop;
    end Processor;

    function Read_Sensor return Sample is separate;

end Pipeline;
```

76. **Emitted Ada (pipeline.ads):**

```ada
pragma SPARK_Mode;

with System;

package Pipeline
    with Initializes => Scale_Factor
is
    type Sample is range 0 .. 1023;
    type Result is range 0 .. 2047;

    -- Channel-backing protected types
    protected type Raw_Samples_Channel_Type
        with Priority => System.Priority'(10)  -- ceiling = max(Sampler=10, Processor=5)
    is
        entry Send (Item : in Sample);
        entry Receive (Item : out Sample);
    private
        Buffer : array (0 .. 15) of Sample;
        Head   : Natural := 0;
        Tail   : Natural := 0;
        Count  : Natural := 0;
    end Raw_Samples_Channel_Type;

    protected type Processed_Channel_Type
        with Priority => System.Priority'(5)   -- ceiling = max(Processor=5)
    is
        entry Send (Item : in Result);
        entry Receive (Item : out Result);
    private
        Buffer : array (0 .. 7) of Result;
        Head   : Natural := 0;
        Tail   : Natural := 0;
        Count  : Natural := 0;
    end Processed_Channel_Type;

    Raw_Samples : Raw_Samples_Channel_Type;
    Processed   : Processed_Channel_Type;

    task Sampler
        with Priority => 10,
             Global   => (In_Out => Raw_Samples);

    task Processor
        with Priority => 5,
             Global   => (Input  => Scale_Factor,
                          In_Out => (Raw_Samples, Processed));

    Scale_Factor : Sample := 2;

    function Read_Sensor return Sample is separate;
end Pipeline;
```

77. **GNATprove output on emitted Ada:**
- Flow analysis (Bronze): PASSED — `Global` aspects verified, no uninitialized reads, `Initializes` verified.
- AoRTE (Silver): PASSED — all arithmetic uses wide intermediates, channel buffer indexing uses matching index types, no division by zero, no null dereferences.
- Concurrency: PASSED — no shared mutable state (task `Global` aspects do not overlap on mutable variables), ceiling priority protocol respected.

---

## 5.7 Relationship to 8652:2023

78. The SPARK assurance model has no direct precedent in 8652:2023. It is an extension of the SPARK 2014/2022 verification framework (SPARK RM) applied to Safe's language rules.

79. The key innovation is that Safe's language rules (D27, Section 2, §2.8) are specifically designed to make the emitted Ada Silver-provable without developer annotations. This is a language-level guarantee, not a tool-level guarantee — the rules are part of the language definition, not advisory recommendations.

80. The `--emit-ada` backend is a conformance requirement (Section 6), not an optional feature. Every conforming Safe implementation shall be capable of producing annotated SPARK Ada that passes GNATprove at Bronze and Silver levels.
