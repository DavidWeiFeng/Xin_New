package org.taomee.events
{
   import flash.events.Event;
   import org.taomee.tmf.HeadInfo;
   
   public class SocketEvent extends Event
   {
      
      public static const COMPLETE:String = Event.COMPLETE;
      
      private var _data:Object;
      
      private var _headInfo:HeadInfo;
      
      public function SocketEvent(_arg_1:String, _arg_2:HeadInfo, _arg_3:Object)
      {
         super(_arg_1,false,false);
         this._headInfo = _arg_2;
         this._data = _arg_3;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get headInfo() : HeadInfo
      {
         return this._headInfo;
      }
   }
}

