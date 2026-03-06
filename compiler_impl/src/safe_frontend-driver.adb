with Ada.Characters.Handling;
with Ada.Directories;
with Ada.Strings.Fixed;
with Ada.Text_IO;
with Safe_Frontend.Ast;
with Safe_Frontend.Diagnostics;
with Safe_Frontend.Lexer;
with Safe_Frontend.Mir;
with Safe_Frontend.Parser;
with Safe_Frontend.Semantics;
with Safe_Frontend.Source;

package body Safe_Frontend.Driver is
   package FD renames Safe_Frontend.Diagnostics;
   package FL renames Safe_Frontend.Lexer;
   package FM renames Safe_Frontend.Mir;
   package FP renames Safe_Frontend.Parser;
   package FS renames Safe_Frontend.Source;
   type Pipeline_Result is record
      Ast         : Safe_Frontend.Ast.Compilation_Unit;
      Typed       : Safe_Frontend.Semantics.Typed_Unit;
      Mir_Unit    : FM.Unit;
      Diagnostics : FD.Diagnostic_Vectors.Vector;
      Success     : Boolean := False;
   end record;

   function Source_Stem (Path : String) return String is
      Simple : constant String := Ada.Directories.Simple_Name (Path);
      Dot    : constant Natural := Ada.Strings.Fixed.Index (Simple, ".", Ada.Strings.Backward);
   begin
      if Dot = 0 then
         return Ada.Characters.Handling.To_Lower (Simple);
      end if;
      return
        Ada.Characters.Handling.To_Lower
          (Simple (Simple'First .. Dot - 1));
   end Source_Stem;

   procedure Write_File (Path : String; Contents : String) is
      File : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Create (File => File, Mode => Ada.Text_IO.Out_File, Name => Path);
      Ada.Text_IO.Put (File, Contents);
      Ada.Text_IO.Close (File);
   end Write_File;

   function Run_Pipeline (Path : String; Include_Semantics : Boolean := True) return Pipeline_Result is
      Input       : constant FS.Source_File := FS.Load (Path);
      Diagnostics : FD.Diagnostic_Vectors.Vector;
      Tokens      : FL.Token_Vectors.Vector := FL.Lex (Input, Diagnostics);
      Result      : Pipeline_Result;
   begin
      Result.Diagnostics := Diagnostics;
      if FD.Has_Errors (Result.Diagnostics) then
         return Result;
      end if;
      Result.Ast := FP.Parse (Input, Tokens, Result.Diagnostics);
      if FD.Has_Errors (Result.Diagnostics) or else not Include_Semantics then
         Result.Success := not FD.Has_Errors (Result.Diagnostics);
         return Result;
      end if;
      Result.Typed :=
        Safe_Frontend.Semantics.Analyze
          (Result.Ast, Tokens, Result.Diagnostics);
      if FD.Has_Errors (Result.Diagnostics) then
         return Result;
      end if;
      Result.Mir_Unit := FM.Lower (Result.Typed);
      Result.Success := True;
      return Result;
   end Run_Pipeline;

   function Run_Ast (Path : String) return Integer is
      Result : constant Pipeline_Result := Run_Pipeline (Path, Include_Semantics => False);
   begin
      if not Result.Success then
         FD.Print (Result.Diagnostics);
         return Safe_Frontend.Exit_Diagnostics;
      end if;
      Ada.Text_IO.Put
        (Safe_Frontend.Ast.To_Json (Result.Ast));
      return Safe_Frontend.Exit_Success;
   end Run_Ast;

   function Run_Check (Path : String) return Integer is
      Result : constant Pipeline_Result := Run_Pipeline (Path);
   begin
      if not Result.Success then
         FD.Print (Result.Diagnostics);
         return Safe_Frontend.Exit_Diagnostics;
      end if;
      return Safe_Frontend.Exit_Success;
   end Run_Check;

   function Run_Emit
     (Path          : String;
      Out_Dir       : String;
      Interface_Dir : String) return Integer
   is
      Result : constant Pipeline_Result := Run_Pipeline (Path);
      Stem   : constant String := Source_Stem (Path);
   begin
      if not Result.Success then
         FD.Print (Result.Diagnostics);
         return Safe_Frontend.Exit_Diagnostics;
      end if;

      Ada.Directories.Create_Path (Out_Dir);
      Ada.Directories.Create_Path (Interface_Dir);

      Write_File
        (Out_Dir & "/" & Stem & ".ast.json",
         Safe_Frontend.Ast.To_Json (Result.Ast));
      Write_File
        (Out_Dir & "/" & Stem & ".typed.json",
         Safe_Frontend.Semantics.To_Json (Result.Typed));
      Write_File (Out_Dir & "/" & Stem & ".mir.json", FM.To_Json (Result.Mir_Unit));
      Write_File
        (Interface_Dir & "/" & Stem & ".safei.json",
         Safe_Frontend.Semantics.Interface_Json (Result.Typed));
      return Safe_Frontend.Exit_Success;
   end Run_Emit;
end Safe_Frontend.Driver;
