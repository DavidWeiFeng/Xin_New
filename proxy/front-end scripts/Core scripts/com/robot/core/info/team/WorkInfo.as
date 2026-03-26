package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class WorkInfo
   {
      
      public var buyTime:uint;
      
      public var id:uint;
      
      public var resID:uint;
      
      public var workCount:uint;
      
      public var totalRes:uint;
      
      public function WorkInfo(_arg_1:IDataInput)
      {
         super();
         this.buyTime = _arg_1.readUnsignedInt();
         this.id = _arg_1.readUnsignedInt();
         this.resID = _arg_1.readUnsignedInt();
         this.workCount = _arg_1.readUnsignedInt();
         this.totalRes = _arg_1.readUnsignedInt();
      }
   }
}

