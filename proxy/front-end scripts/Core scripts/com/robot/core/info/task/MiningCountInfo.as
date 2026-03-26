package com.robot.core.info.task
{
   import flash.utils.IDataInput;
   
   public class MiningCountInfo
   {
      
      private var _miningCout:uint;
      
      public function MiningCountInfo(_arg_1:IDataInput)
      {
         super();
         this._miningCout = _arg_1.readUnsignedInt();
      }
      
      public function get miningCount() : uint
      {
         return this._miningCout;
      }
   }
}

