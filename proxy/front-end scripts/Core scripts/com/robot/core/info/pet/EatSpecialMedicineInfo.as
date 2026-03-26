package com.robot.core.info.pet
{
   import flash.utils.IDataInput;
   
   public class EatSpecialMedicineInfo
   {
      
      private var _catchTime:uint;
      
      private var _effectID:uint;
      
      private var _leftCount:uint;
      
      public function EatSpecialMedicineInfo(_arg_1:IDataInput)
      {
         super();
         this._catchTime = _arg_1.readUnsignedInt();
         if(this._catchTime != 0)
         {
            this._effectID = _arg_1.readUnsignedShort();
            this._leftCount = _arg_1.readByte();
         }
      }
      
      public function get catchTime() : uint
      {
         return this._catchTime;
      }
      
      public function get effectID() : uint
      {
         return this._effectID;
      }
      
      public function get leftCount() : uint
      {
         return this._leftCount;
      }
   }
}

