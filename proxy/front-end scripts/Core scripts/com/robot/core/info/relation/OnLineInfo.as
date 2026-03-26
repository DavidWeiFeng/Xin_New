package com.robot.core.info.relation
{
   import flash.utils.IDataInput;
   
   public class OnLineInfo
   {
      
      private var _userID:uint;
      
      private var _serverID:uint;
      
      private var _mapType:uint;
      
      private var _mapID:uint;
      
      public function OnLineInfo(_arg_1:IDataInput = null)
      {
         super();
         this._userID = _arg_1.readUnsignedInt();
         this._serverID = _arg_1.readUnsignedInt();
         this._mapType = _arg_1.readUnsignedInt();
         this._mapID = _arg_1.readUnsignedInt();
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get serverID() : uint
      {
         return this._serverID;
      }
      
      public function get mapType() : uint
      {
         return this._mapType;
      }
      
      public function get mapID() : uint
      {
         return this._mapID;
      }
   }
}

