package gs.easing
{
   public class Expo
   {
      
      public function Expo()
      {
         super();
      }
      
      public static function easeOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number) : Number
      {
         return _arg_1 == _arg_4 ? _arg_2 + _arg_3 : _arg_3 * (-Math.pow(2,-10 * _arg_1 / _arg_4) + 1) + _arg_2;
      }
      
      public static function easeIn(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number) : Number
      {
         return _arg_1 == 0 ? _arg_2 : _arg_3 * Math.pow(2,10 * (_arg_1 / _arg_4 - 1)) + _arg_2 - _arg_3 * 0.001;
      }
      
      public static function easeInOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number) : Number
      {
         if(_arg_1 == 0)
         {
            return _arg_2;
         }
         if(_arg_1 == _arg_4)
         {
            return _arg_2 + _arg_3;
         }
         _arg_1 /= _arg_4 / 2;
         if(_arg_1 < 1)
         {
            return _arg_3 / 2 * Math.pow(2,10 * (_arg_1 - 1)) + _arg_2;
         }
         return _arg_3 / 2 * (-Math.pow(2,-10 * --_arg_1) + 2) + _arg_2;
      }
   }
}

