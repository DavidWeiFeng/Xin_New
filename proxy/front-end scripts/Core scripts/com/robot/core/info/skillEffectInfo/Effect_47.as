package com.robot.core.info.skillEffectInfo
{
   public class Effect_47 extends AbstractEffectInfo
   {
      
      public function Effect_47()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return _arg_1[0] + "回合内，自身免疫能力下降效果";
      }
   }
}

