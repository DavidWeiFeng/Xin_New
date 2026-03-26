package com.robot.core.info.pet.update
{
   import flash.utils.IDataInput;
   
   public class UpdateSkillInfo
   {
      
      private var _petCatchTime:uint;
      
      private var _activeSkills:Array;
      
      private var _unactiveSkills:Array;
      
      public function UpdateSkillInfo(_arg_1:IDataInput)
      {
         var _local_4:uint = 0;
         var _local_5:uint = 0;
         this._activeSkills = [];
         this._unactiveSkills = [];
         super();
         this._petCatchTime = _arg_1.readUnsignedInt();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         var _local_3:uint = uint(_arg_1.readUnsignedInt());
         while(_local_4 < _local_2)
         {
            this._activeSkills.push(_arg_1.readUnsignedInt());
            _local_4++;
         }
         while(_local_5 < _local_3)
         {
            this._unactiveSkills.push(_arg_1.readUnsignedInt());
            _local_5++;
         }
      }
      
      public function get petCatchTime() : uint
      {
         return this._petCatchTime;
      }
      
      public function get activeSkills() : Array
      {
         return this._activeSkills;
      }
      
      public function get unactiveSkills() : Array
      {
         return this._unactiveSkills;
      }
   }
}

