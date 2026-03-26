package com.robot.core.info.skillEffectInfo
{
   public class Effect_2009 extends AbstractEffectInfo
   {
      
      public function Effect_2009()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         if(_arg_1[1] == 1)
         {
            return "对方每持有1个能力下降和异常状态，该技能的[威力]提升" + _arg_1[0];
         }
         return "对方每持有1个能力下降，该技能的[威力]提升" + _arg_1[0];
      }
   }
}

