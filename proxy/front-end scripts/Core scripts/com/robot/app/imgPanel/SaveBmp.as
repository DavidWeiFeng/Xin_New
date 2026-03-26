package com.robot.app.imgPanel
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.FileReference;
   import flash.net.URLRequest;
   
   public class SaveBmp
   {
      
      private static var file:FileReference;
      
      public function SaveBmp()
      {
         super();
      }
      
      public static function download(_arg_1:String) : void
      {
         var _local_2:URLRequest = new URLRequest();
         _local_2.url = _arg_1;
         file = new FileReference();
         var _local_3:String = "赛尔截图_" + new Date().valueOf() + ".jpg";
         configureListeners();
         file.download(_local_2,_local_3);
      }
      
      private static function configureListeners() : void
      {
         file.addEventListener(Event.CANCEL,cancelHandler);
         file.addEventListener(Event.COMPLETE,completeHandler);
         file.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         file.addEventListener(ProgressEvent.PROGRESS,progressHandler);
         file.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
      }
      
      private static function removeConfigureListeners() : void
      {
         file.removeEventListener(Event.CANCEL,cancelHandler);
         file.removeEventListener(Event.COMPLETE,completeHandler);
         file.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         file.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
         file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
      }
      
      private static function cancelHandler(_arg_1:Event) : void
      {
         removeConfigureListeners();
      }
      
      private static function completeHandler(_arg_1:Event) : void
      {
         removeConfigureListeners();
      }
      
      private static function ioErrorHandler(_arg_1:IOErrorEvent) : void
      {
         removeConfigureListeners();
      }
      
      private static function progressHandler(_arg_1:ProgressEvent) : void
      {
         var _local_2:FileReference = FileReference(_arg_1.target);
      }
      
      private static function securityErrorHandler(_arg_1:SecurityErrorEvent) : void
      {
         removeConfigureListeners();
      }
   }
}

