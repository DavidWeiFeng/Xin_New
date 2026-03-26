package com.robot.core.info.moneyAndGold
{
   import flash.utils.IDataInput;
   
   public class GoldBuyProductInfo
   {
      
      private var _payGold:Number;
      
      private var _gold:Number;
      
      public function GoldBuyProductInfo(_arg_1:IDataInput)
      {
         super();
         _arg_1.readUnsignedInt();
         this._payGold = _arg_1.readUnsignedInt() / 100;
         this._gold = _arg_1.readUnsignedInt() / 100;
      }
      
      public function get payGold() : Number
      {
         return this._payGold;
      }
      
      public function get gold() : Number
      {
         return this._gold;
      }
   }
}

