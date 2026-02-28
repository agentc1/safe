# Annex A — Predefined Language Environment

1. This annex classifies every library unit listed in ISO/IEC 8652:2023 Annex A (Predefined Language Environment) as **retained**, **excluded**, or **modified** with respect to Safe. A library unit not listed here is excluded by default.

2. A conforming implementation shall provide every library unit classified as retained, with the interface specified in 8652:2023 and subject to the restrictions of Section 2 of this document. A conforming implementation shall not provide any library unit classified as excluded; any `with` clause naming an excluded library unit shall be rejected at compile time.

3. A library unit classified as modified is retained with specific changes noted in its entry. A conforming implementation shall provide the modified interface as specified.

4. Exclusions fall into the following categories, each traced to a design decision:
   - **Generics (D16):** Library units that are generic packages or generic library-level subprograms are excluded because generics are excluded.
   - **Tagged types (D18):** Library units whose interfaces depend on tagged types, type extensions, or class-wide types are excluded.
   - **Exceptions (D14):** Library units whose interfaces declare, raise, or handle exceptions are excluded.
   - **Controlled types (D18, Section 2 paragraph 80):** Library units depending on `Ada.Finalization` are excluded.
   - **Tasking (D15):** Library units depending on full Ada tasking are excluded.
   - **Streams (Section 2 paragraph 134):** Library units depending on stream types are excluded.
   - **Dynamic allocation patterns:** Library units requiring unbounded dynamic allocation incompatible with the ownership model are excluded.
   - **Distributed systems (Section 2 paragraph 143):** Annex E library units are excluded.

---

## A.1 The Package Standard

5. **8652:2023 Reference:** §A.1

6. **Status:** RETAINED.

7. The package `Standard` is retained as specified in 8652:2023 §A.1. All predefined types (`Boolean`, `Integer`, `Float`, `Character`, `Wide_Character`, `Wide_Wide_Character`, `String`, `Wide_String`, `Wide_Wide_String`, `Duration`), predefined subtypes (`Natural`, `Positive`), and the predefined operators on these types are available.

8. **Note:** The predefined subtype `Positive` (range `1 .. Integer.Last`) serves as the standard nonzero-integer subtype for division (D27 Rule 3). The predefined subtype `Natural` (range `0 .. Integer.Last`) is retained. Both are subtypes of `Integer` as specified in 8652:2023.

---

## A.2 The Package Ada

9. **8652:2023 Reference:** §A.2

10. **Status:** RETAINED.

11. The package `Ada` is retained as the root package for the predefined library hierarchy. It is a pure package with no declarations of its own.

---

## A.3 Character Handling

### A.3.1 The Package Ada.Characters

12. **8652:2023 Reference:** §A.3.1

13. **Status:** RETAINED.

14. The package `Ada.Characters` is retained as the parent package for character handling utilities. It is a pure package with no declarations of its own.

### A.3.2 The Package Ada.Characters.Handling

15. **8652:2023 Reference:** §A.3.2

16. **Status:** RETAINED.

17. The package `Ada.Characters.Handling` is retained. All classification functions (`Is_Letter`, `Is_Digit`, `Is_Alphanumeric`, `Is_Special`, `Is_Control`, etc.) and conversion functions (`To_Upper`, `To_Lower`, `To_Basic`) are available.

18. **Note:** The functions `To_String` and `To_Wide_String` operating on bounded/unbounded strings are not applicable (those string types are excluded). Functions operating on `Character` and `String` (fixed-length) are retained.

### A.3.3 The Package Ada.Characters.Latin_1

19. **8652:2023 Reference:** §A.3.3

20. **Status:** RETAINED.

21. The package `Ada.Characters.Latin_1` is retained. All character constant declarations for the Latin-1 character set are available.

### A.3.4 The Package Ada.Characters.Conversions

22. **8652:2023 Reference:** §A.3.4

23. **Status:** RETAINED.

24. The package `Ada.Characters.Conversions` is retained. Character and string conversion functions between `Character`, `Wide_Character`, and `Wide_Wide_Character` (and their corresponding string types) are available.

---

## A.4 String Handling

### A.4.1 The Package Ada.Strings

25. **8652:2023 Reference:** §A.4.1

26. **Status:** MODIFIED.

27. The package `Ada.Strings` is retained with modification. The type declarations and constants (`Space`, `Length_Error`, `Pattern_Error`, `Index_Error`, `Translation_Error`) are retained. However, the exception declarations (`Length_Error`, `Pattern_Error`, `Index_Error`, `Translation_Error`) are excluded because exceptions are excluded (D14).

28. **Legality Rule:** A conforming implementation shall provide the package `Ada.Strings` without exception declarations. The enumeration types `Alignment`, `Truncation`, `Membership`, and `Direction` are retained. The `Space` constant is retained.

### A.4.2 The Package Ada.Strings.Maps

29. **8652:2023 Reference:** §A.4.2

30. **Status:** EXCLUDED.

31. **Rationale:** `Ada.Strings.Maps` defines the types `Character_Set` and `Character_Mapping`, which are used with the string search and transformation functions in `Ada.Strings.Fixed`, `Ada.Strings.Bounded`, and `Ada.Strings.Unbounded`. The package itself depends on controlled types for `Character_Set` and `Character_Mapping` in typical implementations, and its primary consumers (`Ada.Strings.Fixed`, etc.) are excluded or significantly restricted. Excluded per the controlled types dependency and overall string library simplification.

### A.4.3 The Package Ada.Strings.Fixed

32. **8652:2023 Reference:** §A.4.3

33. **Status:** EXCLUDED.

34. **Rationale:** `Ada.Strings.Fixed` provides string search, replacement, and transformation operations on fixed-length strings. Its interface raises exceptions (`Index_Error`, `Length_Error`, `Pattern_Error`) on error conditions (D14), depends on `Ada.Strings.Maps` types for search and translation operations, and many of its subprograms are overloaded (D12). Safe programs perform fixed-length string manipulation using array slicing, direct indexing, and explicit length tracking.

### A.4.4 The Package Ada.Strings.Bounded

35. **8652:2023 Reference:** §A.4.4

36. **Status:** EXCLUDED.

