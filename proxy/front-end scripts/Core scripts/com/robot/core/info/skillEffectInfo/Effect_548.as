package com.robot.core.info.skillEffectInfo
{
   public class Effect_548 extends AbstractEffectInfo
   {
      
      public function Effect_548()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "消除对手能力提升状态，消除成功后恢复体力" + param1[0] + "点体力";
      }
   }
}

