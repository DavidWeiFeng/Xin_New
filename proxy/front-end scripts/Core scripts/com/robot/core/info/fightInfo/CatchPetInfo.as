package com.robot.core.info.fightInfo
{
   import flash.utils.IDataInput;
   
   public class CatchPetInfo
   {
      
      private var _catchTime:uint;
      
      private var _petID:uint;
      
      public function CatchPetInfo(_arg_1:IDataInput)
      {
         super();
         this._catchTime = _arg_1.readUnsignedInt();
         this._petID = _arg_1.readUnsignedInt();
      }
      
      public function get catchTime() : uint
      {
         return this._catchTime;
      }
      
      public function get petID() : uint
      {
         return this._petID;
      }
   }
}

