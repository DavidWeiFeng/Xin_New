package com.robot.core.info.fightInfo.attack
{
   import flash.utils.IDataInput;
   
   public class UseSkillInfo
   {
      
      private var _firstAttackInfo:AttackValue;
      
      private var _secondAttackInfo:AttackValue;
      
      public function UseSkillInfo(_arg_1:IDataInput)
      {
         super();
         this._firstAttackInfo = new AttackValue(_arg_1);
         this._secondAttackInfo = new AttackValue(_arg_1);
      }
      
      public function get firstAttackInfo() : AttackValue
      {
         return this._firstAttackInfo;
      }
      
      public function get secondAttackInfo() : AttackValue
      {
         return this._secondAttackInfo;
      }
   }
}

