package com.robot.core.info.skillEffectInfo
{
   public class Effect_576 extends AbstractEffectInfo
   {
      
      public function Effect_576()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内免疫低于" + param1[1] + "的攻击伤害";
      }
   }
}

