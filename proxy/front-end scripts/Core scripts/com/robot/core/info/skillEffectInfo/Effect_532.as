package com.robot.core.info.skillEffectInfo
{
   public class Effect_532 extends AbstractEffectInfo
   {
      
      public function Effect_532()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内每回合使用技能恢复自身最大体力的1/" + param1[1] + "并造成等量百分比伤害";
      }
   }
}

