package com.robot.core.info.skillEffectInfo
{
   public class Effect_517 extends AbstractEffectInfo
   {
      
      public function Effect_517()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "%概率使对手害怕，每损失" + param1[1] + "%体力，害怕几率提升" + param1[2] + "%";
      }
   }
}

