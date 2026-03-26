package com.robot.core.info.skillEffectInfo
{
   public class Effect_489 extends AbstractEffectInfo
   {
      
      public function Effect_489()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若自身处于能力提升状态，则每次攻击恢复自身体力的1/" + param1[0];
      }
   }
}