37. **Rationale:** `Ada.Strings.Bounded` is a generic package (D16). Its instantiation (`Ada.Strings.Bounded.Generic_Bounded_Length`) produces a bounded-length string type. Excluded because generics are excluded.

### A.4.5 The Package Ada.Strings.Unbounded

38. **8652:2023 Reference:** §A.4.5

39. **Status:** EXCLUDED.

40. **Rationale:** `Ada.Strings.Unbounded` provides dynamically-allocated variable-length strings. It requires controlled types for automatic deallocation via finalization (excluded per Section 2 paragraph 80), raises exceptions (D14), uses overloaded subprograms (D12), and performs unbounded dynamic allocation outside the ownership model. Safe programs use fixed-length arrays and slices for string handling (D23).

### A.4.6 The Package Ada.Strings.Maps.Constants

41. **8652:2023 Reference:** §A.4.6

42. **Status:** EXCLUDED.

43. **Rationale:** Depends on `Ada.Strings.Maps`, which is excluded.

### A.4.7 The Package Ada.Strings.Wide_Maps

44. **8652:2023 Reference:** §A.4.7

45. **Status:** EXCLUDED.

46. **Rationale:** Wide-character analog of `Ada.Strings.Maps`. Excluded for the same reasons as `Ada.Strings.Maps`.

### A.4.8 The Package Ada.Strings.Wide_Fixed

47. **8652:2023 Reference:** §A.4.8

48. **Status:** EXCLUDED.

49. **Rationale:** Wide-character analog of `Ada.Strings.Fixed`. Excluded for the same reasons as `Ada.Strings.Fixed`.

### A.4.9 The Package Ada.Strings.Wide_Bounded

50. **8652:2023 Reference:** §A.4.9

51. **Status:** EXCLUDED.

52. **Rationale:** Generic package (D16). Wide-character analog of `Ada.Strings.Bounded`.

### A.4.10 The Package Ada.Strings.Wide_Unbounded

53. **8652:2023 Reference:** §A.4.10

54. **Status:** EXCLUDED.

55. **Rationale:** Wide-character analog of `Ada.Strings.Unbounded`. Requires controlled types, exceptions, and unbounded dynamic allocation.

### A.4.11 The Package Ada.Strings.Wide_Wide_Maps

56. **8652:2023 Reference:** §A.4.11

57. **Status:** EXCLUDED.

58. **Rationale:** Wide-wide-character analog of `Ada.Strings.Maps`. Excluded for the same reasons.

### A.4.12 The Package Ada.Strings.Wide_Wide_Fixed

59. **8652:2023 Reference:** §A.4.12

60. **Status:** EXCLUDED.

61. **Rationale:** Excluded for the same reasons as `Ada.Strings.Fixed`.

### A.4.13 The Package Ada.Strings.Wide_Wide_Bounded

62. **8652:2023 Reference:** §A.4.13

63. **Status:** EXCLUDED.

64. **Rationale:** Generic package (D16).

### A.4.14 The Package Ada.Strings.Wide_Wide_Unbounded

65. **8652:2023 Reference:** §A.4.14

66. **Status:** EXCLUDED.

67. **Rationale:** Requires controlled types, exceptions, and unbounded dynamic allocation.

### A.4.15 The Package Ada.Strings.UTF_Encoding

68. **8652:2023 Reference:** §A.4.11 (Ada 2012) / §A.4.15 (Ada 2022 numbering)

69. **Status:** EXCLUDED.

70. **Rationale:** The UTF encoding packages raise `Encoding_Error` exceptions (D14) and depend on unbounded string types in portions of the interface.

### A.4.16 The Package Ada.Strings.Text_Buffers

71. **8652:2023 Reference:** §A.4.12 (Ada 2022)

72. **Status:** EXCLUDED.

73. **Rationale:** `Ada.Strings.Text_Buffers` defines the root tagged type `Root_Buffer_Type` for the `Put_Image` feature (D18 — tagged types excluded). The `Buffer_Type` child is also excluded.

### A.4.17 The Package Ada.Strings.Hash

74. **8652:2023 Reference:** §A.4.9

75. **Status:** EXCLUDED.

76. **Rationale:** `Ada.Strings.Hash` is a library-level function, not a package. It is retained if the implementation provides it as a non-generic function. However, its primary use is with `Ada.Containers` hashed containers, which are excluded (D16, D18). Implementations are not required to provide it.

---

## A.5 Numerics

### A.5.1 The Package Ada.Numerics

77. **8652:2023 Reference:** §A.5

78. **Status:** RETAINED.

79. The package `Ada.Numerics` is retained. The constants `Pi` and `e` are available.

### A.5.2 The Package Ada.Numerics.Elementary_Functions

80. **8652:2023 Reference:** §A.5.1

81. **Status:** EXCLUDED.

82. **Rationale:** `Ada.Numerics.Elementary_Functions` is a non-generic instantiation of `Ada.Numerics.Generic_Elementary_Functions` for the type `Float`. In 8652:2023, it is defined as a renaming of an instantiation. Since generic instantiations are excluded (D16), and the package is defined in terms of one, it is excluded.

83. **Note:** An implementation may provide `Ada.Numerics.Elementary_Functions` as a non-generic package with monomorphic subprograms for the type `Float` as an implementation extension. Such an extension is outside the scope of this specification.

### A.5.3 The Package Ada.Numerics.Generic_Elementary_Functions

84. **8652:2023 Reference:** §A.5.1

85. **Status:** EXCLUDED.

86. **Rationale:** Generic package (D16).

### A.5.4 The Package Ada.Numerics.Float_Random

87. **8652:2023 Reference:** §A.5.2

88. **Status:** RETAINED.

89. The package `Ada.Numerics.Float_Random` is retained. It provides a non-generic random number generator producing uniformly distributed `Float` values. The type `Generator` and the functions `Random` and `Reset` are available.

90. **Note:** The `Generator` type contains internal state. It is a limited private type and follows standard Ada limited type semantics. No ownership rules apply beyond those for limited types.

### A.5.5 The Package Ada.Numerics.Discrete_Random

91. **8652:2023 Reference:** §A.5.2

92. **Status:** EXCLUDED.

93. **Rationale:** `Ada.Numerics.Discrete_Random` is a generic package (D16). Safe programs requiring discrete random values shall use `Ada.Numerics.Float_Random` and scale the result to the desired discrete range.

