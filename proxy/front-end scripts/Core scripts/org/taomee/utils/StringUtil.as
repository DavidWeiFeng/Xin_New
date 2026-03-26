package org.taomee.utils
{
   import flash.utils.ByteArray;
   
   public class StringUtil
   {
      
      private static const HEX_Head:String = "0x";
      
      public function StringUtil()
      {
         super();
      }
      
      public static function trim(_arg_1:String) : String
      {
         return StringUtil.leftTrim(StringUtil.rightTrim(_arg_1));
      }
      
      public static function ipToUint(i:String) : uint
      {
         var str:String = null;
         str = null;
         var arr:Array = i.split(".");
         str = HEX_Head;
         arr.forEach(function(_arg_1:String, _arg_2:int, _arg_3:Array):void
         {
            str += uint(_arg_1).toString(16);
         });
         return uint(str);
      }
      
      public static function timeFormat(_arg_1:int, _arg_2:String = "-") : String
      {
         var _local_3:Date = new Date(_arg_1 * 1000);
         return _local_3.getFullYear().toString() + _arg_2 + (_local_3.getMonth() + 1).toString() + _arg_2 + _local_3.getDate().toString();
      }
      
      public static function endsWith(_arg_1:String, _arg_2:String) : Boolean
      {
         return _arg_2 == _arg_1.substring(_arg_1.length - _arg_2.length);
      }
      
      public static function remove(_arg_1:String, _arg_2:String) : String
      {
         return StringUtil.replace(_arg_1,_arg_2,"");
      }
      
      public static function leftTrim(_arg_1:String) : String
      {
         var _local_2:Number = _arg_1.length;
         var _local_3:Number = 0;
         while(_local_3 < _local_2)
         {
            if(_arg_1.charCodeAt(_local_3) > 32)
            {
               return _arg_1.substring(_local_3);
            }
            _local_3++;
         }
         return "";
      }
      
      public static function stopwatchFormat(_arg_1:int) : String
      {
         var _local_2:int = int(_arg_1 / 60);
         var _local_3:int = _arg_1 % 60;
         var _local_4:String = _local_2 < 10 ? "0" + _local_2.toString() : _local_2.toString();
         var _local_5:String = _local_3 < 10 ? "0" + _local_3.toString() : _local_3.toString();
         return _local_4 + ":" + _local_5;
      }
      
      public static function stringHasValue(_arg_1:String) : Boolean
      {
         return _arg_1 != null && _arg_1.length > 0;
      }
      
      public static function beginsWith(_arg_1:String, _arg_2:String) : Boolean
      {
         return _arg_2 == _arg_1.substring(0,_arg_2.length);
      }
      
      public static function replace(_arg_1:String, _arg_2:String, _arg_3:String) : String
      {
         var _local_6:Boolean = false;
         var _local_4:Number = NaN;
         var _local_5:String = new String();
         var _local_7:Number = _arg_1.length;
         var _local_8:Number = _arg_2.length;
         for(var _local_9:Number = 0; _local_9 < _local_7; _local_9++)
         {
            if(_arg_1.charAt(_local_9) == _arg_2.charAt(0))
            {
               _local_6 = true;
               _local_4 = 0;
               while(_local_4 < _local_8)
               {
                  if(_arg_1.charAt(_local_9 + _local_4) != _arg_2.charAt(_local_4))
                  {
                     _local_6 = false;
                     break;
                  }
                  _local_4++;
               }
               if(_local_6)
               {
                  _local_5 += _arg_3;
                  _local_9 += _local_8 - 1;
                  continue;
               }
            }
            _local_5 += _arg_1.charAt(_local_9);
         }
         return _local_5;
      }
      
      public static function renewZero(_arg_1:String, _arg_2:int) : String
      {
         var _local_3:int = 0;
         var _local_4:String = "";
         var _local_5:int = _arg_1.length;
         if(_local_5 < _arg_2)
         {
            _local_3 = 0;
            while(_local_3 < _arg_2 - _local_5)
            {
               _local_4 += "0";
               _local_3++;
            }
            return _local_4 + _arg_1;
         }
         return _arg_1;
      }
      
      public static function toByteArray(_arg_1:String, _arg_2:uint) : ByteArray
      {
         var _local_3:ByteArray = new ByteArray();
         _local_3.writeUTFBytes(_arg_1);
         _local_3.length = _arg_2;
         _local_3.position = 0;
         return _local_3;
      }
      
      public static function stringsAreEqual(_arg_1:String, _arg_2:String, _arg_3:Boolean) : Boolean
      {
         if(_arg_3)
         {
            return _arg_1 == _arg_2;
         }
         return _arg_1.toUpperCase() == _arg_2.toUpperCase();
      }
      
      public static function uintToIp(_arg_1:uint) : String
      {
         var _local_2:String = _arg_1.toString(16);
         var _local_3:String = uint(HEX_Head + _local_2.slice(0,2)).toString();
         var _local_4:String = uint(HEX_Head + _local_2.slice(2,4)).toString();
         var _local_5:String = uint(HEX_Head + _local_2.slice(4,6)).toString();
         var _local_6:String = uint(HEX_Head + _local_2.slice(6)).toString();
         return _local_3 + "." + _local_4 + "." + _local_5 + "." + _local_6;
      }
      
      public static function hexToIp(_arg_1:uint) : String
      {
         var _local_4:uint = 0;
         var _local_2:ByteArray = new ByteArray();
         _local_2.writeUnsignedInt(_arg_1);
         _local_2.position = 0;
         var _local_3:String = "";
         while(_local_4 < 4)
         {
            _local_3 += _local_2.readUnsignedByte().toString() + ".";
            _local_4++;
         }
         return _local_3.substr(0,_local_3.length - 1);
      }
      
      public static function rightTrim(_arg_1:String) : String
      {
         var _local_2:Number = _arg_1.length;
         var _local_3:Number = _local_2;
         while(_local_3 > 0)
         {
            if(_arg_1.charCodeAt(_local_3 - 1) > 32)
            {
               return _arg_1.substring(0,_local_3);
            }
            _local_3--;
         }
         return "";
      }
   }
}

