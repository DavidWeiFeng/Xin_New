package com.robot.core.info.skillEffectInfo
{
   public class Effect_520 extends AbstractEffectInfo
   {
      
      public function Effect_520()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "有" + param1[0] + "%的几率使自己害怕";
      }
   }
}

