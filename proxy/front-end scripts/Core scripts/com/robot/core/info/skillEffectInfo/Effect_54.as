package com.robot.core.info.skillEffectInfo
{
   public class Effect_54 extends AbstractEffectInfo
   {
      
      public function Effect_54()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         if(_arg_1[1] == 2)
         {
            return _arg_1[0] + "回合内，令对方的攻击伤害变为50%";
         }
         if(_arg_1[1] == 4)
         {
            return _arg_1[0] + "回合内，令对方的攻击伤害变为25%";
         }
         if(_arg_1[1] == 5)
         {
            return _arg_1[0] + "回合内，令对方的攻击伤害变为20%";
         }
         return _arg_1[0] + "回合内，令对方的攻击伤害变为1/" + _arg_1[1];
      }
   }
}

