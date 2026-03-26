package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.ui.alert.Alarm;
   
   public class PetProTool
   {
      
      public function PetProTool()
      {
         super();
      }
      
      public static function checkLimitPetClass(param1:PetPropInfo) : Boolean
      {
         var _loc2_:int = int(param1.itemId);
         var _loc3_:int = int(ItemXMLInfo.getLimitPetClass(_loc2_));
         if(_loc3_ > 0 && _loc3_ != PetXMLInfo.getPetClass(param1.petInfo.id))
         {
            Alarm.show(ItemXMLInfo.getName(_loc2_) + "不能使用在" + PetXMLInfo.getName(param1.petInfo.id) + "身上！");
            return false;
         }
         return true;
      }
   }
}

