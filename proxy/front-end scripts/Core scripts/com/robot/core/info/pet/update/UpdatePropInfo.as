package com.robot.core.info.pet.update
{
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.PetManager;
   import flash.utils.IDataInput;
   
   public class UpdatePropInfo
   {
      
      private var _catchTime:uint;
      
      private var _id:uint;
      
      private var _level:uint;
      
      private var _exp:uint;
      
      private var _maxHp:uint;
      
      private var _attack:uint;
      
      private var _defence:uint;
      
      private var _sa:uint;
      
      private var _sd:uint;
      
      private var _sp:uint;
      
      private var _ev_hp:uint;
      
      private var _ev_a:uint;
      
      private var _ev_d:uint;
      
      private var _ev_sa:uint;
      
      private var _ev_sd:uint;
      
      private var _ev_sp:uint;
      
      private var _currentLvExp:uint;
      
      private var _nextLvExp:uint;
      
      public function UpdatePropInfo(_arg_1:IDataInput)
      {
         super();
         this._catchTime = _arg_1.readUnsignedInt();
         this._id = _arg_1.readUnsignedInt();
         this._level = _arg_1.readUnsignedInt();
         this._exp = _arg_1.readUnsignedInt();
         this._currentLvExp = _arg_1.readUnsignedInt();
         this._nextLvExp = _arg_1.readUnsignedInt();
         this._maxHp = _arg_1.readUnsignedInt();
         this._attack = _arg_1.readUnsignedInt();
         this._defence = _arg_1.readUnsignedInt();
         this._sa = _arg_1.readUnsignedInt();
         this._sd = _arg_1.readUnsignedInt();
         this._sp = _arg_1.readUnsignedInt();
         this._ev_hp = _arg_1.readUnsignedInt();
         this._ev_a = _arg_1.readUnsignedInt();
         this._ev_d = _arg_1.readUnsignedInt();
         this._ev_sa = _arg_1.readUnsignedInt();
         this._ev_sd = _arg_1.readUnsignedInt();
         this._ev_sp = _arg_1.readUnsignedInt();
      }
      
      public function update() : void
      {
         var _local_1:PetInfo = null;
         _local_1 = PetManager.getPetInfo(this._catchTime);
         _local_1.id = this.id;
         _local_1.level = this.level;
         _local_1.maxHp = this.maxHp;
         _local_1.attack = this.attack;
         _local_1.defence = this.defence;
         _local_1.s_a = this.sa;
         _local_1.s_d = this.sd;
         _local_1.speed = this.sp;
         _local_1.exp = this.exp;
         _local_1.nextLvExp = this.nextLvExp;
         _local_1.lvExp = this.currentLvExp;
      }
      
      public function get catchTime() : uint
      {
         return this._catchTime;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get level() : uint
      {
         return this._level;
      }
      
      public function get exp() : uint
      {
         return this._exp;
      }
      
      public function get currentLvExp() : uint
      {
         return this._currentLvExp;
      }
      
      public function get nextLvExp() : uint
      {
         return this._nextLvExp;
      }
      
      public function get maxHp() : uint
      {
         return this._maxHp;
      }
      
      public function get attack() : uint
      {
         return this._attack;
      }
      
      public function get defence() : uint
      {
         return this._defence;
      }
      
      public function get sa() : uint
      {
         return this._sa;
      }
      
      public function get sd() : uint
      {
         return this._sd;
      }
      
      public function get sp() : uint
      {
         return this._sp;
      }
   }
}

