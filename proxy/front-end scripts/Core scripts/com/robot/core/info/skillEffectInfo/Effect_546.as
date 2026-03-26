package com.robot.core.info.skillEffectInfo
{
   public class Effect_546 extends AbstractEffectInfo
   {
      
      public function Effect_546()
      {
         super();
         _argsNum = 7;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length - 1)
         {
            if(param1[_loc3_ + 1] != 0)
            {
               _loc2_ += propDict[_loc3_] + "属性" + param1[_loc3_ + 1] + ",";
            }
            _loc3_++;
         }
         if(_loc2_ != "")
         {
            _loc2_ = _loc2_.substr(0,_loc2_.length - 1);
         }
         return "若对手处于" + statusDict[param1[0]] + "状态则对手" + _loc2_;
      }
   }
}

