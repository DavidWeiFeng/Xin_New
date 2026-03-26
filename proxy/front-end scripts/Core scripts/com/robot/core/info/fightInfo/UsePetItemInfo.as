package com.robot.core.info.fightInfo
{
   import flash.utils.IDataInput;
   
   public class UsePetItemInfo
   {
      
      private var _userID:uint;
      
      private var _itemID:uint;
      
      private var _uesrHP:uint;
      
      public var changeHp:int;
      
      public function UsePetItemInfo(_arg_1:IDataInput)
      {
         super();
         this._userID = _arg_1.readUnsignedInt();
         this._itemID = _arg_1.readUnsignedInt();
         this._uesrHP = _arg_1.readUnsignedInt();
         this.changeHp = _arg_1.readInt();
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
      
      public function get userHP() : uint
      {
         return this._uesrHP;
      }
   }
}

