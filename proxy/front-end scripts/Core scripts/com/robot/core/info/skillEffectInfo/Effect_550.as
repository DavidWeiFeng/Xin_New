package com.robot.core.info.skillEffectInfo
{
   public class Effect_550 extends AbstractEffectInfo
   {
      
      public function Effect_550()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         if(param1[0] == 1)
         {
            return "若自身处于异常状态则恢复所有体力";
         }
         return "若自身处于异常状态则恢复1/" + param1[0] + "体力";
      }
   }
}

