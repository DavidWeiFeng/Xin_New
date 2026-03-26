package org.taomee.tmf
{
   import flash.utils.IDataInput;
   
   public class HeadInfo
   {
      
      private var _version:String;
      
      private var _userID:uint;
      
      private var _error:uint;
      
      private var _cmdID:uint;
      
      private var _result:int;
      
      public function HeadInfo(_arg_1:IDataInput)
      {
         super();
         this._version = _arg_1.readUTFBytes(1);
         this._cmdID = _arg_1.readUnsignedInt();
         this._userID = _arg_1.readUnsignedInt();
         this._result = _arg_1.readInt();
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get error() : uint
      {
         return this._error;
      }
      
      public function get cmdID() : uint
      {
         return this._cmdID;
      }
      
      public function get result() : int
      {
         return this._result;
      }
      
      public function get version() : String
      {
         return this._version;
      }
   }
}

