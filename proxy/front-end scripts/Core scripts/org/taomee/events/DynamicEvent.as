package org.taomee.events
{
   import flash.events.Event;
   
   public class DynamicEvent extends Event
   {
      
      private var _paramObject:Object;
      
      public function DynamicEvent(_arg_1:String, _arg_2:Object = null)
      {
         super(_arg_1,false,false);
         this._paramObject = _arg_2;
      }
      
      public function get paramObject() : Object
      {
         return this._paramObject;
      }
      
      override public function clone() : Event
      {
         return new DynamicEvent(type,this._paramObject);
      }
   }
}

