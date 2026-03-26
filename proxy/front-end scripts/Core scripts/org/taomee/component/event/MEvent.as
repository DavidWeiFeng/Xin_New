package org.taomee.component.event
{
   import flash.events.Event;
   
   public class MEvent extends Event
   {
      
      public static const PANEL_CLOSED:String = "panelClosed";
      
      public function MEvent(_arg_1:String, _arg_2:Boolean = false, _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
   }
}