### A.5.6 The Packages Ada.Numerics.Generic_Complex_Types and Ada.Numerics.Generic_Complex_Elementary_Functions

94. **8652:2023 Reference:** §G.1.1, §G.1.2

95. **Status:** EXCLUDED.

96. **Rationale:** Generic packages (D16). These are also Annex G (Numerics) specialized-needs packages.

### A.5.7 The Package Ada.Numerics.Big_Numbers

97. **8652:2023 Reference:** §A.5.5 through §A.5.7 (Ada 2022)

98. **Status:** EXCLUDED.

99. **Rationale:** `Ada.Numerics.Big_Numbers.Big_Integers` and `Ada.Numerics.Big_Numbers.Big_Reals` require controlled types for automatic deallocation of arbitrary-precision representations and raise exceptions on invalid operations (D14). `Ada.Numerics.Big_Numbers.Big_Numbers_Generic_Interface` is a generic package (D16).

---

## A.6 Input-Output

### A.6.1 Input-Output Overview

100. **8652:2023 Reference:** §A.6, §A.7

101. All Ada I/O packages raise exceptions (`Status_Error`, `Mode_Error`, `Name_Error`, `Use_Error`, `Device_Error`, `End_Error`, `Data_Error`, `Layout_Error`) defined in `Ada.IO_Exceptions`. Since exceptions are excluded (D14), the standard I/O packages cannot be retained in their 8652:2023 form.

102. **Note:** Safe programs perform I/O through the C interface (`pragma Import`) or through an implementation-defined I/O library that reports errors via discriminated records or status codes rather than exceptions.

### A.6.2 The Package Ada.Sequential_IO

103. **8652:2023 Reference:** §A.8.1

104. **Status:** EXCLUDED.

105. **Rationale:** Generic package (D16) that raises exceptions (D14).

### A.6.3 The Package Ada.Direct_IO

106. **8652:2023 Reference:** §A.8.4

107. **Status:** EXCLUDED.

108. **Rationale:** Generic package (D16) that raises exceptions (D14).

### A.6.4 The Package Ada.Text_IO

109. **8652:2023 Reference:** §A.10.1

110. **Status:** EXCLUDED.

111. **Rationale:** `Ada.Text_IO` raises exceptions throughout its interface (`Status_Error`, `Mode_Error`, `Name_Error`, `Use_Error`, `Device_Error`, `End_Error`, `Data_Error`, `Layout_Error`) (D14). Additionally, the nested generic packages `Integer_IO`, `Modular_IO`, `Float_IO`, `Fixed_IO`, `Decimal_IO`, and `Enumeration_IO` are generic (D16). The `File_Type` is a controlled type in typical implementations.

112. **Note:** Safe programs perform text output through the C interface (e.g., `pragma Import (C, Put_Line, "puts");`) or through an implementation-defined text I/O library. See Annex C of this document for implementation advice on providing a Safe-compatible I/O facility.

### A.6.5 The Packages Ada.Text_IO.Integer_IO, Float_IO, Fixed_IO, Decimal_IO, Modular_IO, Enumeration_IO

113. **8652:2023 Reference:** §A.10.8, §A.10.9

114. **Status:** EXCLUDED.

115. **Rationale:** These are generic packages nested within `Ada.Text_IO` (D16). They are also excluded because their parent package `Ada.Text_IO` is excluded.

### A.6.6 The Package Ada.Text_IO.Text_Streams

116. **8652:2023 Reference:** §A.12.2

117. **Status:** EXCLUDED.

118. **Rationale:** Depends on streams (Section 2 paragraph 134) and `Ada.Text_IO` (excluded).

### A.6.7 The Package Ada.Text_IO.Bounded_IO

119. **8652:2023 Reference:** §A.10.11

120. **Status:** EXCLUDED.

121. **Rationale:** Depends on `Ada.Strings.Bounded` (generic, excluded) and `Ada.Text_IO` (excluded).

### A.6.8 The Package Ada.Text_IO.Unbounded_IO

122. **8652:2023 Reference:** §A.10.12

123. **Status:** EXCLUDED.

124. **Rationale:** Depends on `Ada.Strings.Unbounded` (excluded) and `Ada.Text_IO` (excluded).

### A.6.9 The Packages Ada.Wide_Text_IO and Ada.Wide_Wide_Text_IO

125. **8652:2023 Reference:** §A.11

126. **Status:** EXCLUDED.

127. **Rationale:** Wide-character analogs of `Ada.Text_IO`. Excluded for the same reasons: exception-raising interface (D14), generic nested packages (D16).

### A.6.10 The Package Ada.Stream_IO

128. **8652:2023 Reference:** §A.12.1

129. **Status:** EXCLUDED.

130. **Rationale:** Depends on streams (Section 2 paragraph 134) and raises exceptions (D14).

### A.6.11 The Package Ada.Storage_IO

131. **8652:2023 Reference:** §A.9

132. **Status:** EXCLUDED.

133. **Rationale:** Generic package (D16) that raises exceptions (D14).

---

## A.7 The Package Ada.IO_Exceptions

134. **8652:2023 Reference:** §A.13

135. **Status:** EXCLUDED.

136. **Rationale:** Declares exceptions (`Status_Error`, `Mode_Error`, `Name_Error`, `Use_Error`, `Device_Error`, `End_Error`, `Data_Error`, `Layout_Error`). Exceptions are excluded (D14).

---

## A.8 The Package Ada.Command_Line

137. **8652:2023 Reference:** §A.15

138. **Status:** RETAINED.

139. The package `Ada.Command_Line` is retained. The functions `Argument_Count`, `Argument`, `Command_Name`, and the procedure `Set_Exit_Status` are available.

140. **Note:** The function `Argument` in 8652:2023 raises `Constraint_Error` if the index is out of range; in Safe, this invokes the runtime abort handler. The programmer shall validate the index against `Argument_Count` before calling `Argument`, consistent with D27's philosophy of explicit bounds checking before narrowing operations.

---

## A.9 The Package Ada.Directories

141. **8652:2023 Reference:** §A.16

142. **Status:** EXCLUDED.

