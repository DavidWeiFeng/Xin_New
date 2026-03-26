package org.taomee.utils
{
   public class ColorUtil
   {
      
      public static const RGB_MAX:uint = 256;
      
      public static const HUE_MAX:uint = 360;
      
      public static const PCT_MAX:uint = 100;
      
      public function ColorUtil()
      {
         super();
      }
      
      public static function HueToRGB(_arg_1:Number, _arg_2:Number, _arg_3:Number) : Object
      {
         var _local_7:int = 0;
         var _local_4:Number = NaN;
         var _local_5:Number = NaN;
         var _local_6:Number = NaN;
         while(_arg_3 < 0)
         {
            _arg_3 += HUE_MAX;
         }
         _local_7 = int(int(_arg_3 / 60));
         _local_6 = (_arg_3 - _local_7 * 60) / 60;
         _local_7 %= 6;
         _local_4 = _arg_1 + (_arg_2 - _arg_1) * _local_6;
         _local_5 = _arg_2 - (_arg_2 - _arg_1) * _local_6;
         switch(_local_7)
         {
            case 0:
               return {
                  "r":_arg_2,
                  "g":_local_4,
                  "b":_arg_1
               };
            case 1:
               return {
                  "r":_local_5,
                  "g":_arg_2,
                  "b":_arg_1
               };
            case 2:
               return {
                  "r":_arg_1,
                  "g":_arg_2,
                  "b":_local_4
               };
            case 3:
               return {
                  "r":_arg_1,
                  "g":_local_5,
                  "b":_arg_2
               };
            case 4:
               return {
                  "r":_local_4,
                  "g":_arg_1,
                  "b":_arg_2
               };
            case 5:
               return {
                  "r":_arg_2,
                  "g":_arg_1,
                  "b":_local_5
               };
            default:
               return null;
         }
      }
      
      public static function RGBtoHSV(_arg_1:Number, _arg_2:Number, _arg_3:Number) : Object
      {
         var _local_4:Number = NaN;
         var _local_5:Number = NaN;
         var _local_6:Number = NaN;
         var _local_7:Number = NaN;
         var _local_8:Number = 0;
         _local_5 = Math.max(_arg_1,Math.max(_arg_2,_arg_3));
         _local_4 = Math.min(_arg_1,Math.min(_arg_2,_arg_3));
         if(_local_5 == 0)
         {
            return {
               "h":0,
               "s":0,
               "v":0
            };
         }
         _local_7 = _local_5;
         _local_6 = (_local_5 - _local_4) / _local_5;
         _local_8 = RGBToHue(_arg_1,_arg_2,_arg_3);
         return {
            "h":_local_8,
            "s":_local_6,
            "v":_local_7
         };
      }
      
      public static function HSVtoRGB(_arg_1:Number, _arg_2:Number, _arg_3:Number) : Object
      {
         var _local_4:Number = (1 - _arg_2) * _arg_3;
         return HueToRGB(_local_4,_arg_3,_arg_1);
      }
      
      public static function getAlpha(_arg_1:uint) : uint
      {
         return _arg_1 >> 24 & 0xFF;
      }
      
      public static function HSVtoHSL(_arg_1:Number, _arg_2:Number, _arg_3:Number) : Object
      {
         var _local_4:Object = HSVtoRGB(_arg_1,_arg_2,_arg_3);
         return RGBtoHSL(_local_4.r,_local_4.g,_local_4.b);
      }
      
      public static function getGreen(_arg_1:uint) : uint
      {
         return _arg_1 >> 8 & 0xFF;
      }
      
      public static function getColor24(_arg_1:uint, _arg_2:uint, _arg_3:uint) : uint
      {
         return _arg_1 << 16 | _arg_2 << 8 | _arg_3;
      }
      
      public static function getBlue(_arg_1:uint) : uint
      {
         return _arg_1 & 0xFF;
      }
      
      public static function HSLtoRGB(_arg_1:Number, _arg_2:Number, _arg_3:Number) : Object
      {
         var _local_4:Number = NaN;
         if(_arg_2 < 0.5)
         {
            _local_4 = _arg_3 * _arg_2;
         }
         else
         {
            _local_4 = _arg_3 * (1 - _arg_2);
         }
         return HueToRGB(_arg_2 - _local_4,_arg_2 + _local_4,_arg_1);
      }
      
      public static function getColor32(_arg_1:uint, _arg_2:uint, _arg_3:uint, _arg_4:uint) : uint
      {
         return _arg_1 << 24 | _arg_2 << 16 | _arg_3 << 8 | _arg_4;
      }
      
      private static function center(_arg_1:Number, _arg_2:Number, _arg_3:Number) : Number
      {
         if(_arg_1 > _arg_2 && _arg_1 > _arg_3)
         {
            if(_arg_2 > _arg_3)
            {
               return _arg_2;
            }
            return _arg_3;
         }
         if(_arg_2 > _arg_1 && _arg_2 > _arg_3)
         {
            if(_arg_1 > _arg_3)
            {
               return _arg_1;
            }
            return _arg_3;
         }
         if(_arg_1 > _arg_2)
         {
            return _arg_1;
         }
         return _arg_2;
      }
      
      public static function HSLtoHSV(_arg_1:Number, _arg_2:Number, _arg_3:Number) : Object
      {
         var _local_4:Object = HSLtoRGB(_arg_1,_arg_2,_arg_3);
         return RGBtoHSV(_local_4.r,_local_4.g,_local_4.b);
      }
      
      public static function RGBToHue(_arg_1:Number, _arg_2:Number, _arg_3:Number) : uint
      {
         var _local_4:Number = NaN;
         var _local_5:Number = NaN;
         var _local_6:Number = NaN;
         var _local_7:Number = NaN;
         var _local_8:Number = NaN;
         _local_7 = Math.max(_arg_1,Math.max(_arg_2,_arg_3));
         _local_5 = Math.min(_arg_1,Math.min(_arg_2,_arg_3));
         if(_local_7 - _local_5 == 0)
         {
            return 0;
         }
         _local_6 = center(_arg_1,_arg_2,_arg_3);
         if(_arg_1 == _local_7)
         {
            if(_arg_3 == _local_5)
            {
               _local_8 = 0;
            }
            else
            {
               _local_8 = 5;
            }
         }
         else if(_arg_2 == _local_7)
         {
            if(_arg_3 == _local_5)
            {
               _local_8 = 1;
            }
            else
            {
               _local_8 = 2;
            }
         }
         else if(_arg_1 == _local_5)
         {
            _local_8 = 3;
         }
         else
         {
            _local_8 = 4;
         }
         if(_local_8 % 2 == 0)
         {
            _local_4 = _local_6 - _local_5;
         }
         else
         {
            _local_4 = _local_7 - _local_6;
         }
         _local_4 /= _local_7 - _local_5;
         return 60 * (_local_8 + _local_4);
      }
      
      public static function RGBtoHSL(_arg_1:Number, _arg_2:Number, _arg_3:Number) : Object
      {
         var _local_4:Number = NaN;
         var _local_5:Number = NaN;
         var _local_6:Number = NaN;
         var _local_7:Number = NaN;
         var _local_8:Number = NaN;
         var _local_9:Number = 0;
         _local_5 = Math.max(_arg_1,Math.max(_arg_2,_arg_3));
         _local_4 = Math.min(_arg_1,Math.min(_arg_2,_arg_3));
         _local_7 = (_local_4 + _local_5) * 0.5;
         if(_local_7 == 0)
         {
            return {
               "h":_local_9,
               "l":0,
               "s":1
            };
         }
         _local_6 = (_local_5 - _local_4) * 0.5;
         if(_local_7 < 0.5)
         {
            _local_8 = _local_6 / _local_7;
         }
         else
         {
            _local_8 = _local_6 / (1 - _local_7);
         }
         _local_9 = RGBToHue(_arg_1,_arg_2,_arg_3);
         return {
            "h":_local_9,
            "l":_local_7,
            "s":_local_8
         };
      }
      
      public static function getRed(_arg_1:uint) : uint
      {
         return _arg_1 >> 16 & 0xFF;
      }
   }
}

