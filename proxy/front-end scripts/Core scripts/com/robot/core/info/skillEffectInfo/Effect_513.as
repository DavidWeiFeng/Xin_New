package com.robot.core.info.skillEffectInfo
{
   public class Effect_513 extends AbstractEffectInfo
   {
      
      public function Effect_513()
      {
         super();
         _argsNum = 0;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "处在烧伤、中毒、冻伤状态时威力翻倍，命中后解除这些异常状态 ";
      }
   }
}

