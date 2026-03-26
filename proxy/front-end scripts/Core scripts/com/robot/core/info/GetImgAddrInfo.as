package com.robot.core.info
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GetImgAddrInfo
   {
      
      private var _ip:String;
      
      private var _port:uint;
      
      private var _session:ByteArray;
      
      public function GetImgAddrInfo(_arg_1:IDataInput)
      {
         super();
         this._ip = _arg_1.readUTFBytes(16);
         this._port = _arg_1.readShort();
         this._session = new ByteArray();
         _arg_1.readBytes(this._session,0,16);
      }
      
      public function get ip() : String
      {
         return this._ip;
      }
      
      public function get port() : uint
      {
         return this._port;
      }
      
      public function get session() : ByteArray
      {
         return this._session;
      }
   }
}

