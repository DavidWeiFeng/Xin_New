package com.robot.core.info.skillEffectInfo
{
   public class Effect_491 extends AbstractEffectInfo
   {
      
      public function Effect_491()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内对手造成的伤害降低" + param1[1] + "%";
      }
   }
}

