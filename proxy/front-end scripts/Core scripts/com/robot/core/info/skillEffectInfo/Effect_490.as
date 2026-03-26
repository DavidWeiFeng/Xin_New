package com.robot.core.info.skillEffectInfo
{
   public class Effect_490 extends AbstractEffectInfo
   {
      
      public function Effect_490()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "造成的伤害大于" + param1[0] + ",，则对自身" + propDict[param1[1]] + "+" + param1[2];
      }
   }
}

