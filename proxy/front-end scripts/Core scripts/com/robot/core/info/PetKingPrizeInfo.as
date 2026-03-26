package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class PetKingPrizeInfo
   {
      
      private var _petID:uint;
      
      private var _catchTime:uint;
      
      public function PetKingPrizeInfo(_arg_1:IDataInput)
      {
         super();
         this._petID = _arg_1.readUnsignedInt();
         this._catchTime = _arg_1.readUnsignedInt();
      }
      
      public function get petID() : uint
      {
         return this._petID;
      }
      
      public function get catchTime() : uint
      {
         return this._catchTime;
      }
   }
}

