package com.robot.core.info.skillEffectInfo
{
   public class Effect_530 extends AbstractEffectInfo
   {
      
      public function Effect_530()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "使用时若自身体力低于1/" + param1[0] + "则恢复所有体力值";
      }
   }
}

