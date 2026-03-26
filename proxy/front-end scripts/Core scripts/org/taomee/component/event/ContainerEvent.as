package org.taomee.component.event
{
   import flash.events.Event;
   import org.taomee.component.UIComponent;
   
   public class ContainerEvent extends Event
   {
      
      public static const COMP_ADDED:String = "compAdded";
      
      public static const COMP_REMOVED:String = "compRemoved";
      
      private var comp:UIComponent;
      
      public function ContainerEvent(_arg_1:String, _arg_2:UIComponent, _arg_3:Boolean = false, _arg_4:Boolean = false)
      {
         super(_arg_1,_arg_3,_arg_4);
         this.comp = _arg_2;
      }
      
      public function get component() : UIComponent
      {
         return this.comp;
      }
   }
}

