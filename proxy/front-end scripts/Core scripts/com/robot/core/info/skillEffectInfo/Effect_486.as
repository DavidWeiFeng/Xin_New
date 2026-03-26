package com.robot.core.info.skillEffectInfo
{
   public class Effect_486 extends AbstractEffectInfo
   {
      
      public function Effect_486()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "下" + param1[0] + "回合若自身选择使用技能则无视对手能力提升状态";
      }
   }
}

