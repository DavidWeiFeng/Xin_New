package com.robot.core.info.skillEffectInfo
{
   public class Effect_2007 extends AbstractEffectInfo
   {
      
      public function Effect_2007()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return "命中时，吸取对方所有技能" + _arg_1[0] + "点PP值";
      }
   }
}

