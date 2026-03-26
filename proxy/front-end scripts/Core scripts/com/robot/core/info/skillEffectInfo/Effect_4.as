package com.robot.core.info.skillEffectInfo
{
   public class Effect_4 extends AbstractEffectInfo
   {
      
      public function Effect_4()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         if(_arg_1[1] != 100)
         {
            if(_arg_1[2] > 0)
            {
               return _arg_1[1] + "%几率令自身的" + propDict[_arg_1[0]] + "等级+" + _arg_1[2];
            }
            return _arg_1[1] + "%几率令自身的" + propDict[_arg_1[0]] + "等级" + _arg_1[2];
         }
         if(_arg_1[2] > 0)
         {
            return "令自身的" + propDict[_arg_1[0]] + "等级+" + _arg_1[2];
         }
         return "令自身的" + propDict[_arg_1[0]] + "等级" + _arg_1[2];
      }
   }
}