143. **Rationale:** `Ada.Directories` raises exceptions throughout its interface (`Name_Error`, `Use_Error`, `Status_Error`) (D14). It also uses controlled types for `Search_Type` and `Directory_Entry_Type`, and string-returning functions that rely on secondary stack or unbounded allocation. Safe programs access directory operations through the C interface.

---

## A.10 The Package Ada.Environment_Variables

144. **8652:2023 Reference:** §A.17

145. **Status:** EXCLUDED.

146. **Rationale:** `Ada.Environment_Variables` raises exceptions on missing variables (D14). The iteration interface uses access-to-subprogram parameters (excluded per Section 2 paragraph 13). Safe programs access environment variables through the C interface (e.g., `pragma Import (C, Getenv, "getenv");`).

---

## A.11 The Package Ada.Calendar

147. **8652:2023 Reference:** §9.6

148. **Status:** MODIFIED.

149. The package `Ada.Calendar` is retained with modification. The type `Time`, the function `Clock`, and the functions `Year`, `Month`, `Day`, `Seconds` for decomposing a `Time` value are retained. The function `Time_Of` for composing a `Time` value is retained.

150. **Modification:** The exception `Time_Error` declared in `Ada.Calendar` is excluded (D14). Operations that would raise `Time_Error` in 8652:2023 shall instead invoke the runtime abort handler.

151. **Note:** The subpackage `Ada.Calendar.Formatting` (§9.6.1) is excluded because it raises `Time_Error` and depends on string operations. The subpackage `Ada.Calendar.Time_Zones` (§9.6.1) is excluded for the same reasons. The subpackage `Ada.Calendar.Arithmetic` (§9.6.1) is excluded because it raises `Time_Error`.

---

## A.12 The Package Ada.Exceptions

152. **8652:2023 Reference:** §11.4.1

153. **Status:** EXCLUDED.

154. **Rationale:** Exceptions are excluded in their entirety (D14). The package `Ada.Exceptions` provides `Exception_Name`, `Exception_Message`, `Exception_Information`, and `Exception_Occurrence` — all of which are meaningless without the exception mechanism.

---

## A.13 The Package Ada.Finalization

155. **8652:2023 Reference:** §7.6

156. **Status:** EXCLUDED.

157. **Rationale:** Controlled types are excluded (Section 2 paragraph 80). `Ada.Finalization` defines the root types `Controlled` and `Limited_Controlled` for user-defined finalization. Deallocation in Safe is handled by automatic scope-based deallocation under the ownership model (D17).

---

## A.14 The Package Ada.Tags

158. **8652:2023 Reference:** §3.9

159. **Status:** EXCLUDED.

160. **Rationale:** Tagged types are excluded (D18). `Ada.Tags` provides runtime tag operations (`Tag`, `External_Tag`, `Internal_Tag`, `Descendant_Tag`, `Is_Descendant_At_Same_Level`, `Parent_Tag`) — all of which are meaningless without tagged types.

---

## A.15 The Package Ada.Streams

161. **8652:2023 Reference:** §13.13.1

162. **Status:** EXCLUDED.

163. **Rationale:** Streams are excluded (Section 2 paragraph 134). `Ada.Streams` defines `Root_Stream_Type`, which is a tagged limited type (tagged types excluded, D18). Stream-oriented attributes (`Read`, `Write`, `Input`, `Output`) are excluded.

### A.15.1 The Package Ada.Streams.Stream_IO

164. **8652:2023 Reference:** §A.12.1

165. **Status:** EXCLUDED.

166. **Rationale:** Depends on streams (excluded) and raises exceptions (D14).

---

## A.16 Tasking-Related Packages

### A.16.1 The Package Ada.Task_Identification

167. **8652:2023 Reference:** §C.7.1

168. **Status:** EXCLUDED.

169. **Rationale:** Full Ada tasking is excluded (D15). `Ada.Task_Identification` provides `Task_Id`, `Current_Task`, `Is_Terminated`, `Is_Callable`, and `Abort_Task` — none of which are applicable to Safe's static task and channel model (D28).

### A.16.2 The Package Ada.Task_Attributes

170. **8652:2023 Reference:** §C.7.2

171. **Status:** EXCLUDED.

172. **Rationale:** Generic package (D16) that depends on full Ada tasking (D15).

### A.16.3 The Package Ada.Task_Termination

173. **8652:2023 Reference:** §C.7.3

174. **Status:** EXCLUDED.

175. **Rationale:** Depends on full Ada tasking (D15) and uses access-to-subprogram parameters (excluded per Section 2 paragraph 13).

### A.16.4 The Package Ada.Synchronous_Task_Control

176. **8652:2023 Reference:** §D.10

177. **Status:** EXCLUDED.

178. **Rationale:** Provides `Suspension_Object` for inter-task synchronization. Excluded because Safe uses channels for all inter-task communication (D28). Suspension objects would permit shared-state synchronization patterns that bypass the channel model.

### A.16.5 The Package Ada.Synchronous_Barriers

179. **8652:2023 Reference:** §D.10.1

180. **Status:** EXCLUDED.

181. **Rationale:** Depends on full Ada tasking (D15). Barriers are a shared-state synchronization pattern that bypasses the channel model (D28).

### A.16.6 The Package Ada.Asynchronous_Task_Control

182. **8652:2023 Reference:** §D.11

183. **Status:** EXCLUDED.

184. **Rationale:** Depends on full Ada tasking (D15) and `Ada.Task_Identification` (excluded).

### A.16.7 The Package Ada.Dynamic_Priorities

185. **8652:2023 Reference:** §D.5.1

186. **Status:** EXCLUDED.

187. **Rationale:** Dynamic priorities are excluded. Task priorities in Safe are static, assigned at the point of task declaration (D28). Dynamic priority changes would invalidate the ceiling priority protocol analysis.

---

## A.17 The Package Ada.Containers

188. **8652:2023 Reference:** §A.18.1

189. **Status:** EXCLUDED.

190. **Rationale:** The `Ada.Containers` hierarchy is excluded in its entirety. Every container package in the hierarchy is a generic package (D16), and the container interfaces depend on tagged types (D18), controlled types (for automatic memory management via finalization), and exceptions (D14). The following packages are all excluded:

