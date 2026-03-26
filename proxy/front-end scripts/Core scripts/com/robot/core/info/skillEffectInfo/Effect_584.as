package com.robot.core.info.skillEffectInfo
{
   public class Effect_584 extends AbstractEffectInfo
   {
      
      public function Effect_584()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内自己的所有攻击技能都附有" + param1[1] + "%的秒杀概率";
      }
   }
}

