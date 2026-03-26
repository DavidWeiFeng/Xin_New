package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   
   public class TaskConditionXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = TaskConditionXMLInfo_xmlClass;
      
      setup();
      
      public function TaskConditionXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         var _local_2:uint = 0;
         _dataMap = new HashMap();
         var _local_3:XMLList = XML(new xmlClass()).elements("task");
         for each(_local_1 in _local_3)
         {
            _local_2 = uint(_local_1.@id);
            _dataMap.add(_local_2,_local_1);
         }
      }
      
      public static function getConditionStep(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return _local_2.@step;
      }
      
      public static function getConditionList(_arg_1:uint) : Array
      {
         var _local_2:XML = null;
         var _local_3:Array = [];
         var _local_4:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_4))
         {
            for each(_local_2 in _local_4.condition)
            {
               _local_3.push(new TaskConditionListInfo(_local_2));
            }
         }
         return _local_3;
      }
   }
}

