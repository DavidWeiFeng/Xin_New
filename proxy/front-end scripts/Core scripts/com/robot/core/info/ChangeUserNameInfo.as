package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class ChangeUserNameInfo
   {
      
      private var _userId:uint;
      
      private var _nickName:String;
      
      public function ChangeUserNameInfo(_arg_1:IDataInput)
      {
         super();
         this._userId = _arg_1.readUnsignedInt();
         this._nickName = _arg_1.readUTFBytes(16);
      }
      
      public function get userId() : uint
      {
         return this._userId;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
   }
}

