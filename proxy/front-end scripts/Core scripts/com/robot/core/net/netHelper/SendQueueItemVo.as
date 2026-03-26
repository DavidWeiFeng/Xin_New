package com.robot.core.net.netHelper
{
   public class SendQueueItemVo
   {
      
      public var cmdID:int;
      
      public var args:Array;
      
      public var callBackFun:Function;
      
      public var errorHandleFun:Function;
      
      public function SendQueueItemVo()
      {
         super();
      }
   }
}

