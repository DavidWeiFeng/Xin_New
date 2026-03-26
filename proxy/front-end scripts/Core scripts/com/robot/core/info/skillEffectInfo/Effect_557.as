package com.robot.core.info.skillEffectInfo
{
   public class Effect_557 extends AbstractEffectInfo
   {
      
      public function Effect_557()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内若对手使用天生先制等级＞0的技能则命中前" + param1[1] + "%令对手" + statusDict[param1[2]];
      }
   }
}

