# Annex B — Interface to C

1. This annex specifies the interface between Safe and the C programming language. Safe retains a subset of 8652:2023 Annex B (Interface to Other Languages) restricted to the C language interface. All other language interfaces defined in 8652:2023 Annex B are excluded.

2. The C interface is essential for systems programming on OpenBSD, where the system call interface, the C library (libc), and all kernel interfaces are defined in C. A conforming Safe implementation shall support the C interface features specified in this annex.

3. **8652:2023 Reference:** Annex B (Interface to Other Languages), comprising B.1 (Interfacing Pragmas), B.2 (The Package Interfaces), B.3 (Interfacing with C), B.3.1 (The Package Interfaces.C.Strings), B.3.2 (The Generic Package Interfaces.C.Pointers), B.3.3 (Unchecked Union Types), B.4 (Interfacing with COBOL), and B.5 (Interfacing with Fortran).

---

## B.1 Interfacing Pragmas

4. **8652:2023 Reference:** B.1

### Syntax

5. The following interfacing pragmas are retained from 8652:2023 B.1:

```
pragma Import (C, local_name [, external_name [, link_name]]);
pragma Export (C, local_name [, external_name [, link_name]]);
pragma Convention (C, local_name);
pragma Linker_Options (string_expression);
```

6. The *convention_identifier* in `pragma Import`, `pragma Export`, and `pragma Convention` shall be `C`. No other convention identifier is permitted. A conforming implementation shall reject any interfacing pragma that specifies a convention other than `C` or `Intrinsic`.

7. **Note:** Convention `Intrinsic` is retained for compiler-recognized built-in operations as specified in 8652:2023 B.1(12). It shall not be used in user-written `pragma Import` or `pragma Export` declarations.

### Legality Rules

8. `pragma Import` shall apply only to subprogram declarations and object declarations. It shall not apply to types. A conforming implementation shall reject `pragma Import` applied to a type declaration.

9. `pragma Export` shall apply only to subprogram declarations and object declarations. It shall not apply to types. A conforming implementation shall reject `pragma Export` applied to a type declaration.

10. `pragma Convention` may apply to subprogram declarations, object declarations, and record type declarations. When applied to a record type declaration, it specifies that the record's layout shall follow C structure layout conventions (see paragraph 68).

11. A subprogram to which `pragma Import` is applied shall not have a body in the Safe source. The declaration serves as the subprogram's complete definition; the implementation is provided by the linked C object code. A conforming implementation shall reject a body for an imported subprogram.

12. A subprogram to which `pragma Export` is applied shall have a body in the Safe source. The body provides the implementation callable from C. A conforming implementation shall reject `pragma Export` on a subprogram that has no body.

13. An imported subprogram shall not use parameter modes `in out` or `out` with types that are not passed by reference in the C calling convention. Scalar types and access types are passed by value in C; a parameter of such a type with mode `in out` or `out` requires a pointer in C, which has no direct representation in Safe's parameter model. A conforming implementation shall reject `in out` or `out` parameters of scalar or access type on imported subprograms.

14. **Note:** Record types and array types with `pragma Convention(C)` are passed by reference, and therefore mode `in out` and `out` are permitted for parameters of such types on imported subprograms.

15. The *external_name* and *link_name* arguments, when provided, shall be static string expressions.

16. `pragma Linker_Options` provides a string that is passed to the system linker. The argument shall be a static string expression. This pragma is retained as specified in 8652:2023 B.1(33-36).

### Static Semantics

17. An entity to which `pragma Import` is applied is an *imported entity*. Its defining occurrence in the Safe source provides the type signature. Its implementation is external.

18. An entity to which `pragma Export` is applied is an *exported entity*. It is visible to C code under the name specified by *external_name* (or, if *external_name* is omitted, by the *link_name*, or if both are omitted, by the linker name derived from the Safe identifier in an implementation-defined manner).

19. An entity to which `pragma Convention(C)` is applied follows C calling conventions and data layout conventions. For subprograms, this specifies the C calling convention. For record types, this specifies C structure layout (see paragraph 68).

20. The convention of an imported or exported subprogram is implicitly `C`. An explicit `pragma Convention(C)` on such a subprogram is permitted but redundant.

