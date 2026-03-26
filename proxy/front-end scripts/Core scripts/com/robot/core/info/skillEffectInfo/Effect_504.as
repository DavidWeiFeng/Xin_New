package com.robot.core.info.skillEffectInfo
{
   public class Effect_504 extends AbstractEffectInfo
   {
      
      public function Effect_504()
      {
         super();
         _argsNum = 7;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         var _loc2_:String = "";
         var _loc3_:* = "";
         var _loc4_:String = "";
         var _loc5_:int = 1;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_] != 0)
            {
               _loc3_ = propDict[_loc5_ - 1] + param1[_loc5_] + ",";
               _loc2_ += _loc3_;
            }
            _loc5_++;
         }
         _loc4_ = _loc2_.slice(0,_loc2_.length - 1);
         return param1[0] + "%令对手害怕，若没有触发害怕效果，则对手" + _loc4_;
      }
   }
}

