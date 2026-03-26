package com.robot.core.info.skillEffectInfo
{
   public class Effect_498 extends AbstractEffectInfo
   {
      
      public function Effect_498()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内致命一击几率上升1/" + param1[1];
      }
   }
}