### Dynamic Semantics

21. A call to an imported subprogram transfers control to the external C function according to the platform's C calling convention. Parameters are passed according to the C ABI for the target architecture (System V AMD64 ABI on amd64, AAPCS64 on arm64).

22. Upon return from an imported subprogram, the return value (if any) is converted from the C return type to the corresponding Safe type. If the returned value does not satisfy the constraints of the Safe return type, the runtime abort handler is invoked with a diagnostic identifying the source location and the failed constraint. The implementation shall emit a range check at the call site for the returned value, consistent with D27 Rule 1 (wide intermediate arithmetic and narrowing checks at assignment points).

23. **Note:** The programmer should ensure that imported C functions return values within the declared Safe type's range, or use an intermediate unconstrained type and perform explicit bounds checking before narrowing.

24. A call to an exported subprogram from C transfers control to the Safe subprogram body. Parameters are received according to the C ABI. Upon return, the result value (if any) is passed back to the C caller according to the C ABI.

25. `pragma Linker_Options` causes the specified string to be passed to the linker when the compilation unit containing the pragma is included in a partition. Multiple `pragma Linker_Options` in the same compilation unit are passed to the linker in order of appearance.

### Implementation Requirements

26. A conforming implementation shall support the C calling convention for the target platform. On OpenBSD/amd64, this is the System V AMD64 ABI. On OpenBSD/arm64, this is the AAPCS64 ABI.

27. A conforming implementation shall pass the *external_name* or *link_name* to the linker so that the imported symbol is resolved at link time. If the symbol is not found, a link-time error shall result.

28. A conforming implementation shall emit exported symbols in the generated C code with external linkage and the specified name, so that they are visible to a C linker.

29. Since the Safe compiler emits C99 source code (D4), the implementation of interfacing pragmas is straightforward: `pragma Import` generates an `extern` declaration in the emitted C, `pragma Export` ensures the function definition has external linkage with the specified name, and `pragma Linker_Options` generates appropriate flags in the build commands or link scripts.

---

## B.2 The Package Interfaces

30. **8652:2023 Reference:** B.2

### Static Semantics

31. The package `Interfaces` is retained as specified in 8652:2023 B.2. It provides the following type declarations for hardware-oriented integer types:

```ada
package Interfaces is

   type Integer_8  is range -128 .. 127;
   type Integer_16 is range -32_768 .. 32_767;
   type Integer_32 is range -2_147_483_648 .. 2_147_483_647;
   type Integer_64 is range -9_223_372_036_854_775_808 ..
                              9_223_372_036_854_775_807;

   type Unsigned_8  is mod 2**8;
   type Unsigned_16 is mod 2**16;
   type Unsigned_32 is mod 2**32;
   type Unsigned_64 is mod 2**64;

   function Shift_Left   (Value : Unsigned_8;  Amount : Natural) return Unsigned_8;
   function Shift_Right  (Value : Unsigned_8;  Amount : Natural) return Unsigned_8;
   function Shift_Right_Arithmetic
                          (Value : Unsigned_8;  Amount : Natural) return Unsigned_8;
   function Rotate_Left  (Value : Unsigned_8;  Amount : Natural) return Unsigned_8;
   function Rotate_Right (Value : Unsigned_8;  Amount : Natural) return Unsigned_8;

   -- Analogous shift/rotate functions for Unsigned_16, Unsigned_32, Unsigned_64

end Interfaces;
```

32. The shift and rotate functions are declared with `pragma Convention(Intrinsic)` and are implemented by the compiler as intrinsic operations. They do not require linking with external code.

