package org.taomee.utils
{
   import flash.utils.Dictionary;
   
   public class DictionaryUtil
   {
      
      public function DictionaryUtil()
      {
         super();
      }
      
      public static function getValues(_arg_1:Dictionary) : Array
      {
         var _local_2:Object = null;
         var _local_3:Array = new Array();
         for each(_local_2 in _arg_1)
         {
            _local_3.push(_local_2);
         }
         return _local_3;
      }
      
      public static function getKeys(_arg_1:Dictionary) : Array
      {
         var _local_2:Object = null;
         var _local_3:Array = new Array();
         for(_local_2 in _arg_1)
         {
            _local_3.push(_local_2);
         }
         return _local_3;
      }
   }
}

