package com.robot.core.event
{
   import flash.events.Event;
   
   public class GamePlatformEvent extends Event
   {
      
      public static const GAME_WIN:String = "gameWin";
      
      public static const GAME_LOST:String = "gameLost";
      
      public function GamePlatformEvent(_arg_1:String, _arg_2:Boolean = false, _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
   }
}

