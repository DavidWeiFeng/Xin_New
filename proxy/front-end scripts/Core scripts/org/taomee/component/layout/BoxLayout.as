package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class BoxLayout extends EmptyLayout implements ILayoutManager
   {
      
      private static var TYPE:String = "boxLayout";
      
      public static const X_AXIS:uint = 0;
      
      public static const Y_AXIS:uint = 1;
      
      private var _axis:uint;
      
      private var _gap:int;
      
      public function BoxLayout(_arg_1:int = 0, _arg_2:int = 5)
      {
         super();
         this._axis = _arg_1;
         this._gap = _arg_2;
      }
      
      public function get axis() : uint
      {
         return this._axis;
      }
      
      public function set axis(_arg_1:uint) : void
      {
         if(this._axis == _arg_1)
         {
            return;
         }
         this._axis = _arg_1;
         broadcast();
      }
      
      public function set gap(_arg_1:int) : void
      {
         if(this._gap == _arg_1)
         {
            return;
         }
         this._gap = _arg_1;
         broadcast();
      }
      
      private function layoutY() : void
      {
         var _local_1:UIComponent = null;
         var _local_3:Number = NaN;
         var _local_4:uint = 0;
         var _local_2:uint = container.compList.length;
         _local_3 = (container.height - (_local_2 - 1) * this._gap) / _local_2;
         for each(_local_1 in container.compList)
         {
            if(_local_4 == 0)
            {
               _local_1.y = _local_3 * _local_4;
            }
            else
            {
               _local_1.y = _local_3 * _local_4 + this._gap;
            }
            _local_1.x = 0;
            _local_1.height = _local_3;
            _local_1.width = container.width;
            _local_4++;
         }
      }
      
      override public function getType() : String
      {
         return TYPE + this._axis.toString() + this._gap.toString();
      }
      
      override public function doLayout() : void
      {
         if(this._axis == Y_AXIS)
         {
            this.layoutY();
         }
         else
         {
            this.layoutX();
         }
      }
      
      public function get gap() : int
      {
         return this._gap;
      }
      
      private function layoutX() : void
      {
         var _local_1:UIComponent = null;
         var _local_4:uint = 0;
         var _local_2:uint = container.compList.length;
         var _local_3:Number = (container.width - (_local_2 - 1) * this._gap) / _local_2;
         for each(_local_1 in container.compList)
         {
            if(_local_4 == 0)
            {
               _local_1.x = _local_3 * _local_4;
            }
            else
            {
               _local_1.x = _local_3 * _local_4 + this._gap;
            }
            _local_1.y = 0;
            _local_1.width = _local_3;
            _local_1.height = container.height;
            _local_4++;
         }
      }
   }
}

