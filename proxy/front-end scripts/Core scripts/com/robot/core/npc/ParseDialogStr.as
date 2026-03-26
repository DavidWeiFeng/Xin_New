package com.robot.core.npc
{
   import org.taomee.ds.HashMap;
   
   public class ParseDialogStr
   {
      
      public static const SPLIT:String = "$$";
      
      private var array:Array = [];
      
      public var emotionMap:HashMap = new HashMap();
      
      private var tempStr:String;
      
      private var colorMap:HashMap = new HashMap();
      
      public function ParseDialogStr(_arg_1:String)
      {
         super();
         this.spliceStr(_arg_1);
      }
      
      private function spliceStr(_arg_1:String) : void
      {
         var _local_2:String = null;
         var _local_3:String = null;
         var _local_4:String = null;
         var _local_5:String = null;
         var _local_6:uint = 0;
         var _local_7:String = null;
         var _local_8:RegExp = null;
         var _local_9:uint = 0;
         var _local_10:uint = 0;
         while(_local_10 < _arg_1.length)
         {
            _local_2 = _arg_1.charAt(_local_10);
            if(_local_2 == "#")
            {
               _local_4 = _arg_1.charAt(_local_10 - 1);
               _local_5 = _arg_1.charAt(_local_10 + 1);
               _local_6 = 0;
               if(_local_4 != "$" && uint(_local_5).toString() == _local_5)
               {
                  this.array.push(_arg_1.slice(0,_local_10));
                  _local_7 = _arg_1.substr(_local_10 + 1,1 + _local_6);
                  while(uint(_local_7) < 100 && uint(_local_7).toString() == _local_7 && _local_6 < _arg_1.length)
                  {
                     _local_6++;
                     _local_7 = _arg_1.substr(_local_10 + 1,1 + _local_6);
                  }
                  this.tempStr = _arg_1.substring(_local_10 + 1 + _local_6,_arg_1.length);
                  this.emotionMap.add(this.array.length,uint(_arg_1.slice(_local_10 + 1,_local_10 + 1 + _local_6)));
                  this.spliceStr(this.tempStr);
                  return;
               }
            }
            _local_3 = _arg_1.substr(_local_10,2);
            if(_local_3 == "0x")
            {
               this.array.push(_arg_1.slice(0,_local_10));
               _local_8 = /[a-z0-9A-Z]/;
               _local_9 = 0;
               while(Boolean(_local_8.test(_arg_1.substr(_local_10 + 2 + _local_9,1))) && _local_9 < 6)
               {
                  _local_9++;
               }
               if(_local_9 > 0)
               {
                  this.colorMap.add(this.array.length,_arg_1.substr(_local_10 + 2,_local_9));
                  this.tempStr = _arg_1.substring(_local_10 + 2 + _local_9,_arg_1.length);
                  this.spliceStr(this.tempStr);
               }
               else
               {
                  this.array.push(_local_3);
                  this.tempStr = _arg_1.substring(_local_10 + 2,_arg_1.length);
                  this.spliceStr(this.tempStr);
               }
               return;
            }
            if(_local_10 == _arg_1.length - 1)
            {
               this.array.push(_arg_1.slice());
               return;
            }
            _local_10++;
         }
      }
      
      public function getColor(_arg_1:uint) : String
      {
         if(!this.colorMap.containsKey(_arg_1))
         {
            return "ffffff";
         }
         return this.colorMap.getValue(_arg_1);
      }
      
      public function get strArray() : Array
      {
         return this.array;
      }
      
      public function get str() : String
      {
         return this.array.join(SPLIT);
      }
      
      public function getEmotionNum(_arg_1:uint) : int
      {
         if(!this.emotionMap.containsKey(_arg_1))
         {
            return -1;
         }
         return this.emotionMap.getValue(_arg_1);
      }
   }
}

