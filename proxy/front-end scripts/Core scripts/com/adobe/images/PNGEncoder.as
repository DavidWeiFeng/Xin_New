package com.adobe.images
{
   import flash.display.BitmapData;
   import flash.geom.*;
   import flash.utils.*;
   
   public class PNGEncoder
   {
      
      private static var crcTable:Array;
      
      private static var crcTableComputed:Boolean = false;
      
      public function PNGEncoder()
      {
         super();
      }
      
      private static function writeChunk(_arg_1:ByteArray, _arg_2:uint, _arg_3:ByteArray) : void
      {
         var _local_4:uint = 0;
         var _local_5:uint = 0;
         var _local_6:uint = 0;
         var _local_7:uint = 0;
         var _local_10:int = 0;
         if(!crcTableComputed)
         {
            crcTableComputed = true;
            crcTable = [];
            _local_5 = 0;
            while(_local_5 < 256)
            {
               _local_4 = _local_5;
               _local_6 = 0;
               while(_local_6 < 8)
               {
                  if(Boolean(_local_4 & 1))
                  {
                     _local_4 = uint(uint(3988292384) ^ uint(_local_4 >>> 1));
                  }
                  else
                  {
                     _local_4 = uint(_local_4 >>> 1);
                  }
                  _local_6++;
               }
               crcTable[_local_5] = _local_4;
               _local_5++;
            }
         }
         if(_arg_3 != null)
         {
            _local_7 = _arg_3.length;
         }
         _arg_1.writeUnsignedInt(_local_7);
         var _local_8:uint = _arg_1.position;
         _arg_1.writeUnsignedInt(_arg_2);
         if(_arg_3 != null)
         {
            _arg_1.writeBytes(_arg_3);
         }
         var _local_9:uint = _arg_1.position;
         _arg_1.position = _local_8;
         _local_4 = 4294967295;
         while(_local_10 < _local_9 - _local_8)
         {
            _local_4 = uint(crcTable[(_local_4 ^ _arg_1.readUnsignedByte()) & uint(255)] ^ uint(_local_4 >>> 8));
            _local_10++;
         }
         _local_4 = uint(_local_4 ^ uint(4294967295));
         _arg_1.position = _local_9;
         _arg_1.writeUnsignedInt(_local_4);
      }
      
      public static function encode(_arg_1:BitmapData) : ByteArray
      {
         var _local_2:uint = 0;
         var _local_3:int = 0;
         var _local_7:int = 0;
         var _local_4:ByteArray = new ByteArray();
         _local_4.writeUnsignedInt(2303741511);
         _local_4.writeUnsignedInt(218765834);
         var _local_5:ByteArray = new ByteArray();
         _local_5.writeInt(_arg_1.width);
         _local_5.writeInt(_arg_1.height);
         _local_5.writeUnsignedInt(134610944);
         _local_5.writeByte(0);
         writeChunk(_local_4,1229472850,_local_5);
         var _local_6:ByteArray = new ByteArray();
         while(_local_7 < _arg_1.height)
         {
            _local_6.writeByte(0);
            if(!_arg_1.transparent)
            {
               _local_3 = 0;
               while(_local_3 < _arg_1.width)
               {
                  _local_2 = _arg_1.getPixel(_local_3,_local_7);
                  _local_6.writeUnsignedInt(uint((_local_2 & 0xFFFFFF) << 8 | 0xFF));
                  _local_3++;
               }
            }
            else
            {
               _local_3 = 0;
               while(_local_3 < _arg_1.width)
               {
                  _local_2 = _arg_1.getPixel32(_local_3,_local_7);
                  _local_6.writeUnsignedInt(uint((_local_2 & 0xFFFFFF) << 8 | _local_2 >>> 24));
                  _local_3++;
               }
            }
            _local_7++;
         }
         _local_6.compress();
         writeChunk(_local_4,1229209940,_local_6);
         writeChunk(_local_4,1229278788,null);
         return _local_4;
      }
   }
}

