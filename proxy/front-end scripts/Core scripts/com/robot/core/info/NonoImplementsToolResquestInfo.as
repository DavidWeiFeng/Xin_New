package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class NonoImplementsToolResquestInfo
   {
      
      private var _id:uint;
      
      private var _itemId:uint;
      
      private var _power:uint;
      
      private var _ai:uint;
      
      private var _mate:uint;
      
      private var _iq:uint;
      
      public function NonoImplementsToolResquestInfo(_arg_1:IDataInput)
      {
         super();
         this._id = _arg_1.readUnsignedInt();
         this._itemId = _arg_1.readUnsignedInt();
         this._power = _arg_1.readUnsignedInt() / 1000;
         this._ai = _arg_1.readUnsignedShort();
         this._mate = _arg_1.readUnsignedInt() / 1000;
         this._iq = _arg_1.readUnsignedInt();
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get itemId() : uint
      {
         return this._itemId;
      }
      
      public function get power() : uint
      {
         return this._power;
      }
      
      public function get ai() : uint
      {
         return this._ai;
      }
      
      public function get mate() : uint
      {
         return this._mate;
      }
      
      public function get iq() : uint
      {
         return this._iq;
      }
   }
}

