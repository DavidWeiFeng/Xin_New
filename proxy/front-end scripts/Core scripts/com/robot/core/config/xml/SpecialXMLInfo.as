package com.robot.core.config.xml
{
   import flash.utils.*;
   import org.taomee.utils.*;
   
   public class SpecialXMLInfo
   {
      
      private static var array:Array;
      
      private static var dict:Dictionary;
      
      private static var xmlClass:Class = SpecialXMLInfo_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      setup();
      
      public function SpecialXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         var _local_2:uint = 0;
         var _local_3:Array = null;
         array = [];
         dict = new Dictionary();
         var _local_4:XMLList = xml.elements("item");
         for each(_local_1 in _local_4)
         {
            _local_2 = uint(_local_1.@id);
            _local_3 = String(_local_1.@cloths).split(",");
            array.push(_local_3);
            dict[_local_3] = _local_2;
         }
      }
      
      public static function getSpecialID(_arg_1:Array) : uint
      {
         var _local_2:Array = null;
         var _local_3:uint = 0;
         for each(_local_2 in array)
         {
            if(ArrayUtil.arraysAreEqual(_arg_1,_local_2))
            {
               return uint(dict[_local_2]);
            }
         }
         return _local_3;
      }
   }
}

