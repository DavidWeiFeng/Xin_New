package com.robot.core.info.skillEffectInfo
{
   public class Effect_559 extends AbstractEffectInfo
   {
      
      public function Effect_559()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内若对手使用攻击技能则随机进入烧伤、冻伤、中毒、麻痹、害怕、睡眠中的一种异常状态";
      }
   }
}

