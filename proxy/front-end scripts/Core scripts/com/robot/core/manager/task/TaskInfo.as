package com.robot.core.manager.task
{
   public class TaskInfo
   {
      
      public var id:uint;
      
      public var pro:uint;
      
      public var callback:Function;
      
      public var outType:uint;
      
      public var status:Boolean;
      
      public var isComplete:Boolean;
      
      public var type:uint;
      
      public function TaskInfo(_arg_1:uint, _arg_2:uint, _arg_3:Function)
      {
         super();
         this.id = _arg_1;
         this.pro = _arg_2;
         this.callback = _arg_3;
      }
   }
}

