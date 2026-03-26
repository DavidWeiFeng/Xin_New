package com.robot.core.info
{
   import com.robot.core.info.pet.PetSkillInfo;
   import flash.utils.IDataInput;
   
   public class UsePetItemOutOfFightInfo
   {
      
      private var _hp:uint;
      
      private var _maxHp:uint;
      
      private var _a:uint;
      
      private var _sa:uint;
      
      private var _d:uint;
      
      private var _sd:uint;
      
      private var _sp:uint;
      
      public var catchTime:uint;
      
      public var id:uint;
      
      public var exp:uint;
      
      public var nick:String;
      
      public var nature:uint;
      
      public var dv:uint;
      
      public var lv:uint;
      
      public var ev_hp:uint;
      
      public var ev_attack:uint;
      
      public var ev_defence:uint;
      
      public var ev_sa:uint;
      
      public var ev_sd:uint;
      
      public var ev_sp:uint;
      
      private var _skillArray:Array;
      
      public function UsePetItemOutOfFightInfo(_arg_1:IDataInput)
      {
         var _local_3:uint = 0;
         this._skillArray = [];
         super();
         this.catchTime = _arg_1.readUnsignedInt();
         this.id = _arg_1.readUnsignedInt();
         this.nick = _arg_1.readUTFBytes(16);
         this.nature = _arg_1.readUnsignedInt();
         this.dv = _arg_1.readUnsignedInt();
         this.lv = _arg_1.readUnsignedInt();
         this._hp = _arg_1.readUnsignedInt();
         this._maxHp = _arg_1.readUnsignedInt();
         this.exp = _arg_1.readUnsignedInt();
         this.ev_hp = _arg_1.readUnsignedInt();
         this.ev_attack = _arg_1.readUnsignedInt();
         this.ev_defence = _arg_1.readUnsignedInt();
         this.ev_sa = _arg_1.readUnsignedInt();
         this.ev_sd = _arg_1.readUnsignedInt();
         this.ev_sp = _arg_1.readUnsignedInt();
         this._a = _arg_1.readUnsignedInt();
         this._sa = _arg_1.readUnsignedInt();
         this._d = _arg_1.readUnsignedInt();
         this._sd = _arg_1.readUnsignedInt();
         this._sp = _arg_1.readUnsignedInt();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         while(_local_3 < _local_2)
         {
            this._skillArray.push(new PetSkillInfo(_arg_1));
            _local_3++;
         }
      }
      
      public function get hp() : uint
      {
         return this._hp;
      }
      
      public function get maxHp() : uint
      {
         return this._maxHp;
      }
      
      public function get a() : uint
      {
         return this._a;
      }
      
      public function get sa() : uint
      {
         return this._sa;
      }
      
      public function get d() : uint
      {
         return this._d;
      }
      
      public function get sd() : uint
      {
         return this._sd;
      }
      
      public function get sp() : uint
      {
         return this._sp;
      }
      
      public function get skillArray() : Array
      {
         return this._skillArray;
      }
   }
}

