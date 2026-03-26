package org.taomee.component.containers
{
   import org.taomee.component.Container;
   import org.taomee.component.layout.FlowLayout;
   
   public class Box extends Container
   {
      
      private var _dir:String;
      
      private var _valign:int;
      
      private var _halign:int;
      
      public function Box(_arg_1:int = 5)
      {
         super();
         layout = new FlowLayout(FlowLayout.X_AXIS);
         this.gap = _arg_1;
      }
      
      private function updateLayout() : void
      {
         if(this._dir == BoxDirection.HORIZONTAL)
         {
            (layout as FlowLayout).axis = FlowLayout.X_AXIS;
         }
         else
         {
            (layout as FlowLayout).axis = FlowLayout.Y_AXIS;
         }
      }
      
      public function set valign(_arg_1:uint) : void
      {
         this._valign = _arg_1;
         (layout as FlowLayout).valign = _arg_1;
      }
      
      public function set gap(_arg_1:uint) : void
      {
         (layout as FlowLayout).gap = _arg_1;
      }
      
      public function get gap() : uint
      {
         return (layout as FlowLayout).gap;
      }
      
      public function set halign(_arg_1:uint) : void
      {
         this._halign = _arg_1;
         (layout as FlowLayout).halign = _arg_1;
      }
      
      public function set direction(_arg_1:String) : void
      {
         if(_arg_1 == this._dir)
         {
            return;
         }
         this._dir = _arg_1;
         this.updateLayout();
      }
      
      public function get direction() : String
      {
         return this._dir;
      }
   }
}

