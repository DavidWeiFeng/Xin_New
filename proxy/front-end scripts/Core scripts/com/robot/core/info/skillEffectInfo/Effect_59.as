package com.robot.core.info.skillEffectInfo
{
   public class Effect_59 extends AbstractEffectInfo
   {
      
      private var a:Array = ["攻击","防御","特攻","特防","速度","命中"];
      
      public function Effect_59()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         var _loc2_:uint = uint(param1[0]);
         var _loc3_:uint = uint(param1[1]);
         return "消耗自身全部体力(体力降到0), 使下一只出战精灵的" + this.a[_loc2_] + "和" + this.a[_loc3_] + "能力提升1个等级";
      }
   }
}

