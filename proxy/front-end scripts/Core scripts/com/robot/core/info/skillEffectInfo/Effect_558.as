package com.robot.core.info.skillEffectInfo
{
   public class Effect_558 extends AbstractEffectInfo
   {
      
      public function Effect_558()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若自身不处于能力提升或下降状态时则恢复" + param1[0] + "点体力";
      }
   }
}

