package org.taomee.component.event
{
   import flash.events.Event;
   
   public class ButtonEvent extends Event
   {
      
      public static const ON_ROLL_OVER:String = "onRollOver";
      
      public static const ON_ROLL_OUT:String = "onRollOut";
      
      public static const PRESS:String = "press";
      
      public static const RELEASE:String = "release";
      
      public static const RELEASE_OUTSIDE:String = "releaseOutside";
      
      public function ButtonEvent(_arg_1:String, _arg_2:Boolean = false, _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
   }
}

