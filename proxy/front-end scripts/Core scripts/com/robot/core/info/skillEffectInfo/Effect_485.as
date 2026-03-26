package com.robot.core.info.skillEffectInfo
{
   public class Effect_485 extends AbstractEffectInfo
   {
      
      public function Effect_485()
      {
         super();
         _argsNum = 0;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "消除对手能力提升状态，消除成功则恢复自身所有体力";
      }
   }
}

