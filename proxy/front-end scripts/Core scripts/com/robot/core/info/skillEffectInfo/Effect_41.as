package com.robot.core.info.skillEffectInfo
{
   public class Effect_41 extends AbstractEffectInfo
   {
      
      public function Effect_41()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         var _local_2:String = null;
         if(_arg_1[0] != _arg_1[1])
         {
            _local_2 = _arg_1[0] + "~" + _arg_1[1] + "回合内，我方受到的所有火系伤害减少50%";
         }
         else
         {
            _local_2 = _arg_1[0] + "回合内，我方受到的所有火系伤害减少50%";
         }
         return _local_2;
      }
   }
}

