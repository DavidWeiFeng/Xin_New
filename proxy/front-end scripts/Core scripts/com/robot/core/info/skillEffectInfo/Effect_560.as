package com.robot.core.info.skillEffectInfo
{
   public class Effect_560 extends AbstractEffectInfo
   {
      
      public function Effect_560()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "下回合其他攻击技能附加" + param1[0] + "点固定伤害";
      }
   }
}

