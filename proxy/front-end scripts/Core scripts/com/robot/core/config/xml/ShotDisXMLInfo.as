package com.robot.core.config.xml
{
   import com.robot.core.info.item.*;
   import com.robot.core.skeleton.*;
   import org.taomee.ds.*;
   
   public class ShotDisXMLInfo
   {
      
      private static var xmllist:XMLList;
      
      private static var _map:HashMap;
      
      private static var DEFAULT:uint;
      
      private static var xmlClass:Class = ShotDisXMLInfo_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      setup();
      
      public function ShotDisXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         DEFAULT = uint(xml.@defaultDis);
         _map = new HashMap();
         var _local_2:XMLList = xml.elements("item");
         for each(_local_1 in _local_2)
         {
            _map.add(_local_1.@id.toString(),_local_1);
         }
      }
      
      public static function getDistance(_arg_1:uint) : uint
      {
         var _local_2:XML = _map.getValue(_arg_1.toString());
         if(Boolean(_local_2))
         {
            return uint(_local_2.@dis);
         }
         return DEFAULT;
      }
      
      public static function getClothDistance(_arg_1:Array) : uint
      {
         var _local_2:uint = 0;
         for each(_local_2 in _arg_1)
         {
            if(ClothInfo.getItemInfo(_local_2).type == ClothPreview.FLAG_HEAD)
            {
               break;
            }
         }
         return ItemXMLInfo.getShotDis(_local_2);
      }
   }
}

