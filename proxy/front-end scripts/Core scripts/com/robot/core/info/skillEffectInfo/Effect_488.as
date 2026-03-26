package com.robot.core.info.skillEffectInfo
{
   public class Effect_488 extends AbstractEffectInfo
   {
      
      public function Effect_488()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若对手的HP小于" + param1[0] + ",则造成的伤害增加" + param1[1] + "%";
      }
   }
}

