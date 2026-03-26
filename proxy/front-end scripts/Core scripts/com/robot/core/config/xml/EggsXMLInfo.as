package com.robot.core.config.xml
{
   import com.robot.core.config.ClientConfig;
   import org.taomee.ds.HashMap;
   
   public class EggsXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var xl:XMLList;
      
      public function EggsXMLInfo()
      {
         super();
      }
      
      public static function getIDList() : Array
      {
         return _dataMap.getKeys();
      }
      
      public static function getSpouseIDByMale(param1:uint) : uint
      {
         var _loc2_:XML = null;
         var _loc3_:Array = _dataMap.getValues();
         for each(_loc2_ in _loc3_)
         {
            if(uint(_loc2_.@MaleMon) == param1)
            {
               return uint(_loc2_.@FemaleMon);
            }
         }
         return 0;
      }
      
      public static function getSpouseIDByFeMale(param1:uint) : uint
      {
         var _loc2_:XML = null;
         var _loc3_:Array = _dataMap.getValues();
         for each(_loc2_ in _loc3_)
         {
            if(uint(_loc2_.@FemaleMon) == param1)
            {
               return uint(_loc2_.@MaleMon);
            }
         }
         return 0;
      }
      
      public static function getEggIconURL(param1:uint) : String
      {
         return ClientConfig.getResPath("egg/icon/" + param1 + ".swf");
      }
      
      public static function getEggEffectURL(param1:uint) : String
      {
         return ClientConfig.getResPath("egg/effect/" + param1 + ".swf");
      }
   }
}

