package com.robot.core.info.skillEffectInfo
{
   public class Effect_586 extends AbstractEffectInfo
   {
      
      public function Effect_586()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内自己的属性攻击必中";
      }
   }
}

