package com.robot.core.info.skillEffectInfo
{
   public class Effect_566 extends AbstractEffectInfo
   {
      
      public function Effect_566()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "攻击时忽略对手" + param1[0] + "%的防御值";
      }
   }
}

