package com.robot.app.task.taskProStep
{
   public class TaskStepInfo
   {
      
      public var taskID:uint;
      
      public var pro:uint;
      
      public var stepID:uint = 0;
      
      public var mapID:uint = 0;
      
      public var stepType:uint = 0;
      
      public var goto1:Array = [];
      
      public var isComplete:Boolean = false;
      
      public function TaskStepInfo(_arg_1:uint, _arg_2:uint, _arg_3:uint, _arg_4:XML = null)
      {
         super();
         this.taskID = _arg_1;
         this.pro = _arg_2;
         this.mapID = _arg_3;
         if(Boolean(_arg_4))
         {
            this.stepID = _arg_4.@id;
            this.stepType = _arg_4.@type;
            this.goto1 = String(_arg_4["@goto"]).split("_");
         }
      }
   }
}

