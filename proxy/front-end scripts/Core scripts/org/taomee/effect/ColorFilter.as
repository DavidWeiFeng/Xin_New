package org.taomee.effect
{
   import flash.filters.*;
   
   public class ColorFilter
   {
      
      private static const RED:Number = 0.3086;
      
      private static const GREEN:Number = 0.6094;
      
      private static const BLUE:Number = 0.082;
      
      private static const DELTA_INDEX:Array = [0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.2,0.21,0.22,0.24,0.25,0.27,0.28,0.3,0.32,0.34,0.36,0.38,0.4,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.8,0.83,0.86,0.89,0.92,0.95,0.98,1,1.06,1.12,1.18,1.24,1.3,1.36,1.42,1.48,1.54,1.6,1.66,1.72,1.78,1.84,1.9,1.96,2,2.12,2.25,2.37,2.5,2.62,2.75,2.87,3,3.2,3.4,3.6,3.8,4,4.3,4.7,4.9,5,5.5,6,6.5,6.8,7,7.3,7.5,7.8,8,8.4,8.7,9,9.4,9.6,9.8,10];
      
      public function ColorFilter()
      {
         super();
      }
      
      public static function setContrast(_arg_1:Number) : ColorMatrixFilter
      {
         var _local_2:Number = NaN;
         _arg_1 = Number(ColorFilter.cleanValue(_arg_1,100));
         if(_arg_1 == 0 || isNaN(_arg_1))
         {
            return null;
         }
         if(_arg_1 < 0)
         {
            _local_2 = 127 + _arg_1 / 100 * 127;
         }
         else
         {
            _local_2 = _arg_1 % 1;
            if(_local_2 == 0)
            {
               _local_2 = Number(DELTA_INDEX[_arg_1]);
            }
            else
            {
               _local_2 = DELTA_INDEX[_arg_1 << 0] * (1 - _local_2) + DELTA_INDEX[(_arg_1 << 0) + 1] * _local_2;
            }
            _local_2 = _local_2 * 127 + 127;
         }
         return new ColorMatrixFilter([_local_2 / 127,0,0,0,0.5 * (127 - _local_2),0,_local_2 / 127,0,0,0.5 * (127 - _local_2),0,0,_local_2 / 127,0,0.5 * (127 - _local_2),0,0,0,1,0,0,0,0,0,1]);
      }
      
      public static function setGrayscale() : ColorMatrixFilter
      {
         return new ColorMatrixFilter([ColorFilter.RED,ColorFilter.GREEN,ColorFilter.BLUE,0,0,ColorFilter.RED,ColorFilter.GREEN,ColorFilter.BLUE,0,0,ColorFilter.RED,ColorFilter.GREEN,ColorFilter.BLUE,0,0,0,0,0,1,0]);
      }
      
      protected static function cleanValue(_arg_1:Number, _arg_2:Number) : Number
      {
         return Math.min(_arg_2,Math.max(-_arg_2,_arg_1));
      }
      
      public static function setBrightness(_arg_1:Number) : ColorMatrixFilter
      {
         _arg_1 = Number(ColorFilter.cleanValue(_arg_1,100));
         if(_arg_1 == 0 || isNaN(_arg_1))
         {
            return null;
         }
         return new ColorMatrixFilter([1,0,0,0,_arg_1,0,1,0,0,_arg_1,0,0,1,0,_arg_1,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public static function setHue(_arg_1:Number) : ColorMatrixFilter
      {
         _arg_1 = ColorFilter.cleanValue(_arg_1,180) / 180 * Math.PI;
         if(_arg_1 == 0 || isNaN(_arg_1))
         {
            return null;
         }
         var _local_2:Number = Math.cos(_arg_1);
         var _local_3:Number = Math.sin(_arg_1);
         return new ColorMatrixFilter([0.213 + _local_2 * (1 - 0.213) + _local_3 * -0.213,0.715 + _local_2 * -0.715 + _local_3 * -0.715,0.072 + _local_2 * -0.072 + _local_3 * (1 - 0.072),0,0,0.213 + _local_2 * -0.213 + _local_3 * 0.143,0.715 + _local_2 * (1 - 0.715) + _local_3 * 0.14,0.072 + _local_2 * -0.072 + _local_3 * -0.283,0,0,0.213 + _local_2 * -0.213 + _local_3 * -(1 - 0.213),0.715 + _local_2 * -0.715 + _local_3 * 0.715,0.072 + _local_2 * (1 - 0.072) + _local_3 * 0.072,0,0,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public static function setInvert() : ColorMatrixFilter
      {
         return new ColorMatrixFilter([-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0]);
      }
      
      public static function setSaturation(_arg_1:Number) : ColorMatrixFilter
      {
         _arg_1 = Number(ColorFilter.cleanValue(_arg_1,100));
         if(_arg_1 == 0 || isNaN(_arg_1))
         {
            return null;
         }
         var _local_2:Number = 1 + (_arg_1 > 0 ? 3 * _arg_1 / 100 : _arg_1 / 100);
         return new ColorMatrixFilter([ColorFilter.RED * (1 - _local_2) + _local_2,ColorFilter.GREEN * (1 - _local_2),ColorFilter.BLUE * (1 - _local_2),0,0,ColorFilter.RED * (1 - _local_2),ColorFilter.GREEN * (1 - _local_2) + _local_2,ColorFilter.BLUE * (1 - _local_2),0,0,ColorFilter.RED * (1 - _local_2),ColorFilter.GREEN * (1 - _local_2),ColorFilter.BLUE * (1 - _local_2) + _local_2,0,0,0,0,0,1,0,0,0,0,0,1]);
      }
   }
}

