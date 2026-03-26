package com.robot.core.info.skillEffectInfo
{
   public class Effect_525 extends AbstractEffectInfo
   {
      
      public function Effect_525()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内有" + param1[1] + "%概率免疫对手的攻击伤害";
      }
   }
}

