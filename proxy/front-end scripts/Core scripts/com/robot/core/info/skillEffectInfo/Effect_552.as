package com.robot.core.info.skillEffectInfo
{
   public class Effect_552 extends AbstractEffectInfo
   {
      
      public function Effect_552()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若对手处于异常状态，则" + param1[0] + "%几率附加" + param1[1] + "点伤害";
      }
   }
}

