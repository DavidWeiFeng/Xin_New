package com.robot.core.info.task
{
   import flash.utils.IDataInput;
   
   public class BossMonsterInfo
   {
      
      private var _bonusID:uint;
      
      private var _exp:uint;
      
      private var _ev:uint;
      
      private var _petID:uint;
      
      private var _captureTm:uint;
      
      private var _itemID:uint;
      
      private var _itemCnt:uint;
      
      private var _monBallList:Array;
      
      public function BossMonsterInfo(_arg_1:IDataInput)
      {
         var _local_3:uint = 0;
         super();
         this._bonusID = _arg_1.readUnsignedInt();
         this._exp = _arg_1.readUnsignedInt();
         this._ev = _arg_1.readUnsignedInt();
         this._monBallList = new Array();
         this._petID = _arg_1.readUnsignedInt();
         this._captureTm = _arg_1.readUnsignedInt();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
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
      
      public function get bonusID() : uint
      {
         return this._bonusID;
      }
      
      public function get exp() : uint
      {
         return this._exp;
      }
      
      public function get ev() : uint
      {
         return this._ev;
      }
      
      public function get monBallList() : Array
      {
         return this._monBallList;
      }
      
      public function get petID() : uint
      {
         return this._petID;
      }
      
      public function get captureTm() : uint
      {
         return this._captureTm;
      }
   }
}

