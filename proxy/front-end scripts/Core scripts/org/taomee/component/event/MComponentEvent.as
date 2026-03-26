package org.taomee.component.event
{
   import flash.events.Event;
   
   public class MComponentEvent extends Event
   {
      
      public static const UPDATE:String = "onUpdate";
      
      public function MComponentEvent(_arg_1:String, _arg_2:Boolean = false, _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
   }
}

