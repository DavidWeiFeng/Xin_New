package com.adobe.crypto
{
   import com.adobe.utils.*;
   import flash.utils.*;
   
   public class MD5
   {
      
      public function MD5()
      {
         super();
      }
      
      private static function ff(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int) : int
      {
         return transform(f,_arg_1,_arg_2,_arg_3,_arg_4,_arg_5,_arg_6,_arg_7);
      }
      
      private static function createBlocks(_arg_1:String) : Array
      {
         var _local_4:int = 0;
         var _local_2:Array = new Array();
         var _local_3:int = _arg_1.length * 8;
         while(_local_4 < _local_3)
         {
            _local_2[_local_4 >> 5] |= (_arg_1.charCodeAt(_local_4 / 8) & 0xFF) << _local_4 % 32;
            _local_4 += 8;
         }
         _local_2[_local_3 >> 5] |= 128 << _local_3 % 32;
         _local_2[(_local_3 + 64 >>> 9 << 4) + 14] = _local_3;
         return _local_2;
      }
      
      private static function f(_arg_1:int, _arg_2:int, _arg_3:int) : int
      {
         return _arg_1 & _arg_2 | ~_arg_1 & _arg_3;
      }
      
      private static function ii(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int) : int
      {
         return transform(i,_arg_1,_arg_2,_arg_3,_arg_4,_arg_5,_arg_6,_arg_7);
      }
      
      private static function h(_arg_1:int, _arg_2:int, _arg_3:int) : int
      {
         return _arg_1 ^ _arg_2 ^ _arg_3;
      }
      
      private static function transform(_arg_1:Function, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:int) : int
      {
         var _local_9:int = _arg_2 + int(_arg_1(_arg_3,_arg_4,_arg_5)) + _arg_6 + _arg_8;
         return IntUtil.rol(_local_9,_arg_7) + _arg_3;
      }
      
      private static function g(_arg_1:int, _arg_2:int, _arg_3:int) : int
      {
         return _arg_1 & _arg_3 | _arg_2 & ~_arg_3;
      }
      
      private static function hh(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int) : int
      {
         return transform(h,_arg_1,_arg_2,_arg_3,_arg_4,_arg_5,_arg_6,_arg_7);
      }
      
      private static function i(_arg_1:int, _arg_2:int, _arg_3:int) : int
      {
         return _arg_2 ^ (_arg_1 | ~_arg_3);
      }
      
      public static function hash(_arg_1:String) : String
      {
         var _local_2:int = 0;
         var _local_3:int = 0;
         var _local_4:int = 0;
         var _local_5:int = 0;
         var _local_12:int = 0;
         var _local_6:int = 1732584193;
         var _local_7:int = -271733879;
         var _local_8:int = -1732584194;
         var _local_9:int = 271733878;
         var _local_10:Array = createBlocks(changeUTF(_arg_1));
         var _local_11:int = int(_local_10.length);
         while(_local_12 < _local_11)
         {
            _local_2 = _local_6;
            _local_3 = _local_7;
            _local_4 = _local_8;
            _local_5 = _local_9;
            _local_6 = ff(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 0],7,-680876936);
            _local_9 = ff(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 1],12,-389564586);
            _local_8 = ff(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 2],17,606105819);
            _local_7 = ff(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 3],22,-1044525330);
            _local_6 = ff(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 4],7,-176418897);
            _local_9 = ff(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 5],12,1200080426);
            _local_8 = ff(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 6],17,-1473231341);
            _local_7 = ff(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 7],22,-45705983);
            _local_6 = ff(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 8],7,1770035416);
            _local_9 = ff(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 9],12,-1958414417);
            _local_8 = ff(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 10],17,-42063);
            _local_7 = ff(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 11],22,-1990404162);
            _local_6 = ff(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 12],7,1804603682);
            _local_9 = ff(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 13],12,-40341101);
            _local_8 = ff(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 14],17,-1502002290);
            _local_7 = ff(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 15],22,1236535329);
            _local_6 = gg(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 1],5,-165796510);
            _local_9 = gg(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 6],9,-1069501632);
            _local_8 = gg(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 11],14,643717713);
            _local_7 = gg(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 0],20,-373897302);
            _local_6 = gg(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 5],5,-701558691);
            _local_9 = gg(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 10],9,38016083);
            _local_8 = gg(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 15],14,-660478335);
            _local_7 = gg(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 4],20,-405537848);
            _local_6 = gg(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 9],5,568446438);
            _local_9 = gg(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 14],9,-1019803690);
            _local_8 = gg(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 3],14,-187363961);
            _local_7 = gg(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 8],20,1163531501);
            _local_6 = gg(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 13],5,-1444681467);
            _local_9 = gg(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 2],9,-51403784);
            _local_8 = gg(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 7],14,1735328473);
            _local_7 = gg(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 12],20,-1926607734);
            _local_6 = hh(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 5],4,-378558);
            _local_9 = hh(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 8],11,-2022574463);
            _local_8 = hh(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 11],16,1839030562);
            _local_7 = hh(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 14],23,-35309556);
            _local_6 = hh(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 1],4,-1530992060);
            _local_9 = hh(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 4],11,1272893353);
            _local_8 = hh(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 7],16,-155497632);
            _local_7 = hh(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 10],23,-1094730640);
            _local_6 = hh(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 13],4,681279174);
            _local_9 = hh(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 0],11,-358537222);
            _local_8 = hh(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 3],16,-722521979);
            _local_7 = hh(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 6],23,76029189);
            _local_6 = hh(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 9],4,-640364487);
            _local_9 = hh(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 12],11,-421815835);
            _local_8 = hh(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 15],16,530742520);
            _local_7 = hh(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 2],23,-995338651);
            _local_6 = ii(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 0],6,-198630844);
            _local_9 = ii(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 7],10,1126891415);
            _local_8 = ii(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 14],15,-1416354905);
            _local_7 = ii(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 5],21,-57434055);
            _local_6 = ii(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 12],6,1700485571);
            _local_9 = ii(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 3],10,-1894986606);
            _local_8 = ii(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 10],15,-1051523);
            _local_7 = ii(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 1],21,-2054922799);
            _local_6 = ii(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 8],6,1873313359);
            _local_9 = ii(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 15],10,-30611744);
            _local_8 = ii(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 6],15,-1560198380);
            _local_7 = ii(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 13],21,1309151649);
            _local_6 = ii(_local_6,_local_7,_local_8,_local_9,_local_10[_local_12 + 4],6,-145523070);
            _local_9 = ii(_local_9,_local_6,_local_7,_local_8,_local_10[_local_12 + 11],10,-1120210379);
            _local_8 = ii(_local_8,_local_9,_local_6,_local_7,_local_10[_local_12 + 2],15,718787259);
            _local_7 = ii(_local_7,_local_8,_local_9,_local_6,_local_10[_local_12 + 9],21,-343485551);
            _local_6 += _local_2;
            _local_7 += _local_3;
            _local_8 += _local_4;
            _local_9 += _local_5;
            _local_12 += 16;
         }
         return IntUtil.toHex(_local_6) + IntUtil.toHex(_local_7) + IntUtil.toHex(_local_8) + IntUtil.toHex(_local_9);
      }
      
      private static function changeUTF2ASCII(_arg_1:String) : String
      {
         var _local_2:int = 0;
         var _local_3:String = null;
         var _local_7:int = 0;
         if(_arg_1.length > 65535)
         {
            throw new Error("In MD5:changeUTF2 s.length must less than 65536");
         }
         var _local_4:ByteArray = new ByteArray();
         _local_4.writeUTF(_arg_1);
         _local_4.position = 2;
         var _local_5:String = "";
         var _local_6:int = int(_local_4.bytesAvailable);
         while(_local_7 < _local_6)
         {
            _local_2 = int(_local_4.readUnsignedByte());
            _local_3 = String.fromCharCode(_local_2);
            _local_5 += _local_3;
            _local_7++;
         }
         return _local_5;
      }
      
      private static function changeUTF(_arg_1:String) : String
      {
         var _local_5:int = 0;
         var _local_2:int = int(Math.ceil(_arg_1.length / 65530));
         var _local_3:String = "";
         var _local_4:String = "";
         while(_local_5 < _local_2)
         {
            if(_local_5 == _local_2 - 1)
            {
               _local_3 = _arg_1.substr(_local_5 * 65530);
            }
            else
            {
               _local_3 = _arg_1.substr(_local_5 * 65530,65530);
            }
            _local_4 += changeUTF2ASCII(_local_3);
            _local_5++;
         }
         return _local_4;
      }
      
      private static function gg(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int) : int
      {
         return transform(g,_arg_1,_arg_2,_arg_3,_arg_4,_arg_5,_arg_6,_arg_7);
      }
   }
}

