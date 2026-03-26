package com.robot.core.info.skillEffectInfo
{
   public class Effect_29 extends AbstractEffectInfo
   {
      
      public function Effect_29()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return "额外附加" + _arg_1[0] + "点[固定伤害]";
      }
   }
}

