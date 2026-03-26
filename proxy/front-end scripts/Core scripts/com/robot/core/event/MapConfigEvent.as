package com.robot.core.event
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class MapConfigEvent extends Event
   {
      
      public static const HIT_MAP_COMPONENT:String = "hitMapComponent";
      
      private var _hitMC:Sprite;
      
      public function MapConfigEvent(_arg_1:String, _arg_2:Sprite, _arg_3:Boolean = false, _arg_4:Boolean = false)
      {
         super(_arg_1,_arg_3,_arg_4);
         this._hitMC = _arg_2;
      }
      
      public function get hitMC() : Sprite
      {
         return this._hitMC;
      }
   }
}

