package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class ShooterInfo
   {
      
      public static const PLAYER:uint = 1;
      
      public static const BUILDING:uint = 2;
      
      private var _type:uint;
      
      private var _buyTime:uint;
      
      private var _userID:uint;
      
      private var _leftHp:uint;
      
      private var _maxHp:uint;
      
      public function ShooterInfo(_arg_1:IDataInput)
      {
         super();
         this._type = _arg_1.readUnsignedInt();
         this._buyTime = _arg_1.readUnsignedInt();
         this._userID = _arg_1.readUnsignedInt();
         this._leftHp = _arg_1.readUnsignedInt();
         this._maxHp = _arg_1.readUnsignedInt();
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get buyTime() : uint
      {
         return this._buyTime;
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get leftHp() : uint
      {
         return this._leftHp;
      }
      
      public function get maxHp() : uint
      {
         return this._maxHp;
      }
   }
}

