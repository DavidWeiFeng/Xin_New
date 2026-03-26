package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   
   public class TimePasswordXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var _xml:XML;
      
      private static var xmlClass:Class = TimePasswordXMLInfo_xmlClass;
      
      setup();
      
      public function TimePasswordXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         _dataMap = new HashMap();
         _xml = XML(new xmlClass());
         var _local_2:XMLList = _xml.elements("item");
         for each(_local_1 in _local_2)
         {
            _dataMap.add(_local_1.@id.toString(),_local_1);
         }
      }
      
      public static function getIDList() : Array
      {
         return _dataMap.getKeys();
      }
   }
}

