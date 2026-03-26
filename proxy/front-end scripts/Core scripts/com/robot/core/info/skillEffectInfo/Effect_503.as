package com.robot.core.info.skillEffectInfo
{
   public class Effect_503 extends AbstractEffectInfo
   {
      
      public function Effect_503()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若造成的伤害不足" + param1[0] + "，则回合结束时对手损失" + param1[1] + "点固定体力";
      }
   }
}

