package com.robot.core.utils
{
   public class BitUtils
   {
      
      public function BitUtils()
      {
         super();
      }
      
      public static function setBit(param1:uint, param2:uint) : uint
      {
         var _loc3_:int = Math.pow(2,param2);
         return _loc3_ | param1;
      }
      
      public static function setBit0(param1:uint, param2:uint) : uint
      {
         var _loc3_:int = Math.pow(2,param2);
         return param1 - _loc3_;
      }
      
      public static function getBit(param1:uint, param2:uint) : uint
      {
         var _loc3_:int = 32;
         var _loc4_:uint = 1;
         var _loc5_:int = 0;
         if(param2 == 0)
         {
            return param1 & _loc4_;
         }
         param1 >>= param2;
         return param1 & _loc4_;
      }
      
      public static function bitToString(param1:uint) : String
      {
         var _loc2_:int = 32;
         var _loc3_:int = 0;
         var _loc4_:String = "";
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = String(param1 & 1) + _loc4_;
            param1 >>= 1;
            _loc3_++;
         }
         return _loc4_;
      }
      
      public static function bitToList(param1:uint) : Array
      {
         var _loc2_:int = 32;
         var _loc3_:int = 0;
         var _loc4_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_[_loc3_] = param1 & 1;
            param1 >>= 1;
            _loc3_++;
         }
         return _loc4_;
      }
      
      public static function getHalfByte(param1:int, param2:int) : int
      {
         return param1 >> param2 * 4 & 0x0F;
      }
   }
}

