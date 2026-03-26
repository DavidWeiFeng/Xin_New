package com.robot.core.info.skillEffectInfo
{
   public class Effect_67 extends AbstractEffectInfo
   {
      
      public function Effect_67()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         return "直接击败对方出战精灵时，削减对方下1只出战精灵相当于其[最大体力]1/" + _arg_1[0] + "的HP";
      }
   }
}

