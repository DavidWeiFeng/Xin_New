package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   
   public class MovesLangXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = MovesLangXMLInfo_xmlClass;
      
      setup();
      
      public function MovesLangXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         _dataMap = new HashMap();
         var _local_2:XMLList = XML(new xmlClass()).elements("moves");
         for each(_local_1 in _local_2)
         {
            _dataMap.add(uint(_local_1.@id),_local_1.elements("lang"));
         }
      }
      
      public static function getRandomLang(_arg_1:uint) : String
      {
         var _local_2:XML = null;
         var _local_3:XMLList = _dataMap.getValue(_arg_1);
         if(Boolean(_local_3))
         {
            _local_2 = _local_3[int(_local_3.length() * Math.random())];
            return _local_2.toString();
         }
         return "";
      }
   }
}

