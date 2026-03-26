package com.robot.app.taskPanel
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.config.xml.*;
   
   public class TaskConditionManager
   {
      
      public static const NPC_CLICK:uint = 0;
      
      public static const BEFOR_ACCEPT:uint = 1;
      
      public function TaskConditionManager()
      {
         super();
      }
      
      public static function getConditionStep(_arg_1:uint) : uint
      {
         return TaskConditionXMLInfo.getConditionStep(_arg_1);
      }
      
      public static function conditionTask(_arg_1:uint, _arg_2:String) : Boolean
      {
         var _local_3:TaskConditionListInfo = null;
         if(!TasksXMLInfo.getIsCondition(_arg_1))
         {
            return true;
         }
         var _local_4:Array = TaskConditionXMLInfo.getConditionList(_arg_1);
         for each(_local_3 in _local_4)
         {
            if(!_local_3.getClass()[_local_3.fun]())
            {
               NpcTipDialog.show(_local_3.error,null,_arg_2);
               return false;
            }
         }
         return true;
      }
   }
}

