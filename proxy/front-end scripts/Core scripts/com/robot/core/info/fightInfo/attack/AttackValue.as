package com.robot.core.info.fightInfo.attack
{
   import com.robot.core.info.pet.PetSkillInfo;
   import flash.utils.IDataInput;
   
   public class AttackValue
   {
      
      private var _userID:uint;
      
      private var _skillID:uint;
      
      private var _atkTimes:uint;
      
      private var _lostHP:uint;
      
      private var _gainHP:int;
      
      private var _remainHp:int;
      
      private var _maxHp:uint;
      
      private var _isCrit:uint;
      
      private var _status:Array;
      
      private var _state:uint;
      
      private var _battleLv:Array;
      
      private var _skillInfoArray:Array;
      
      private var _Offensive:Number;
      
      public function AttackValue(_arg_1:IDataInput)
      {
         var skillinfo:PetSkillInfo = null;
         var _local_2:uint = 0;
         var _local_3:uint = 0;
         var _local_5:uint = 0;
         var j:uint = 0;
         this._status = [];
         this._battleLv = [];
         this._skillInfoArray = [];
         super();
         this._userID = _arg_1.readUnsignedInt();
         this._skillID = _arg_1.readUnsignedInt();
         this._atkTimes = _arg_1.readUnsignedInt();
         this._lostHP = _arg_1.readUnsignedInt();
         this._gainHP = _arg_1.readInt();
         this._remainHp = _arg_1.readInt();
         this._maxHp = _arg_1.readUnsignedInt();
         this._state = _arg_1.readUnsignedInt();
         var skilllen:uint = uint(_arg_1.readUnsignedInt());
         while(_local_5 < skilllen)
         {
            skillinfo = new PetSkillInfo(_arg_1);
            this._skillInfoArray.push(skillinfo);
            _local_5++;
         }
         this._isCrit = _arg_1.readUnsignedInt();
         _local_5 = 0;
         while(_local_5 < 20)
         {
            this._status.push(_arg_1.readByte());
            _local_5++;
         }
         j = 0;
         while(j < 6)
         {
            this._battleLv.push(_arg_1.readByte());
            j++;
         }
         this._Offensive = _arg_1.readFloat();
      }
      
      public function get Offensive() : Number
      {
         return this._Offensive;
      }
      
      public function get skillInfoArray() : Array
      {
         return this._skillInfoArray;
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get skillID() : uint
      {
         return this._skillID;
      }
      
      public function get lostHP() : uint
      {
         return this._lostHP;
      }
      
      public function get gainHP() : int
      {
         return this._gainHP;
      }
      
      public function get remainHP() : int
      {
         return this._remainHp;
      }
      
      public function get isCrit() : Boolean
      {
         return this._isCrit == 1;
      }
      
      public function get atkTimes() : uint
      {
         return this._atkTimes;
      }
      
      public function get status() : Array
      {
         return this._status;
      }
      
      public function get maxHp() : uint
      {
         return this._maxHp;
      }
      
      public function get state() : uint
      {
         return this._state;
      }
      
      public function get battleLv() : Array
      {
         return this._battleLv;
      }
   }
}

