package com.robot.core.info.skillEffectInfo
{
   public class Effect_547 extends AbstractEffectInfo
   {
      
      public function Effect_547()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "使敌我双方同时" + statusDict[param1[0]] + param1[1] + "回合";
      }
   }
}

