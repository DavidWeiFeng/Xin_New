package com.robot.core.info
{
   import com.robot.core.manager.MainManager;
   import flash.utils.IDataInput;
   
   public class ChatInfo
   {
      
      private var _senderID:uint;
      
      private var _senderNicName:String;
      
      private var _toID:uint;
      
      private var _msg:String;
      
      public var isRead:Boolean = false;
      
      public function ChatInfo(_arg_1:IDataInput)
      {
         super();
         this._senderID = _arg_1.readUnsignedInt();
         this._senderNicName = _arg_1.readUTFBytes(16);
         this._toID = _arg_1.readUnsignedInt();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         this._msg = _arg_1.readUTFBytes(_local_2);
      }
      
      public function get senderID() : uint
      {
         return this._senderID;
      }
      
      public function get senderNickName() : String
      {
         return this._senderNicName;
      }
      
      public function get toID() : uint
      {
         return this._toID;
      }
      
      public function get msg() : String
      {
         return this._msg;
      }
      
      public function get talkID() : uint
      {
         if(this._senderID == MainManager.actorID)
         {
            return this._toID;
         }
         return this._senderID;
      }
   }
}

