package com.robot.core.info.skillEffectInfo
{
   public class Effect_527 extends AbstractEffectInfo
   {
      
      public function Effect_527()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "使用技能时体力低于1/" + param1[0] + ",则" + param1[1] + "回合内免疫异常状态";
      }
   }
}

