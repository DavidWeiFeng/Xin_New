package org.taomee.component.layout
{
   import org.taomee.component.*;
   
   public class FlowWarpLayout extends EmptyLayout implements ILayoutManager
   {
      
      private static const TYPE:String = "flowWarpLayout";
      
      public static const CENTER:int = 0;
      
      public static const LEFT:int = 1;
      
      public static const RIGHT:int = 2;
      
      public static const TOP:uint = 1;
      
      public static const MIDLLE:uint = 0;
      
      public static const BOTTOM:uint = 2;
      
      private var initialHeight:Number;
      
      private var _hgap:int;
      
      private var initialWidth:Number;
      
      private var _valign:uint;
      
      private var _halign:uint;
      
      private var _vgap:int;
      
      public function FlowWarpLayout(_arg_1:uint = 1, _arg_2:uint = 0, _arg_3:int = 5, _arg_4:int = 5)
      {
         super();
         this._halign = _arg_1;
         this._valign = _arg_2;
         this._hgap = _arg_3;
         this._vgap = _arg_4;
      }
      
      public function set vgap(_arg_1:int) : void
      {
         if(_arg_1 == this._vgap)
         {
            return;
         }
         this._vgap = _arg_1;
         broadcast();
      }
      
      public function get valign() : uint
      {
         return this._valign;
      }
      
      override public function doLayout() : void
      {
         var _local_1:UIComponent = null;
         var _local_2:int = 0;
         var _local_5:uint = 0;
         this.initialWidth = this.initialHeight = 0;
         var _local_3:Number = 0;
         var _local_4:Number = compSprite.numChildren;
         for each(_local_1 in container.compList)
         {
            if(this.initialWidth + _local_1.width + this.hgap * (_local_5 - _local_2) > container.width)
            {
               this.moveComponent(_local_2,_local_5 - 1,this.initialWidth,_local_3);
               _local_2 = int(_local_5);
               this.initialWidth = _local_1.width;
               _local_3 = _local_1.height;
               if(_local_5 == _local_4 - 1)
               {
                  this.moveComponent(_local_2,_local_4 - 1,this.initialWidth,_local_3);
               }
            }
            else
            {
               this.initialWidth += _local_1.width;
               _local_3 = Math.max(_local_3,_local_1.height);
               if(_local_5 == _local_4 - 1)
               {
                  this.moveComponent(_local_2,_local_4 - 1,this.initialWidth,_local_3);
               }
            }
            _local_5++;
         }
      }
      
      public function get halign() : uint
      {
         return this._halign;
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
      
      public function get vgap() : int
      {
         return this._vgap;
      }
      
      public function set hgap(_arg_1:int) : void
      {
         if(_arg_1 == this._hgap)
         {
            return;
         }
         this._hgap = _arg_1;
         broadcast();
      }
      
      private function moveComponent(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:Number) : void
      {
         var _local_6:UIComponent = null;
         var _local_7:UIComponent = null;
         var _local_5:Number = NaN;
         switch(this.halign)
         {
            case RIGHT:
               _local_5 = container.width - _arg_3 - this.hgap * (_arg_2 - _arg_1);
               break;
            case CENTER:
               _local_5 = (container.width - _arg_3 - this.hgap * (_arg_2 - _arg_1)) / 2;
               break;
            default:
               _local_5 = 0;
         }
         var _local_8:int = _arg_1;
         while(_local_8 < _arg_2 + 1)
         {
            _local_6 = container.compList[_local_8] as UIComponent;
            if(_local_8 == _arg_1)
            {
               _local_6.x = _local_5;
            }
            else
            {
               _local_7 = container.compList[_local_8 - 1] as UIComponent;
               _local_6.x = _local_7.x + _local_7.width + this.hgap;
            }
            switch(this.valign)
            {
               case MIDLLE:
                  _local_6.y = (_arg_4 - _local_6.height) / 2 + this.initialHeight;
                  break;
               case BOTTOM:
                  _local_6.y = _arg_4 - _local_6.height + this.initialHeight;
                  break;
               default:
                  _local_6.y = this.initialHeight;
            }
            _local_8++;
         }
         this.initialHeight += _arg_4 + this.vgap;
      }
      
      public function get hgap() : int
      {
         return this._hgap;
      }
      
      override public function getType() : String
      {
         return TYPE + this.halign.toString() + this.valign.toString() + this.hgap.toString() + this.vgap.toString();
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
   }
}

