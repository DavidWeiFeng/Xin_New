package org.taomee.net
{
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.net.Socket;
   import flash.utils.*;
   import org.taomee.events.*;
   import org.taomee.tmf.*;
   
   public class SocketImpl extends Socket
   {
      
      public static const PACKAGE_MAX:uint = 8388608;
      
      private static const XOR_KEY:Vector.<uint> = Vector.<uint>([26,59,92,125,158,191,208,241]);
      
      public var port:int;
      
      private var _headLength:uint = 17;
      
      private var _headInfo:HeadInfo;
      
      private var _dataLen:uint;
      
      private var _isGetHead:Boolean = true;
      
      private var _packageLen:uint;
      
      public var session:ByteArray;
      
      private var _version:String = "1";
      
      public var userID:uint = 0;
      
      public var ip:String;
      
      private var outTime:int = 0;
      
      private var _result:uint = 0;
      
      private var XOR_KEY_LEN:uint = 0;
      
      public function SocketImpl(_arg_1:String = "1")
      {
         super();
         this._version = _arg_1;
         this._headLength = SocketVersion.getHeadLength(_arg_1);
      }
      
      public function XOREncrypt(data:ByteArray, key:ByteArray) : ByteArray
      {
         var byte:uint = 0;
         var result:ByteArray = new ByteArray();
         data.position = 0;
         result.writeBytes(data);
         result.position = 0;
         var keyLen:uint = key.length;
         if(keyLen == 0)
         {
            return result;
         }
         var keyPos:uint = 0;
         while(result.bytesAvailable > 0)
         {
            byte = result.readUnsignedByte();
            byte ^= key[keyPos];
            --result.position;
            result.writeByte(byte);
            keyPos = (keyPos + 1) % keyLen;
         }
         result.position = 0;
         return result;
      }
      
      public function XORDecrypt(encryptedData:ByteArray, key:uint) : ByteArray
      {
         var b:uint = 0;
         var keyIndex:int = 0;
         if(encryptedData.length == 0)
         {
            return new ByteArray();
         }
         if(this.XOR_KEY_LEN == 0)
         {
            this.XOR_KEY_LEN = ExternalInterface.call("sethash") || 0;
         }
         trace("XOR_KEY_LEN:" + this.XOR_KEY_LEN);
         var keyBytes:ByteArray = new ByteArray();
         keyBytes.endian = Endian.BIG_ENDIAN;
         keyBytes.writeUnsignedInt(key);
         keyBytes.position = 0;
         var keyArr:Array = [];
         for(var i:int = 0; i < 4; i++)
         {
            keyArr.push(keyBytes.readUnsignedByte());
         }
         var keyLen:int = int(keyArr.length);
         var decrypted:ByteArray = new ByteArray();
         encryptedData.position = 0;
         var idx:int = 0;
         while(encryptedData.bytesAvailable > 0)
         {
            b = encryptedData.readUnsignedByte();
            keyIndex = idx % keyLen;
            decrypted.writeByte(b ^ keyArr[keyIndex]);
            idx++;
         }
         decrypted.position = 0;
         return decrypted;
      }
      
      public function send(_arg_1:uint, _arg_2:Array) : uint
      {
         var _local_3:* = undefined;
         var _local_4:ByteArray = new ByteArray();
         for each(_local_3 in _arg_2)
         {
            if(_local_3 is String)
            {
               _local_4.writeUTFBytes(_local_3);
            }
            else if(_local_3 is ByteArray)
            {
               _local_4.writeBytes(_local_3);
            }
            else
            {
               _local_4.writeUnsignedInt(_local_3);
            }
         }
         if(_arg_1 > 1000)
         {
            ++this._result;
         }
         var _local_5:uint = _local_4.length + this._headLength;
         writeUnsignedInt(_local_5);
         writeUTFBytes(this._version);
         writeUnsignedInt(_arg_1);
         writeUnsignedInt(this.userID);
         writeInt(this._result);
         writeBytes(this.XORDecrypt(_local_4,this.XOR_KEY_LEN));
         flush();
         return this._result;
      }
      
      public function get version() : String
      {
         return this._version;
      }
      
      private function onData(_arg_1:Event) : void
      {
         var _local_4:ByteArray = null;
         var _local_2:ByteArray = null;
         var _local_3:Class = null;
         this.outTime = 0;
         while(bytesAvailable > 0)
         {
            if(this._isGetHead)
            {
               if(bytesAvailable >= this._headLength)
               {
                  this._packageLen = readUnsignedInt();
                  if(this._packageLen < this._headLength || this._packageLen > PACKAGE_MAX)
                  {
                     SocketDispatcher.getInstance().dispatchEvent(new SocketErrorEvent(SocketErrorEvent.ERROR,null));
                     readBytes(new ByteArray());
                     return;
                  }
                  this._headInfo = new HeadInfo(this);
                  if(this._headInfo.result != 0)
                  {
                     SocketDispatcher.getInstance().dispatchEvent(new SocketErrorEvent(SocketErrorEvent.ERROR,this._headInfo));
                     continue;
                  }
                  this._dataLen = this._packageLen - this._headLength;
                  if(this._dataLen == 0)
                  {
                     SocketDispatcher.getInstance().dispatchEvent(new SocketEvent(this._headInfo.cmdID.toString(),this._headInfo,null));
                     continue;
                  }
                  this._isGetHead = false;
               }
            }
            else if(bytesAvailable >= this._dataLen)
            {
               _local_2 = new ByteArray();
               readBytes(_local_2,0,this._dataLen);
               _local_4 = _local_2;
               _local_3 = TMF.getClass(this._headInfo.cmdID);
               trace("recv cmdID:",this._headInfo.cmdID);
               SocketDispatcher.getInstance().dispatchEvent(new SocketEvent(this._headInfo.cmdID.toString(),this._headInfo,new _local_3(_local_4)));
               this._isGetHead = true;
            }
            if(this.outTime > 200 || !connected)
            {
               break;
            }
            ++this.outTime;
         }
      }
      
      private function byteArrayToHex(_arg_1:ByteArray) : String
      {
         var _local_4:uint = 0;
         var _local_2:String = "";
         var _local_3:uint = _arg_1.position;
         _arg_1.position = 0;
         while(_arg_1.bytesAvailable > 0)
         {
            _local_4 = _arg_1.readUnsignedByte();
            _local_2 += (_local_4 < 16 ? "0" : "") + _local_4.toString(16);
         }
         _arg_1.position = _local_3;
         return _local_2;
      }
      
      override public function connect(_arg_1:String, _arg_2:int) : void
      {
         super.connect(_arg_1,_arg_2);
         this._result = 0;
         this.addEvent();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(ProgressEvent.SOCKET_DATA,this.onData);
      }
      
      private function addEvent() : void
      {
         addEventListener(ProgressEvent.SOCKET_DATA,this.onData);
      }
      
      override public function close() : void
      {
         this.removeEvent();
         if(connected)
         {
            super.close();
         }
         this.ip = "";
         this.port = -1;
         this._result = 0;
      }
      
      private function hexToByteArray(_arg_1:String) : ByteArray
      {
         var _local_4:uint = 0;
         var _local_3:uint = 0;
         var _local_2:ByteArray = new ByteArray();
         while(_local_3 < _arg_1.length)
         {
            _local_4 = parseInt(_arg_1.substr(_local_3,2),16);
            _local_2.writeByte(_local_4);
            _local_3 += 2;
         }
         _local_2.position = 0;
         return _local_2;
      }
   }
}

