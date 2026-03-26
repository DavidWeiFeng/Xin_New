package com.robot.core.event
{
   import flash.events.Event;
   
   public class TeamEvent extends Event
   {
      
      public static const MODIFY_LOGO:String = "modifyLogo";
      
      public function TeamEvent(_arg_1:String, _arg_2:Boolean = false, _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
   }
}

