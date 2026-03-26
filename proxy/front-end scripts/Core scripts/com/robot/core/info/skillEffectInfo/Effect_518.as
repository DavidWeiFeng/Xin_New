package com.robot.core.info.skillEffectInfo
{
   public class Effect_518 extends AbstractEffectInfo
   {
      
      public function Effect_518()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若伤害高于" + param1[0] + "，则自身" + propDict[param1[1]] + "+" + param1[2];
      }
   }
}

