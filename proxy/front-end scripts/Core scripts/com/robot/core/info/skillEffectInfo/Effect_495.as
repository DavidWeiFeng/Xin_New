package com.robot.core.info.skillEffectInfo
{
   public class Effect_495 extends AbstractEffectInfo
   {
      
      public function Effect_495()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若对手处于" + statusDict[param1[0]] + "状态，则" + param1[1] + "%几率秒杀对手";
      }
   }
}

