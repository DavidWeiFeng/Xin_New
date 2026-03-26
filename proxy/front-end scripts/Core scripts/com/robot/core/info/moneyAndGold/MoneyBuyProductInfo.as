package com.robot.core.info.moneyAndGold
{
   import flash.utils.IDataInput;
   
   public class MoneyBuyProductInfo
   {
      
      private var _payMoney:Number;
      
      private var _money:Number;
      
      public function MoneyBuyProductInfo(_arg_1:IDataInput)
      {
         super();
         _arg_1.readUnsignedInt();
         this._payMoney = _arg_1.readUnsignedInt() / 100;
         this._money = _arg_1.readUnsignedInt() / 100;
      }
      
      public function get payMoney() : Number
      {
         return this._payMoney;
      }
      
      public function get money() : Number
      {
         return this._money;
      }
   }
}

