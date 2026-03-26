package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class SoftBoxLayout extends EmptyLayout implements ILayoutManager
   {
      
      private static const TYPE:String = "softBoxLayout";
      
      public static const CENTER:uint = 0;
      
      public static const LEFT:uint = 1;
      
      public static const TOP:uint = 1;
      
      public static const RIGHT:uint = 2;
      
      public static const BOTTOM:uint = 2;
      
      public static const X_AXIS:uint = 0;
      
      public static const Y_AXIS:uint = 1;
      
      private var _axis:uint;
      
      private var _align:uint;
      
      private var _gap:int;
      
      public function SoftBoxLayout(_arg_1:int = 0, _arg_2:int = 5, _arg_3:int = 0)
      {
         super();
         this._axis = _arg_1;
         this._gap = _arg_2;
         this._align = _arg_3;
      }
      
      public function get axis() : uint
      {
         return this._axis;
      }
      
      public function set axis(_arg_1:uint) : void
      {
         if(_arg_1 == this._axis)
         {
            return;
         }
         this._axis = _arg_1;
         broadcast();
      }
      
      public function get align() : uint
      {
         return this._align;
      }
      
      public function set align(_arg_1:uint) : void
      {
         if(_arg_1 == this._align)
         {
            return;
         }
         this._align = _arg_1;
         broadcast();
      }
      
      private function layoutX() : void
      {
         var _local_2:UIComponent = null;
         var _local_3:UIComponent = null;
         var _local_4:UIComponent = null;
         var _local_7:uint = 0;
         var _local_8:uint = 0;
         var _local_1:Number = NaN;
         var _local_5:Number = 0;
         var _local_6:int = int(container.compList.length);
         for each(_local_2 in container.compList)
         {
            _local_2.y = 0;
            _local_2.x = 0;
            _local_5 += _local_2.width;
            _local_2.height = container.height;
            _local_7++;
         }
         if(_local_6 > 0)
         {
            _local_5 += (_local_6 - 1) * this.gap;
         }
         switch(this.align)
         {
            case RIGHT:
               _local_1 = container.width - _local_5;
               break;
            case CENTER:
               _local_1 = (container.width - _local_5) / 2;
               break;
            default:
               _local_1 = 0;
         }
         for each(_local_3 in container.compList)
         {
            if(_local_8 == 0)
            {
               _local_3.x = _local_1;
            }
            else
            {
               _local_4 = container.compList[_local_8 - 1];
               _local_3.x = _local_4.x + _local_4.width + this.gap;
            }
            _local_8++;
         }
      }
      
      private function layoutY() : void
      {
         var _local_2:UIComponent = null;
         var _local_3:UIComponent = null;
         var _local_4:UIComponent = null;
         var _local_7:uint = 0;
         var _local_8:uint = 0;
         var _local_1:Number = NaN;
         var _local_5:Number = 0;
         var _local_6:int = int(container.compList.length);
         for each(_local_2 in container.compList)
         {
            _local_2.y = 0;
            _local_2.x = 0;
            _local_5 += _local_2.height;
            _local_2.width = container.width;
            _local_7++;
         }
         if(_local_6 > 0)
         {
            _local_5 += (_local_6 - 1) * this.gap;
         }
         switch(this.align)
         {
            case RIGHT:
               _local_1 = container.height - _local_5;
               break;
            case CENTER:
               _local_1 = (container.height - _local_5) / 2;
               break;
            default:
               _local_1 = 0;
         }
         for each(_local_3 in container.compList)
         {
            if(_local_8 == 0)
            {
               _local_3.y = _local_1;
            }
            else
            {
               _local_4 = container.compList[_local_8 - 1];
               _local_3.y = _local_4.y + _local_4.height + this.gap;
            }
            _local_8++;
         }
      }
      
      override public function getType() : String
      {
         return TYPE + this.axis.toString() + this.gap.toString() + this.align.toString();
      }
      
      public function get gap() : int
      {
         return this._gap;
      }
      
      public function set gap(_arg_1:int) : void
      {
         if(_arg_1 == this._gap)
         {
            return;
         }
         this._gap = _arg_1;
         broadcast();
      }
      
      override public function doLayout() : void
      {
         if(this.axis == X_AXIS)
         {
            this.layoutX();
         }
         else
         {
            this.layoutY();
         }
      }
   }
}

