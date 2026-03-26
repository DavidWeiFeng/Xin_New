package com.robot.core.info.skillEffectInfo
{
   public class Effect_588 extends AbstractEffectInfo
   {
      
      public function Effect_588()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         var _loc2_:Array = ["攻击","防御","特攻","特防","速度","命中"];
         return "先出手时，" + param1[0] + "%概率使自己" + _loc2_[param1[1]] + "+" + param1[2];
      }
   }
}

