package com.robot.core.info.skillEffectInfo
{
   public class Effect_574 extends AbstractEffectInfo
   {
      
      public function Effect_574()
      {
         super();
         _argsNum = 0;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "消耗自身全部体力，令己方下次使用的技能必定先手、必定命中，下次命中的攻击技能必定打出致命一击";
      }
   }
}

