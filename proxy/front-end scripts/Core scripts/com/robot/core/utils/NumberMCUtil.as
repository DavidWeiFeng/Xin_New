package com.robot.core.utils
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class NumberMCUtil
   {
      
      public static const MC_NUM_ORDER_1:String = "0-1-2-3-4-5-6-7-8-9";
      
      public static const MC_NUM_ORDER_2:String = "9-8-7-6-5-4-3-2-1-0";
      
      public static const MC_NUM_ORDER_3:String = "1-2-3-4-5-6-7-8-9-0";
      
      public function NumberMCUtil()
      {
         super();
      }
      
      public static function type0_9(param1:MovieClip, param2:int = -1) : void
      {
         if(param2 == -1)
         {
            param1.gotoAndStop(11);
         }
         else
         {
            param2 = param2 > 9 ? 9 : param2;
            param2 = param2 < 0 ? 0 : param2;
            param1.gotoAndStop(param2 + 1);
         }
      }
      
      private static function type9_0(param1:MovieClip, param2:int) : void
      {
         param2 = param2 > 9 ? 9 : param2;
         param2 = param2 < 0 ? 0 : param2;
         param1.gotoAndStop(10 - param2);
      }
      
      public static function type1_9_0(param1:MovieClip, param2:int) : void
      {
         param2 = param2 > 9 ? 9 : param2;
         param2 = param2 < 0 ? 0 : param2;
         if(param2 == 0)
         {
            param2 = 10;
         }
         param1.gotoAndStop(param2);
      }
      
      public static function updateNumbers(param1:Vector.<MovieClip>, param2:int, param3:String, param4:Boolean = true, param5:Boolean = false) : void
      {
         var _loc6_:MovieClip = null;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = String(param2);
         if(param4)
         {
            _loc10_ = param1.length - _loc12_.length;
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc12_ = "0" + _loc12_;
               _loc11_++;
            }
         }
         for each(_loc6_ in param1)
         {
            if(param3 == MC_NUM_ORDER_1)
            {
               type0_9(_loc6_);
            }
            else if(param3 == MC_NUM_ORDER_2)
            {
               type9_0(_loc6_,0);
            }
            else if(param3 == MC_NUM_ORDER_3)
            {
               type1_9_0(_loc6_,0);
            }
            if(param5)
            {
               _loc6_.visible = false;
            }
         }
         _loc7_ = false;
         _loc9_ = 0;
         while(_loc9_ < param1.length && _loc9_ < _loc12_.length)
         {
            _loc8_ = uint(int(_loc12_.charAt(_loc9_)));
            if(param3 == MC_NUM_ORDER_1)
            {
               type0_9(param1[_loc9_],_loc8_);
               param1[_loc9_].visible = true;
            }
            else if(param3 == MC_NUM_ORDER_2)
            {
               type9_0(param1[_loc9_],_loc8_);
               param1[_loc9_].visible = true;
            }
            else if(param3 == MC_NUM_ORDER_3)
            {
               type1_9_0(param1[_loc9_],_loc8_);
               param1[_loc9_].visible = true;
            }
            if(param5)
            {
               if(_loc8_ != 0 && _loc7_ == false)
               {
                  _loc7_ = true;
               }
               if(!_loc7_ && _loc8_ == 0 && _loc9_ != _loc12_.length - 1)
               {
                  param1[_loc9_].visible = false;
               }
            }
            _loc9_++;
         }
      }
      
      public static function middleNumsByVisible(param1:Point, param2:int, param3:Vector.<MovieClip>) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:MovieClip = null;
         var _loc9_:int = 0;
         for each(_loc4_ in param3)
         {
            if(_loc4_.visible)
            {
               _loc9_++;
            }
         }
         _loc5_ = _loc9_ * param2;
         _loc6_ = param1.x - _loc5_ * 0.5;
         _loc7_ = 0;
         for each(_loc8_ in param3)
         {
            if(_loc8_.visible)
            {
               _loc8_.x = _loc6_ + _loc7_ * param2;
               _loc7_++;
            }
         }
      }
   }
}

