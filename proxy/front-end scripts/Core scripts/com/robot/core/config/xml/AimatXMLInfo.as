package com.robot.core.config.xml
{
   import com.robot.core.manager.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class AimatXMLInfo
   {
      
      private static var _dataList:Array;
      
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = AimatXMLInfo_xmlClass;
      
      setup();
      
      public function AimatXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         var _local_2:uint = 0;
         var _local_3:uint = 0;
         var _local_4:Array = null;
         var _local_5:uint = 0;
         var _local_6:Array = null;
         var _local_7:String = null;
         _dataList = [];
         _dataMap = new HashMap();
         var _local_8:XMLList = XML(new xmlClass()).elements("item");
         for each(_local_1 in _local_8)
         {
            _local_2 = uint(_local_1.@id);
            _local_3 = uint(_local_1.@tranID);
            _local_4 = String(_local_1.@cloth).split(",");
            _local_5 = uint(_local_1.@type);
            _local_6 = [];
            for each(_local_7 in _local_4)
            {
               _local_6.push(uint(_local_7));
            }
            _dataList.push({
               "id":_local_2,
               "cloth":_local_6,
               "tranID":_local_3,
               "type":_local_5
            });
            _dataMap.add(_local_2,_local_1);
         }
      }
      
      public static function getType(_arg_1:Array) : uint
      {
         var _local_2:Object = null;
         var _local_3:Array = null;
         for each(_local_2 in _dataList)
         {
            _local_3 = _local_2.cloth;
            if(ArrayUtil.embody(_arg_1,_local_3))
            {
               if(Boolean(MainManager.actorModel))
               {
                  if(MainManager.actorModel.isTransform && _local_2.tranID != 0)
                  {
                     return _local_2.tranID;
                  }
                  return _local_2.id;
               }
               return _local_2.id;
            }
         }
         return _dataList[0].id;
      }
      
      public static function getTypeId(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return uint(_local_2.@type);
         }
         return 0;
      }
      
      public static function getSoundStart(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Number(_local_2.@soundStart);
         }
         return 0;
      }
      
      public static function getIsStage(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return uint(_local_2.@isState);
         }
         return 0;
      }
      
      public static function getSoundEnd(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Number(_local_2.@soundEnd);
         }
         return 0;
      }
      
      public static function getSpeed(_arg_1:uint) : Number
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Number(_local_2.@speed);
         }
         return 0;
      }
      
      public static function getCloths(_arg_1:uint) : Array
      {
         var _local_2:Object = null;
         for each(_local_2 in _dataList)
         {
            if(_local_2.id == _arg_1)
            {
               return _local_2.cloth;
            }
         }
         return [];
      }
   }
}