191. The excluded container packages include:
- `Ada.Containers` (§A.18.1) — root package; declares `Hash_Type`, `Count_Type`, and the exception `Capacity_Error`
- `Ada.Containers.Vectors` (§A.18.2) — generic, tagged, controlled, exceptions
- `Ada.Containers.Doubly_Linked_Lists` (§A.18.3) — generic, tagged, controlled, exceptions
- `Ada.Containers.Hashed_Maps` (§A.18.5) — generic, tagged, controlled, exceptions
- `Ada.Containers.Ordered_Maps` (§A.18.6) — generic, tagged, controlled, exceptions
- `Ada.Containers.Hashed_Sets` (§A.18.8) — generic, tagged, controlled, exceptions
- `Ada.Containers.Ordered_Sets` (§A.18.9) — generic, tagged, controlled, exceptions
- `Ada.Containers.Multiway_Trees` (§A.18.10) — generic, tagged, controlled, exceptions
- `Ada.Containers.Indefinite_Vectors` (§A.18.11) — generic, tagged, controlled, exceptions
- `Ada.Containers.Indefinite_Doubly_Linked_Lists` (§A.18.12) — generic, tagged, controlled, exceptions
- `Ada.Containers.Indefinite_Hashed_Maps` (§A.18.13) — generic, tagged, controlled, exceptions
- `Ada.Containers.Indefinite_Ordered_Maps` (§A.18.14) — generic, tagged, controlled, exceptions
- `Ada.Containers.Indefinite_Hashed_Sets` (§A.18.15) — generic, tagged, controlled, exceptions
- `Ada.Containers.Indefinite_Ordered_Sets` (§A.18.16) — generic, tagged, controlled, exceptions
- `Ada.Containers.Indefinite_Multiway_Trees` (§A.18.17) — generic, tagged, controlled, exceptions
- `Ada.Containers.Bounded_Vectors` (§A.18.19) — generic, tagged, exceptions
- `Ada.Containers.Bounded_Doubly_Linked_Lists` (§A.18.20) — generic, tagged, exceptions
- `Ada.Containers.Bounded_Hashed_Maps` (§A.18.21) — generic, tagged, exceptions
- `Ada.Containers.Bounded_Ordered_Maps` (§A.18.22) — generic, tagged, exceptions
- `Ada.Containers.Bounded_Hashed_Sets` (§A.18.23) — generic, tagged, exceptions
- `Ada.Containers.Bounded_Ordered_Sets` (§A.18.24) — generic, tagged, exceptions
- `Ada.Containers.Bounded_Multiway_Trees` (§A.18.25) — generic, tagged, exceptions
- `Ada.Containers.Synchronized_Queue_Interfaces` (§A.18.27) — generic, tagged (synchronized interface)
- `Ada.Containers.Unbounded_Synchronized_Queues` (§A.18.28) — generic, tagged
- `Ada.Containers.Bounded_Synchronized_Queues` (§A.18.29) — generic, tagged
- `Ada.Containers.Unbounded_Priority_Queues` (§A.18.30) — generic, tagged
- `Ada.Containers.Bounded_Priority_Queues` (§A.18.31) — generic, tagged

192. **Note:** Safe programs build dynamic data structures (linked lists, trees, maps) using access types with the ownership model (D17) and records with discriminants. The channel type (D28) provides safe bounded queues for inter-task communication.

---

## A.18 The Package Ada.Unchecked_Conversion

193. **8652:2023 Reference:** §13.9

194. **Status:** EXCLUDED.

195. **Rationale:** `Ada.Unchecked_Conversion` is a generic library-level function (D16) that bypasses the type system. Deferred to the system sublanguage (D24).

---

## A.19 The Package Ada.Unchecked_Deallocation

196. **8652:2023 Reference:** §13.11.2

197. **Status:** EXCLUDED.

198. **Rationale:** `Ada.Unchecked_Deallocation` is a generic library-level procedure (D16). Deallocation is handled automatically by the ownership model (D17). Explicit deallocation is excluded to prevent dangling access values.

---

## A.20 The Package Ada.Unchecked_Access_Conversions and Ada.Unchecked_Deallocate_Subpool

199. **8652:2023 Reference:** §13.11.4, §13.11.5

200. **Status:** EXCLUDED.

201. **Rationale:** Storage subpools are excluded (Section 2 paragraph 130). These are generic packages (D16) for subpool management.

---

## A.21 The Package Ada.Locales

202. **8652:2023 Reference:** §A.19

203. **Status:** EXCLUDED.

204. **Rationale:** `Ada.Locales` provides locale-dependent information (`Language`, `Country`). Its utility depends on string handling facilities that are largely excluded. Safe programs access locale information through the C interface if needed.

---

## A.22 The Package Ada.Dispatching

205. **8652:2023 Reference:** §D.2.1

206. **Status:** EXCLUDED.

207. **Rationale:** `Ada.Dispatching` provides task dispatching domain control. Depends on full Ada tasking (D15) and tagged types (D18).

---

## A.23 The Package Ada.Interrupts

208. **8652:2023 Reference:** §C.3.2

209. **Status:** EXCLUDED.

210. **Rationale:** Interrupt handling is excluded (Section 2 paragraph 138). Deferred to the system sublanguage (D24).

### A.23.1 The Package Ada.Interrupts.Names

211. **8652:2023 Reference:** §C.3.2

212. **Status:** EXCLUDED.

213. **Rationale:** Depends on `Ada.Interrupts` (excluded).

---

## A.24 The Package Ada.Real_Time

214. **8652:2023 Reference:** §D.8

215. **Status:** EXCLUDED.

216. **Rationale:** `Ada.Real_Time` is part of the Real-Time Systems annex, which is excluded except for static task priorities (Section 2 paragraph 140). Safe programs use `Ada.Calendar` for time queries or interface with C timing functions for high-resolution timing.

### A.24.1 The Package Ada.Real_Time.Timing_Events

217. **8652:2023 Reference:** §D.15

218. **Status:** EXCLUDED.

219. **Rationale:** Depends on `Ada.Real_Time` (excluded) and uses access-to-subprogram types for event handlers (excluded per Section 2 paragraph 13).

---

## A.25 The Package Ada.Execution_Time

220. **8652:2023 Reference:** §D.14

221. **Status:** EXCLUDED.

222. **Rationale:** Part of the Real-Time Systems annex (excluded per Section 2 paragraph 140).

