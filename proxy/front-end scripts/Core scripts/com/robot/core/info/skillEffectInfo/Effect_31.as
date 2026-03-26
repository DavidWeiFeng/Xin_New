package com.robot.core.info.skillEffectInfo
{
   public class Effect_31 extends AbstractEffectInfo
   {
      
      public function Effect_31()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         var _local_2:String = null;
         if(_arg_1[0] != _arg_1[1])
         {
            _local_2 = "连续进行" + _arg_1[0] + "~" + _arg_1[1] + "次攻击";
         }
         else
         {
            _local_2 = "连续进行" + _arg_1[0] + "次攻击";
         }
         return _local_2;
      }
   }
}

