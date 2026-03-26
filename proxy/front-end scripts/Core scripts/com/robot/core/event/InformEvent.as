package com.robot.core.event
{
   import com.robot.core.info.InformInfo;
   import flash.events.Event;
   
   public class InformEvent extends Event
   {
      
      public static const INFORM:String = "inform";
      
      private var _info:InformInfo;
      
      public function InformEvent(_arg_1:String, _arg_2:InformInfo)
      {
         super(_arg_1,false,false);
         this._info = _arg_2;
      }
      
      public function get info() : InformInfo
      {
         return this._info;
      }
   }
}

