package com.robot.core.info.pet
{
   import flash.utils.IDataInput;
   
   public class PetListInfo
   {
      
      public var id:uint;
      
      public var catchTime:uint;
      
      public var course:uint;
      
      public var level:uint;
      
      public var skinID:uint;
      
      public var isshiny:uint;
      
      public var shiny:PetGlowFilter;
      
      public function PetListInfo(_arg_1:IDataInput = null)
      {
         super();
         if(Boolean(_arg_1))
         {
            this.id = _arg_1.readUnsignedInt();
            this.catchTime = _arg_1.readUnsignedInt();
            this.level = _arg_1.readUnsignedInt();
            this.skinID = _arg_1.readUnsignedInt();
            this.isshiny = _arg_1.readUnsignedInt();
            if(Boolean(this.isshiny))
            {
               this.shiny = new PetGlowFilter(_arg_1);
            }
         }
      }
   }
}

