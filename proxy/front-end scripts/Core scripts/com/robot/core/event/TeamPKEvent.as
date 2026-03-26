package com.robot.core.event
{
   import flash.events.Event;
   
   public class TeamPKEvent extends Event
   {
      
      public static const GET_BUILDING_LIST:String = "getBuildingList";
      
      public static const OPEN_TOOL:String = "openTool";
      
      public static const CLOSE_TOOL:String = "closeTool";
      
      public static const OPEN_DOOR:String = "openDoor";
      
      public static const COUNT_TIME:String = "countTime";
      
      public function TeamPKEvent(_arg_1:String, _arg_2:Boolean = false, _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
   }
}