---

## A.26 The Package Ada.Assertions

223. **8652:2023 Reference:** §11.4.2

224. **Status:** EXCLUDED.

225. **Rationale:** `Ada.Assertions` declares `Assertion_Error` (an exception) and `Assert` procedures. Exceptions are excluded (D14). Safe retains `pragma Assert` (Section 2 paragraph 106), which invokes the runtime abort handler on failure rather than raising an exception.

---

## B — Interface Packages

### B.1 The Package Interfaces

226. **8652:2023 Reference:** §B.2

227. **Status:** RETAINED.

228. The package `Interfaces` is retained. It provides the types `Integer_8`, `Integer_16`, `Integer_32`, `Integer_64`, `Unsigned_8`, `Unsigned_16`, `Unsigned_32`, `Unsigned_64`, and the shift/rotate functions for modular types.

229. **Note:** These types are essential for interfacing with C code (D4), hardware register manipulation, and binary protocol implementation. The shift and rotate functions (`Shift_Left`, `Shift_Right`, `Shift_Right_Arithmetic`, `Rotate_Left`, `Rotate_Right`) are retained as non-overloaded operations on the specific modular types.

### B.2 The Package Interfaces.C

230. **8652:2023 Reference:** §B.3

231. **Status:** RETAINED.

232. The package `Interfaces.C` is retained. It provides the types `int`, `short`, `long`, `unsigned`, `unsigned_short`, `unsigned_long`, `C_float`, `double`, `long_double`, `char`, `signed_char`, `unsigned_char`, `ptrdiff_t`, `size_t`, `wchar_t`, `char16_t`, `char32_t`, and the `char_array` and `wchar_array` array types.

233. **Note:** The string conversion functions (`To_C`, `To_Ada`, `Is_Nul_Terminated`) are retained for `char_array` to `String` conversions. These are essential for the C interface (D4).

### B.3 The Package Interfaces.C.Strings

234. **8652:2023 Reference:** §B.3.1

235. **Status:** EXCLUDED.

236. **Rationale:** The type `chars_ptr` is an access type representing a C `char *` pointer with semantics that are incompatible with SPARK 2022 ownership rules. C string pointers may alias, be shared, point into the middle of allocated blocks, or be freed by foreign code. These properties make `chars_ptr` fundamentally unsafe in Safe's ownership model. See Annex B, §B.3.1 for the detailed rationale and the recommended alternative using `Interfaces.C.char_array` with `To_C` and `To_Ada`.

237. A conforming implementation shall reject any `with Interfaces.C.Strings;` clause.

### B.4 The Package Interfaces.C.Pointers

239. **8652:2023 Reference:** §B.3.2

240. **Status:** EXCLUDED.

241. **Rationale:** `Interfaces.C.Pointers` is a generic package (D16) providing pointer arithmetic on C-style arrays.

### B.5 The Package Interfaces.Fortran

242. **8652:2023 Reference:** §B.5

243. **Status:** EXCLUDED.

244. **Rationale:** Fortran interface is outside the scope of Safe's C-focused foreign function interface (D4).

### B.6 The Package Interfaces.COBOL

245. **8652:2023 Reference:** §B.4

246. **Status:** EXCLUDED.

247. **Rationale:** COBOL interface is outside the scope of Safe's C-focused foreign function interface (D4).

---

## C — The Package System

248. **8652:2023 Reference:** §13.7

249. **Status:** RETAINED.

250. The package `System` is retained. The following declarations are available:
- `System.Name` — implementation-defined system name
- `System.Min_Int`, `System.Max_Int` — minimum and maximum integer values
- `System.Max_Binary_Modulus`, `System.Max_Nonbinary_Modulus` — maximum modular type moduli
- `System.Max_Base_Digits` — maximum floating point digits
- `System.Max_Mantissa` — maximum mantissa for fixed point
- `System.Fine_Delta` — finest delta for fixed point
- `System.Address` — the type representing machine addresses
- `System.Null_Address` — the null address value
- `System.Storage_Unit` — bits per storage element
- `System.Word_Size` — bits per word
- `System.Memory_Size` — available memory (implementation-defined)
- `System.Bit_Order` — default bit ordering
- `System.Default_Bit_Order` — default bit ordering value

251. **Note:** `System.Address` is essential for representation clauses and the C interface. The `Address` attribute on objects and subprograms is retained (see Section 2 attribute inventory).

### C.1 The Package System.Storage_Elements

252. **8652:2023 Reference:** §13.7.1

253. **Status:** RETAINED.

254. The package `System.Storage_Elements` is retained. It provides `Storage_Offset`, `Storage_Count`, `Storage_Element`, `Storage_Array`, address arithmetic (`+`, `-` on `Address` and `Storage_Offset`), and `To_Address`/`To_Integer` conversion functions.

255. **Note:** These types and operations are essential for memory layout control, C interface address arithmetic, and representation clause support.

### C.2 The Package System.Address_To_Access_Conversions

256. **8652:2023 Reference:** §13.7.2

257. **Status:** EXCLUDED.

258. **Rationale:** Generic package (D16) that converts between addresses and access values, bypassing the ownership model (D17). Deferred to the system sublanguage (D24).

### C.3 The Package System.Machine_Code

259. **8652:2023 Reference:** §13.8

260. **Status:** EXCLUDED.

261. **Rationale:** Machine code insertions are excluded (Section 2 paragraph 122). Deferred to the system sublanguage (D24).

### C.4 The Package System.Storage_Pools

262. **8652:2023 Reference:** §13.11

263. **Status:** EXCLUDED.

264. **Rationale:** User-defined storage pools are excluded (Section 2 paragraph 130). Tagged type `Root_Storage_Pool` is excluded (D18).

### C.5 The Package System.Storage_Pools.Subpools

265. **8652:2023 Reference:** §13.11.4

266. **Status:** EXCLUDED.

267. **Rationale:** Storage subpools are excluded (Section 2 paragraph 130). Depends on tagged types (D18) and generics (D16).

### C.6 The Package System.Multiprocessors

268. **8652:2023 Reference:** §D.16

269. **Status:** EXCLUDED.

270. **Rationale:** Part of the Real-Time Systems annex (excluded per Section 2 paragraph 140). Processor affinity control is outside the scope of Safe's static task model (D28).

