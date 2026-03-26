package com.robot.core.info.skillEffectInfo
{
   public class Effect_519 extends AbstractEffectInfo
   {
      
      public function Effect_519()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内自身每处于一种能力强化或弱化状态时都会回复" + param1[1] + "点体力";
      }
   }
}

