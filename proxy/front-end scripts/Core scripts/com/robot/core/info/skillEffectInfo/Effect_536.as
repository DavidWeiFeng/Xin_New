package com.robot.core.info.skillEffectInfo
{
   public class Effect_536 extends AbstractEffectInfo
   {
      
      public function Effect_536()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "若当次攻击击败对手，恢复对手体力上限1/" + param1[0] + "的体力 ";
      }
   }
}

