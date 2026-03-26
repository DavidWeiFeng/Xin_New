package com.robot.core.info.skillEffectInfo
{
   public class Effect_16 extends AbstractEffectInfo
   {
      
      public function Effect_16()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return "命中时，有" + _arg_1[0] + "%几率令对方陷入睡眠状态";
      }
   }
}

