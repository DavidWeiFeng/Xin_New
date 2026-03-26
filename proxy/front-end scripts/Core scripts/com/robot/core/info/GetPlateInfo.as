package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class GetPlateInfo
   {
      
      private var _count:uint = 0;
      
      public function GetPlateInfo(_arg_1:IDataInput)
      {
         super();
         this._count = _arg_1.readUnsignedInt();
      }
      
      public function get PlateCount() : uint
      {
         return this._count;
      }
   }
}

