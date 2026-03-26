package com.robot.core.info.skillEffectInfo
{
   public class Effect_516 extends AbstractEffectInfo
   {
      
      public function Effect_516()
      {
         super();
         _argsNum = 7;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         var _loc2_:* = null;
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < 6)
         {
            if(param1[_loc4_] != 0)
            {
               _loc2_ = propDict[_loc4_] + "+" + param1[_loc4_] + ",";
               _loc3_ += _loc2_;
            }
            _loc4_++;
         }
         return _loc3_ + "体力值低于1/" + param1[6] + "时强化效果翻倍";
      }
   }
}

