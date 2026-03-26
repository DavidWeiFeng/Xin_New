package com.robot.core.info.task
{
   import flash.utils.IDataInput;
   
   public class MiningInfo
   {
      
      private var _oreCount:uint;
      
      public function MiningInfo(_arg_1:IDataInput)
      {
         super();
         this._oreCount = _arg_1.readUnsignedInt();
      }
      
      public function get oreCount() : uint
      {
         return this._oreCount;
      }
   }
}

