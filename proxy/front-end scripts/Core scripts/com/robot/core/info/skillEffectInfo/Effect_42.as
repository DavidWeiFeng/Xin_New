package com.robot.core.info.skillEffectInfo
{
   public class Effect_42 extends AbstractEffectInfo
   {
      
      public function Effect_42()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         var _local_2:String = null;
         if(_arg_1[0] != _arg_1[1])
         {
            _local_2 = _arg_1[0] + "~" + _arg_1[1] + "回合内，自身的电招式伤害提升100%";
         }
         else
         {
            _local_2 = _arg_1[0] + "回合内，自身的电招式伤害提升100%";
         }
         return _local_2;
      }
   }
}

