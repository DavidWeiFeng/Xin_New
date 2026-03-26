package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class FlowLayout extends EmptyLayout implements ILayoutManager
   {
      
      private static const TYPE:String = "flowLayout";
      
      public static const CENTER:int = 0;
      
      public static const LEFT:int = 1;
      
      public static const RIGHT:int = 2;
      
      public static const TOP:uint = 1;
      
      public static const MIDLLE:uint = 0;
      
      public static const BOTTOM:uint = 2;
      
      public static const X_AXIS:uint = 0;
      
      public static const Y_AXIS:uint = 1;
      
      private var _axis:uint;
      
      private var _halign:uint;
      
      private var _valign:uint;
      
      private var _gap:int;
      
      public function FlowLayout(_arg_1:uint = 1, _arg_2:uint = 1, _arg_3:uint = 1, _arg_4:int = 5)
      {
         super();
         this._axis = _arg_1;
         this._gap = _arg_4;
         this._halign = _arg_2;
         this._valign = _arg_3;
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
      
      public function get gap() : int
      {
         return this._gap;
      }
      
      public function get halign() : uint
      {
         return this._halign;
      }
      
      private function layoutY() : void
      {
         var _local_4:Number = NaN;
         var _local_1:UIComponent = null;
         var _local_2:UIComponent = null;
         var _local_3:Number = NaN;
         _local_4 = 0;
         var _local_5:uint = container.compList.length;
         for each(_local_2 in container.compList)
         {
            _local_2.x = _local_2.y = 0;
            _local_4 += _local_2.height;
            if(Boolean(_local_1))
            {
               _local_2.y = _local_1.y + _local_1.height + this.gap;
            }
            _local_1 = _local_2;
         }
         _local_4 += this.gap * (_local_5 - 1);
         switch(this.valign)
         {
            case BOTTOM:
               _local_3 = container.height - _local_4;
               break;
            case MIDLLE:
               _local_3 = (container.height - _local_4) / 2;
               break;
            default:
               _local_3 = 0;
         }
         for each(_local_2 in container.compList)
         {
            _local_2.y += _local_3;
            switch(this.halign)
            {
               case RIGHT:
                  _local_2.x = container.width - _local_2.width;
                  break;
               case CENTER:
                  _local_2.x = (container.width - _local_2.width) / 2;
            }
         }
      }
      
      override public function getType() : String
      {
         return TYPE + this.axis.toString() + this.gap.toString();
      }
      
      override public function doLayout() : void
      {
         if(this.axis == Y_AXIS)
         {
            this.layoutY();
         }
         else
         {
            this.layoutX();
         }
      }
      
      public function get valign() : uint
      {
         return this._valign;
      }
      
      public function set halign(_arg_1:uint) : void
      {
         if(_arg_1 == this._halign)
         {
            return;
         }
         this._halign = _arg_1;
         broadcast();
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
      
      private function layoutX() : void
      {
         var _local_1:UIComponent = null;
         var _local_2:UIComponent = null;
         var _local_3:Number = NaN;
         var _local_4:Number = 0;
         var _local_5:uint = container.compList.length;
         for each(_local_2 in container.compList)
         {
            _local_2.x = _local_2.y = 0;
            _local_4 += _local_2.width;
            if(Boolean(_local_1))
            {
               _local_2.x = _local_1.x + _local_1.width + this.gap;
            }
            _local_1 = _local_2;
         }
         _local_4 += this.gap * (_local_5 - 1);
         switch(this.halign)
         {
            case RIGHT:
               _local_3 = container.width - _local_4;
               break;
            case CENTER:
               _local_3 = (container.width - _local_4) / 2;
               break;
            default:
               _local_3 = 0;
         }
         for each(_local_2 in container.compList)
         {
            _local_2.x += _local_3;
            switch(this.valign)
            {
               case BOTTOM:
                  _local_2.y = container.height - _local_2.height;
                  break;
               case MIDLLE:
                  _local_2.y = (container.height - _local_2.height) / 2;
            }
         }
      }
      
      public function set valign(_arg_1:uint) : void
      {
         if(_arg_1 == this._valign)
         {
            return;
         }
         this._valign = _arg_1;
         broadcast();
      }
   }
}

