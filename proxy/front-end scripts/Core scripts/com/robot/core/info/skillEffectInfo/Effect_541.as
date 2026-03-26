package com.robot.core.info.skillEffectInfo
{
   public class Effect_541 extends AbstractEffectInfo
   {
      
      public function Effect_541()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "造成的攻击伤害若低于" + param1[0] + "则恢复自身" + param1[1] + "点体力";
      }
   }
}

