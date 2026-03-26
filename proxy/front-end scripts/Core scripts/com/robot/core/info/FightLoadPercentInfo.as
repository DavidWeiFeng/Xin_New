package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class FightLoadPercentInfo
   {
      
      private var _id:uint;
      
      private var _percent:uint;
      
      public function FightLoadPercentInfo(_arg_1:IDataInput)
      {
         super();
         this._id = _arg_1.readUnsignedInt();
         this._percent = _arg_1.readUnsignedInt();
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get percent() : uint
      {
         return this._percent;
      }
   }
}

