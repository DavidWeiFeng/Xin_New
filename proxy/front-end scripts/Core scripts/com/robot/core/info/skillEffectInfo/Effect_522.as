package com.robot.core.info.skillEffectInfo
{
   public class Effect_522 extends AbstractEffectInfo
   {
      
      public function Effect_522()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内若处于异常状态则受到伤害减少" + param1[1] + "点,睡眠除外";
      }
   }
}

