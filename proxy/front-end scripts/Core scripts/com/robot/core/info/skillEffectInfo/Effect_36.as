package com.robot.core.info.skillEffectInfo
{
   public class Effect_36 extends AbstractEffectInfo
   {
      
      public function Effect_36()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return "命中时，有" + _arg_1[0] + "%的几率秒杀对方";
      }
   }
}

