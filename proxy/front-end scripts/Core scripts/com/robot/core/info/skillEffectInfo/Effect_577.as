package com.robot.core.info.skillEffectInfo
{
   public class Effect_577 extends AbstractEffectInfo
   {
      
      public function Effect_577()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "自身处于能力提升状态时，使对手" + propDict[param1[0]] + "能力" + param1[1];
      }
   }
}

