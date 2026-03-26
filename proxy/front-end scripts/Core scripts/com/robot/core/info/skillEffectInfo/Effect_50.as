package com.robot.core.info.skillEffectInfo
{
   public class Effect_50 extends AbstractEffectInfo
   {
      
      public function Effect_50()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return _arg_1[0] + "回合内，自身受到[物理攻击]伤害减少50%";
      }
   }
}

