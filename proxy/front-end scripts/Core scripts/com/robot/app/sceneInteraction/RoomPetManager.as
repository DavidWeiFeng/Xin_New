package com.robot.app.sceneInteraction
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.pet.PetListInfo;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   
   public class RoomPetManager extends EventDispatcher
   {
      
      private static var _instance:RoomPetManager;
      
      private var _petMap:HashMap = new HashMap();
      
      private var _isget:Boolean;
      
      public function RoomPetManager()
      {
         super();
      }
      
      public static function getInstance() : RoomPetManager
      {
         if(_instance == null)
         {
            _instance = new RoomPetManager();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(Boolean(_instance))
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function getShowList(_arg_1:uint) : void
      {
         if(this._isget)
         {
            dispatchEvent(new PetEvent(PetEvent.ROOM_PET_LIST,0));
            return;
         }
         SocketConnection.addCmdListener(CommandID.PET_ROOM_LIST,this.onList);
         SocketConnection.addCmdListener(CommandID.PET_ROOM_SHOW,this.onList);
         SocketConnection.send(CommandID.PET_ROOM_LIST,_arg_1);
      }
      
      public function getInfos() : Array
      {
         return this._petMap.getValues();
      }
      
      public function showOrHide(_arg_1:PetListInfo, _arg_2:Boolean) : void
      {
         var _local_3:PetListInfo = null;
         if(_arg_2)
         {
            if(this._petMap.length == 5)
            {
               Alarm.show("你已经有5个精灵在展示，再添加的话，精灵会觉得很拥挤哦");
               return;
            }
            this._petMap.add(_arg_1.catchTime,_arg_1);
         }
         else if(!this._petMap.remove(_arg_1.catchTime))
         {
            return;
         }
         var _local_4:Array = this._petMap.getValues();
         if(_local_4.length == 0)
         {
            SocketConnection.send(CommandID.PET_ROOM_SHOW,0);
            return;
         }
         var _local_5:ByteArray = new ByteArray();
         for each(_local_3 in _local_4)
         {
            _local_5.writeUnsignedInt(_local_3.catchTime);
            _local_5.writeUnsignedInt(_local_3.id);
         }
         SocketConnection.send(CommandID.PET_ROOM_SHOW,this._petMap.length,_local_5);
      }
      
      public function removePet(_arg_1:uint) : void
      {
         if(Boolean(this._petMap.remove(_arg_1)))
         {
            dispatchEvent(new PetEvent(PetEvent.ROOM_PET_SHOW,0));
         }
      }
      
      public function contains(_arg_1:uint) : Boolean
      {
         return this._petMap.containsKey(_arg_1);
      }
      
      public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_ROOM_LIST,this.onList);
         SocketConnection.removeCmdListener(CommandID.PET_ROOM_SHOW,this.onList);
         this._petMap = null;
      }
      
      private function onList(_arg_1:SocketEvent) : void
      {
         var _local_2:PetListInfo = null;
         var _local_5:int = 0;
         this._petMap.clear();
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         while(_local_5 < _local_4)
         {
            _local_2 = new PetListInfo(_local_3);
            this._petMap.add(_local_2.catchTime,_local_2);
            _local_5++;
         }
         if(_arg_1.headInfo.cmdID == CommandID.PET_ROOM_LIST)
         {
            this._isget = true;
            SocketConnection.removeCmdListener(CommandID.PET_ROOM_LIST,this.onList);
            dispatchEvent(new PetEvent(PetEvent.ROOM_PET_LIST,0));
         }
         else
         {
            dispatchEvent(new PetEvent(PetEvent.ROOM_PET_SHOW,0));
         }
      }
   }
}

