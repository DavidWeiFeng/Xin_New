package com.robot.core.info.teamPK
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.utils.StringUtil;
   
   public class TeamPKSignInfo
   {
      
      private var _sign:ByteArray = new ByteArray();
      
      private var _ip:String;
      
      private var _port:uint;
      
      public function TeamPKSignInfo(_arg_1:IDataInput)
      {
         super();
         _arg_1.readBytes(this._sign,0,24);
         this._ip = StringUtil.hexToIp(_arg_1.readUnsignedInt());
         this._port = _arg_1.readUnsignedShort();
      }
      
      public function get sign() : ByteArray
      {
         return this._sign;
      }
      
      public function get ip() : String
      {
         return this._ip;
      }
      
      public function get port() : uint
      {
         return this._port;
      }
   }
}

