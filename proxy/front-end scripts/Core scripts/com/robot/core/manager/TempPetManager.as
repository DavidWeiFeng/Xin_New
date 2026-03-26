package com.robot.core.manager
{
   import com.robot.core.event.MapEvent;
   import com.robot.core.mode.TempPetModel;
   
   public class TempPetManager
   {
      
      private static var _tempPet:TempPetModel;
      
      private static var petID:uint;
      
      public function TempPetManager()
      {
         super();
      }
      
      public static function showTempPet(_arg_1:uint) : void
      {
         petID = _arg_1;
         if(petID == 0)
         {
            return;
         }
         if(_tempPet == null)
         {
            _tempPet = new TempPetModel(MainManager.actorModel);
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onChangeMapComp);
         }
         _tempPet.show(petID);
      }
      
      private static function onChangeMapComp(_arg_1:MapEvent) : void
      {
         showTempPet(petID);
      }
      
      public static function hideTempPet() : void
      {
         if(Boolean(_tempPet))
         {
            MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onChangeMapComp);
            _tempPet.destroy();
            _tempPet = null;
         }
      }
   }
}

