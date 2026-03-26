package org.taomee.utils
{
   import flash.utils.*;
   
   public class Base64
   {
      
      private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
      
      public static const version:String = "1.0.0";
      
      public function Base64()
      {
         super();
         throw new Error("Base64 class is static container only");
      }
      
      public static function encode(_arg_1:String) : String
      {
         var _local_2:ByteArray = new ByteArray();
         _local_2.writeUTFBytes(_arg_1);
         return encodeByteArray(_local_2);
      }
      
      public static function encodeByteArray(_arg_1:ByteArray) : String
      {
         var _local_2:Array = null;
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_5:uint = 0;
         var _local_6:String = "";
         var _local_7:Array = new Array(4);
         _arg_1.position = 0;
         while(_arg_1.bytesAvailable > 0)
         {
            _local_2 = new Array();
            _local_3 = 0;
            while(_local_3 < 3 && _arg_1.bytesAvailable > 0)
            {
               _local_2[_local_3] = _arg_1.readUnsignedByte();
               _local_3++;
            }
            _local_7[0] = (_local_2[0] & 0xFC) >> 2;
            _local_7[1] = (_local_2[0] & 3) << 4 | _local_2[1] >> 4;
            _local_7[2] = (_local_2[1] & 0x0F) << 2 | _local_2[2] >> 6;
            _local_7[3] = _local_2[2] & 0x3F;
            _local_4 = _local_2.length;
            while(_local_4 < 3)
            {
               _local_7[_local_4 + 1] = 64;
               _local_4++;
            }
            _local_5 = 0;
            while(_local_5 < _local_7.length)
            {
               _local_6 += BASE64_CHARS.charAt(_local_7[_local_5]);
               _local_5++;
            }
         }
         return _local_6;
      }
      
      public static function decode(_arg_1:String) : String
      {
         var _local_2:ByteArray = decodeToByteArray(_arg_1);
         return _local_2.readUTFBytes(_local_2.length);
      }
      
      public static function decodeToByteArray(_arg_1:String) : ByteArray
      {
         var _local_2:uint = 0;
         var _local_3:uint = 0;
         var _local_7:uint = 0;
         var _local_4:ByteArray = new ByteArray();
         var _local_5:Array = new Array(4);
         var _local_6:Array = new Array(3);
         while(_local_7 < _arg_1.length)
         {
            _local_2 = 0;
            while(_local_2 < 4 && _local_7 + _local_2 < _arg_1.length)
            {
               _local_5[_local_2] = BASE64_CHARS.indexOf(_arg_1.charAt(_local_7 + _local_2));
               _local_2++;
            }
            _local_6[0] = (_local_5[0] << 2) + ((_local_5[1] & 0x30) >> 4);
            _local_6[1] = ((_local_5[1] & 0x0F) << 4) + ((_local_5[2] & 0x3C) >> 2);
            _local_6[2] = ((_local_5[2] & 3) << 6) + _local_5[3];
            _local_3 = 0;
            while(_local_3 < _local_6.length)
            {
               if(_local_5[_local_3 + 1] == 64)
               {
                  break;
               }
               _local_4.writeByte(_local_6[_local_3]);
               _local_3++;
            }
            _local_7 += 4;
         }
         _local_4.position = 0;
         return _local_4;
      }
   }
}

