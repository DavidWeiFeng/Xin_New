package com.robot.core.info.fightInfo
{
   import flash.utils.IDataInput;
   
   public class FightPetInfo
   {
      
      private var _userID:uint;
      
      private var _petID:uint;
      
      private var _petName:String;
      
      private var _catchTime:uint;
      
      private var _hp:uint;
      
      private var _maxHP:uint;
      
      private var _lv:uint;
      
      private var _catchable:Boolean;
      
      private var _battleLv:Array;
      
      public function FightPetInfo(_arg_1:IDataInput)
      {
         var _local_2:uint = 0;
         super();
         this._userID = _arg_1.readUnsignedInt();
         this._petID = _arg_1.readUnsignedInt();
         this._petName = _arg_1.readUTFBytes(16);
         this._catchTime = _arg_1.readUnsignedInt();
         this._hp = _arg_1.readUnsignedInt();
         this._maxHP = _arg_1.readUnsignedInt();
         this._lv = _arg_1.readUnsignedInt();
         this._catchable = _arg_1.readUnsignedInt() == 1;
         if(this._hp > this._maxHP)
         {
            this._maxHP = this._hp;
         }
         this._battleLv = [];
         while(_local_2 < 6)
         {
            this._battleLv.push(_arg_1.readByte());
            _local_2++;
         }
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get petID() : uint
      {
         return this._petID;
      }
      
      public function get petName() : String
      {
         return this._petName;
      }
      
      public function get catchTime() : uint
      {
         return this._catchTime;
      }
      
      public function get hp() : uint
      {
         return this._hp;
      }
      
      public function get maxHP() : uint
      {
         return this._maxHP;
      }
      
      public function get level() : uint
      {
         return this._lv;
      }
      
      public function get catchable() : Boolean
      {
         return this._catchable;
      }
      
      public function get battleLv() : Array
      {
         return this._battleLv;
      }
   }
}

