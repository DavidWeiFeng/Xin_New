package com.robot.core.info.skillEffectInfo
{
   public class Effect_542 extends AbstractEffectInfo
   {
      
      public function Effect_542()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "对手每处于一种能力下降状态时附加" + param1[0] + "点固定伤害";
      }
   }
}

