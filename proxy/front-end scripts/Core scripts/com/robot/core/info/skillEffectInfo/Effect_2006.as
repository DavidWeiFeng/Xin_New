package com.robot.core.info.skillEffectInfo
{
   public class Effect_2006 extends AbstractEffectInfo
   {
      
      public function Effect_2006()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return "命中时，有" + _arg_1[0] + "%的几率增加自身所有技能" + _arg_1[1] + "点PP值";
      }
   }
}

