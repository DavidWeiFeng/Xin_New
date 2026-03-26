package com.robot.core.event
{
   import flash.events.Event;
   
   public class NonoActionEvent extends Event
   {
      
      public static const COLOR_CHANGE:String = "colorChange";
      
      public static const NAME_CHANGE:String = "nameChange";
      
      public static const CLOSE_OPEN:String = "closeOpen";
      
      public static const CHARGEING:String = "chargeing";
      
      public static const NONO_PLAY:String = "nonoPlay";
      
      private var _actionType:String;
      
      private var _data:Object;
      
      public function NonoActionEvent(_arg_1:String, _arg_2:String, _arg_3:Object)
      {
         super(_arg_1);
         this._actionType = _arg_2;
         this._data = _arg_3;
      }
      
      public function get actionType() : String
      {
         return this._actionType;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

