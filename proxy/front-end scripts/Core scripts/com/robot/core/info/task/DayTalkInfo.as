package com.robot.core.info.task
{
   import flash.utils.IDataInput;
   
   public class DayTalkInfo
   {
      
      private var _cateCount:uint;
      
      private var _cateList:Array;
      
      private var _outCount:uint;
      
      private var _outList:Array;
      
      public function DayTalkInfo(_arg_1:IDataInput)
      {
         var _local_2:int = 0;
         var _local_3:int = 0;
         this._cateList = [];
         this._outList = [];
         super();
         this._cateCount = _arg_1.readUnsignedInt();
         while(_local_2 < this._cateCount)
         {
            this._cateList.push(new CateInfo(_arg_1));
            _local_2++;
         }
         this._outCount = _arg_1.readUnsignedInt();
         while(_local_3 < this._outCount)
         {
            this._outList.push(new CateInfo(_arg_1));
            _local_3++;
         }
      }
      
      public function get outCount() : uint
      {
         return this._outCount;
      }
      
      public function get outList() : Array
      {
         return this._outList;
      }
   }
}

