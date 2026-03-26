package com.robot.core.net
{
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import org.taomee.manager.ResourceManager;
   
   public class BefLoad extends BaseBeanController
   {
      
      private static const PET_PATH:String = "resource/fightResource/pet/swf/";
      
      private static const SKILL_PATH:String = "resource/fightResource/skill/swf/";
      
      public function BefLoad()
      {
         super();
      }
      
      override public function start() : void
      {
         var _local_1:PetInfo = null;
         var _local_2:Array = null;
         var _local_3:PetSkillInfo = null;
         var _local_4:Array = PetManager.infos;
         for each(_local_1 in _local_4)
         {
            ResourceManager.addBef(PET_PATH + _local_1.id.toString() + ".swf","pet",false);
            _local_2 = _local_1.skillArray;
            for each(_local_3 in _local_2)
            {
               ResourceManager.addBef(SKILL_PATH + _local_3.id.toString() + ".swf","skill",false);
            }
         }
         finish();
      }
   }
}

