# Section 6 — Conformance

1. This section specifies the requirements for a conforming Safe implementation and a conforming Safe program.

---

## 6.1 Conforming Implementation

2. A conforming Safe implementation shall:

a) Accept every conforming Safe program (§6.2) and produce either executable output or annotated Ada/SPARK output.

b) Reject every program that uses an excluded feature (Section 2) at compile time, with a diagnostic identifying the excluded construct.

c) Implement the single-file package model (Section 3), the task and channel concurrency model (Section 4), and the Silver-by-construction rules (Section 2, §2.8).

d) Provide the `--emit-ada` backend (§6.4) and the `--emit-c` backend (§6.5).

e) Provide the retained library units specified in Annex A.

f) Support the C interface specified in Annex B.

g) Be written in Ada 2022 / SPARK 2022 and pass GNATprove at Silver level (§6.8).

---

## 6.2 Conforming Program

3. A conforming Safe program is a program that:

a) Uses only features retained or added by this specification (Sections 2–4).

b) Satisfies all legality rules specified in this document, including the Silver-by-construction rules (Section 2, §2.8).

c) Consists of one or more `.safe` source files, each containing exactly one package declaration (Section 3).

d) Contains no use of excluded features, excluded pragmas, excluded attributes, or excluded library units.

4. A conforming Safe program need not be Silver-provable in all execution paths to be accepted by the compiler. The Silver-by-construction rules (§2.8) ensure that runtime checks are *provable* from type information, but whether interval analysis succeeds for a particular arithmetic expression depends on the specific values involved. A program with a narrowing check that GNATprove cannot discharge is accepted by the Safe compiler but fails Silver verification when emitted via `--emit-ada`.

