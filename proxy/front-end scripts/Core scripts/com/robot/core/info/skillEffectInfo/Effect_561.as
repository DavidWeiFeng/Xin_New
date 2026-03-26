package com.robot.core.info.skillEffectInfo
{
   public class Effect_561 extends AbstractEffectInfo
   {
      
      public function Effect_561()
      {
         super();
         _argsNum = 0;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "先出手时当回合对手使用技能后若自身体力为0，则令自身体力等于最大体力";
      }
   }
}

