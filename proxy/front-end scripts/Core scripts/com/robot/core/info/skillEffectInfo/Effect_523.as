package com.robot.core.info.skillEffectInfo
{
   public class Effect_523 extends AbstractEffectInfo
   {
      
      public function Effect_523()
      {
         super();
         _argsNum = 6;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         var _loc2_:* = "";
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_] == 1)
            {
               _loc2_ = propDict[_loc4_] + "+" + param1[_loc4_] + "、";
               _loc3_ += _loc2_;
            }
            _loc4_++;
         }
         _loc3_ = _loc3_.slice(0,_loc3_.length - 1);
         return "若当回合未击败对手，则自身" + _loc3_;
      }
   }
}

