package com.robot.core.info.pet
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PetBargeListInfo
   {
      
      private var _data:ByteArray;
      
      private var _monCount:uint;
      
      private var _monID:uint;
      
      private var _enCntCnt:uint;
      
      private var _isCatched:uint;
      
      private var _isKilled:uint;
      
      private var _petBargeIdList:Array;
      
      private var _isCatchedList:Array;
      
      private var _enCntCntList:Array;
      
      private var _isKillList:Array;
      
      public function PetBargeListInfo(_arg_1:IDataInput = null)
      {
         var _local_2:uint = 0;
         this._petBargeIdList = [];
         this._isCatchedList = [];
         this._enCntCntList = [];
         this._isKillList = [];
         super();
         if(Boolean(_arg_1))
         {
            this._data = new ByteArray();
            _arg_1.readBytes(this._data);
            (_arg_1 as ByteArray).position = 0;
            this._monCount = _arg_1.readUnsignedInt();
            _local_2 = 0;
            while(_local_2 < this._monCount)
            {
               this._monID = _arg_1.readUnsignedInt();
               this._enCntCnt = _arg_1.readUnsignedInt();
               this._isCatched = _arg_1.readUnsignedInt();
               this._isKilled = _arg_1.readUnsignedInt();
               this._petBargeIdList.push(this._monID);
               this._isCatchedList.push([this._monID,this._isCatched]);
               this._enCntCntList.push([this._monID,this._enCntCnt]);
               this._isKillList.push([this._monID,this._isKilled]);
               _local_2++;
            }
         }
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
      
      public function get petBargeIdList() : Array
      {
         return this._petBargeIdList;
      }
      
      public function get isCatchedList() : Array
      {
         return this._isCatchedList;
      }
      
      public function get enCntCntList() : Array
      {
         return this._enCntCntList;
      }
      
      public function get isKillList() : Array
      {
         return this._isKillList;
      }
   }
}

