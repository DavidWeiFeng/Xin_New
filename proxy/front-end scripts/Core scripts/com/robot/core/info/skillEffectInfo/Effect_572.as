package com.robot.core.info.skillEffectInfo
{
   public class Effect_572 extends AbstractEffectInfo
   {
      
      public function Effect_572()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "攻击对手时若对手处于" + statusDict[param1[0]] + "状态，则" + param1[1] + "%使对手" + statusDict[param1[2]];
      }
   }
}

