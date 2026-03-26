package org.taomee.events
{
   import flash.events.Event;
   import org.taomee.tmf.HeadInfo;
   
   public class SocketErrorEvent extends Event
   {
      
      public static const ERROR:String = "error";
      
      private var _headInfo:HeadInfo;
      
      public function SocketErrorEvent(_arg_1:String, _arg_2:HeadInfo, _arg_3:Boolean = false, _arg_4:Boolean = false)
      {
         super(_arg_1,_arg_3,_arg_4);
         this._headInfo = _arg_2;
      }
      
      public function get headInfo() : HeadInfo
      {
         return this._headInfo;
      }
   }
}

