--  Verified Emission Template: Discriminant-Check Safety on Result Records
--  See template_discriminant_result.ads for clause references.

pragma SPARK_Mode (On);

with Safe_PO; use Safe_PO;

package body Template_Discriminant_Result
  with SPARK_Mode => On
is

   -------------------------------------------------------------------
   --  Pattern 1: Guarded access via conditional branch
   --
   --  Emission pattern:
   --    1. Branch on R.OK
   --    2. Within True branch: Check_Discriminant(R.OK, True)
   --    3. Access R.Value
   --    4. Within False branch: Check_Discriminant(R.OK, False)
   --    5. Access R.Error_Code
   -------------------------------------------------------------------
   function Get_Value_Or_Default
     (R       : Result_Model;
      Default : Integer) return Integer
   is
   begin
      if R.OK then
         --  PO hook: discriminant is established as True in this branch.
         Check_Discriminant (R.OK, True);

         --  Legal: R.OK = True is proved, so R.Value is accessible.
         return R.Value;
      else
         --  PO hook: discriminant is established as False in this branch.
         Check_Discriminant (R.OK, False);

         --  Legal: R.OK = False is proved, so R.Error_Code is accessible.
         --  Return default rather than error code for this pattern.
         return Default;
      end if;
   end Get_Value_Or_Default;

   -------------------------------------------------------------------
   --  Pattern 2: Caller-established precondition
   --
   --  The precondition Pre => R.OK guarantees the discriminant.
   --  GNATprove proves Check_Discriminant from the precondition.
   -------------------------------------------------------------------
   function Unwrap_Value (R : Result_Model) return Integer is
   begin
      --  PO hook: discriminant check — proved from precondition.
      Check_Discriminant (R.OK, True);

      return R.Value;
   end Unwrap_Value;

   -------------------------------------------------------------------
   --  Pattern 3: Mutation invalidation and re-guard
   --
   --  Emission pattern:
   --    1. R is reassigned (discriminant fact invalidated)
   --    2. New guard re-establishes the discriminant
   --    3. Variant field access is legal after re-guard
   --
   --  This demonstrates §2.12 ¶148: "The established discriminant
   --  fact is invalidated by assignment to the discriminated object."
   -------------------------------------------------------------------
   procedure Replace_And_Read
     (R       : in out Result_Model;
      New_R   : Result_Model;
      Output  : out Integer)
   is
   begin
      --  Assignment invalidates any prior discriminant fact on R.
      R := New_R;

      --  Must re-guard before accessing variant fields.
      if R.OK then
         --  PO hook: re-established after mutation.
         Check_Discriminant (R.OK, True);
         Output := R.Value;
      else
         Check_Discriminant (R.OK, False);
         Output := R.Error_Code;
      end if;
   end Replace_And_Read;

end Template_Discriminant_Result;
