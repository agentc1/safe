# Section 4 — Tasks and Channels

1. This section specifies Safe's concurrency model. It replaces Sections 9.1 through 9.11 of 8652:2023 with a restricted model based on static tasks and typed channels. The excluded features of Section 9 are enumerated in Section 2, §2.1.7 of this document.

2. The concurrency model provides the following constructs:
- Task declarations — static, package-level tasks, each creating exactly one concurrent activity
- Channel declarations — typed, bounded-capacity FIFO queues for inter-task communication
- Channel operations — `send`, `receive`, `try_send`, `try_receive` statements
- Select statement — multiplexing across channel receive operations with optional delay timeout

3. The model enforces a single invariant at compile time: **no shared mutable state between tasks**. All inter-task data flow occurs through channels. This invariant is sufficient for data race freedom and is verifiable by extension of the `Global` analysis described in Section 5.

4. The constructs specified in this section map to the Jorvik tasking profile (8652:2023 §D.13) when emitted as Ada via `--emit-ada`. The mapping is specified in the Implementation Requirements subsections below.

---

## 4.1 Task Declarations

### Syntax

5. The syntax for task declarations is:

```
task_declaration ::=
    'task' defining_identifier [ task_aspect_clause ] 'is'
    'begin'
        sequence_of_statements
    'end' defining_identifier ';'

task_aspect_clause ::=
    'with' 'Priority' '=>' static_expression
```

6. The `task_declaration` production appears in the `package_declarative_item` production (Section 8, §8.2). Task declarations are package-level declarations.

### Legality Rules

7. A task declaration shall appear only as a `package_declarative_item` within a `package_unit`. A conforming implementation shall reject any task declaration that appears within a subprogram body, block statement, or any scope other than a package-level declarative region.

8. Each task declaration creates exactly one task. There are no task types, no task arrays, and no dynamic task creation. A conforming implementation shall reject any construct that would create more than one task from a single declaration.

9. The `defining_identifier` after `end` shall match the `defining_identifier` after `task`. A conforming implementation shall reject a task declaration where the identifiers do not match.

10. The `static_expression` in a `task_aspect_clause` shall be of an integer type and shall evaluate to a value in the range of `System.Any_Priority` (8652:2023 §D.1). A conforming implementation shall reject a task declaration whose priority expression is not static or is outside the valid priority range.

11. If no `task_aspect_clause` is present, the task has the default priority `System.Default_Priority` (8652:2023 §D.1(19)).

12. A task body shall not contain a nested task declaration. A conforming implementation shall reject any task declaration that appears within the `sequence_of_statements` of another task declaration.

13. The `sequence_of_statements` within a task body follows the same rules as a subprogram body: declarations and statements may interleave freely (D11, Section 3). The declarations within a task body are local to the task and are not visible outside the task body.

### Static Semantics

14. A task declaration introduces the `defining_identifier` as the name of a task. The name is visible within the enclosing package according to the standard visibility rules. A task name is not a type name; it cannot be used as a type mark in declarations.

15. The priority of a task is a static property determined at compile time from the `task_aspect_clause` or the default priority. The compiler uses task priorities to compute ceiling priorities for channel-backing protected objects (see §4.2).

16. The body of a task constitutes a separate scope. Names declared within the task body (including loop variables, block-local declarations, and interleaved declarations) follow the standard visibility rules of 8652:2023 §8.2 and §8.3, confined to the task body.

### Dynamic Semantics

17. Each task declaration causes the creation of exactly one task at program startup. The task begins executing the `sequence_of_statements` in its body after all package-level initialization has completed (see §4.7).

18. A task executes its body sequentially. The scheduling of tasks relative to one another is determined by the implementation's task scheduler, subject to the priority ordering specified by task priorities. Higher-priority tasks are scheduled before lower-priority tasks when both are ready to execute.

19. If the `sequence_of_statements` of a task body completes (either by reaching the end of the statements or by executing a `return` statement), the task terminates. See §4.6 for termination semantics.

### Implementation Requirements

20. The `--emit-ada` backend shall emit each task declaration as an Ada task type with a single instance and a `Priority` aspect:

```ada
-- Emitted Ada for: task Sampler with Priority => 10 is ...
task type Sampler_Task_Type is
   pragma Priority (10);
end Sampler_Task_Type;

Sampler : Sampler_Task_Type;

task body Sampler_Task_Type is
begin
   -- task body statements
end Sampler_Task_Type;
```

21. The `--emit-c` backend shall emit each task declaration as a pthread creation call during program initialization:

```c
/* Emitted C for: task Sampler with Priority => 10 */
static void* sampler_task_body(void* arg);
static pthread_t sampler_thread;
/* Created during __safe_runtime_init() with priority 10 */
```

22. The emitted code shall conform to the Jorvik tasking profile (8652:2023 §D.13) in the Ada backend. The C backend shall use POSIX threads with priority scheduling where supported by the target platform.

### Examples

23. A task that reads sensor data and sends it to a channel:

```ada
task Sensor_Reader with Priority => 10 is
begin
    loop
        R : Reading := Read_ADC (0);
        send Readings, R;
        delay 0.1;
    end loop;
end Sensor_Reader;
```

24. A task with default priority:

```ada
task Logger is
begin
    loop
        Msg : Log_Entry;
        receive Log_Channel, Msg;
        Write_Log (Msg);
    end loop;
end Logger;
```

