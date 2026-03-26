package com.robot.core.info.skillEffectInfo
{
   public class Effect_484 extends AbstractEffectInfo
   {
      
      public function Effect_484()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "连续攻击对手" + param1[0] + "次，每次使用攻击次数+" + param1[1] + ",最大攻击次数" + param1[2] + "次 ";
      }
   }
}

