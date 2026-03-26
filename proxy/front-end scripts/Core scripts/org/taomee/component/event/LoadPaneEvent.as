package org.taomee.component.event
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class LoadPaneEvent extends Event
   {
      
      public static const ON_LOAD_CONTENT:String = "onLoadContent";
      
      private var content:DisplayObject;
      
      public function LoadPaneEvent(_arg_1:String, _arg_2:DisplayObject, _arg_3:Boolean = false, _arg_4:Boolean = false)
      {
         super(_arg_1,_arg_3,_arg_4);
         this.content = _arg_2;
      }
      
      public function getContent() : DisplayObject
      {
         return this.content;
      }
   }
}

