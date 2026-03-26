package com.robot.core.info.item
{
   import flash.utils.*;
   
   public class ClothInfo
   {
      
      private static var dict:Dictionary;
      
      public static const DEFAULT_HEAD:uint = 100001;
      
      public static const DEFAULT_WAIST:uint = 100002;
      
      public static const DEFAULT_FOOT:uint = 100003;
      
      public function ClothInfo()
      {
         super();
      }
      
      public static function parseInfo(_arg_1:XML) : void
      {
         var _local_2:XML = null;
         dict = new Dictionary(true);
         var _local_3:XMLList = _arg_1.descendants("Item");
         for each(_local_2 in _local_3)
         {
            dict["item_" + _local_2.@ID.toString()] = _local_2;
         }
      }
      
      public static function getItemInfo(_arg_1:int) : ClothData
      {
         if(!dict["item_" + _arg_1.toString()])
         {
            throw new Error("没有找到对应的物品ID：" + _arg_1);
         }
         return new ClothData(dict["item_" + _arg_1.toString()]);
      }
   }
}

