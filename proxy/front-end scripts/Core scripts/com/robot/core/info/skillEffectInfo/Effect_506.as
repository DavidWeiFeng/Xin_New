package com.robot.core.info.skillEffectInfo
{
   public class Effect_506 extends AbstractEffectInfo
   {
      
      public function Effect_506()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "下回合受到致命伤害时残留" + param1[0] + "点体力 ";
      }
   }
}

