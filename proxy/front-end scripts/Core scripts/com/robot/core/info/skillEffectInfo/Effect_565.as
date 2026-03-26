package com.robot.core.info.skillEffectInfo
{
   public class Effect_565 extends AbstractEffectInfo
   {
      
      public function Effect_565()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "先出手时恢复1/" + param1[0] + "体力";
      }
   }
}

