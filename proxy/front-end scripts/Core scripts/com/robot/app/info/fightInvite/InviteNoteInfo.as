package com.robot.app.info.fightInvite
{
   import flash.utils.IDataInput;
   
   public class InviteNoteInfo
   {
      
      private var _userID:uint;
      
      private var _nickName:String;
      
      private var _mode:uint;
      
      public function InviteNoteInfo(_arg_1:IDataInput)
      {
         super();
         this._userID = _arg_1.readUnsignedInt();
         this._nickName = _arg_1.readUTFBytes(16);
         this._mode = _arg_1.readUnsignedInt();
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
      
      public function get mode() : uint
      {
         return this._mode;
      }
   }
}

