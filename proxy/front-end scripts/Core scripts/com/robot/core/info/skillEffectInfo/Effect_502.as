package com.robot.core.info.skillEffectInfo
{
   public class Effect_502 extends AbstractEffectInfo
   {
      
      public function Effect_502()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内所有直接攻击都将降低对手1/" + param1[1] + "的HP";
      }
   }
}

