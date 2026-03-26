package com.robot.core.newloader
{
   import com.robot.core.event.XMLLoadEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   [Event(name="onSuccess",type="com.event.XMLLoadEvent")]
   [Event(name="error",type="com.event.XMLLoadEvent")]
   public class XMLLoader extends URLLoader
   {
      
      private var url:String;
      
      public function XMLLoader(_arg_1:String)
      {
         super();
         this.url = _arg_1;
         this.addEventListener(Event.COMPLETE,this._onLoad);
         this.addEventListener(IOErrorEvent.IO_ERROR,this._error);
      }
      
      public function doLoad(_arg_1:String = "") : void
      {
         if(_arg_1 == "")
         {
            this.load(new URLRequest(this.url));
         }
         else
         {
            this.addEventListener(Event.COMPLETE,this._onLoad);
            this.addEventListener(IOErrorEvent.IO_ERROR,this._error);
            this.load(new URLRequest(_arg_1));
         }
      }
      
      private function _onLoad(_arg_1:Event) : void
      {
         this.removeEventListener(Event.COMPLETE,this._onLoad);
         this.removeEventListener(IOErrorEvent.IO_ERROR,this._error);
         dispatchEvent(new XMLLoadEvent(XMLLoadEvent.ON_SUCCESS,this));
      }
      
      private function _error(_arg_1:IOErrorEvent) : void
      {
         this.removeEventListener(Event.COMPLETE,this._onLoad);
         this.removeEventListener(IOErrorEvent.IO_ERROR,this._error);
         dispatchEvent(new XMLLoadEvent(XMLLoadEvent.ERROR,this));
      }
   }
}

