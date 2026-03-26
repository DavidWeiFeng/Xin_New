package com.robot.core.info.skillEffectInfo
{
   public class Effect_2004 extends AbstractEffectInfo
   {
      
      public function Effect_2004()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return "对方处于烧伤状态的场合，削减对方相当于其最大生命1/" + _arg_1[0] + "的HP(对Boss效果减半)";
      }
   }
}

