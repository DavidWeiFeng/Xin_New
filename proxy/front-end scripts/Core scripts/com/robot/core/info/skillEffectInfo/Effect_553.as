package com.robot.core.info.skillEffectInfo
{
   public class Effect_553 extends AbstractEffectInfo
   {
      
      public function Effect_553()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若打出致命一击则对手" + param1[0] + "%几率" + statusDict[param1[1]];
      }
   }
}

