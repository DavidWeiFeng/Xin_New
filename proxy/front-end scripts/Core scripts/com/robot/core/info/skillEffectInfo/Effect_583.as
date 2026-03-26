package com.robot.core.info.skillEffectInfo
{
   public class Effect_583 extends AbstractEffectInfo
   {
      
      public function Effect_583()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "使对手随机的" + param1[0] + "个技能的PP值归零";
      }
   }
}

