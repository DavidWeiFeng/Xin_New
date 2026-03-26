package org.taomee.utils
{
   public class MathUtil
   {
      
      public function MathUtil()
      {
         super();
      }
      
      public static function randomHalfAdd(_arg_1:Number) : Number
      {
         return _arg_1 + Math.random() * (_arg_1 / 2);
      }
      
      public static function randomHalve(_arg_1:Number) : Number
      {
         return _arg_1 - Math.random() * (_arg_1 / 2);
      }
      
      public static function randomRegion(_arg_1:Number, _arg_2:Number) : Number
      {
         return _arg_1 + Math.random() * (_arg_2 - _arg_1);
      }
   }
}

