package com.robot.core.info.skillEffectInfo
{
   public class Effect_570 extends AbstractEffectInfo
   {
      
      public function Effect_570()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "免疫下" + param1[0] + "次受到的攻击";
      }
   }
}

