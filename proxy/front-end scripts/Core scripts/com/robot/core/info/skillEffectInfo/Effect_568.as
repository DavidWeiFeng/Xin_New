package com.robot.core.info.skillEffectInfo
{
   public class Effect_568 extends AbstractEffectInfo
   {
      
      public function Effect_568()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "解除自身能力下降状态，若解除成功则" + param1[0] + "回合内躲避所有攻击 ";
      }
   }
}

