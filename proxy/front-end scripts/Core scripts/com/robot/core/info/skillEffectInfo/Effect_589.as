package com.robot.core.info.skillEffectInfo
{
   public class Effect_589 extends AbstractEffectInfo
   {
      
      public function Effect_589()
      {
         super();
         _argsNum = 6;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         var _loc2_:* = "复制对手";
         var _loc3_:Array = ["攻击","防御","特攻","特防","速度","命中"];
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         while(_loc5_ < 6)
         {
            if(int(param1[_loc5_]) > 0)
            {
               if(_loc4_)
               {
                  _loc2_ += ",";
               }
               _loc4_ = true;
               _loc2_ += _loc3_[_loc5_];
            }
            _loc5_++;
         }
         return _loc2_ + "的能力上升状态";
      }
   }
}

