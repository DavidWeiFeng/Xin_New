package org.taomee.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.taomee.manager.TaomeeManager;
   
   public class DisplayUtil
   {
      
      private static const MOUSE_EVENT_LIST:Array = [MouseEvent.CLICK,MouseEvent.DOUBLE_CLICK,MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_MOVE,MouseEvent.MOUSE_OUT,MouseEvent.MOUSE_OVER,MouseEvent.MOUSE_UP,MouseEvent.MOUSE_WHEEL,MouseEvent.ROLL_OUT,MouseEvent.ROLL_OVER];
      
      public function DisplayUtil()
      {
         super();
      }
      
      public static function FillColor(_arg_1:DisplayObject, _arg_2:uint) : void
      {
         var _local_3:ColorTransform = new ColorTransform();
         _local_3.color = _arg_2;
         _arg_1.transform.colorTransform = _local_3;
      }
      
      public static function stopAllMovieClip(_arg_1:DisplayObjectContainer) : void
      {
         var _local_2:DisplayObjectContainer = null;
         var _local_3:MovieClip = _arg_1 as MovieClip;
         if(_local_3 != null)
         {
            _local_3.stop();
            _local_3 = null;
         }
         var _local_4:int = _arg_1.numChildren - 1;
         if(_local_4 < 0)
         {
            return;
         }
         var _local_5:int = _local_4;
         while(_local_5 >= 0)
         {
            _local_2 = _arg_1.getChildAt(_local_5) as DisplayObjectContainer;
            if(_local_2 != null)
            {
               stopAllMovieClip(_local_2);
            }
            _local_5--;
         }
      }
      
      public static function hasParent(_arg_1:DisplayObject) : Boolean
      {
         if(_arg_1.parent == null)
         {
            return false;
         }
         return _arg_1.parent.contains(_arg_1);
      }
      
      public static function localToLocal(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:Point = null) : Point
      {
         if(_arg_3 == null)
         {
            _arg_3 = new Point(0,0);
         }
         _arg_3 = _arg_1.localToGlobal(_arg_3);
         return _arg_2.globalToLocal(_arg_3);
      }
      
      public static function copyDisplayAsBmp(_arg_1:DisplayObject) : Bitmap
      {
         var _local_2:BitmapData = new BitmapData(_arg_1.width,_arg_1.height,true,0);
         var _local_3:Rectangle = _arg_1.getRect(_arg_1);
         var _local_4:Matrix = new Matrix();
         _local_4.translate(-_local_3.x,-_local_3.y);
         _local_2.draw(_arg_1,_local_4);
         var _local_5:Bitmap = new Bitmap(_local_2,PixelSnapping.AUTO,true);
         _local_5.x = _local_3.x;
         _local_5.y = _local_3.y;
         return _local_5;
      }
      
      public static function align(_arg_1:DisplayObject, _arg_2:Rectangle = null, _arg_3:int = 0, _arg_4:Point = null) : void
      {
         if(_arg_2 == null)
         {
            _arg_2 = new Rectangle(0,0,TaomeeManager.stageWidth,TaomeeManager.stageHeight);
         }
         if(Boolean(_arg_4))
         {
            _arg_2.offsetPoint(_arg_4);
         }
         var _local_5:Rectangle = _arg_1.getRect(_arg_1);
         var _local_6:Number = _arg_2.width - _arg_1.width;
         var _local_7:Number = _arg_2.height - _arg_1.height;
         switch(_arg_3)
         {
            case AlignType.TOP_LEFT:
               _arg_1.x = _arg_2.x;
               _arg_1.y = _arg_2.y;
               return;
            case AlignType.TOP_CENTER:
               _arg_1.x = _arg_2.x + _local_6 / 2 - _local_5.x;
               _arg_1.y = _arg_2.y;
               return;
            case AlignType.TOP_RIGHT:
               _arg_1.x = _arg_2.x + _local_6 - _local_5.x;
               _arg_1.y = _arg_2.y;
               return;
            case AlignType.MIDDLE_LEFT:
               _arg_1.x = _arg_2.x;
               _arg_1.y = _arg_2.y + _local_7 / 2 - _local_5.x;
               return;
            case AlignType.MIDDLE_CENTER:
               _arg_1.x = _arg_2.x + _local_6 / 2 - _local_5.x;
               _arg_1.y = _arg_2.y + _local_7 / 2 - _local_5.y;
               return;
            case AlignType.MIDDLE_RIGHT:
               _arg_1.x = _arg_2.x + _local_6 - _local_5.x;
               _arg_1.y = _arg_2.y + _local_7 / 2 - _local_5.y;
               return;
            case AlignType.BOTTOM_LEFT:
               _arg_1.x = _arg_2.x;
               _arg_1.y = _arg_2.y + _local_7 - _local_5.y;
               return;
            case AlignType.BOTTOM_CENTER:
               _arg_1.x = _arg_2.x + _local_6 / 2 - _local_5.x;
               _arg_1.y = _arg_2.y + _local_7 - _local_5.y;
               return;
            case AlignType.BOTTOM_RIGHT:
               _arg_1.x = _arg_2.x + _local_6 - _local_5.x;
               _arg_1.y = _arg_2.y + _local_7 - _local_5.y;
         }
      }
      
      public static function getColor(_arg_1:DisplayObject, _arg_2:uint = 0, _arg_3:uint = 0, _arg_4:Boolean = false) : uint
      {
         var _local_5:BitmapData = new BitmapData(_arg_1.width,_arg_1.height);
         _local_5.draw(_arg_1);
         var _local_6:uint = !_arg_4 ? _local_5.getPixel(int(_arg_2),int(_arg_3)) : _local_5.getPixel32(int(_arg_2),int(_arg_3));
         _local_5.dispose();
         return _local_6;
      }
      
      public static function removeForParent(_arg_1:DisplayObject, _arg_2:Boolean = true) : void
      {
         var _local_3:DisplayObjectContainer = null;
         if(_arg_1 == null)
         {
            return;
         }
         if(_arg_1.parent == null)
         {
            return;
         }
         if(!_arg_1.parent.contains(_arg_1))
         {
            return;
         }
         if(_arg_2)
         {
            _local_3 = _arg_1 as DisplayObjectContainer;
            if(Boolean(_local_3))
            {
               stopAllMovieClip(_local_3);
               _local_3 = null;
            }
         }
         _arg_1.parent.removeChild(_arg_1);
      }
      
      public static function mouseEnabledAll(target:InteractiveObject) : void
      {
         var container:DisplayObjectContainer = null;
         var i:int = 0;
         var child:InteractiveObject = null;
         var b:Boolean = Boolean(MOUSE_EVENT_LIST.some(function(_arg_1:String, _arg_2:int, _arg_3:Array):Boolean
         {
            if(target.hasEventListener(_arg_1))
            {
               return true;
            }
            return false;
         }));
         if(!b)
         {
            target.mouseEnabled = false;
         }
         container = target as DisplayObjectContainer;
         if(Boolean(container))
         {
            i = container.numChildren - 1;
            while(i >= 0)
            {
               child = container.getChildAt(i) as InteractiveObject;
               if(Boolean(child))
               {
                  mouseEnabledAll(child);
               }
               i -= 1;
            }
         }
      }
      
      public static function uniformScale(_arg_1:DisplayObject, _arg_2:Number) : void
      {
         if(_arg_1.width >= _arg_1.height)
         {
            _arg_1.width = _arg_2;
            _arg_1.scaleY = _arg_1.scaleX;
         }
         else
         {
            _arg_1.height = _arg_2;
            _arg_1.scaleX = _arg_1.scaleY;
         }
      }
      
      public static function removeAllChild(_arg_1:DisplayObjectContainer) : void
      {
         var _local_2:DisplayObjectContainer = null;
         while(_arg_1.numChildren > 0)
         {
            _local_2 = _arg_1.removeChildAt(0) as DisplayObjectContainer;
            if(_local_2 != null)
            {
               stopAllMovieClip(_local_2);
               _local_2 = null;
            }
         }
      }
   }
}

