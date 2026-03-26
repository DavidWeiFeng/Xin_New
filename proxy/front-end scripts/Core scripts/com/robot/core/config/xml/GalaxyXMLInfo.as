package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   
   public class GalaxyXMLInfo
   {
      
      private static var _hashMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _xmllist:XMLList;
      
      private static var xmlClass:Class = GalaxyXMLInfo_xmlClass;
      
      setup();
      
      public function GalaxyXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         _hashMap = new HashMap();
         _xml = XML(new xmlClass());
         _xmllist = _xml.elements("galaxy");
         for each(_local_1 in _xmllist)
         {
            _hashMap.add(uint(_local_1.@id),_local_1);
         }
      }
      
      public static function getName(_arg_1:uint) : String
      {
         var _local_2:XML = _hashMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return _local_2.@name;
         }
         return "";
      }
   }
}

