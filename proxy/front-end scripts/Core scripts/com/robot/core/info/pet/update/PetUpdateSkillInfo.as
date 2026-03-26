package com.robot.core.info.pet.update
{
   import flash.utils.IDataInput;
   
   public class PetUpdateSkillInfo
   {
      
      private var _infoArray:Array;
      
      public function PetUpdateSkillInfo(_arg_1:IDataInput)
      {
         var _local_3:uint = 0;
         this._infoArray = [];
         super();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         while(_local_3 < _local_2)
         {
            this._infoArray.push(new UpdateSkillInfo(_arg_1));
            _local_3++;
         }
      }
      
      public function get infoArray() : Array
      {
         return this._infoArray;
      }
   }
}

