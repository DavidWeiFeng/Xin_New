package com.robot.core.event
{
   import com.robot.core.info.AimatInfo;
   import flash.events.Event;
   
   public class AimatEvent extends Event
   {
      
      public static const OPEN:String = "open";
      
      public static const CLOSE:String = "close";
      
      public static const PLAY_START:String = "playStart";
      
      public static const PLAY_END:String = "playEnd";
      
      private var _info:AimatInfo;
      
      public function AimatEvent(_arg_1:String, _arg_2:AimatInfo)
      {
         super(_arg_1);
         this._info = _arg_2;
      }
      
      public function get info() : AimatInfo
      {
         return this._info;
      }
   }
}

