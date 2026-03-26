package com.robot.app.petUpdate
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import flash.utils.*;
   
   public class ModifyPetManagerInfo
   {
      
      public function ModifyPetManagerInfo()
      {
         super();
      }
      
      public static function addSkill(_arg_1:uint, _arg_2:uint) : void
      {
         var _local_3:PetInfo = PetManager.getPetInfo(_arg_1);
         if(_local_3.skillArray.length == 4)
         {
            throw new Error("宠物技能已经为四个，不能再手动添加技能");
         }
         var _local_4:ByteArray = new ByteArray();
         _local_4.writeUnsignedInt(_arg_2);
         _local_4.writeUnsignedInt(SkillXMLInfo.getPP(_arg_2));
         _local_4.position = 0;
         _local_3.skillArray.push(new PetSkillInfo(_local_4));
      }
      
      public static function replaceSkill(_arg_1:uint, _arg_2:Array, _arg_3:Array) : void
      {
         var _local_4:uint = 0;
         var _local_5:PetSkillInfo = null;
         var _local_6:uint = 0;
         var _local_7:uint = 0;
         var _local_8:ByteArray = null;
         var _local_10:uint = 0;
         var _local_9:PetInfo = PetManager.getPetInfo(_arg_1);
         for each(_local_4 in _arg_2)
         {
            _local_5 = _local_9.getSkillInfo(_local_4);
            _local_6 = uint(_local_9.skillArray.indexOf(_local_5));
            _local_7 = uint(_arg_3[_local_10]);
            _local_8 = new ByteArray();
            _local_8.writeUnsignedInt(_local_7);
            _local_8.writeUnsignedInt(SkillXMLInfo.getPP(_local_7));
            _local_8.position = 0;
            _local_9.skillArray[_local_6] = new PetSkillInfo(_local_8);
            _local_10++;
         }
      }
   }
}

