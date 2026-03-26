package org.taomee.utils
{
   import flash.geom.Point;
   
   public class GeomUtil
   {
      
      public static const R_T_D:Number = 180 / Math.PI;
      
      public static const D_T_R:Number = Math.PI / 180;
      
      public function GeomUtil()
      {
         super();
      }
      
      public static function radiansToDegrees(_arg_1:Number) : Number
      {
         return _arg_1 * R_T_D;
      }
      
      public static function pointAngle(_arg_1:Point, _arg_2:Point) : Number
      {
         return Math.atan2(_arg_1.y - _arg_2.y,_arg_1.x - _arg_2.x) * R_T_D;
      }
      
      public static function pointRadians(_arg_1:Point, _arg_2:Point) : Number
      {
         return Math.atan2(_arg_1.y - _arg_2.y,_arg_1.x - _arg_2.x);
      }
      
      public static function getCirclePoint(_arg_1:Point, _arg_2:Number, _arg_3:Number) : Point
      {
         var _local_4:Number = _arg_2 * D_T_R;
         return _arg_1.add(new Point(Math.cos(_local_4) * _arg_3,Math.sin(_local_4) * _arg_3));
      }
      
      public static function degreesToRadians(_arg_1:Number) : Number
      {
         return _arg_1 * D_T_R;
      }
      
      public static function angleSpeed(_arg_1:Point, _arg_2:Point) : Point
      {
         var _local_3:Number = Math.atan2(_arg_1.y - _arg_2.y,_arg_1.x - _arg_2.x);
         return new Point(Math.cos(_local_3),Math.sin(_local_3));
      }
      
      public static function angleToSpeed(_arg_1:Number) : Point
      {
         var _local_2:Number = _arg_1 * D_T_R;
         return new Point(Math.cos(_local_2),Math.sin(_local_2));
      }
      
      public static function radiansToSpeed(_arg_1:Number) : Point
      {
         return new Point(Math.cos(_arg_1),Math.sin(_arg_1));
      }
   }
}

