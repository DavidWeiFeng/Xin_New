package com.robot.core.info.pet
{
   import flash.utils.IDataInput;
   
   public class PetFusionInfo
   {
      
      public var obtainTime:uint;
      
      public var soulID:uint;
      
      public var starterCpTm:uint;
      
      public var costItemFlag:uint;
      
      public function PetFusionInfo(_arg_1:IDataInput)
      {
         super();
         this.obtainTime = _arg_1.readUnsignedInt();
         this.soulID = _arg_1.readUnsignedInt();
         this.starterCpTm = _arg_1.readUnsignedInt();
         this.costItemFlag = _arg_1.readUnsignedInt();
      }
   }
}

