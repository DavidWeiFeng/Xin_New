package com.robot.core.info.skillEffectInfo
{
   public class Effect_38 extends AbstractEffectInfo
   {
      
      public function Effect_38()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return "对方的【最大HP】下降" + _arg_1[0] + "点";
      }
   }
}

