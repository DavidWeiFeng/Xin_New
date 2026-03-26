package com.robot.core.info.skillEffectInfo
{
   public class Effect_515 extends AbstractEffectInfo
   {
      
      public function Effect_515()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "自身处于能力下降状态时附加" + param1[0] + "点固定伤害，并解除这些能力下降状态";
      }
   }
}

