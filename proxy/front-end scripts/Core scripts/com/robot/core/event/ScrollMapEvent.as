package com.robot.core.event
{
   import flash.events.Event;
   
   public class ScrollMapEvent extends Event
   {
      
      public static const SCROLL_COMPLETE:String = "scrollComplete";
      
      public function ScrollMapEvent(_arg_1:String, _arg_2:Boolean = false, _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
   }
}

