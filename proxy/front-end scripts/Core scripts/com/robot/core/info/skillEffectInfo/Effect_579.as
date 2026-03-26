package com.robot.core.info.skillEffectInfo
{
   public class Effect_579 extends AbstractEffectInfo
   {
      
      public function Effect_579()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若当回合未击败对手，则恢复自身最大体力的1/" + param1[0];
      }
   }
}

