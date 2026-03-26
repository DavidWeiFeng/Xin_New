package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPkUserInfo
   {
      
      private var _uid:uint;
      
      private var _hp:uint;
      
      private var _maxHp:uint;
      
      private var _where:uint;
      
      public function TeamPkUserInfo(_arg_1:IDataInput)
      {
         super();
         this._uid = _arg_1.readUnsignedInt();
         this._hp = _arg_1.readUnsignedInt();
         this._maxHp = _arg_1.readUnsignedInt();
         this._where = _arg_1.readUnsignedInt();
         _arg_1.readUnsignedInt();
         _arg_1.readUnsignedInt();
      }
      
      public function get uid() : uint
      {
         return this._uid;
      }
      
      public function get hp() : uint
      {
         return this._hp;
      }
      
      public function get maxHp() : uint
      {
         return this._maxHp;
      }
      
      public function get isFreeze() : Boolean
      {
         return this._where == 2;
      }
   }
}

