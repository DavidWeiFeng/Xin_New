package com.robot.core.info.skillEffectInfo
{
   public class Effect_483 extends AbstractEffectInfo
   {
      
      public function Effect_483()
      {
         super();
         _argsNum = 6;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         var _loc2_:int = 0;
         var _loc3_:Array = ["攻击等级","防御等级","特攻等级","特防等级","速度等级","命中等级"];
         var _loc4_:String = "对手";
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            if(param1[_loc2_] < 0)
            {
               _loc4_ += _loc3_[_loc2_] + String(param1[_loc2_]) + ",";
            }
            _loc2_++;
         }
         return _loc4_ + "后出手时弱化效果翻倍";
      }
   }
}

