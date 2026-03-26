package com.robot.core.info.skillEffectInfo
{
   public class Effect_21 extends AbstractEffectInfo
   {
      
      public function Effect_21()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         var _local_2:String = null;
         if(_arg_1[0] != _arg_1[1])
         {
            _local_2 = _arg_1[0] + "~" + _arg_1[1] + "回合内，将自身所受伤害的1/" + _arg_1[2] + "反弹给对方";
         }
         else
         {
            _local_2 = _arg_1[0] + "回合内，将自身所受伤害的1/" + _arg_1[2] + "反弹给对方";
         }
         return _local_2;
      }
   }
}

