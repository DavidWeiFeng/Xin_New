package com.robot.core.info.skillEffectInfo
{
   public class Effect_524 extends AbstractEffectInfo
   {
      
      public function Effect_524()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内若被对手击败则对手疲惫" + param1[1] + "回合 ";
      }
   }
}

