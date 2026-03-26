package com.robot.core.info.pet.update
{
   import flash.utils.IDataInput;
   
   public class PetUpdatePropInfo
   {
      
      private var _addition:uint;
      
      private var _dataArray:Array;
      
      public function PetUpdatePropInfo(_arg_1:IDataInput)
      {
         var _local_3:uint = 0;
         this._dataArray = [];
         super();
         this._addition = _arg_1.readUnsignedInt();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         while(_local_3 < _local_2)
         {
            this._dataArray.push(new UpdatePropInfo(_arg_1));
            _local_3++;
         }
      }
      
      public function get dataArray() : Array
      {
         return this._dataArray;
      }
      
      public function get addition() : Number
      {
         return this._addition / 100;
      }
      
      public function get addPer() : uint
      {
         return this._addition;
      }
   }
}

