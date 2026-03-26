package com.robot.core.info.skillEffectInfo
{
   public class Effect_505 extends AbstractEffectInfo
   {
      
      public function Effect_505()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若打出致命一击，则造成伤害值的" + param1[0] + "%恢复自身体力 ";
      }
   }
}

