package com.robot.core.info.skillEffectInfo
{
   public class Effect_511 extends AbstractEffectInfo
   {
      
      public function Effect_511()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "%概率威力翻倍 体力低于1/" + param1[1] + "时概率增加" + param1[2] + "%";
      }
   }
}