33. A conforming implementation shall provide the `Interfaces` package with all types and operations specified in 8652:2023 B.2. The implementation-defined integer and modular types shall have the sizes and ranges indicated by their names (e.g., `Integer_32` is exactly 32 bits, two's complement).

### Legality Rules

34. The `Interfaces` package is available via `with Interfaces;`. The types and operations declared in `Interfaces` are used with qualified names (e.g., `Interfaces.Unsigned_32`) or via `use type Interfaces.Unsigned_32;` to make operators directly visible.

---

## B.3 The Package Interfaces.C

35. **8652:2023 Reference:** B.3

### Static Semantics

36. The package `Interfaces.C` is retained. It provides type declarations that correspond to the fundamental C types as defined by the C standard (ISO/IEC 9899). The following is the retained content of `Interfaces.C`:

```ada
package Interfaces.C is

   -- Types corresponding to C's signed integer types

   type int        is range implementation_defined;  -- C int
   type short      is range implementation_defined;  -- C short
   type long       is range implementation_defined;  -- C long
   type long_long  is range implementation_defined;  -- C long long (C99)

   -- Types corresponding to C's unsigned integer types

   type unsigned           is mod implementation_defined;  -- C unsigned int
   type unsigned_short     is mod implementation_defined;  -- C unsigned short
   type unsigned_long      is mod implementation_defined;  -- C unsigned long
   type unsigned_long_long is mod implementation_defined;  -- C unsigned long long (C99)

   -- Types corresponding to C's character types

   type char is implementation_defined;  -- C char, maps to Character
   type signed_char   is range -128 .. 127;
   type unsigned_char is mod 256;

   -- C pointer-sized types

   type size_t    is mod implementation_defined;  -- C size_t
   type ptrdiff_t is range implementation_defined;  -- C ptrdiff_t

   -- Floating point types corresponding to C

   type C_float     is digits implementation_defined;  -- C float
   type double      is digits implementation_defined;  -- C double
   type long_double is digits implementation_defined;  -- C long double

   -- The null character for C string termination

   nul : constant char;

   -- Array types for C strings and character arrays

   type char_array is array (size_t range <>) of aliased char;

   function To_C   (Item : in String; Append_Nul : in Boolean := True)
      return char_array;
   function To_Ada (Item : in char_array; Trim_Nul : in Boolean := True)
      return String;

   function Is_Nul_Terminated (Item : in char_array) return Boolean;

end Interfaces.C;
```

37. **Note:** The 8652:2023 `Interfaces.C` package declares overloaded versions of `To_C` and `To_Ada` (with and without the `Append_Nul`/`Trim_Nul` parameter). Since Safe excludes overloading (D12), only the versions with the explicit boolean parameter are retained. The default value (`True`) provides the common-case behavior when the parameter is omitted at the call site.

38. The exact ranges and sizes of the numeric types are implementation-defined and shall correspond to the sizes of the corresponding C types on the target platform. On OpenBSD/amd64:

| Safe Type (Interfaces.C) | C Type | Size |
|---|---|---|
| `int` | `int` | 32 bits |
| `short` | `short` | 16 bits |
| `long` | `long` | 64 bits |
| `long_long` | `long long` | 64 bits |
| `unsigned` | `unsigned int` | 32 bits |
| `unsigned_short` | `unsigned short` | 16 bits |
| `unsigned_long` | `unsigned long` | 64 bits |
| `unsigned_long_long` | `unsigned long long` | 64 bits |
| `char` | `char` | 8 bits |
| `signed_char` | `signed char` | 8 bits |
| `unsigned_char` | `unsigned char` | 8 bits |
| `size_t` | `size_t` | 64 bits |
| `ptrdiff_t` | `ptrdiff_t` | 64 bits |
| `C_float` | `float` | 32 bits |
| `double` | `double` | 64 bits |
| `long_double` | `long double` | 128 bits |

39. On OpenBSD/arm64, the sizes are identical to amd64 for all types listed above.

### Legality Rules

40. The types in `Interfaces.C` shall be used for parameters and return types of imported and exported subprograms when the corresponding C function uses C fundamental types. Using Safe-native numeric types (e.g., `Integer`, `Float`) for C interface subprogram parameters is permitted only when the Safe type has the same size and representation as the corresponding C type.

41. **Recommendation:** Programs should use the types from `Interfaces.C` for all C-interfacing subprogram parameters to ensure portability and correct type correspondence.

### Dynamic Semantics

42. The `To_C` function converts a Safe `String` value to a `char_array`. When `Append_Nul` is `True` (the default), a nul character is appended. The resulting `char_array` has bounds `0 .. Item.Length` (with nul) or `0 .. Item.Length - 1` (without nul).

43. The `To_Ada` function converts a `char_array` to a Safe `String`. When `Trim_Nul` is `True` (the default), the first nul character and all subsequent elements are excluded from the result.

44. `Is_Nul_Terminated` returns `True` if `Item` contains at least one element equal to `nul`.

---

## B.3.1 The Package Interfaces.C.Strings

45. **8652:2023 Reference:** B.3.1

### Static Semantics

46. The package `Interfaces.C.Strings` is excluded. It defines the type `chars_ptr`, which is an access type representing a C `char *` pointer, and associated operations for managing C strings through pointers.

47. **Rationale:** `chars_ptr` is an access type with semantics that are incompatible with SPARK 2022 ownership rules. C string pointers have no ownership semantics -- they may alias, be shared, point into the middle of allocated blocks, or be freed by foreign code. These properties make `chars_ptr` fundamentally unsafe in Safe's ownership model.

48. **Alternative:** Programs that need to pass string data to C functions shall use `Interfaces.C.char_array` values. For C functions that accept `const char *` parameters, the Safe program passes a `char_array` with `pragma Convention(C)` -- the compiler passes the address of the first element, which is the C convention for array parameters. For C functions that return `char *`, the program shall declare the return type as `Interfaces.C.int` or another appropriate type representing an opaque handle, and copy data through a C wrapper function that copies the string into a caller-supplied buffer.

### Legality Rules

49. A conforming implementation shall reject any `with Interfaces.C.Strings;` clause. The package is not available in Safe.

---

## B.3.2 The Generic Package Interfaces.C.Pointers

50. **8652:2023 Reference:** B.3.2

51. **Legality Rule:** `Interfaces.C.Pointers` is excluded. It is a generic package, and generics are excluded from Safe (D16). A conforming implementation shall reject any `with Interfaces.C.Pointers;` clause.

---

## B.3.3 Unchecked Union Types

52. **8652:2023 Reference:** B.3.3

53. **Legality Rule:** The `Unchecked_Union` aspect is excluded. Unchecked unions remove the discriminant check on variant record access, creating a source of undetectable type errors at runtime. A conforming implementation shall reject any type declaration bearing the `Unchecked_Union` aspect.

54. **Note:** C unions may be represented in Safe using discriminated records with explicit discriminants. The discriminant serves as the union tag, and access to variant components is checked at compile time.

---

## B.4 Interfacing with COBOL

55. **8652:2023 Reference:** B.4

56. **Legality Rule:** The COBOL interface (package `Interfaces.COBOL`) is excluded in its entirety. A conforming implementation shall reject any `with Interfaces.COBOL;` clause or any `pragma Convention(COBOL, ...)`.

---

## B.5 Interfacing with Fortran

57. **8652:2023 Reference:** B.5

58. **Legality Rule:** The Fortran interface (package `Interfaces.Fortran`) is excluded in its entirety. A conforming implementation shall reject any `with Interfaces.Fortran;` clause or any `pragma Convention(Fortran, ...)`.

---

## B.6 Type Mapping Between Safe and C

59. This section specifies how Safe types correspond to C types when used in imported or exported subprograms, and when records are given convention `C`.

### B.6.1 Scalar Type Correspondence

#### Numeric Types

60. The following table specifies the correspondence between Safe numeric types and C types. The Safe types from `Interfaces.C` correspond exactly to their C counterparts as specified in paragraph 38.

61. Safe-native integer types correspond to C types as follows:

| Safe Type | C Type | Notes |
|---|---|---|
| `Integer` | `int` or `int32_t` | Implementation-defined; typically 32 bits |
| `Natural` | `int` or `uint32_t` | Subset of Integer; range 0..Integer.Last |
| `Positive` | `int` or `uint32_t` | Subset of Integer; range 1..Integer.Last |
| `Long_Integer` | `long` or `int64_t` | Implementation-defined; typically 64 bits |
| `Float` | `float` | IEEE 754 binary32 |
| `Long_Float` | `double` | IEEE 754 binary64 |
| User-defined integer types | Determined by size | See paragraph 62 |
| User-defined modular types | Determined by size | See paragraph 63 |
| User-defined fixed point types | No direct C equivalent | See paragraph 64 |

62. A user-defined integer type with `pragma Convention(C)` is represented as the smallest C signed integer type that can hold the full range. A user-defined integer type used as a parameter of an imported subprogram without `pragma Convention(C)` is passed as the C type corresponding to its base type.

63. A user-defined modular type with `pragma Convention(C)` is represented as the C unsigned integer type of the same size (e.g., a `mod 2**32` type maps to `uint32_t`).

64. Fixed point types have no direct C equivalent. When a fixed point value must be passed to C, the programmer should convert it to an integer representation (using the type's `Small` attribute to determine the scaling factor) or to a floating point value, and import the C function with the corresponding numeric parameter type.

#### Boolean Type

65. The Safe `Boolean` type corresponds to C `_Bool` (or `bool` with `<stdbool.h>`). The value `False` maps to 0 and `True` maps to 1. When an imported C function returns a value of type `int` intended as a boolean, the Safe declaration should use `Interfaces.C.int` as the return type and convert explicitly.

#### Character Type

66. The Safe `Character` type corresponds to C `char`. The representation is the platform's native character set (ASCII on OpenBSD). `Interfaces.C.char` is an explicit alias for this correspondence.

#### Enumeration Types

67. User-defined enumeration types with `pragma Convention(C)` are represented as C `int` values, with the internal codes corresponding to the position numbers of the enumeration literals (starting from 0). Enumeration representation clauses are respected.

### B.6.2 Composite Type Correspondence

#### Record Types

68. A record type with `pragma Convention(C, Record_Type)` has its components laid out in memory following the C structure layout rules for the target platform. This means:

69. Components are laid out in declaration order. No reordering is performed.

70. Each component is aligned to its natural alignment (the alignment required by the C ABI for the corresponding C type).

71. Padding bytes are inserted between components as necessary to satisfy alignment requirements.

72. The overall structure size is rounded up to a multiple of the largest component alignment.

73. These rules correspond to the layout that a C compiler would produce for a `struct` with the same component types in the same order.

74. **Legality Rule:** A record type with `pragma Convention(C)` shall not have discriminants. C structures do not have discriminants. A conforming implementation shall reject `pragma Convention(C)` applied to a discriminated record type.

75. **Legality Rule:** Every component of a record type with `pragma Convention(C)` shall itself be of a type that has a defined C correspondence (scalar types, other Convention-C record types, or array types with Convention-C element types). A conforming implementation should issue a warning if a component type has no defined C correspondence.

#### Array Types

76. An array type whose element type has convention `C`, or an array type with `pragma Convention(C)`, is laid out as a contiguous sequence of elements with no padding between elements (unless the element type itself requires padding for alignment). This corresponds to a C array.

77. When an array is passed as a parameter to an imported C function, it is passed by reference -- the C function receives a pointer to the first element. This is the standard C array-passing convention.

78. Unconstrained array types cannot be directly passed to C functions because the bounds information has no C representation. The programmer shall pass constrained array subtypes or use explicit length parameters.

#### String Passing

79. Safe strings (`String` type, which is `array (Positive range <>) of Character`) are not directly compatible with C strings (`char *`, null-terminated). Programs interfacing with C shall use one of the following approaches:

80. **Approach 1 -- char_array with To_C:** Convert the Safe string to a `Interfaces.C.char_array` using `Interfaces.C.To_C`, which appends a nul terminator. Pass the `char_array` to the imported C function.

81. **Approach 2 -- Fixed-length buffer:** Declare a fixed-length `Interfaces.C.char_array` buffer, fill it with the string data and a nul terminator, and pass it to C.

82. **Approach 3 -- C wrapper function:** Write a C wrapper function that accepts a pointer and a length (avoiding the need for nul termination), and import that wrapper.

---

## B.7 Access-to-Subprogram Exclusion and Callbacks

83. **8652:2023 Reference:** B.1(35-38), §3.10

84. **Legality Rule:** Access-to-subprogram types are excluded from Safe (D17). Consequently, C callback patterns that require passing a function pointer from Safe to C are not directly supported.

85. C callback patterns are excluded because access-to-subprogram types create indirect calls that cannot be statically resolved, violating Safe's property that every call resolves to a known target at compile time.

86. **Alternative -- C wrapper approach:** When a C library requires a callback function pointer, the programmer shall write a thin C wrapper (in C source) that provides the callback and calls back into Safe through an exported function. The exported Safe function is a normal subprogram with `pragma Export`, and the C wrapper holds the function pointer. This keeps all Safe code statically dispatched while satisfying the C library's callback requirement.

87. **Example pattern:**

```c
/* callback_wrapper.c -- compiled separately as C */
extern int safe_callback_handler(int value);  /* exported from Safe */

static int (*stored_callback)(int) = NULL;

void register_safe_callback(void) {
    stored_callback = &safe_callback_handler;
}

int invoke_callback(int value) {
    if (stored_callback != NULL)
        return stored_callback(value);
    return -1;
}
```

```ada
-- In Safe source:
public function Callback_Handler (Value : Interfaces.C.int) return Interfaces.C.int is
begin
    -- process value
    return Value * 2;
end Callback_Handler;
pragma Export (C, Callback_Handler, "safe_callback_handler");

procedure Register_Callback;
pragma Import (C, Register_Callback, "register_safe_callback");
```

---

## B.8 Summary of Retained and Excluded Features

88. The following table summarizes the status of each 8652:2023 Annex B feature in Safe:

| 8652:2023 Section | Feature | Status | Notes |
|---|---|---|---|
| B.1 | `pragma Import(C, ...)` | Retained | C convention only |
| B.1 | `pragma Export(C, ...)` | Retained | C convention only |
| B.1 | `pragma Convention(C, ...)` | Retained | C convention only |
| B.1 | `pragma Linker_Options` | Retained | As specified in 8652:2023 |
| B.1 | Convention `Intrinsic` | Retained | Compiler built-ins only |
| B.1 | Other conventions | Excluded | Only C and Intrinsic permitted |
| B.2 | Package `Interfaces` | Retained | Integer and modular types, shift/rotate |
| B.3 | Package `Interfaces.C` | Retained | C type mappings, char_array, To_C/To_Ada |
| B.3.1 | Package `Interfaces.C.Strings` | Excluded | chars_ptr incompatible with ownership |
| B.3.2 | Package `Interfaces.C.Pointers` | Excluded | Generic package; generics excluded |
| B.3.3 | `Unchecked_Union` aspect | Excluded | Removes discriminant safety |
| B.4 | Package `Interfaces.COBOL` | Excluded | COBOL interface not needed |
| B.5 | Package `Interfaces.Fortran` | Excluded | Fortran interface not needed |

---

## B.9 Examples

### B.9.1 Importing a C System Call

89. The following example imports the OpenBSD `pledge(2)` and `unveil(2)` system calls:

```ada
with Interfaces.C;

package Pledge is

    public function Pledge_Call (Promises  : Interfaces.C.char_array;
                                Execpromises : Interfaces.C.char_array)
        return Interfaces.C.int;
    pragma Import (C, Pledge_Call, "pledge");

    public function Unveil_Call (Path    : Interfaces.C.char_array;
                                Perms   : Interfaces.C.char_array)
        return Interfaces.C.int;
    pragma Import (C, Unveil_Call, "unveil");

    public type Pledge_Result is (Success, Failure);

    public function Restrict_Program return Pledge_Result is
    begin
        Promises : Interfaces.C.char_array := Interfaces.C.To_C ("stdio rpath");
        Empty    : Interfaces.C.char_array := Interfaces.C.To_C ("");
        Result   : Interfaces.C.int := Pledge_Call (Promises, Empty);
        if Result = 0 then
            return Success;
        else
            return Failure;
        end if;
    end Restrict_Program;

end Pledge;
```

### B.9.2 Importing a C Library Function

90. The following example imports the C `write(2)` system call for low-level I/O:

```ada
with Interfaces.C;

package Low_Level_IO is

    subtype File_Descriptor is Interfaces.C.int range 0 .. Interfaces.C.int.Last;
    subtype Positive_Size   is Interfaces.C.size_t range 1 .. Interfaces.C.size_t.Last;

    public function C_Write (Fd    : File_Descriptor;
                             Buf   : Interfaces.C.char_array;
                             Count : Interfaces.C.size_t)
        return Interfaces.C.ptrdiff_t;
    pragma Import (C, C_Write, "write");

    public procedure Write_Message (Fd  : File_Descriptor;
                                    Msg : String) is
    begin
        Buf     : Interfaces.C.char_array := Interfaces.C.To_C (Msg, Append_Nul => False);
        Written : Interfaces.C.ptrdiff_t := C_Write (Fd, Buf, Buf.Length);
        pragma Assert (Written >= 0);
    end Write_Message;

end Low_Level_IO;
```

### B.9.3 Exporting a Safe Function Callable from C

91. The following example exports a Safe function that C code can call:

```ada
with Interfaces.C;

package Checksum is

    public type Byte is mod 256;
    public type Byte_Array is array (Interfaces.C.size_t range <>) of Byte;
    pragma Convention (C, Byte);

    public function Compute_Checksum (Data : Byte_Array;
                                     Len  : Interfaces.C.size_t)
        return Interfaces.C.unsigned is
    begin
        Sum : Interfaces.C.unsigned := 0;
        for I in Data.First .. Data.First + Len - 1 loop
            Sum := Sum + Interfaces.C.unsigned (Data (I));
        end loop;
        return Sum;
    end Compute_Checksum;
    pragma Export (C, Compute_Checksum, "safe_compute_checksum");

end Checksum;
```

92. The corresponding C declaration for calling this function:

```c
/* In C code: */
extern unsigned int safe_compute_checksum(const unsigned char *data,
                                          size_t len);
```

### B.9.4 Passing Records Between Safe and C

93. The following example demonstrates a record type with `pragma Convention(C)` for interoperability with a C structure:

```ada
with Interfaces.C;

package Time_Spec is

    type Timespec is record
        Tv_Sec  : Interfaces.C.long;
        Tv_Nsec : Interfaces.C.long;
    end record;
    pragma Convention (C, Timespec);

    public function Clock_Gettime (Clock_Id : Interfaces.C.int;
                                   Tp       : in out Timespec)
        return Interfaces.C.int;
    pragma Import (C, Clock_Gettime, "clock_gettime");

    CLOCK_MONOTONIC : constant Interfaces.C.int := 3;  -- OpenBSD value

    public type Milliseconds is range 0 .. 2_147_483_647;

    public function Current_Time_Ms return Milliseconds is
    begin
        Ts     : Timespec := (Tv_Sec => 0, Tv_Nsec => 0);
        Result : Interfaces.C.int := Clock_Gettime (CLOCK_MONOTONIC, Ts);
        pragma Assert (Result = 0);
        -- Wide intermediate: Tv_Sec * 1000 computed in mathematical integer
        Ms : Milliseconds := Milliseconds (Ts.Tv_Sec * 1000 +
                                           Ts.Tv_Nsec / 1_000_000);
        return Ms;
    end Current_Time_Ms;

end Time_Spec;
```

94. The corresponding C structure:

```c
/* Equivalent C declaration: */
struct timespec {
    long tv_sec;
    long tv_nsec;
};
```

95. The `pragma Convention(C, Timespec)` guarantees that the Safe record and the C structure have identical memory layout: same component order, same alignment, same padding.

### B.9.5 Working with C Strings

96. The following example demonstrates converting between Safe strings and C null-terminated character arrays:

```ada
with Interfaces.C;

package Syslog is

    LOG_ERR     : constant Interfaces.C.int := 3;
    LOG_WARNING : constant Interfaces.C.int := 4;
    LOG_INFO    : constant Interfaces.C.int := 6;

    procedure C_Syslog (Priority : Interfaces.C.int;
                        Message  : Interfaces.C.char_array);
    pragma Import (C, C_Syslog, "syslog");

    procedure C_Openlog (Ident    : Interfaces.C.char_array;
                         Logopt   : Interfaces.C.int;
                         Facility : Interfaces.C.int);
    pragma Import (C, C_Openlog, "openlog");

    LOG_PID    : constant Interfaces.C.int := 16#01#;
    LOG_DAEMON : constant Interfaces.C.int := 3 * 8;  -- LOG_DAEMON = (3 << 3)

    public procedure Initialize (Program_Name : String) is
    begin
        C_Name : Interfaces.C.char_array := Interfaces.C.To_C (Program_Name);
        C_Openlog (C_Name, LOG_PID, LOG_DAEMON);
    end Initialize;

    public procedure Log_Error (Message : String) is
    begin
        C_Msg : Interfaces.C.char_array := Interfaces.C.To_C (Message);
        C_Syslog (LOG_ERR, C_Msg);
    end Log_Error;

    public procedure Log_Info (Message : String) is
    begin
        C_Msg : Interfaces.C.char_array := Interfaces.C.To_C (Message);
        C_Syslog (LOG_INFO, C_Msg);
    end Log_Info;

end Syslog;
```

97. The `To_C` function from `Interfaces.C` converts the Safe `String` to a nul-terminated `char_array` suitable for passing to C functions that expect `const char *`.

### B.9.6 Complete C Interface Example -- OpenBSD sysctl

98. The following example demonstrates a complete C interface pattern combining record types, imported functions, and type conversions:

```ada
with Interfaces.C;
with Interfaces;

package Sysctl is

    -- MIB constants for kern.hostname
    CTL_KERN     : constant Interfaces.C.int := 1;
    KERN_HOSTNAME : constant Interfaces.C.int := 10;

    type MIB_Entry is range 0 .. 15;
    type MIB_Array is array (MIB_Entry range <>) of Interfaces.C.int;
    pragma Convention (C, MIB_Array);

    function C_Sysctl (Name    : MIB_Array;
                       Namelen : Interfaces.C.unsigned;
                       Oldp    : in out Interfaces.C.char_array;
                       Oldlenp : in out Interfaces.C.size_t;
                       Newp    : Interfaces.C.char_array;
                       Newlen  : Interfaces.C.size_t)
        return Interfaces.C.int;
    pragma Import (C, C_Sysctl, "sysctl");

    Max_Hostname : constant := 256;

    public function Get_Hostname return String is
    begin
        MIB    : MIB_Array (0 .. 1) := (0 => CTL_KERN, 1 => KERN_HOSTNAME);
        Buffer : Interfaces.C.char_array (0 .. Max_Hostname - 1) :=
                     (others => Interfaces.C.nul);
        Length : Interfaces.C.size_t := Max_Hostname;
        Empty  : Interfaces.C.char_array (0 .. 0) := (0 => Interfaces.C.nul);

        Result : Interfaces.C.int :=
            C_Sysctl (MIB, 2, Buffer, Length, Empty, 0);
        pragma Assert (Result = 0);

        return Interfaces.C.To_Ada (Buffer, Trim_Nul => True);
    end Get_Hostname;

end Sysctl;
```

---

## B.10 Implementation Advice

99. A conforming implementation should provide clear diagnostic messages when a C interface pragma is used incorrectly. Specifically:

100. When `pragma Import` or `pragma Export` specifies a convention other than `C`, the diagnostic should state that only the C convention is supported in Safe and reference this annex.

101. When `pragma Convention(C)` is applied to a discriminated record type, the diagnostic should explain that C structures do not support discriminants and suggest using a non-discriminated record.

102. When a program attempts to use `Interfaces.C.Strings`, `Interfaces.C.Pointers`, `Interfaces.COBOL`, or `Interfaces.Fortran`, the diagnostic should identify the excluded package and suggest the retained alternative (e.g., `Interfaces.C.char_array` instead of `Interfaces.C.Strings.chars_ptr`).

103. When an imported subprogram has `in out` or `out` mode parameters of scalar type, the diagnostic should explain the C calling convention limitation and suggest restructuring the interface.

104. The implementation should document the exact mapping between Safe types and C types for each supported target platform, including sizes, alignments, and any platform-specific considerations.

105. When emitting C99 code (D4), the implementation should generate `#include` directives for standard C headers as needed by imported symbols (e.g., `#include <unistd.h>` for POSIX system calls), or should emit `extern` declarations that match the imported subprogram signatures.
