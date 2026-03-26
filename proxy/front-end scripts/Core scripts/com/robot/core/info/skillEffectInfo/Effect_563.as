package com.robot.core.info.skillEffectInfo
{
   public class Effect_563 extends AbstractEffectInfo
   {
      
      public function Effect_563()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "命中后" + param1[0] + "回合内若对手受到特攻伤害则100%烧伤";
      }
   }
}

