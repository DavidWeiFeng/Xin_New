package com.robot.core.pet
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.info.RoomPetInfo;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class PetInfoController extends BaseBeanController
   {
      
      private static var _petInfoApp:AppModel;
      
      private static var _roomPetInfoPanel:AppModel;
      
      public static var _isRoom:Boolean = false;
      
      public function PetInfoController()
      {
         super();
      }
      
      public static function getInfo(_arg_1:Boolean, _arg_2:uint, _arg_3:uint) : void
      {
         _isRoom = _arg_1;
         SocketConnection.send(CommandID.PET_ROOM_INFO,_arg_2,_arg_3);
      }
      
      public static function showPetInfoPanel(_arg_1:RoomPetInfo) : void
      {
         if(!_petInfoApp)
         {
            _petInfoApp = new AppModel(ClientConfig.getAppModule("PetSimpleInfoPanel"),"正在打开精灵信息");
            _petInfoApp.setup();
         }
         _petInfoApp.init(_arg_1);
         _petInfoApp.show();
      }
      
      public static function showRoomInfoPanel(_arg_1:RoomPetInfo) : void
      {
         if(!_roomPetInfoPanel)
         {
            _roomPetInfoPanel = new AppModel(ClientConfig.getAppModule("RoomPetInfoPanel"),"正在打开精灵信息");
            _roomPetInfoPanel.setup();
         }
         _roomPetInfoPanel.init(_arg_1);
         _roomPetInfoPanel.show();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PET_ROOM_INFO,this.onInfoHandler);
         finish();
      }
      
      private function onInfoHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:RoomPetInfo = _arg_1.data as RoomPetInfo;
         if(_isRoom)
         {
            if(Boolean(_petInfoApp))
            {
               _petInfoApp.destroy();
               _petInfoApp = null;
            }
            showRoomInfoPanel(_local_2);
         }
         else
         {
            if(Boolean(_roomPetInfoPanel))
            {
               _roomPetInfoPanel.destroy();
               _roomPetInfoPanel = null;
            }
            showPetInfoPanel(_local_2);
         }
      }
   }
}

