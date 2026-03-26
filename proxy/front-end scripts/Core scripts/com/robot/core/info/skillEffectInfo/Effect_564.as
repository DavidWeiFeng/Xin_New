package com.robot.core.info.skillEffectInfo
{
   public class Effect_564 extends AbstractEffectInfo
   {
      
      public function Effect_564()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "命中后" + param1[0] + "回合内若对手受到攻击伤害则100%烧伤";
      }
   }
}

