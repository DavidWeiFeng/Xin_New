package com.robot.core.info.skillEffectInfo
{
   public class Effect_578 extends AbstractEffectInfo
   {
      
      public function Effect_578()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内对手所有属性技能命中率减少" + param1[1] + "%";
      }
   }
}

