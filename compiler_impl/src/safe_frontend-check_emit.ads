with Safe_Frontend.Check_Model;

package Safe_Frontend.Check_Emit is
   package CM renames Safe_Frontend.Check_Model;

   function Ast_Json
     (Parsed   : CM.Parsed_Unit;
      Resolved : CM.Resolved_Unit) return String;

   function Typed_Json
     (Parsed   : CM.Parsed_Unit;
      Resolved : CM.Resolved_Unit) return String;

   function Interface_Json
     (Parsed   : CM.Parsed_Unit;
      Resolved : CM.Resolved_Unit) return String;
end Safe_Frontend.Check_Emit;
