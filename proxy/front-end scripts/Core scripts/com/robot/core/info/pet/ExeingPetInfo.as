package com.robot.core.info.pet
{
   import flash.utils.IDataInput;
   
   public class ExeingPetInfo
   {
      
      public var _flag:uint;
      
      public var _remainDay:uint;
      
      public var _course:uint;
      
      public var _capTm:Number;
      
      public var _petId:uint;
      
      public function ExeingPetInfo(_arg_1:IDataInput = null)
      {
         super();
         if(Boolean(_arg_1))
         {
            this._flag = _arg_1.readUnsignedInt();
            this._capTm = _arg_1.readUnsignedInt();
            this._petId = _arg_1.readUnsignedInt();
            this._remainDay = _arg_1.readUnsignedInt() / 3600;
            this._course = _arg_1.readUnsignedInt();
         }
      }
   }
}

