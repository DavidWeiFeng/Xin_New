package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class SuitXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var map:HashMap;
      
      private static var xmlClass:Class = SuitXMLInfo_xmlClass;
      
      setup();
      
      public function SuitXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         var array:Array = null;
         _dataMap = new HashMap();
         map = new HashMap();
         var xl:XMLList = XML(new xmlClass()).elements("item");
         for each(item in xl)
         {
            _dataMap.add(uint(item.@id),item);
            array = String(item.@cloths).split(" ");
            array.forEach(function(_arg_1:String, _arg_2:int, _arg_3:Array):void
            {
               _arg_3[_arg_2] = uint(_arg_1);
            });
            array.sort(Array.NUMERIC);
            map.add(array.join(","),item);
         }
      }
      
      public static function getSuitID(clothIDs:Array) : uint
      {
         var str:String = null;
         var xml:XML = null;
         var array:Array = clothIDs.slice();
         array = array.filter(function(_arg_1:uint, _arg_2:int, _arg_3:Array):Boolean
         {
            if(ItemXMLInfo.getType(_arg_1) == "bg")
            {
               return false;
            }
            return true;
         });
         array.forEach(function(_arg_1:String, _arg_2:int, _arg_3:Array):void
         {
            _arg_3[_arg_2] = uint(_arg_1);
         });
         array.sort(Array.NUMERIC);
         str = array.join(",");
         xml = map.getValue(str);
         if(Boolean(xml))
         {
            return xml.@id;
         }
         return 0;
      }
      
      public static function getIsTransform(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return uint(_local_2.@transform) == 1;
         }
         return false;
      }
      
      public static function getCloths(_arg_1:uint) : Array
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return String(_local_2.@cloths).split(" ");
         }
         return null;
      }
      
      public static function getSuitTranSpeed(_arg_1:uint) : Number
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Number(_local_2.@tranSpeed);
         }
         return 4;
      }
      
      public static function getName(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return String(_local_2.@name);
         }
         return "";
      }
      
      public static function getClothsForItem(_arg_1:uint) : Array
      {
         var _local_2:XML = null;
         var _local_3:Array = null;
         var _local_4:Array = _dataMap.getValues();
         for each(_local_2 in _local_4)
         {
            _local_3 = String(_local_2.@cloths).split(" ");
            if(_local_3.indexOf(_arg_1.toString()) != -1)
            {
               return _local_3;
            }
         }
         return null;
      }
      
      public static function getIDForItem(_arg_1:uint) : uint
      {
         var _local_2:XML = null;
         var _local_3:Array = null;
         var _local_4:Array = _dataMap.getValues();
         for each(_local_2 in _local_4)
         {
            _local_3 = String(_local_2.@cloths).split(" ");
            if(_local_3.indexOf(_arg_1) != -1)
            {
               return uint(_local_2.@id);
            }
         }
         return 0;
      }
      
      public static function getIsEliteItems(_arg_1:Array) : Array
      {
         var _local_2:XML = null;
         var _local_3:Array = null;
         var _local_4:uint = 0;
         var _local_5:Array = [];
         var _local_6:Array = _dataMap.getValues();
         for each(_local_2 in _local_6)
         {
            _local_3 = String(_local_2.@cloths).split(" ");
            for each(_local_4 in _arg_1)
            {
               if(ArrayUtil.arrayContainsValue(_local_3,_local_4.toString()))
               {
                  if(getIsElite(_local_2.@id))
                  {
                     _local_5.push(uint(_local_2.@id));
                     break;
                  }
               }
            }
         }
         return _local_5;
      }
      
      public static function getIDsForItems(_arg_1:Array) : Array
      {
         var _local_2:XML = null;
         var _local_3:Array = null;
         var _local_4:uint = 0;
         var _local_5:Array = [];
         var _local_6:Array = _dataMap.getValues();
         for each(_local_2 in _local_6)
         {
            _local_3 = String(_local_2.@cloths).split(" ");
            for each(_local_4 in _arg_1)
            {
               if(ArrayUtil.arrayContainsValue(_local_3,_local_4.toString()))
               {
                  _local_5.push(uint(_local_2.@id));
                  break;
               }
            }
         }
         return _local_5;
      }
      
      private static function getIsElite(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return Boolean(uint(_local_2.@elite));
      }
      
      public static function getIsVip(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return Boolean(uint(_local_2.@VipOnly));
      }
   }
}

