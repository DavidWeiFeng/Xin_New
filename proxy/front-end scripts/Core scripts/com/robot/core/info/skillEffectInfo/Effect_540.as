package com.robot.core.info.skillEffectInfo
{
   public class Effect_540 extends AbstractEffectInfo
   {
      
      public function Effect_540()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若后出手则下" + param1[0] + "回合攻击必定致命一击";
      }
   }
}

