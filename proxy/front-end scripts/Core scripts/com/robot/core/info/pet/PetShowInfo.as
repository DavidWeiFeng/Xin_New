package com.robot.core.info.pet
{
   import flash.utils.IDataInput;
   
   public class PetShowInfo
   {
      
      public var userID:uint;
      
      public var catchTime:uint;
      
      public var petID:uint;
      
      public var flag:uint;
      
      public var dv:uint;
      
      public var isshiny:uint;
      
      public var shiny:PetGlowFilter;
      
      public var skinID:uint;
      
      public function PetShowInfo(_arg_1:IDataInput = null)
      {
         var _local_2:int = 0;
         super();
         if(Boolean(_arg_1))
         {
            this.userID = _arg_1.readUnsignedInt();
            this.catchTime = _arg_1.readUnsignedInt();
            this.petID = _arg_1.readUnsignedInt();
            this.flag = _arg_1.readUnsignedInt();
            this.dv = _arg_1.readUnsignedInt();
            this.isshiny = _arg_1.readUnsignedInt();
            if(Boolean(this.isshiny))
            {
               this.shiny = new PetGlowFilter(_arg_1);
            }
            this.skinID = _arg_1.readUnsignedInt();
            _local_2 = 0;
            while(_local_2 < 3)
            {
               _arg_1.readUnsignedInt();
               _local_2++;
            }
         }
      }
   }
}

