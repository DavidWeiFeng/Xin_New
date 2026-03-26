package com.robot.core.event
{
   import flash.events.Event;
   import flash.net.URLLoader;
   
   public class XMLLoadEvent extends Event
   {
      
      public static var ON_SUCCESS:String = "onSuccess";
      
      public static var ERROR:String = "error";
      
      private var urlloader:URLLoader;
      
      private var _xml:XML;
      
      public function XMLLoadEvent(_arg_1:String, _arg_2:URLLoader, _arg_3:Boolean = false, _arg_4:Boolean = false)
      {
         super(_arg_1,_arg_3,_arg_4);
         this.urlloader = _arg_2;
      }
      
      public function getXML() : XML
      {
         return new XML(this.urlloader.data);
      }
   }
}