---

## 4.2 Channel Declarations

### Syntax

25. The syntax for channel declarations is:

```
channel_declaration ::=
    [ 'public' ] 'channel' defining_identifier ':' subtype_mark
        'capacity' static_expression ';'
```

26. The `channel_declaration` production appears in the `package_declarative_item` production (Section 8, §8.2). Channel declarations are package-level declarations.

### Legality Rules

27. A channel declaration shall appear only as a `package_declarative_item` within a `package_unit`. A conforming implementation shall reject any channel declaration that appears within a subprogram body, task body, block statement, or any scope other than a package-level declarative region.

28. The `subtype_mark` in a channel declaration shall denote a definite subtype. A conforming implementation shall reject a channel declaration whose element type is an unconstrained array type, an unconstrained type with discriminants without defaults, or any other indefinite subtype.

29. The `static_expression` specifying the capacity shall be of an integer type, shall be a static expression as defined by 8652:2023 §4.9, and shall evaluate to a positive value (greater than zero). A conforming implementation shall reject a channel declaration whose capacity expression is not static, is not of an integer type, or evaluates to a value less than one.

30. A channel declaration that bears the `public` keyword is visible to client packages that `with` the declaring package. A channel declaration without the `public` keyword is private to the declaring package.

### Static Semantics

31. A channel declaration introduces the `defining_identifier` as the name of a channel. A channel name is not a type name; it cannot be used as a type mark, as a target of assignment, or in any context other than the channel operations specified in §4.3 and the `select` statement specified in §4.4.

32. A channel has the following static properties:
- **Element type** — the subtype denoted by the `subtype_mark`. All values sent through the channel and received from the channel are of this subtype.
- **Capacity** — the value of the `static_expression`. This determines the maximum number of elements that may be buffered in the channel at any time.
- **Ceiling priority** — computed by the implementation as the maximum of the priorities of all tasks that perform operations on the channel. This priority is used for the channel's backing protected object in the emitted Ada (see §4.2, paragraph 39).

33. The buffer storage for a channel is allocated statically. The implementation allocates storage for `capacity` elements of the element type at program load time. No dynamic allocation occurs during channel operations.

### Dynamic Semantics

34. A channel operates as a bounded FIFO (first-in, first-out) queue. Elements are enqueued by `send` operations and dequeued by `receive` operations in the order they were enqueued.

35. A channel is initially empty. No elements are present in the channel buffer at program startup.

36. The channel remains valid for the entire lifetime of the program. There is no operation to close, destroy, or invalidate a channel.

### Implementation Requirements

37. The `--emit-ada` backend shall emit each channel declaration as a protected object with ceiling priority, `Send` and `Receive` entries, and an internal bounded buffer:

```ada
-- Emitted Ada for: channel Readings : Reading capacity 16;
protected Readings_PO
    with Priority => Ceiling_Priority  -- computed from accessing tasks
is
    entry Send (Item : in Reading);
    entry Receive (Item : out Reading);
    function Try_Send (Item : in Reading) return Boolean;
    function Try_Receive (Item : out Reading) return Boolean;
private
    Buffer : array (0 .. 15) of Reading;
    Head   : Natural := 0;
    Tail   : Natural := 0;
    Count  : Natural := 0;
end Readings_PO;
```

38. The `--emit-c` backend shall emit each channel as a statically allocated ring buffer with a mutex and condition variables:

```c
/* Emitted C for: channel Readings : Reading capacity 16 */
typedef struct {
    Reading buffer[16];
    int head;
    int tail;
    int count;
    pthread_mutex_t mutex;
    pthread_cond_t not_full;
    pthread_cond_t not_empty;
} safe_channel_Readings_t;
static safe_channel_Readings_t Readings_channel;
```

39. **Ceiling priority computation:** The implementation shall compute the ceiling priority of a channel's backing protected object as the maximum of the priorities of all tasks that perform any operation (`send`, `receive`, `try_send`, `try_receive`, or `select` receive) on that channel. This computation is performed at compile time, since all tasks and their priorities are statically known. The ceiling priority protocol (8652:2023 §D.3) ensures that a task executing within the channel's protected object is not preempted by any task that might also access the same channel, guaranteeing deadlock freedom.

### Examples

40. A private channel with element type `Reading` and capacity 16:

```ada
channel Readings : Reading capacity 16;
```

41. A public channel for cross-package communication:

```ada
public channel Commands : Command capacity 4;
```

42. A channel carrying variant records:

```ada
type Message (Kind : Message_Kind := Status) is record
    case Kind is
        when Status  => Level : Alarm_Level;
        when Data    => Value : Reading;
        when Command => Code  : Command_Code;
    end case;
end record;

channel Messages : Message capacity 32;
```

---

## 4.3 Channel Operations

### Syntax

43. The syntax for channel operations is:

```
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
```

44. These statement forms appear in the `simple_statement` production (Section 8, §8.7). The `channel_name` shall resolve to a channel declared by a `channel_declaration`.

### Legality Rules

45. The `channel_name` in a channel operation shall denote a channel. A conforming implementation shall reject a channel operation whose first argument does not denote a channel declared by a `channel_declaration`.

46. **`send` statement:** The `expression` shall be of the element type of the channel. A conforming implementation shall reject a `send` statement where the type of the expression does not match the channel's element type.

