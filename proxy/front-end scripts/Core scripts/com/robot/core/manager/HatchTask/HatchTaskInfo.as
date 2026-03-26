package com.robot.core.manager.HatchTask
{
   public class HatchTaskInfo
   {
      
      public var outType:uint;
      
      public var isComplete:Boolean = false;
      
      public var type:uint;
      
      public var obtainTime:uint;
      
      public var statusList:Array;
      
      public var itemID:uint;
      
      public var callback:Function;
      
      public function HatchTaskInfo(_arg_1:uint, _arg_2:uint, _arg_3:Array, _arg_4:Function = null)
      {
         super();
         this.obtainTime = _arg_1;
         this.itemID = _arg_2;
         this.statusList = _arg_3;
         this.callback = _arg_4;
      }
   }
}

