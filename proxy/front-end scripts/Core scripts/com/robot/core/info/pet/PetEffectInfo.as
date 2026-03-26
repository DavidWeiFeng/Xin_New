package com.robot.core.info.pet
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PetEffectInfo
   {
      
      public var itemId:uint;
      
      public var status:uint;
      
      public var leftCount:uint;
      
      public var effectID:uint;
      
      public var param:ByteArray;
      
      public var args:String;
      
      public function PetEffectInfo(_arg_1:IDataInput)
      {
         super();
         this.itemId = _arg_1.readUnsignedInt();
         this.status = _arg_1.readUnsignedByte();
         this.leftCount = _arg_1.readUnsignedByte();
         this.effectID = _arg_1.readUnsignedShort();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         var _local_5:uint = 0;
         this.args = _arg_1.readUnsignedInt().toString();
         while(_local_5 < _local_2 - 1)
         {
            this.args += " " + _arg_1.readUnsignedInt();
            _local_5++;
         }
      }
   }
}