5. **Note:** The distinction is between *language conformance* (the program uses only Safe features and obeys all legality rules) and *verification conformance* (the program's emitted Ada passes GNATprove at Silver level). Both are goals, but language conformance is enforced by the compiler, while verification conformance is checked by GNATprove on the emitted output.

---

## 6.3 Compilation Model

### 6.3.1 Single-Pass Compilation

6. A conforming implementation shall compile each `.safe` source file in a single pass through the source text, using a recursive descent parser (D3). The compiler shall process declarations in source order and shall not require a second pass over the source.

7. **Declaration-before-use:** Every identifier shall be declared before its first use within the same compilation unit, with the sole exception of forward declarations for mutual recursion (Section 3, §3.2.3). The compiler shall resolve every identifier at the point of use without lookahead.

### 6.3.2 Symbol Files

8. A conforming implementation shall produce a binary symbol file for each compiled package. The symbol file shall contain the information specified in Section 3, §3.3 (paragraphs 56–62): public type declarations, public subprogram signatures, public constant values, public object types, opaque type size and alignment, and subprogram `Global`/`Depends` information for cross-package analysis.

9. The symbol file format is implementation-defined (see Annex C for implementation advice). The symbol file shall be sufficient for the compiler to process `with` clauses (8652:2023 §10.1.2) in client packages without reading the source of the dependency.

### 6.3.3 Separate Compilation

10. Each `.safe` source file is compiled independently, using only the symbol files of its dependencies (specified by `with` clauses). The compiler shall verify that dependencies are acyclic — a package shall not directly or transitively depend on itself.

11. Subunits (`is separate`, Section 8, §8.9) are compiled in the context of their parent unit and require access to the parent's complete internal state.

---

## 6.4 `--emit-ada` Requirements

12. A conforming implementation shall provide an `--emit-ada` mode that produces valid ISO/IEC 8652:2023 Ada source code. The emitted Ada shall satisfy all of the following requirements:

### 6.4.1 File Structure

13. For each Safe source file `name.safe`, the `--emit-ada` backend shall produce:
- `name.ads` — the package specification
- `name.adb` — the package body

14. The package specification shall contain:
- `pragma SPARK_Mode;`
- Public type declarations
- Public subprogram declarations with `Global` and `Depends` aspects
- Package-level `Initializes` aspect
- Opaque types declared as Ada `private` types (full declaration in the private part)

15. The package body shall contain:
- `pragma SPARK_Mode;`
- All subprogram bodies
- All private declarations
- Opaque type full declarations (replicated from the spec's private part)

### 6.4.2 SPARK Annotations

16. **Stone guarantee:** The emitted Ada shall compile with `pragma SPARK_Mode` without errors. Every emitted construct shall be SPARK-legal.

17. **Bronze guarantee:** The emitted Ada shall include:
- `Global` aspects on every subprogram (Section 5, §5.2.1)
- `Depends` aspects on every subprogram (Section 5, §5.2.2)
- `Initializes` aspect on every package (Section 5, §5.2.3)

18. Every conforming Safe program, when emitted via `--emit-ada` and submitted to GNATprove, shall pass flow analysis at Bronze level with no errors, no warnings, and no user-supplied annotations.

19. **Silver guarantee:** Every conforming Safe program, when emitted via `--emit-ada` and submitted to GNATprove, shall pass AoRTE proof at Silver level with no unproven checks and no user-supplied annotations. This is guaranteed by the D27 language rules (Section 2, §2.8).

### 6.4.3 Tasking Emission

20. Tasks shall be emitted as Jorvik-profile Ada:
- Each `task` declaration becomes an Ada task type with a single instance and a `Priority` aspect.
- `Global` aspects on task bodies specify owned variables and channel operations.

21. Channels shall be emitted as protected objects:
- Each `channel` declaration becomes a protected type with a single instance.
- The protected type has `Send` and `Receive` entries with bounded internal buffer.
- The protected type has a `Priority` aspect set to the ceiling priority (maximum of accessing task priorities).

22. Channel operations shall be emitted as entry calls:
- `send Ch, Value;` becomes `Ch_PO.Send(Value);`
- `receive Ch, Variable;` becomes `Ch_PO.Receive(Variable);`
- `try_send` and `try_receive` become conditional entry calls.

23. The `select` statement on channels shall be emitted as a conditional entry call pattern that tests channels in declaration order (deterministic, first-ready wins).

24. The emitted Jorvik-profile SPARK shall pass GNATprove concurrency analysis: no data race warnings, ceiling priority protocol respected, `Global` aspects on task bodies verified.

### 6.4.4 Wide Intermediate Arithmetic Emission

25. Integer arithmetic expressions shall be emitted using a wide integer type (e.g., `Long_Long_Integer` or a compiler-defined type) for intermediate computations, with explicit narrowing conversions at assignment/return/parameter points. The width shall be sufficient to hold any intermediate result without overflow.

### 6.4.5 Ownership Model Emission

26. Access type operations shall be emitted preserving the SPARK ownership model:
- Move assignments shall be emitted with source set to `null` after the move.
- Automatic deallocation at scope exit shall be emitted as calls to `Ada.Unchecked_Deallocation` in the generated body (the generated body is SPARK-mode with appropriate `Unchecked_Deallocation` in a non-SPARK wrapper if necessary, or the implementation uses a finalizer pattern).

---

## 6.5 `--emit-c` Requirements

27. A conforming implementation shall provide an `--emit-c` mode that produces C99 source code. The emitted C shall satisfy all of the following requirements:

### 6.5.1 C99 Compliance

28. The emitted C code shall compile under `cc -std=c99 -Wall -Werror` without warnings on the target platform.

29. The emitted C code shall be PIE (Position-Independent Executable) compatible. On OpenBSD, this is mandatory.

### 6.5.2 Arithmetic Emission

30. Integer arithmetic expressions shall be emitted using `int64_t` (or `__int128` if necessary) for intermediate computations, per D27 Rule 1. Range checks shall be emitted as explicit bounds tests at narrowing points (assignment, return, parameter passing):

```c
/* Safe source: return (A + B) / 2; where A, B : Reading (0..4095) */
int64_t _wide_temp = (int64_t)a + (int64_t)b;
int64_t _result = _wide_temp / 2;
if (_result < 0 || _result > 4095) {
    _safe_range_check_failed(__FILE__, __LINE__);
}
return (int32_t)_result;
```

### 6.5.3 Array Index Checks

31. Array index checks shall be emitted at every indexing operation:

```c
/* Safe source: return Table(Ch); where Ch : Channel_Id (0..7) */
/* D27 Rule 2 guarantees Ch is already in range, but emit check for defense-in-depth */
if (ch < 0 || ch > 7) {
    _safe_index_check_failed(__FILE__, __LINE__);
}
return table[ch];
```

### 6.5.4 Division Operations

32. D27 Rule 3 guarantees that the divisor type excludes zero. The emitted C need not insert runtime division-by-zero checks, as the type system prevents zero divisors. Implementations may emit checks as defense-in-depth.

### 6.5.5 Null Dereference

33. D27 Rule 4 guarantees that access subtypes at dereference points exclude null. The emitted C need not insert runtime null checks at dereference points. Implementations may emit checks as defense-in-depth.

### 6.5.6 Access Type Emission

34. Access type allocation shall be emitted as calls to the runtime allocator. Deallocation shall be emitted as calls to the runtime deallocator at owner scope exit:

```c
/* Allocator: P := new Node'(Value => 42, Next => null); */
node_t *p = _safe_alloc(sizeof(node_t));
p->value = 42;
p->next = NULL;

/* Scope exit: automatic deallocation */
if (p != NULL) {
    _safe_dealloc(p);
    p = NULL;
}
```

35. Move semantics shall be emitted by setting the source to `NULL` after the pointer copy:

```c
/* Move: Target := Source; */
target = source;
source = NULL;
```

### 6.5.7 Task Emission

36. Task declarations shall be emitted as pthread creation calls:

```c
/* Task startup */
pthread_create(&sampler_thread, &sampler_attr, sampler_entry, NULL);
```

37. Task priorities shall be mapped to pthread scheduling priorities where supported by the platform.

### 6.5.8 Channel Emission

38. Channels shall be emitted as ring buffer structures with mutex and condition variable synchronization:

```c
typedef struct {
    sample_t buffer[16];
    int head;
    int tail;
    int count;
    int capacity;
    pthread_mutex_t mutex;
    pthread_cond_t not_full;
    pthread_cond_t not_empty;
} channel_raw_samples_t;
```

39. `send` shall lock the mutex, wait on `not_full` if the buffer is full, enqueue the value, and signal `not_empty`. `receive` shall lock the mutex, wait on `not_empty` if the buffer is empty, dequeue the value, and signal `not_full`.

40. The `select` statement shall be emitted as a multi-channel poll using a shared condition variable or equivalent mechanism.

---

## 6.6 Target Platforms

41. A conforming implementation shall support the following target platforms:
- OpenBSD/amd64
- OpenBSD/arm64

42. Additional platforms may be supported as implementation extensions. The language definition is platform-independent; only the C emission backend and runtime are platform-specific.

---

## 6.7 Runtime Requirements

43. A conforming implementation shall provide a runtime library of approximately 900 LOC C (for the `--emit-c` backend) providing the following services:

| Component | Approximate LOC | Description |
|---|---|---|
| Assert handler | ~30 | `pragma Assert` failure: print location, abort |
| Range check handler | ~30 | Range check failure: print bounds, abort |
| Index check handler | ~30 | Index check failure: print index and bounds, abort |
| Memory allocator | ~100 | `new` allocator, scope-exit deallocator |
| Task lifecycle | ~50 | pthread creation, join, priority setting |
| Channel implementation | ~200 | Ring buffer with mutex/condvar |
| Select multiplexing | ~150 | Multi-channel poll with condvar |
| Timer/delay | ~20 | `clock_nanosleep` wrapper |
| Startup/shutdown | ~50 | Package initialization ordering, task activation |
| **Total** | **~660** | |

44. The runtime shall link against only `libc` and `libpthread` (or equivalent). No external dependencies beyond the system C library and threading library.

45. The runtime abort handler shall print the source file name, line number, and a diagnostic message before calling `abort()`. The diagnostic shall be human-readable.

---

## 6.8 Compiler Verification Requirement

46. A conforming implementation shall be written in Ada 2022 / SPARK 2022 (D29). All compiler source code shall pass GNATprove at Silver level (Absence of Runtime Errors) with no unproven checks.

47. **What this means:**
- Every array access in the compiler is proven safe.
- Every integer operation in the compiler is proven free of overflow.
- Every pointer dereference in the compiler is proven non-null.
- Every type conversion in the compiler is proven in range.
- A malformed Safe source file may produce a compilation error, but cannot crash the compiler.

48. **Build process:** The compiler build process shall consist of:
1. Compilation by GNAT (Ada compiler).
2. Verification by GNATprove at Silver level.
3. Deployment of the verified binary to the target platform.

49. **Note:** The compiler is not written in Safe. It is written in Ada/SPARK. Safe is the language being compiled. The compiler does not need to self-host.

50. **Estimated compiler structure:**

| Component | Approximate LOC | Silver Challenge |
|---|---|---|
| Lexer | 800–1,200 | Low — character-level, bounded buffers |
| Parser | 2,500–3,500 | Low — recursive descent, predictable control flow |
| Semantic analysis | 2,000–3,000 | Medium — symbol table lookups, type checking |
| Ownership checker | 800–1,200 | Medium — access type tracking |
| D27 rule enforcement | 500–800 | Low — interval arithmetic, type range queries |
| C emitter | 1,500–2,500 | Low — string building, tree walks |
| Ada/SPARK emitter | 1,500–2,500 | Low — string building, annotation generation |
| Task/channel compilation | 1,500–2,500 | Medium — priority analysis, ownership checking |
| Driver and I/O | 500–800 | Low — file handling, command line |
| **Total** | **12,000–17,000** | |

---

## 6.9 Diagnostics

51. A conforming implementation shall produce diagnostic messages that:

a) Identify the source file, line number, and column number of each error.

b) For excluded feature violations, reference the specific section of this specification (e.g., "generics are not permitted [Safe §2.1.10]").

c) For Silver-by-construction rule violations, identify the specific rule and suggest the correct pattern (e.g., "right operand of '/' has type Integer whose range includes zero; use a subtype that excludes zero [Safe §2.8.3]").

d) For ownership violations, identify the specific ownership rule (move, borrow, observe) and the conflicting access.

e) For task-variable ownership violations, identify which tasks access the conflicting variable and suggest channeling.

---

## 6.10 Incremental Recompilation

52. A conforming implementation should support incremental recompilation. When a source file is modified, only that file and its dependents (packages that `with` it) need recompilation.

53. The symbol file mechanism (§6.3.2) enables this: if a package's public interface (as recorded in the symbol file) has not changed, dependents need not be recompiled. The implementation should use content-hash-based change detection on symbol files.

---

## 6.11 Summary — What Constitutes Conformance

54. **Conforming implementation:** Satisfies §6.1 through §6.8, including both backends, retained libraries, the C interface, and the compiler verification requirement.

55. **Conforming program:** Satisfies §6.2 — uses only Safe features, obeys all legality rules including D27.

56. **Verified program:** A conforming program whose `--emit-ada` output passes GNATprove at both Bronze and Silver levels with no unproven checks. This is the expected outcome for a correct Safe program, guaranteed by the language design.
