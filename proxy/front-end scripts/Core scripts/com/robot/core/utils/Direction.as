package com.robot.core.utils
{
   import flash.geom.Point;
   import org.taomee.utils.*;
   
   public class Direction
   {
      
      public static var UP:String = "up";
      
      public static var DOWN:String = "down";
      
      public static var LEFT:String = "left";
      
      public static var LEFT_UP:String = "leftup";
      
      public static var LEFT_DOWN:String = "leftdown";
      
      public static var RIGHT:String = "right";
      
      public static var RIGHT_UP:String = "rightup";
      
      public static var RIGHT_DOWN:String = "rightdown";
      
      public static var LIST:Array = [RIGHT,RIGHT_DOWN,DOWN,LEFT_DOWN,LEFT,LEFT_UP,UP,RIGHT_UP];
      
      public function Direction()
      {
         super();
      }
      
      public static function indexToStr(_arg_1:int) : String
      {
         return LIST[_arg_1];
      }
      
      public static function strToIndex(_arg_1:String) : int
      {
         return LIST.indexOf(_arg_1);
      }
      
      public static function getIndex(_arg_1:Point, _arg_2:Point) : int
      {
         return angleToIndex(GeomUtil.pointAngle(_arg_1,_arg_2));
      }
      
      public static function getStr(_arg_1:Point, _arg_2:Point) : String
      {
         return indexToStr(getIndex(_arg_1,_arg_2));
      }
      
      public static function angleToIndex(_arg_1:Number) : int
      {
         _arg_1 = _arg_1 + 22.5 + 180;
         if(_arg_1 > 360)
         {
            _arg_1 = 0;
         }
         return int(_arg_1 / 45);
      }
      
      public static function angleToStr(_arg_1:Number) : String
      {
         return indexToStr(angleToIndex(_arg_1));
      }
   }
}

