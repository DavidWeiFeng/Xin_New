package com.robot.core.info.skillEffectInfo
{
   public class Effect_555 extends AbstractEffectInfo
   {
      
      public function Effect_555()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若打出致命一击则自身" + param1[0] + "回合内免疫异常状态";
      }
   }
}

