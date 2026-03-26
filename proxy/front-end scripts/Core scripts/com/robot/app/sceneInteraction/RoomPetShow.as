package com.robot.app.sceneInteraction
{
   import com.robot.core.event.*;
   import com.robot.core.info.pet.PetListInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.pet.*;
   import flash.events.*;
   import org.taomee.ds.*;
   
   public class RoomPetShow
   {
      
      private var _petMap:HashMap = new HashMap();
      
      private var _allowLen:int = 0;
      
      private var _allowArr:Array;
      
      private var _appModel:AppModel;
      
      public function RoomPetShow(_arg_1:uint)
      {
         super();
         this._allowArr = MapManager.currentMap.allowData;
         this._allowLen = this._allowArr.length;
         RoomPetManager.getInstance().addEventListener(PetEvent.ROOM_PET_LIST,this.onList);
         RoomPetManager.getInstance().addEventListener(PetEvent.ROOM_PET_SHOW,this.onShow);
         RoomPetManager.getInstance().getShowList(_arg_1);
         PetManager.addEventListener(PetEvent.STORAGE_REMOVED,this.onRemoveStorage);
      }
      
      public function destroy() : void
      {
         PetManager.removeEventListener(PetEvent.STORAGE_REMOVED,this.onRemoveStorage);
         RoomPetManager.getInstance().removeEventListener(PetEvent.ROOM_PET_LIST,this.onList);
         RoomPetManager.getInstance().removeEventListener(PetEvent.ROOM_PET_SHOW,this.onShow);
         this._petMap.eachKey(function(_arg_1:uint):void
         {
            var _local_2:RoomPetModel = _petMap.remove(_arg_1);
            _local_2.destroy();
            _local_2 = null;
         });
         this._petMap = null;
         RoomPetManager.destroy();
         if(Boolean(this._appModel))
         {
            this._appModel.destroy();
         }
      }
      
      private function update() : void
      {
         var arr:Array = null;
         var info:PetListInfo = null;
         var pm:RoomPetModel = null;
         this._petMap.eachKey(function(_arg_1:uint):void
         {
            var _local_2:RoomPetModel = null;
            if(!RoomPetManager.getInstance().contains(_arg_1))
            {
               _local_2 = _petMap.remove(_arg_1);
               _local_2.destroy();
               _local_2 = null;
            }
         });
         arr = RoomPetManager.getInstance().getInfos();
         for each(info in arr)
         {
            if(!this._petMap.containsKey(info.catchTime))
            {
               pm = new RoomPetModel(info);
               this._petMap.add(info.catchTime,pm);
               pm.show(this._allowArr[int(Math.random() * this._allowLen)]);
               pm.addEventListener(MouseEvent.CLICK,this.onClick);
            }
         }
      }
      
      private function onList(_arg_1:Event) : void
      {
         RoomPetManager.getInstance().removeEventListener(PetEvent.ROOM_PET_LIST,this.onList);
         this.update();
      }
      
      private function onShow(_arg_1:Event) : void
      {
         this.update();
      }
      
      private function onClick(_arg_1:MouseEvent) : void
      {
         var _local_2:RoomPetModel = _arg_1.currentTarget as RoomPetModel;
         PetInfoController.getInfo(true,MainManager.actorInfo.mapID,_local_2.info.catchTime);
      }
      
      private function onRemoveStorage(_arg_1:PetEvent) : void
      {
         RoomPetManager.getInstance().removePet(_arg_1.catchTime());
      }
   }
}

