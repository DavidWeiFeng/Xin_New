package com.robot.core.info.skillEffectInfo
{
   public class Effect_34 extends AbstractEffectInfo
   {
      
      public function Effect_34()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         if(Boolean(_arg_1[0] % 1))
         {
            return "将自身所受伤害的" + _arg_1[0] * 100 + "%反弹给对方";
         }
         return "将自身所受伤害的" + _arg_1[0] + "00%反弹给对方";
      }
   }
}

