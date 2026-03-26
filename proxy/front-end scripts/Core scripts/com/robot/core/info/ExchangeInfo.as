package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class ExchangeInfo
   {
      
      public var _exchangeID:uint;
      
      public var _exchangeNum:uint;
      
      public function ExchangeInfo(data:IDataInput = null)
      {
         super();
         if(data != null)
         {
            this._exchangeID = data.readUnsignedInt();
            this._exchangeNum = data.readUnsignedInt();
         }
      }
      
      public function set exchangeID(value:uint) : void
      {
         this._exchangeID = value;
      }
      
      public function get exchangeID() : uint
      {
         return this._exchangeID;
      }
      
      public function set exchangeNum(value:uint) : void
      {
         this._exchangeNum = value;
      }
      
      public function get exchangeNum() : uint
      {
         return this._exchangeNum;
      }
   }
}

