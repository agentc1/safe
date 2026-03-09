with Safe_Frontend.Mir_Model;

package Safe_Frontend.Mir_Write is
   function To_Json
     (Document : Safe_Frontend.Mir_Model.Mir_Document) return String;
end Safe_Frontend.Mir_Write;
