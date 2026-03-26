package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class SomeoneJoinInfo
   {
      
      private var _uid:uint;
      
      private var _hp:uint;
      
      private var _maxHp:uint;
      
      public function SomeoneJoinInfo(_arg_1:IDataInput)
      {
         super();
         this._uid = _arg_1.readUnsignedInt();
         this._hp = _arg_1.readUnsignedInt();
         this._maxHp = _arg_1.readUnsignedInt();
      }
      
      public function get userID() : uint
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
   }
}

