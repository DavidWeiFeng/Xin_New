package gs.easing
{
   public class Sine
   {
      
      private static const _HALF_PI:Number = Math.PI / 2;
      
      public function Sine()
      {
         super();
      }
      
      public static function easeOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number) : Number
      {
         return _arg_3 * Math.sin(_arg_1 / _arg_4 * _HALF_PI) + _arg_2;
      }
      
      public static function easeIn(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number) : Number
      {
         return -_arg_3 * Math.cos(_arg_1 / _arg_4 * _HALF_PI) + _arg_3 + _arg_2;
      }
      
      public static function easeInOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number) : Number
      {
         return -_arg_3 / 2 * (Math.cos(Math.PI * _arg_1 / _arg_4) - 1) + _arg_2;
      }
   }
}

