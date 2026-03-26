package com.robot.app.info.fightInvite
{
   import flash.utils.IDataInput;
   
   public class InviteHandleInfo
   {
      
      private var _userID:uint;
      
      private var _nickName:String;
      
      private var _result:uint;
      
      public function InviteHandleInfo(_arg_1:IDataInput)
      {
         super();
         this._userID = _arg_1.readUnsignedInt();
         this._nickName = _arg_1.readUTFBytes(16);
         this._result = _arg_1.readUnsignedInt();
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
      
      public function get result() : uint
      {
         return this._result;
      }
   }
}