47. **`receive` statement:** The `name` shall denote a variable of the element type of the channel. A conforming implementation shall reject a `receive` statement where the type of the target variable does not match the channel's element type.

48. **`try_send` statement:** The `expression` (second argument) shall be of the element type of the channel. The `name` (third argument) shall denote a variable of type `Boolean`. A conforming implementation shall reject a `try_send` statement where these type constraints are not met.

49. **`try_receive` statement:** The first `name` (second argument) shall denote a variable of the element type of the channel. The second `name` (third argument) shall denote a variable of type `Boolean`. A conforming implementation shall reject a `try_receive` statement where these type constraints are not met.

50. Channel operations may appear in task bodies, in subprogram bodies called (directly or transitively) from task bodies, and in subprogram bodies that are not called from any task (such subprograms execute in the environment task). A conforming implementation shall not restrict channel operations to task bodies alone.

### Static Semantics

51. Channel operations are statements, not expressions. They do not produce a value (except indirectly through their `out` parameters in `receive`, `try_send`, and `try_receive`).

52. A channel operation on a channel constitutes an access to that channel for purposes of ceiling priority computation (§4.2, paragraph 39) and task-variable ownership analysis (§4.5).

### Dynamic Semantics

53. **`send` semantics:** The `send` statement evaluates the expression, then enqueues the resulting value into the channel's buffer. If the channel's buffer is full (the number of buffered elements equals the channel's capacity), the executing task blocks until at least one element is dequeued by a `receive` operation on the same channel. The blocked task does not consume processor resources. When space becomes available, the value is enqueued and the `send` statement completes.

54. **`receive` semantics:** The `receive` statement dequeues the oldest element from the channel's buffer and assigns it to the target variable. If the channel's buffer is empty, the executing task blocks until at least one element is enqueued by a `send` operation on the same channel. The blocked task does not consume processor resources. When an element becomes available, it is dequeued, assigned to the target variable, and the `receive` statement completes.

55. **`try_send` semantics:** The `try_send` statement evaluates the expression and attempts to enqueue the resulting value into the channel's buffer without blocking. If the channel's buffer is not full, the value is enqueued and the Boolean variable (third argument) is set to `True`. If the channel's buffer is full, no value is enqueued and the Boolean variable is set to `False`. The `try_send` statement never blocks the executing task.

56. **`try_receive` semantics:** The `try_receive` statement attempts to dequeue the oldest element from the channel's buffer without blocking. If the channel's buffer is not empty, the element is dequeued, assigned to the target variable (second argument), and the Boolean variable (third argument) is set to `True`. If the channel's buffer is empty, the target variable is not modified and the Boolean variable is set to `False`. The `try_receive` statement never blocks the executing task.

57. **Ordering:** Values enqueued into a channel by `send` or `try_send` operations are dequeued by `receive` or `try_receive` operations in FIFO order. If multiple tasks execute `send` operations on the same channel concurrently, the order in which their values appear in the buffer is determined by the order in which the `send` operations acquire access to the channel's internal buffer, which is serialized by the channel's backing protected object or mutex.

58. **Priority interaction:** When a task blocks on a `send` or `receive` operation, it relinquishes the processor. When the operation becomes possible (space becomes available for `send`, or an element becomes available for `receive`), the task becomes ready. If multiple tasks are blocked waiting on the same channel, they are unblocked in priority order (highest priority first). Tasks of equal priority that are blocked on the same channel are unblocked in FIFO order (the task that blocked first is unblocked first).

### Implementation Requirements

59. The `--emit-ada` backend shall emit `send` and `receive` as entry calls on the channel's backing protected object:

```ada
-- send Readings, R;      =>  Readings_PO.Send (R);
-- receive Readings, R;   =>  Readings_PO.Receive (R);
```

60. The `--emit-ada` backend shall emit `try_send` and `try_receive` as function calls on the channel's backing protected object, using conditional entry calls or protected functions:

```ada
-- try_send Readings, R, Ok;      =>  Ok := Readings_PO.Try_Send (R);
-- try_receive Readings, R, Ok;   =>  Ok := Readings_PO.Try_Receive (R);
```

61. The `--emit-c` backend shall emit `send` and `receive` as calls to the channel runtime library, which implements blocking via `pthread_cond_wait` on the channel's condition variables.

62. The `--emit-c` backend shall emit `try_send` and `try_receive` as calls to the channel runtime library, which acquires the mutex, checks the buffer state, performs the operation if possible, and releases the mutex without waiting on any condition variable.

### Examples

63. Blocking send and receive:

```ada
R : Reading := Read_ADC (0);
send Readings, R;       -- blocks if Readings is full

V : Reading;
receive Readings, V;    -- blocks if Readings is empty
```

64. Non-blocking operations:

```ada
Ok : Boolean;
try_send Readings, R, Ok;
if not Ok then
    -- channel full, handle overflow
    Overflow_Count := Overflow_Count + 1;
end if;

try_receive Readings, V, Ok;
if Ok then
    Process (V);
else
    -- channel empty, nothing to process
    null;
end if;
```

---

## 4.4 Select Statement

### Syntax

65. The syntax for the select statement is:

```
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

66. The `select_statement` production appears in the `compound_statement` production (Section 8, §8.7).

### Legality Rules

67. A select statement shall contain at least one `channel_receive_arm`. A conforming implementation shall reject a select statement that contains only `delay_arm` alternatives and no `channel_receive_arm`.

68. A select statement shall contain at most one `delay_arm`. A conforming implementation shall reject a select statement that contains more than one `delay_arm`.

69. **Receive-only restriction:** Select arms shall contain only channel receive operations and delay timeouts. Send operations are not permitted as select arms. A conforming implementation shall reject any select statement that includes a send operation as an arm.

70. In a `channel_receive_arm`, the `subtype_mark` shall denote the element type of the channel identified by `channel_name`. A conforming implementation shall reject a `channel_receive_arm` where the declared subtype does not match the channel's element type.

71. In a `channel_receive_arm`, the `defining_identifier` introduces a constant that is visible within the `sequence_of_statements` of that arm only. The scope of the `defining_identifier` extends from its declaration to the end of the arm's `sequence_of_statements`. The identifier denotes a constant of the element type — it shall not be assigned to within the arm's statements.

72. In a `delay_arm`, the `expression` shall be of a real type. If the expression is of a fixed point type, it is interpreted as a duration in seconds. If the expression is of a floating point type, it is interpreted as a duration in seconds. The expression shall evaluate to a non-negative value. A conforming implementation shall reject a `delay_arm` whose expression is not of a real type.

73. The `delay_arm`, if present, shall be the last arm in the select statement. A conforming implementation shall reject a select statement where a `delay_arm` is followed by another `select_arm`.

### Static Semantics

74. The `defining_identifier` in a `channel_receive_arm` is a constant of the channel's element type. It is implicitly declared by the arm and receives the value dequeued from the channel when the arm is selected. It is not a variable and shall not appear as the target of an assignment.

75. Each `channel_receive_arm` constitutes an access to the named channel for purposes of ceiling priority computation (§4.2, paragraph 39) and task-variable ownership analysis (§4.5).

### Dynamic Semantics

76. Execution of a select statement proceeds as follows:

77. **Evaluation of readiness:** The implementation evaluates which arms are ready. A `channel_receive_arm` is ready if the named channel's buffer is non-empty (at least one element is available for dequeue). A `delay_arm` is ready if the specified duration has elapsed since the select statement began waiting.

78. **Immediate selection:** If one or more `channel_receive_arm` alternatives are ready at the point of evaluation, the first listed ready arm (in textual order, top to bottom) is selected. The element is dequeued from the channel, assigned to the arm's `defining_identifier`, and the arm's `sequence_of_statements` is executed. The select statement then completes.

79. **Deterministic arm selection:** When multiple `channel_receive_arm` alternatives are simultaneously ready, the first listed ready arm wins. This is deterministic — given the same channel states, the same arm is always selected. This differs from Go's `select`, which selects randomly among ready cases.

80. **Blocking:** If no arm is ready, the executing task blocks. The task remains blocked until one of the following occurs:
- An element becomes available in any of the channels named in the `channel_receive_arm` alternatives.
- The delay duration elapses (if a `delay_arm` is present).

81. **Timeout:** If a `delay_arm` is present and the delay duration elapses before any channel arm becomes ready, the `delay_arm` is selected and its `sequence_of_statements` is executed. The select statement then completes.

82. **No timeout:** If no `delay_arm` is present and no channel arm is ready, the task blocks indefinitely until an element becomes available on one of the named channels.

83. When the task unblocks because an element becomes available on a channel, the readiness evaluation is performed again. If multiple channels have become ready while the task was blocked, the first listed ready arm is selected (paragraph 79).

84. The `sequence_of_statements` of the selected arm executes within the scope of the enclosing task. Declarations within the arm's statements are local to that arm's execution.

### Implementation Requirements

85. The `--emit-ada` backend shall emit the select statement using conditional entry call patterns on the channel-backing protected objects. The implementation shall preserve the deterministic arm selection semantics (first-ready wins).

86. The `--emit-c` backend shall emit the select statement as a multi-channel poll using condition variables. The implementation shall:
- Acquire the mutexes of all named channels.
- Check the readiness of each channel in order.
- If a ready channel is found, dequeue from it, release all mutexes, and execute the arm's statements.
- If no channel is ready, wait on a shared condition variable that is signaled by any `send` operation to any of the named channels.
- On wakeup, re-evaluate readiness in textual order and proceed.
- If a delay arm is present, use a timed wait (`pthread_cond_timedwait`) with the specified duration.

### Examples

87. Basic select with two channels and a timeout:

```ada
select
    when Msg : Message from Incoming =>
        Process (Msg);
    or when Cmd : Command from Commands =>
        Handle (Cmd);
    or delay 1.0 =>
        Heartbeat;
end select;
```

88. Select without timeout (blocks indefinitely until a channel is ready):

```ada
select
    when R : Reading from Sensor_A =>
        Process_A (R);
    or when R : Reading from Sensor_B =>
        Process_B (R);
end select;
```

89. Select with a single channel and timeout (polling pattern):

```ada
select
    when Cmd : Command from Commands =>
        Execute (Cmd);
    or delay 0.05 =>
        null;  -- poll again after 50ms
end select;
```

---

## 4.5 Task-Variable Ownership

### Legality Rules

90. **No shared mutable state:** A package-level variable shall be accessed (read or written) by at most one task. If two or more tasks access the same package-level variable, a conforming implementation shall reject the program.

91. A package-level constant (declared with the `constant` keyword) may be read by multiple tasks, since constants are immutable and cannot be the subject of data races.

92. **Transitivity through the call graph:** The ownership analysis extends transitively through subprogram calls. If a task `T` calls a subprogram `P`, and `P` accesses (reads or writes) a package-level variable `V`, then `T` is considered to access `V`. This transitivity applies through the entire call graph: if `P` calls `Q`, and `Q` accesses `V`, then `T` is considered to access `V` through the chain `T -> P -> Q -> V`.

93. **Subprograms called by multiple tasks:** If a subprogram `P` accesses a package-level variable `V`, and `P` is called (directly or transitively) from two or more tasks, then both tasks are considered to access `V`, and the program shall be rejected under the rule of paragraph 90.

94. A subprogram that does not access any package-level variable (directly or transitively) may be called from any number of tasks without violating the ownership rule.

95. **Channel operations are not variable accesses:** A channel operation (`send`, `receive`, `try_send`, `try_receive`, or a `channel_receive_arm` in a `select` statement) does not constitute an access to a variable for purposes of the ownership rule. Channels are the designated mechanism for inter-task communication, and their internal state is protected by the channel's backing protected object or mutex. Multiple tasks may operate on the same channel.

96. **Environment task:** Subprograms that are not called (directly or transitively) from any declared task are considered to execute in the environment task. A package-level variable accessed by environment-task subprograms shall not also be accessed by any declared task. A conforming implementation shall reject a program where a variable is accessed by both a declared task and an environment-task subprogram.

### Static Semantics

97. **Compile-time checking algorithm:** The ownership check is an extension of the `Global` analysis performed by the compiler for Bronze SPARK assurance (Section 5). The algorithm proceeds as follows:

98. **Step 1 — Variable access sets:** During compilation, the compiler accumulates for each subprogram a read-set and a write-set of package-level variables accessed by the subprogram body. This is a natural byproduct of name resolution during the single compilation pass.

99. **Step 2 — Transitive closure:** The compiler computes the transitive closure of each subprogram's access sets through the call graph. If subprogram `P` calls subprogram `Q`, then the access sets of `P` are extended to include the access sets of `Q`. Since Safe programs are compiled in declaration order (single-pass, D3), and forward declarations are used only for mutual recursion, the call graph is available during compilation.

100. **Step 3 — Task access sets:** For each task declaration, the compiler computes the access set by treating the task body as a subprogram and computing its transitive closure. This produces, for each task, the complete set of package-level variables that the task accesses (directly or transitively).

101. **Step 4 — Overlap detection:** The compiler checks that the access sets of all pairs of tasks are disjoint (excluding constants). If any variable appears in the access sets of two or more tasks, the compiler reports an error identifying the variable, the tasks, and the call chain through which each task reaches the variable.

102. **Step 5 — Environment task check:** The compiler computes the access set of all subprograms not called from any declared task (the environment task's access set). It then verifies that this set is disjoint from every declared task's access set. If overlap is detected, the compiler reports an error.

103. **Mutual recursion:** When forward declarations create mutual recursion, the compiler computes the access sets iteratively to a fixed point. Since the set of variables is finite and access sets can only grow, convergence is guaranteed.

### Dynamic Semantics

104. There are no dynamic semantics associated with task-variable ownership. The ownership check is performed entirely at compile time. At runtime, each task accesses only its own owned variables, and no synchronization is needed for variable access (all inter-task synchronization occurs through channel operations).

### Implementation Requirements

105. The `--emit-ada` backend shall emit `Global` aspects on each task body that reference only the task's owned variables and channel operations. This enables GNATprove to verify data race freedom:

```ada
-- Emitted Ada for a task that owns Threshold and accesses channel Readings
task body Evaluator_Task_Type is
   -- Global => (Input => Threshold,
   --            In_Out => (Readings_PO, Alarms_PO))
begin
   ...
end Evaluator_Task_Type;
```

106. A conforming implementation shall detect all ownership violations at compile time. No ownership violations shall be deferred to runtime or to the Ada backend's verification.

### Examples

107. Legal ownership — each variable accessed by exactly one task:

```ada
Cal_Offset : Reading := 0;    -- owned by Sensor_Reader

task Sensor_Reader with Priority => 10 is
begin
    loop
        R : Reading := Read_ADC (0) + Cal_Offset;  -- legal: owns Cal_Offset
        send Readings, R;
    end loop;
end Sensor_Reader;

Threshold : Reading := 3000;  -- owned by Processor

task Processor with Priority => 5 is
begin
    loop
        R : Reading;
        receive Readings, R;
        if R > Threshold then          -- legal: owns Threshold
            send Alarms, Critical;
        end if;
    end loop;
end Processor;
```

108. Illegal ownership — two tasks access the same variable:

```ada
Shared_Counter : Integer := 0;  -- ERROR: accessed by both tasks

task Writer_A is
begin
    loop
        Shared_Counter := Shared_Counter + 1;  -- accesses Shared_Counter
        delay 1.0;
    end loop;
end Writer_A;

task Writer_B is
begin
    loop
        Shared_Counter := Shared_Counter + 1;  -- ERROR: also accesses Shared_Counter
        delay 1.0;
    end loop;
end Writer_B;
```

A conforming implementation shall reject this program with a diagnostic identifying `Shared_Counter` as accessed by both `Writer_A` and `Writer_B`.

109. Transitive ownership violation through the call graph:

```ada
Config_Value : Integer := 42;

procedure Update_Config is
begin
    Config_Value := Config_Value + 1;  -- accesses Config_Value
end Update_Config;

task Task_A is
begin
    loop
        Update_Config;  -- transitively accesses Config_Value
        delay 1.0;
    end loop;
end Task_A;

task Task_B is
begin
    loop
        X : Integer := Config_Value;  -- directly accesses Config_Value
        -- ERROR: Config_Value accessed by both Task_A (transitively) and Task_B
        delay 1.0;
    end loop;
end Task_B;
```

A conforming implementation shall reject this program, identifying that `Config_Value` is accessed by `Task_A` (via `Update_Config`) and by `Task_B` (directly).

110. Legal shared subprogram — no package-level variable access:

```ada
function Clamp (V : Reading; Low, High : Reading) return Reading is
begin
    if V < Low then
        return Low;
    elsif V > High then
        return High;
    else
        return V;
    end if;
end Clamp;

task Task_A is
begin
    loop
        R : Reading;
        receive Channel_A, R;
        R := Clamp (R, 100, 3900);  -- legal: Clamp accesses no package-level variable
        send Output_A, R;
    end loop;
end Task_A;

task Task_B is
begin
    loop
        R : Reading;
        receive Channel_B, R;
        R := Clamp (R, 200, 3800);  -- legal: Clamp accesses no package-level variable
        send Output_B, R;
    end loop;
end Task_B;
```

---

## 4.6 Task Termination

### Dynamic Semantics

111. A task terminates when:
- The `sequence_of_statements` of its body completes by reaching the end of the statement list, or
- A `return` statement is executed within the task body.

112. A `return` statement within a task body shall not include an expression. The `return` statement in a task body is syntactically the same as a `return` statement in a procedure body (`return;`). A conforming implementation shall reject a `return` statement with an expression within a task body.

113. Upon termination of a task, the following effects occur:

114. **Owned variables become inaccessible:** Package-level variables owned by the terminated task are no longer accessed by any task. They retain their last-assigned values but shall not be accessed by any other task or environment-task subprogram (the ownership assignment is static and does not change at runtime). If the program contains no code path that accesses these variables after task termination, this is vacuously safe. If any code path could access them, the ownership check at compile time would have already rejected the program (since it would mean two tasks access the same variable).

115. **Channel endpoint behavior:** Channel operations performed by other tasks on channels that the terminated task also used are unaffected. A channel remains valid and operational regardless of the state of any task that has used it. Specifically:
- A `send` to a channel whose sole receiver has terminated will block the sending task indefinitely (or fail with `try_send` returning `False` once the buffer is full). This is detectable by static analysis as a potential livelock.
- A `receive` from a channel whose sole sender has terminated will block the receiving task indefinitely (or fail with `try_receive` returning `False` once the buffer is empty). This is detectable by static analysis as a potential livelock.

116. **No automatic notification:** There is no mechanism for a task to detect that another task has terminated. Tasks do not have identity values, termination attributes, or callable/terminated queries (these are excluded per Section 2, §2.1.7, paragraph 92). A task that needs to signal its termination to other tasks should do so by sending a termination message through a channel before executing `return`.

117. **Resource cleanup:** Local variables of the terminated task are finalized in the standard manner. Access-type local variables with non-null values cause automatic deallocation of their designated objects (Section 2, §2.3.4). Local variables of definite types are simply abandoned.

### Implementation Requirements

118. The `--emit-ada` backend shall emit task bodies that terminate normally when the body's statements complete. The emitted Ada shall not use `terminate` alternatives, `abort` statements, or any other Ada tasking termination mechanism beyond normal task completion.

119. The `--emit-c` backend shall emit task termination as a return from the pthread entry function. The implementation shall join or detach the terminated thread as appropriate for the target platform. Resources associated with the thread (stack, thread-local storage) shall be reclaimed by the implementation.

### Examples

120. A task that terminates after processing a fixed number of items:

```ada
task Initializer is
begin
    for I in Channel_Id.Range loop
        Cal_Table (I) := Default_Calibration;
    end loop;
    send Init_Done, True;
    return;
end Initializer;
```

121. A task that terminates upon receiving a shutdown command:

```ada
task Worker is
begin
    loop
        Cmd : Command;
        receive Commands, Cmd;
        if Cmd.Kind = Shutdown then
            send Status, (Kind => Terminated);
            return;
        end if;
        Process (Cmd);
    end loop;
end Worker;
```

---

## 4.7 Task Startup

### Dynamic Semantics

122. Tasks begin executing after all package-level initialization is complete. The startup order is defined as follows:

123. **Phase 1 — Package initialization:** All package-level variable initializations are evaluated in declaration order within each package. Inter-package initialization order follows the `with`-clause dependency graph: if package `A` depends on package `B` (via `with B;`), then all of package `B`'s initializations complete before any of package `A`'s initializations begin. This is the standard elaboration order of 8652:2023 §10.2, simplified by the absence of elaboration-time executable statements (D7).

124. **Phase 2 — Channel initialization:** All channel buffers are initialized to the empty state. This occurs as part of package initialization (channel declarations are package-level declarations whose initialization is the allocation and zeroing of the buffer).

125. **Phase 3 — Task activation:** After all packages have completed initialization, all declared tasks are activated. The order of task activation across packages is implementation-defined, but all tasks begin executing only after Phase 1 and Phase 2 are complete.

126. **Guarantee:** No task body executes before all package-level variable initializers and channel buffer initializations have completed. This means that a task body may read any package-level variable (that it owns per §4.5) and rely on the variable having been initialized with its declared initial value.

127. Within a single package, tasks are activated in declaration order. The first-declared task begins executing first. However, preemption is possible: if a higher-priority task is activated after a lower-priority task, the higher-priority task may preempt the lower-priority task.

### Implementation Requirements

128. The `--emit-ada` backend shall emit tasks as Ada tasks within a package body. The standard Ada task activation rules (8652:2023 §9.2) apply: tasks declared in a declarative region are activated at the end of the declarative region. Since packages in emitted Ada have bodies, the tasks activate when the package body elaboration completes.

129. The `--emit-c` backend shall create all threads during the initialization function (`__safe_runtime_init`), which is called after all package-level initialization code has executed. Thread creation shall use `pthread_create` with the appropriate priority attributes. The initialization function shall create threads in the order tasks are declared across all packages, following the package dependency order.

### Examples

130. Initialization order illustration:

```ada
-- Package Sensors
package Sensors is
    type Reading is range 0 .. 4095;

    Default_Cal : constant Reading := 0;
    Current_Cal : Reading := Default_Cal;  -- initialized in Phase 1

    channel Readings : Reading capacity 16;  -- initialized in Phase 2

    task Sampler with Priority => 10 is      -- activated in Phase 3
    begin
        -- Current_Cal is guaranteed to be 0 here
        -- Readings channel is guaranteed to be empty here
        loop
            R : Reading := Read_ADC (0) + Current_Cal;
            send Readings, R;
            delay 0.1;
        end loop;
    end Sampler;
end Sensors;
```

---

## 4.8 Complete Examples

### 4.8.1 Producer/Consumer

131. A sensor sampling task (producer) sends readings to a processing task (consumer) through a channel:

```ada
package Sensor_System is

    public type Reading is range 0 .. 4095;
    public type Channel_Id is range 0 .. 7;

    channel Readings : Reading capacity 32;
    public channel Alarms : Reading capacity 8;

    Threshold : Reading := 3000;  -- owned by Consumer

    task Producer with Priority => 10 is
    begin
        loop
            for Ch in Channel_Id.Range loop
                R : Reading := Read_ADC (Ch);
                send Readings, R;
            end loop;
            delay 0.01;
        end loop;
    end Producer;

    task Consumer with Priority => 5 is
    begin
        loop
            R : Reading;
            receive Readings, R;
            if R > Threshold then
                send Alarms, R;
            end if;
        end loop;
    end Consumer;

    function Read_ADC (Ch : Channel_Id) return Reading is separate;

end Sensor_System;
```

### 4.8.2 Router/Worker

132. A router task distributes work items across multiple worker tasks, each with its own input channel:

```ada
package Work_System is

    public type Work_Item is record
        Id    : Integer;
        Value : Integer;
    end record;

    public type Result is record
        Id    : Integer;
        Output : Integer;
    end record;

    channel Incoming : Work_Item capacity 64;
    channel Worker_A_In : Work_Item capacity 16;
    channel Worker_B_In : Work_Item capacity 16;
    public channel Results : Result capacity 32;

    task Router with Priority => 8 is
    begin
        loop
            Item : Work_Item;
            receive Incoming, Item;
            -- Simple round-robin: odd IDs to A, even IDs to B
            if Item.Id mod 2 = 1 then
                send Worker_A_In, Item;
            else
                send Worker_B_In, Item;
            end if;
        end loop;
    end Router;

    function Compute (V : Integer) return Integer is
    begin
        -- Pure computation, no package-level variable access.
        -- Can be called from multiple tasks.
        return V * V + 1;
    end Compute;

    task Worker_A with Priority => 5 is
    begin
        loop
            Item : Work_Item;
            receive Worker_A_In, Item;
            Output : Integer := Compute (Item.Value);
            send Results, (Id => Item.Id, Output => Output);
        end loop;
    end Worker_A;

    task Worker_B with Priority => 5 is
    begin
        loop
            Item : Work_Item;
            receive Worker_B_In, Item;
            Output : Integer := Compute (Item.Value);
            send Results, (Id => Item.Id, Output => Output);
        end loop;
    end Worker_B;

end Work_System;
```

133. Note that `Compute` accesses no package-level variables, so it may legally be called from both `Worker_A` and `Worker_B`.

### 4.8.3 Command/Response

134. A command processor receives commands from a channel, executes them, and sends responses back through a separate channel. A select statement with timeout provides periodic heartbeat processing:

```ada
package Command_System is

    type Command_Kind is (Set_Threshold, Query_Status, Reset, Shutdown);
    type Response_Kind is (Ack, Status_Report, Error, Heartbeat);

    type Command is record
        Kind  : Command_Kind;
        Value : Integer;
    end record;

    type Response is record
        Kind    : Response_Kind;
        Code    : Integer;
        Message : Integer;
    end record;

    public channel Commands : Command capacity 8;
    public channel Responses : Response capacity 16;

    Current_Threshold : Integer := 100;  -- owned by Processor

    task Processor with Priority => 7 is
    begin
        Running : Boolean := True;
        while Running loop
            select
                when Cmd : Command from Commands =>
                    case Cmd.Kind is
                        when Set_Threshold =>
                            Current_Threshold := Cmd.Value;
                            send Responses,
                                (Kind    => Ack,
                                 Code    => 0,
                                 Message => Current_Threshold);
                        when Query_Status =>
                            send Responses,
                                (Kind    => Status_Report,
                                 Code    => Current_Threshold,
                                 Message => 0);
                        when Reset =>
                            Current_Threshold := 100;
                            send Responses,
                                (Kind    => Ack,
                                 Code    => 0,
                                 Message => 100);
                        when Shutdown =>
                            send Responses,
                                (Kind    => Ack,
                                 Code    => 0,
                                 Message => 0);
                            Running := False;
                    end case;
                or delay 5.0 =>
                    send Responses,
                        (Kind    => Heartbeat,
                         Code    => Current_Threshold,
                         Message => 0);
            end select;
        end loop;
        return;
    end Processor;

end Command_System;
```

135. This example demonstrates:
- The select statement multiplexing between a command channel and a periodic timeout.
- Deterministic arm selection: if a command is available, it is always processed before the timeout fires.
- Task termination via `return` after receiving a `Shutdown` command.
- The `Current_Threshold` variable is owned exclusively by `Processor`.
- The terminated task sends an acknowledgment through the `Responses` channel before terminating, allowing other parts of the system to detect the shutdown.

### 4.8.4 Multi-Channel Aggregator

136. A task that aggregates data from multiple sensor channels using select:

```ada
package Aggregator is

    type Sensor_Reading is record
        Source : Integer;
        Value  : Integer;
    end record;

    channel Temp_Readings  : Integer capacity 16;
    channel Press_Readings : Integer capacity 16;
    channel Humid_Readings : Integer capacity 16;
    public channel Aggregated : Sensor_Reading capacity 32;

    task Collector with Priority => 6 is
    begin
        loop
            select
                when T : Integer from Temp_Readings =>
                    send Aggregated, (Source => 1, Value => T);
                or when P : Integer from Press_Readings =>
                    send Aggregated, (Source => 2, Value => P);
                or when H : Integer from Humid_Readings =>
                    send Aggregated, (Source => 3, Value => H);
                or delay 10.0 =>
                    -- No data received for 10 seconds; send a sentinel
                    send Aggregated, (Source => 0, Value => 0);
            end select;
        end loop;
    end Collector;

end Aggregator;
```

137. When multiple sensor channels have data available simultaneously, the `Temp_Readings` channel is always serviced first (first-listed arm wins), then `Press_Readings`, then `Humid_Readings`. This deterministic priority ordering is intentional and allows the programmer to prioritize certain data sources by their textual position in the select statement.

---

## 4.9 Relationship to 8652:2023 Section 9

138. This section replaces the following portions of 8652:2023:

| 8652:2023 Section | Status in Safe | Safe Replacement |
|---|---|---|
| §9.1 Task Units and Task Objects | Replaced | §4.1 Task Declarations |
| §9.2 Task Execution — Task Activation | Replaced | §4.7 Task Startup |
| §9.3 Task Dependence — Termination of Tasks | Replaced | §4.6 Task Termination |
| §9.4 Protected Units and Protected Objects | Replaced | §4.2 Channels (internal implementation) |
| §9.5 Intertask Communication | Replaced | §4.3 Channel Operations, §4.4 Select |
| §9.5.1 Protected Subprograms and Protected Actions | Replaced | Channel operations (internal) |
| §9.5.2 Entries and Accept Statements | Excluded | §2.1.7 |
| §9.5.3 Entry Calls | Replaced | §4.3 Channel Operations |
| §9.5.4 Requeue Statements | Excluded | §2.1.7 |
| §9.6 Delay Statements, Duration, and Time | Retained | `delay` in task bodies and select arms |
| §9.7 Select Statements | Replaced | §4.4 Select Statement |
| §9.7.1 Selective Accept | Excluded | §2.1.7 |
| §9.7.2 Timed Entry Calls | Excluded | §2.1.7 |
| §9.7.3 Conditional Entry Calls | Excluded | §2.1.7 |
| §9.7.4 Asynchronous Transfer of Control | Excluded | §2.1.7 |
| §9.8 Abort of a Task — Abort of a Sequence of Statements | Excluded | §2.1.7 |
| §9.9 Task and Entry Attributes | Excluded | §2.1.7 |
| §9.10 Shared Variables | Replaced | §4.5 Task-Variable Ownership |
| §9.11 Example of Tasking and Synchronization | Replaced | §4.8 Examples |

139. The `delay` statement (8652:2023 §9.6) is retained as specified in 8652:2023. Both `delay` *duration* and `delay until` *time* forms are available within task bodies and as the delay arm of a `select` statement. The types `Duration` and `Ada.Real_Time.Time` (if retained per Annex A) are applicable.

140. All other Section 9 constructs not listed in the table above are excluded per Section 2, §2.1.7.
