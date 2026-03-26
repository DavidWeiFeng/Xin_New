package com.robot.core.info.skillEffectInfo
{
   public class Effect_49 extends AbstractEffectInfo
   {
      
      public function Effect_49()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return "令下次攻击对自身造成的伤害减少" + _arg_1[0] + "点";
      }
   }
}

