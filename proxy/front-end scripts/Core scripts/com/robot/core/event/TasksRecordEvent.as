package com.robot.core.event
{
   import flash.events.Event;
   
   public class TasksRecordEvent extends Event
   {
      
      public static const SHOW_TASKSRECORDLISTPANEL:String = "showTasksRecordListPanel";
      
      public static const SHOW_TASKINTRODUCTION:String = "showTaskIntroductionPanel";
      
      public static const HIDE_TASKLISTPANEL:String = "hideTaskListPanel";
      
      private var _type:String;
      
      private var _data:Object;
      
      public function TasksRecordEvent(_arg_1:String, _arg_2:Object = null)
      {
         super(_arg_1);
         this._type = _arg_1;
         this._data = _arg_2;
      }
      
      public function get parameterObj() : Object
      {
         return this._data;
      }
   }
}

