package gs.easing
{
   public class Elastic
   {
      
      private static const _2PI:Number = Math.PI * 2;
      
      public function Elastic()
      {
         super();
      }
      
      public static function easeIn(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number = 0, _arg_6:Number = 0) : Number
      {
         var _local_7:Number = NaN;
         if(_arg_1 == 0)
         {
            return _arg_2;
         }
         _arg_1 /= _arg_4;
         if(_arg_1 == 1)
         {
            return _arg_2 + _arg_3;
         }
         if(!_arg_6)
         {
            _arg_6 = _arg_4 * 0.3;
         }
         if(!_arg_5 || _arg_5 < Math.abs(_arg_3))
         {
            _arg_5 = _arg_3;
            _local_7 = _arg_6 / 4;
         }
         else
         {
            _local_7 = _arg_6 / _2PI * Math.asin(_arg_3 / _arg_5);
         }
         return -(_arg_5 * Math.pow(2,10 * (_arg_1 = _arg_1 - 1)) * Math.sin((_arg_1 * _arg_4 - _local_7) * _2PI / _arg_6)) + _arg_2;
      }
      
      public static function easeInOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number = 0, _arg_6:Number = 0) : Number
      {
         var _local_7:Number = NaN;
         if(_arg_1 == 0)
         {
            return _arg_2;
         }
         _arg_1 /= _arg_4 / 2;
         if(_arg_1 == 2)
         {
            return _arg_2 + _arg_3;
         }
         if(!_arg_6)
         {
            _arg_6 = _arg_4 * (0.3 * 1.5);
         }
         if(!_arg_5 || _arg_5 < Math.abs(_arg_3))
         {
            _arg_5 = _arg_3;
            _local_7 = _arg_6 / 4;
         }
         else
         {
            _local_7 = _arg_6 / _2PI * Math.asin(_arg_3 / _arg_5);
         }
         if(_arg_1 < 1)
         {
            return -0.5 * (_arg_5 * Math.pow(2,10 * (_arg_1 = _arg_1 - 1)) * Math.sin((_arg_1 * _arg_4 - _local_7) * _2PI / _arg_6)) + _arg_2;
         }
         return _arg_5 * Math.pow(2,-10 * (_arg_1 = _arg_1 - 1)) * Math.sin((_arg_1 * _arg_4 - _local_7) * _2PI / _arg_6) * 0.5 + _arg_3 + _arg_2;
      }
      
      public static function easeOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number = 0, _arg_6:Number = 0) : Number
      {
         var _local_7:Number = NaN;
         if(_arg_1 == 0)
         {
            return _arg_2;
         }
         _arg_1 /= _arg_4;
         if(_arg_1 == 1)
         {
            return _arg_2 + _arg_3;
         }
         if(!_arg_6)
         {
            _arg_6 = _arg_4 * 0.3;
         }
         if(!_arg_5 || _arg_5 < Math.abs(_arg_3))
         {
            _arg_5 = _arg_3;
            _local_7 = _arg_6 / 4;
         }
         else
         {
            _local_7 = _arg_6 / _2PI * Math.asin(_arg_3 / _arg_5);
         }
         return _arg_5 * Math.pow(2,-10 * _arg_1) * Math.sin((_arg_1 * _arg_4 - _local_7) * _2PI / _arg_6) + _arg_3 + _arg_2;
      }
   }
}

