package com.robot.core.info.skillEffectInfo
{
   public class Effect_535 extends AbstractEffectInfo
   {
      
      public function Effect_535()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内若受到攻击则自身防御+1 特防+1";
      }
   }
}

