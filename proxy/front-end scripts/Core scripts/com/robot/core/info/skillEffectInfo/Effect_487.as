package com.robot.core.info.skillEffectInfo
{
   public class Effect_487 extends AbstractEffectInfo
   {
      
      public function Effect_487()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若对手的体力大于" + param1[0] + ",则每次使用自身攻击+" + param1[1];
      }
   }
}

