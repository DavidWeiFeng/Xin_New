package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.automaticFight.AutomaticFightManager;
   import com.robot.app.petbag.PetPropInfo;
   
   public class PetPropClass_300028
   {
      
      public function PetPropClass_300028(_arg_1:PetPropInfo)
      {
         super();
         AutomaticFightManager.useItem(_arg_1.itemId);
      }
   }
}