### C.7 The Package System.Multiprocessors.Dispatching_Domains

271. **8652:2023 Reference:** §D.16.1

272. **Status:** EXCLUDED.

273. **Rationale:** Depends on `System.Multiprocessors` (excluded) and full Ada tasking (D15).

### C.8 The Package System.Atomic_Operations

274. **8652:2023 Reference:** §C.6.1 through §C.6.4 (Ada 2022)

275. **Status:** EXCLUDED.

276. **Rationale:** Atomic operations are deferred to the system sublanguage (D24). The Safe concurrency model uses channels (D28) for all inter-task communication; direct atomic access to shared variables would bypass this model.

---

## D — Remaining Annex A Library Units

### D.1 The Package Ada.Iterator_Interfaces

277. **8652:2023 Reference:** §5.5.1

278. **Status:** EXCLUDED.

279. **Rationale:** Defines tagged interface types (`Forward_Iterator`, `Reversible_Iterator`) for user-defined iteration (D18 — tagged types excluded). User-defined iterators are excluded (Section 2 paragraph 49).

### D.2 The Package Ada.Numerics.Generic_Real_Arrays and Ada.Numerics.Generic_Complex_Arrays

280. **8652:2023 Reference:** §G.3.1, §G.3.2

281. **Status:** EXCLUDED.

282. **Rationale:** Generic packages (D16). Part of Annex G (Numerics), a specialized-needs annex.

### D.3 The Package Ada.Wide_Characters.Handling

283. **8652:2023 Reference:** §A.3.5

284. **Status:** RETAINED.

285. The package `Ada.Wide_Characters.Handling` is retained. Classification and conversion functions for `Wide_Character` values are available.

### D.4 The Package Ada.Wide_Wide_Characters.Handling

286. **8652:2023 Reference:** §A.3.6

287. **Status:** RETAINED.

288. The package `Ada.Wide_Wide_Characters.Handling` is retained. Classification and conversion functions for `Wide_Wide_Character` values are available.

---

## Summary Table

289. The following table provides a consolidated view of all classified library units.

