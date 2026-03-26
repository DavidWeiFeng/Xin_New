package com.robot.core.utils
{
   public class ArrayUtils
   {
      
      public function ArrayUtils()
      {
         super();
      }
      
      public static function eq(param1:Array, param2:Array) : Boolean
      {
         if(param1 == param2)
         {
            return true;
         }
         if(param1.length != param2.length)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != param2[_loc3_])
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public static function contains(param1:Array, param2:*) : Boolean
      {
         if(getItemIndex(param1,param2) != -1)
         {
            return true;
         }
         return false;
      }
      
      public static function removeDuplicates(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param1[_loc3_] == param1[_loc2_])
               {
                  if(_loc3_ != _loc2_)
                  {
                     param1.splice(_loc3_,1);
                  }
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return param1;
      }
      
      public static function shuffle(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = Math.floor(Math.random() * _loc4_);
            _loc3_ = param1[_loc5_];
            param1[_loc5_] = param1[_loc2_];
            param1[_loc2_] = _loc3_;
            _loc5_++;
         }
         return param1;
      }
      
      public static function remove(param1:Array, param2:*) : *
      {
         var _loc3_:int = getItemIndex(param1,param2);
         if(_loc3_ != -1)
         {
            param1.splice(_loc3_,1);
         }
         return param2;
      }
      
      public static function getItemIndex(param1:Array, param2:*) : int
      {
         var _loc3_:int = int(param1.length);
         while(--_loc3_ > -1)
         {
            if(param1[_loc3_] == param2)
            {
               return _loc3_;
            }
         }
         return -1;
      }
      
      public static function exchangeIndex(param1:Array, param2:uint, param3:uint) : Array
      {
         var _loc4_:Object = null;
         if(param2 != param3)
         {
            _loc4_ = param1[param3];
            param1[param3] = param1[param2];
            param1[param2] = _loc4_;
         }
         return param1;
      }
      
      public static function exchangeItem(param1:Array, param2:Object, param3:Object) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param2 != null && param3 != null)
         {
            _loc4_ = int(param1.indexOf(param2));
            _loc5_ = int(param1.indexOf(param3));
            if(_loc4_ != -1 && _loc5_ != -1)
            {
               param1 = exchangeIndex(param1,_loc4_,_loc5_);
            }
         }
         return param1;
      }
      
      public static function removeAllItem(param1:Array) : void
      {
         while(param1.length > 0)
         {
            param1.shift();
         }
      }
   }
}

