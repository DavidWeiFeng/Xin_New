package com.robot.core.info.skillEffectInfo
{
   public class Effect_526 extends AbstractEffectInfo
   {
      
      public function Effect_526()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内若对手成功使用属性技能则受到" + param1[1] + "点固定伤害";
      }
   }
}

