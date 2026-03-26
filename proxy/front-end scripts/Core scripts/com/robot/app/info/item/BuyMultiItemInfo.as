package com.robot.app.info.item
{
   import flash.utils.IDataInput;
   
   public class BuyMultiItemInfo
   {
      
      private var _cash:uint;
      
      public function BuyMultiItemInfo(_arg_1:IDataInput)
      {
         super();
         this._cash = _arg_1.readUnsignedInt();
      }
      
      public function get cash() : uint
      {
         return this._cash;
      }
   }
}

