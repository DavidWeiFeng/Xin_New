package com.robot.core.info.skillEffectInfo
{
   public class Effect_2001 extends AbstractEffectInfo
   {
      
      public function Effect_2001()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return _arg_1[0] + "回合内，自身受到攻击时，有" + _arg_1[1] + "几率令对方陷入麻痹状态";
      }
   }
}

