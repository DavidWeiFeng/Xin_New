package com.robot.core.info.skillEffectInfo
{
   public class Effect_492 extends AbstractEffectInfo
   {
      
      public function Effect_492()
      {
         super();
         _argsNum = 5;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return "2回合内对方使用属性技能，则自身立刻恢复1/3生命值且防御+1特防+1";
      }
   }
}

