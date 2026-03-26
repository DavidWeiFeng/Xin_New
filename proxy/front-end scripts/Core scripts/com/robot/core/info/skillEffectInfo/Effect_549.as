package com.robot.core.info.skillEffectInfo
{
   public class Effect_549 extends AbstractEffectInfo
   {
      
      public function Effect_549()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "使对手随机进入烧伤、冻伤、中毒、害怕、疲惫、麻痹其中" + param1[0] + "种异常状态";
      }
   }
}

