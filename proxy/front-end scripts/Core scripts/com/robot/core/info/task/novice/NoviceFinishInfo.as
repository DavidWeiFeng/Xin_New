package com.robot.core.info.task.novice
{
   import flash.utils.IDataInput;
   
   public class NoviceFinishInfo
   {
      
      private var _taskID:uint;
      
      private var _petID:uint;
      
      private var _captureTm:uint;
      
      private var _itemID:uint;
      
      private var _itemCnt:uint;
      
      private var _monBallList:Array;
      
      public function NoviceFinishInfo(_arg_1:IDataInput)
      {
         var _local_3:uint = 0;
         super();
         this._monBallList = new Array();
         this._taskID = _arg_1.readUnsignedInt();
         this._petID = _arg_1.readUnsignedInt();
         this._captureTm = _arg_1.readUnsignedInt();
         var _local_2:uint = _arg_1.readUnsignedInt();
         while(_local_3 < _local_2)
         {
            this._itemID = _arg_1.readUnsignedInt();
            this._itemCnt = _arg_1.readUnsignedInt();
            this._monBallList.push({
               "itemID":this._itemID,
               "itemCnt":this._itemCnt
            });
            _local_3++;
         }
      }
      
      public function get monBallList() : Array
      {
         return this._monBallList;
      }
      
      public function get petID() : uint
      {
         return this._petID;
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
      
      public function get captureTm() : uint
      {
         return this._captureTm;
      }
   }
}

