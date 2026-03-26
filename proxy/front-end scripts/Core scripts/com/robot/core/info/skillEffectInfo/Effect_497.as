package com.robot.core.info.skillEffectInfo
{
   public class Effect_497 extends AbstractEffectInfo
   {
      
      public function Effect_497()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "附加" + param1[0] + "点固定伤害，每次使用额外附加" + param1[1] + "点，最高" + param1[2] + "点，遇到天敌时效果翻倍";
      }
   }
}

