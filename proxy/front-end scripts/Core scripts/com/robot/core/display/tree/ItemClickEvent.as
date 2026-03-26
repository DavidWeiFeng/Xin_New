package com.robot.core.display.tree
{
   import flash.events.Event;
   
   public class ItemClickEvent extends Event
   {
      
      public static const ITEMCLICK:String = "itemclick";
      
      public var item:Btn;
      
      public function ItemClickEvent(_arg_1:Btn, _arg_2:String, _arg_3:Boolean = false, _arg_4:Boolean = false)
      {
         super(_arg_2,_arg_3,_arg_4);
         this.item = _arg_1;
      }
   }
}

