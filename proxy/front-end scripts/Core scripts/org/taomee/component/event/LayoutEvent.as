package org.taomee.component.event
{
   import flash.events.Event;
   
   public class LayoutEvent extends Event
   {
      
      public static const LAYOUT_SET_CHANGED:String = "layoutSetChanged";
      
      public function LayoutEvent(_arg_1:String, _arg_2:Boolean = false, _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
   }
}

