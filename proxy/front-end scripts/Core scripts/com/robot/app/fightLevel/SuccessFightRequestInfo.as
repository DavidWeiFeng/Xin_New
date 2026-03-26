package com.robot.app.fightLevel
{
   import flash.utils.IDataInput;
   
   public class SuccessFightRequestInfo
   {
      
      private var bossId:Array;
      
      private var curLevel:uint;
      
      private var _bossIdA:Array;
      
      public function SuccessFightRequestInfo(_arg_1:IDataInput)
      {
         var _local_3:int = 0;
         super();
         this._bossIdA = [];
         this.curLevel = _arg_1.readUnsignedInt();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         while(_local_3 < _local_2)
         {
            this._bossIdA.push(_arg_1.readUnsignedInt());
            _local_3++;
         }
      }
      
      public function get getBossId() : Array
      {
         return this._bossIdA;
      }
      
      public function get getCurLevel() : uint
      {
         return this.curLevel;
      }
   }
}

