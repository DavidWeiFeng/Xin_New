package com.robot.core.info.skillEffectInfo
{
   public class Effect_514 extends AbstractEffectInfo
   {
      
      public function Effect_514()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "附加对手已损失生命值" + param1[0] + "%的固定伤害 ";
      }
   }
}

