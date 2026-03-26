package com.robot.core.info.skillEffectInfo
{
   public class Effect_499 extends AbstractEffectInfo
   {
      
      public function Effect_499()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "后出手时下回合所有技能先制+" + param1[0];
      }
   }
}

