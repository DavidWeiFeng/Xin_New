package com.robot.core.info.skillEffectInfo
{
   public class Effect_562 extends AbstractEffectInfo
   {
      
      public function Effect_562()
      {
         super();
         _argsNum = 7;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         var _loc2_:String = null;
         var _loc3_:Array = param1.slice(0,6);
         _loc2_ = getPropertyStr(_loc3_);
         return "自身" + _loc2_ + "，对手" + statusDict[param1[6]] + "时强化效果翻倍";
      }
   }
}

