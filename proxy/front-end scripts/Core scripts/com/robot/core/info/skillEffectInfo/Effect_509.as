package com.robot.core.info.skillEffectInfo
{
   public class Effect_509 extends AbstractEffectInfo
   {
      
      public function Effect_509()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "恢复当前受损体力值1/" + param1[0] + "的体力 ";
      }
   }
}