| Library Unit | 8652:2023 Reference | Status | Primary Exclusion Reason |
|---|---|---|---|
| `Standard` | §A.1 | RETAINED | — |
| `Ada` | §A.2 | RETAINED | — |
| `Ada.Assertions` | §11.4.2 | EXCLUDED | Exceptions (D14) |
| `Ada.Asynchronous_Task_Control` | §D.11 | EXCLUDED | Full tasking (D15) |
| `Ada.Calendar` | §9.6 | MODIFIED | Exceptions removed (D14) |
| `Ada.Calendar.Arithmetic` | §9.6.1 | EXCLUDED | Exceptions (D14) |
| `Ada.Calendar.Formatting` | §9.6.1 | EXCLUDED | Exceptions (D14) |
| `Ada.Calendar.Time_Zones` | §9.6.1 | EXCLUDED | Exceptions (D14) |
| `Ada.Characters` | §A.3.1 | RETAINED | — |
| `Ada.Characters.Conversions` | §A.3.4 | RETAINED | — |
| `Ada.Characters.Handling` | §A.3.2 | RETAINED | — |
| `Ada.Characters.Latin_1` | §A.3.3 | RETAINED | — |
| `Ada.Command_Line` | §A.15 | RETAINED | — |
| `Ada.Containers` (all) | §A.18 | EXCLUDED | Generics (D16), tagged types (D18) |
| `Ada.Direct_IO` | §A.8.4 | EXCLUDED | Generics (D16), exceptions (D14) |
| `Ada.Directories` | §A.16 | EXCLUDED | Exceptions (D14), controlled types |
| `Ada.Dispatching` | §D.2.1 | EXCLUDED | Full tasking (D15), tagged types (D18) |
| `Ada.Dynamic_Priorities` | §D.5.1 | EXCLUDED | Full tasking (D15) |
| `Ada.Environment_Variables` | §A.17 | EXCLUDED | Exceptions (D14), access-to-subprogram |
| `Ada.Exceptions` | §11.4.1 | EXCLUDED | Exceptions (D14) |
| `Ada.Execution_Time` | §D.14 | EXCLUDED | Real-time annex excluded |
| `Ada.Finalization` | §7.6 | EXCLUDED | Controlled types excluded |
| `Ada.Interrupts` | §C.3.2 | EXCLUDED | Interrupt handling excluded |
| `Ada.Interrupts.Names` | §C.3.2 | EXCLUDED | Interrupt handling excluded |
| `Ada.IO_Exceptions` | §A.13 | EXCLUDED | Exceptions (D14) |
| `Ada.Iterator_Interfaces` | §5.5.1 | EXCLUDED | Tagged types (D18) |
| `Ada.Locales` | §A.19 | EXCLUDED | String dependencies |
| `Ada.Numerics` | §A.5 | RETAINED | — |
| `Ada.Numerics.Big_Numbers` (all) | §A.5.5–A.5.7 | EXCLUDED | Controlled types, exceptions (D14) |
| `Ada.Numerics.Discrete_Random` | §A.5.2 | EXCLUDED | Generics (D16) |
| `Ada.Numerics.Elementary_Functions` | §A.5.1 | EXCLUDED | Defined as generic instantiation (D16) |
| `Ada.Numerics.Float_Random` | §A.5.2 | RETAINED | — |
| `Ada.Numerics.Generic_Complex_Elementary_Functions` | §G.1.2 | EXCLUDED | Generics (D16) |
| `Ada.Numerics.Generic_Complex_Types` | §G.1.1 | EXCLUDED | Generics (D16) |
| `Ada.Numerics.Generic_Elementary_Functions` | §A.5.1 | EXCLUDED | Generics (D16) |
| `Ada.Numerics.Generic_Real_Arrays` | §G.3.1 | EXCLUDED | Generics (D16) |
| `Ada.Real_Time` | §D.8 | EXCLUDED | Real-time annex excluded |
| `Ada.Real_Time.Timing_Events` | §D.15 | EXCLUDED | Real-time annex excluded |
| `Ada.Sequential_IO` | §A.8.1 | EXCLUDED | Generics (D16), exceptions (D14) |
| `Ada.Storage_IO` | §A.9 | EXCLUDED | Generics (D16), exceptions (D14) |
| `Ada.Stream_IO` | §A.12.1 | EXCLUDED | Streams excluded |
| `Ada.Streams` | §13.13.1 | EXCLUDED | Streams excluded, tagged types (D18) |
| `Ada.Strings` | §A.4.1 | MODIFIED | Exceptions removed (D14) |
| `Ada.Strings.Bounded` | §A.4.4 | EXCLUDED | Generics (D16) |
| `Ada.Strings.Fixed` | §A.4.3 | EXCLUDED | Exceptions (D14), overloading (D12) |
| `Ada.Strings.Hash` | §A.4.9 | EXCLUDED | Primary use with excluded containers |
| `Ada.Strings.Maps` | §A.4.2 | EXCLUDED | Controlled types, consumer packages excluded |
| `Ada.Strings.Maps.Constants` | §A.4.6 | EXCLUDED | Depends on `Ada.Strings.Maps` |
| `Ada.Strings.Text_Buffers` | §A.4.12 | EXCLUDED | Tagged types (D18) |
| `Ada.Strings.Unbounded` | §A.4.5 | EXCLUDED | Controlled types, exceptions (D14) |
| `Ada.Strings.UTF_Encoding` | §A.4.11 | EXCLUDED | Exceptions (D14) |
| `Ada.Strings.Wide_Bounded` | §A.4.9 | EXCLUDED | Generics (D16) |
| `Ada.Strings.Wide_Fixed` | §A.4.8 | EXCLUDED | Exceptions (D14), overloading (D12) |
| `Ada.Strings.Wide_Maps` | §A.4.7 | EXCLUDED | Same as `Ada.Strings.Maps` |
| `Ada.Strings.Wide_Unbounded` | §A.4.10 | EXCLUDED | Controlled types, exceptions (D14) |
| `Ada.Strings.Wide_Wide_Bounded` | §A.4.13 | EXCLUDED | Generics (D16) |
| `Ada.Strings.Wide_Wide_Fixed` | §A.4.12 | EXCLUDED | Exceptions (D14), overloading (D12) |
| `Ada.Strings.Wide_Wide_Maps` | §A.4.11 | EXCLUDED | Same as `Ada.Strings.Maps` |
| `Ada.Strings.Wide_Wide_Unbounded` | §A.4.14 | EXCLUDED | Controlled types, exceptions (D14) |
| `Ada.Synchronous_Barriers` | §D.10.1 | EXCLUDED | Full tasking (D15) |
| `Ada.Synchronous_Task_Control` | §D.10 | EXCLUDED | Channels replace (D28) |
| `Ada.Tags` | §3.9 | EXCLUDED | Tagged types (D18) |
| `Ada.Task_Attributes` | §C.7.2 | EXCLUDED | Generics (D16), full tasking (D15) |
| `Ada.Task_Identification` | §C.7.1 | EXCLUDED | Full tasking (D15) |
| `Ada.Task_Termination` | §C.7.3 | EXCLUDED | Full tasking (D15) |
| `Ada.Text_IO` | §A.10.1 | EXCLUDED | Exceptions (D14), generics (D16) |
| `Ada.Text_IO.Bounded_IO` | §A.10.11 | EXCLUDED | Depends on excluded packages |
| `Ada.Text_IO.Text_Streams` | §A.12.2 | EXCLUDED | Streams excluded |
| `Ada.Text_IO.Unbounded_IO` | §A.10.12 | EXCLUDED | Depends on excluded packages |
| `Ada.Unchecked_Conversion` | §13.9 | EXCLUDED | Generics (D16), type safety (D24) |
| `Ada.Unchecked_Deallocation` | §13.11.2 | EXCLUDED | Generics (D16), ownership model (D17) |
| `Ada.Wide_Characters.Handling` | §A.3.5 | RETAINED | — |
| `Ada.Wide_Text_IO` | §A.11 | EXCLUDED | Exceptions (D14), generics (D16) |
| `Ada.Wide_Wide_Characters.Handling` | §A.3.6 | RETAINED | — |
| `Ada.Wide_Wide_Text_IO` | §A.11 | EXCLUDED | Exceptions (D14), generics (D16) |
| `Interfaces` | §B.2 | RETAINED | — |
| `Interfaces.C` | §B.3 | RETAINED | — |
| `Interfaces.C.Pointers` | §B.3.2 | EXCLUDED | Generics (D16) |
| `Interfaces.C.Strings` | §B.3.1 | EXCLUDED | `chars_ptr` incompatible with ownership (D17) |
| `Interfaces.COBOL` | §B.4 | EXCLUDED | Outside C-focused FFI scope (D4) |
| `Interfaces.Fortran` | §B.5 | EXCLUDED | Outside C-focused FFI scope (D4) |
| `System` | §13.7 | RETAINED | — |
| `System.Address_To_Access_Conversions` | §13.7.2 | EXCLUDED | Generics (D16), bypasses ownership (D17) |
| `System.Atomic_Operations` | §C.6.1–C.6.4 | EXCLUDED | System sublanguage (D24) |
| `System.Machine_Code` | §13.8 | EXCLUDED | System sublanguage (D24) |
| `System.Multiprocessors` | §D.16 | EXCLUDED | Real-time annex excluded |
| `System.Multiprocessors.Dispatching_Domains` | §D.16.1 | EXCLUDED | Real-time annex excluded |
| `System.Storage_Elements` | §13.7.1 | RETAINED | — |
| `System.Storage_Pools` | §13.11 | EXCLUDED | Tagged types (D18), storage pools excluded |
| `System.Storage_Pools.Subpools` | §13.11.4 | EXCLUDED | Tagged types (D18), generics (D16) |

---

## Implementation Advice

290. Implementations should provide an implementation-defined text I/O library as a companion to the retained predefined library. This library should provide basic text input and output operations (put, get, put line, new line, open, close) with error reporting via discriminated records rather than exceptions. See Annex C of this document for detailed implementation advice.

291. Implementations may provide additional non-standard library packages (e.g., `Safe.Text_IO`, `Safe.File_IO`) as implementation extensions, provided they conform to Safe's restrictions: no exceptions, no generics, no tagged types, no controlled types, error reporting via return values or discriminated records.
