package com.robot.core.info.task
{
   import flash.utils.IDataInput;
   
   public class ExchangeOreInfo
   {
      
      private var _paiDou:uint;
      
      private var _oreCount:uint;
      
      public function ExchangeOreInfo(_arg_1:IDataInput)
      {
         super();
         this._oreCount = _arg_1.readUnsignedInt();
         this._paiDou = _arg_1.readUnsignedInt();
      }
      
      public function get paiDou() : uint
      {
         return this._paiDou;
      }
      
      public function get oreCount() : uint
      {
         return this._oreCount;
      }
   }
}

