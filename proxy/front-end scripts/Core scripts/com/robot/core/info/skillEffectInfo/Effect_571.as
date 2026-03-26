package com.robot.core.info.skillEffectInfo
{
   public class Effect_571 extends AbstractEffectInfo
   {
      
      public function Effect_571()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合后对对手造成" + param1[1] + "点固定伤害 重复使用无法叠加";
      }
   }
}

