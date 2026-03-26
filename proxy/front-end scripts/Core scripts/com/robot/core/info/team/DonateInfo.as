package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class DonateInfo
   {
      
      public var buyTime:uint;
      
      public var id:uint;
      
      public var resID:uint;
      
      public var donateCount:uint;
      
      public var totalRes:uint;
      
      public function DonateInfo(_arg_1:IDataInput)
      {
         super();
         this.buyTime = _arg_1.readUnsignedInt();
         this.id = _arg_1.readUnsignedInt();
         this.resID = _arg_1.readUnsignedInt();
         this.donateCount = _arg_1.readUnsignedInt();
         this.totalRes = _arg_1.readUnsignedInt();
      }
   }
}

