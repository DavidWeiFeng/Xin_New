package com.robot.core.info.skillEffectInfo
{
   public class Effect_493 extends AbstractEffectInfo
   {
      
      public function Effect_493()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "2回合内若对方使用攻击技能则自身下2回合必定暴击 ";
      }
   }
}

