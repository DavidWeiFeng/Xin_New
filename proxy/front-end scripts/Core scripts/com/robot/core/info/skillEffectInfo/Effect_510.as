package com.robot.core.info.skillEffectInfo
{
   public class Effect_510 extends AbstractEffectInfo
   {
      
      public function Effect_510()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "当对手处于防御能力提升时，恢复" + param1[0] + "点体力值 ";
      }
   }
}

