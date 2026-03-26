package com.robot.core.info.skillEffectInfo
{
   public class Effect_507 extends AbstractEffectInfo
   {
      
      public function Effect_507()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "下回合若受到的伤害大于" + param1[0] + "，则恢复自身所有体力 ";
      }
   }
}

