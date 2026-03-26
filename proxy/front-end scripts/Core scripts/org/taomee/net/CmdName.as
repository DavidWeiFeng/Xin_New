package org.taomee.net
{
   import org.taomee.ds.HashMap;
   
   public class CmdName
   {
      
      private static var _list:HashMap = new HashMap();
      
      public function CmdName()
      {
         super();
      }
      
      public static function getName(_arg_1:uint) : String
      {
         var _local_2:String = _list.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return _local_2;
         }
         return "---";
      }
      
      public static function addName(_arg_1:uint, _arg_2:String) : void
      {
         _list.add(_arg_1,_arg_2);
      }
   }
}

