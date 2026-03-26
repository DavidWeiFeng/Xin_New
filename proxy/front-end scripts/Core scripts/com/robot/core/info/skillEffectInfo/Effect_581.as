package com.robot.core.info.skillEffectInfo
{
   public class Effect_581 extends AbstractEffectInfo
   {
      
      public function Effect_581()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "属性相同时，额外附加" + param1[0] + "点固定伤害";
      }
   }
}

