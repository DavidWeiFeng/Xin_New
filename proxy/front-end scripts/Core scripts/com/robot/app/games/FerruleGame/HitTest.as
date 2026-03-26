package com.robot.app.games.FerruleGame
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HitTest
   {
      
      public function HitTest()
      {
         super();
      }
      
      public static function complexHitTestObject(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:Number = 1) : Rectangle
      {
         return complexIntersectionRectangle(_arg_1,_arg_2,_arg_3);
      }
      
      public static function intersectionRectangle(_arg_1:DisplayObject, _arg_2:DisplayObject) : Rectangle
      {
         if(!_arg_1.root || !_arg_2.root || !_arg_1.hitTestObject(_arg_2))
         {
            return new Rectangle();
         }
         var _local_3:Rectangle = _arg_1.getBounds(_arg_1.root);
         var _local_4:Rectangle = _arg_2.getBounds(_arg_2.root);
         var _local_5:Rectangle = new Rectangle();
         _local_5.x = Math.max(_local_3.x,_local_4.x);
         _local_5.y = Math.max(_local_3.y,_local_4.y);
         _local_5.width = Math.min(_local_3.x + _local_3.width - _local_5.x,_local_4.x + _local_4.width - _local_5.x);
         _local_5.height = Math.min(_local_3.y + _local_3.height - _local_5.y,_local_4.y + _local_4.height - _local_5.y);
         return _local_5;
      }
      
      public static function complexIntersectionRectangle(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:Number = 1) : Rectangle
      {
         if(_arg_3 <= 0)
         {
            throw new Error("ArgumentError: Error #5001: Invalid value for accuracy",5001);
         }
         if(!_arg_1.hitTestObject(_arg_2))
         {
            return new Rectangle();
         }
         var _local_4:Rectangle = intersectionRectangle(_arg_1,_arg_2);
         if(_local_4.width * _arg_3 < 1 || _local_4.height * _arg_3 < 1)
         {
            return new Rectangle();
         }
         var _local_5:BitmapData = new BitmapData(_local_4.width * _arg_3,_local_4.height * _arg_3,false,0);
         _local_5.draw(_arg_1,HitTest.getDrawMatrix(_arg_1,_local_4,_arg_3),new ColorTransform(1,1,1,1,255,-255,-255,255));
         _local_5.draw(_arg_2,HitTest.getDrawMatrix(_arg_2,_local_4,_arg_3),new ColorTransform(1,1,1,1,255,255,255,255),BlendMode.DIFFERENCE);
         var _local_6:Rectangle = _local_5.getColorBoundsRect(4294967295,4278255615);
         _local_5.dispose();
         if(_arg_3 != 1)
         {
            _local_6.x /= _arg_3;
            _local_6.y /= _arg_3;
            _local_6.width /= _arg_3;
            _local_6.height /= _arg_3;
         }
         _local_6.x += _local_4.x;
         _local_6.y += _local_4.y;
         return _local_6;
      }
      
      protected static function getDrawMatrix(_arg_1:DisplayObject, _arg_2:Rectangle, _arg_3:Number) : Matrix
      {
         var _local_4:Point = null;
         var _local_5:Matrix = null;
         var _local_6:Matrix = _arg_1.root.transform.concatenatedMatrix;
         _local_4 = _arg_1.localToGlobal(new Point());
         _local_5 = _arg_1.transform.concatenatedMatrix;
         _local_5.tx = _local_4.x - _arg_2.x;
         _local_5.ty = _local_4.y - _arg_2.y;
         _local_5.a /= _local_6.a;
         _local_5.d /= _local_6.d;
         if(_arg_3 != 1)
         {
            _local_5.scale(_arg_3,_arg_3);
         }
         return _local_5;
      }
   }
}

