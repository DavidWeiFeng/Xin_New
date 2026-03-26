package com.robot.app.freshFightLevel
{
   import flash.utils.IDataInput;
   
   public class FreshChoiceLevelRequestInfo
   {
      
      private var bossId:uint;
      
      private var curFightLevel:uint;
      
      private var _bossIdA:Array;
      
      public function FreshChoiceLevelRequestInfo(_arg_1:IDataInput = null)
      {
         var _local_2:uint = 0;
         var _local_3:int = 0;
         super();
         if(_arg_1 != null)
         {
            this._bossIdA = [];
            this.curFightLevel = _arg_1.readUnsignedInt();
            _local_2 = uint(_arg_1.readUnsignedInt());
            _local_3 = 0;
            while(_local_3 < _local_2)
            {
               this._bossIdA.push(_arg_1.readUnsignedInt());
               _local_3++;
            }
         }
      }
      
      public function get getBossId() : Array
      {
         return this._bossIdA;
      }
      
      public function get getLevel() : uint
      {
         return this.curFightLevel;
      }
   }
}

