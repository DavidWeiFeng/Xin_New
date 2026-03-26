package com.robot.core.info.skillEffectInfo
{
   public class Effect_580 extends AbstractEffectInfo
   {
      
      public function Effect_580()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内自身受到直接攻击伤害的" + param1[1] + "%反馈给对手";
      }
   }
}

