package com.robot.core.info.skillEffectInfo
{
   public class Effect_500 extends AbstractEffectInfo
   {
      
      public function Effect_500()
      {
         super();
         _argsNum = 0;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若对手处于害怕状态则伤害翻倍";
      }
   }
}

