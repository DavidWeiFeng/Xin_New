package com.robot.core.event
{
   import com.robot.core.newloader.MCLoader;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   
   public class MCLoadEvent extends Event
   {
      
      public static var SUCCESS:String = "success";
      
      public static var ERROR:String = "error";
      
      public static var CLOSE:String = "close";
      
      private var mcloader:MCLoader;
      
      private var content:DisplayObject;
      
      public function MCLoadEvent(_arg_1:String, _arg_2:MCLoader, _arg_3:Boolean = false, _arg_4:Boolean = false)
      {
         super(_arg_1,_arg_3,_arg_4);
         this.mcloader = _arg_2;
      }
      
      public function getParent() : DisplayObjectContainer
      {
         return this.mcloader.parentMC;
      }
      
      public function getLoader() : Loader
      {
         return this.mcloader.loader;
      }
      
      public function getContent() : DisplayObject
      {
         return this.mcloader.loader.content;
      }
      
      public function getApplicationDomain() : ApplicationDomain
      {
         return this.getLoader().contentLoaderInfo.applicationDomain;
      }
   }
}

