package com.robot.core.info.skillEffectInfo
{
   public class Effect_528 extends AbstractEffectInfo
   {
      
      public function Effect_528()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "先出手时" + param1[0] + "回合内不受能力下降技能影响";
      }
   }
}

