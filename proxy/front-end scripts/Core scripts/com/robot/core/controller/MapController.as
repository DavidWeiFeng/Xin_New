package com.robot.core.controller
{
   import com.robot.core.*;
   import com.robot.core.aticon.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.manager.map.config.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.teamInstallation.*;
   import com.robot.core.teamPK.*;
   import com.robot.core.teamPK.shotActive.*;
   import com.robot.core.utils.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.algo.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapController
   {
      
      private static var _isReMap:Boolean = false;
      
      private static var _isChange:Boolean = false;
      
      private static var _isLogin:Boolean = true;
      
      private static var _isSwitching:Boolean = false;
      
      private var _mapModel:MapModel;
      
      private var _newMapID:uint;
      
      private var _dir:int = 0;
      
      private var _roomCol:RoomController;
      
      private var _isShowLoading:Boolean = true;
      
      private var _mapType:uint;
      
      private var _tempStyleID:uint;
      
      public var isChangeLocal:Boolean = false;
      
      public function MapController()
      {
         super();
      }
      
      public static function get isReMap() : Boolean
      {
         return _isReMap;
      }
      
      public function get newMapID() : uint
      {
         return this._newMapID;
      }
      
      public function changeLocalMap(_arg_1:uint, _arg_2:uint = 0) : void
      {
         this.isChangeLocal = true;
         this._dir = _arg_2;
         this._newMapID = _arg_1;
         this._mapType = 0;
         this._tempStyleID = 0;
         _isChange = true;
         _isReMap = false;
         this.startSwitch();
      }
      
      public function closeChange() : void
      {
         this._mapModel.closeChange();
      }
      
      public function changeMap(_arg_1:uint, _arg_2:int = 0, _arg_3:uint = 0) : void
      {
         this.isChangeLocal = false;
         if(_isSwitching)
         {
            return;
         }
         if(!_isLogin)
         {
            if(_arg_1 == MainManager.actorInfo.mapID || _arg_1 == this._newMapID)
            {
               if(_arg_3 == MapManager.type || _arg_3 == this._mapType)
               {
                  if(_arg_3 <= MapManager.TYPE_MAX && _arg_1 != MapManager.TOWER_MAP && _arg_1 != MapManager.FRESH_TRIALS)
                  {
                     return;
                  }
               }
            }
            MouseController.removeMouseEvent();
         }
         this._dir = _arg_2;
         this._newMapID = _arg_1;
         this._mapType = _arg_3;
         this._tempStyleID = MapManager.styleID;
         _isChange = true;
         _isReMap = false;
         this.startSwitch();
      }
      
      public function refMap(_arg_1:Boolean = true) : void
      {
         if(_isSwitching)
         {
            return;
         }
         this._isShowLoading = _arg_1;
         _isChange = true;
         _isReMap = true;
         this.startSwitch();
      }
      
      public function destroy() : void
      {
         MapManager.isInMap = false;
         MainManager.actorModel.stop();
         MainManager.actorModel.aimatStateManager.clear();
         MapConfig.clear();
         MapProcessConfig.destroy();
         if(Boolean(MapManager.currentMap))
         {
            MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_DESTROY,MapManager.currentMap));
            MapManager.currentMap.destroy();
            MapManager.currentMap = null;
         }
      }
      
      private function startSwitch() : void
      {
         _isSwitching = true;
         LevelManager.closeMouseEvent();
         if(this._newMapID > MapManager.ID_MAX)
         {
            switch(this._mapType)
            {
               case MapType.HOOM:
                  FitmentManager.addEventListener(FitmentEvent.USED_LIST,function(_arg_1:FitmentEvent):void
                  {
                     FitmentManager.removeEventListener(FitmentEvent.USED_LIST,arguments.callee);
                     _startSwitch(MapManager.styleID);
                  });
                  FitmentManager.getUsedInfo(this._newMapID);
                  break;
               case MapType.CAMP:
                  ArmManager.addEventListener(ArmEvent.USED_LIST,function(_arg_1:ArmEvent):void
                  {
                     ArmManager.removeEventListener(ArmEvent.USED_LIST,arguments.callee);
                     _startSwitch(MapManager.styleID);
                  });
                  ArmManager.getUsedInfoForServer(this._newMapID);
                  break;
               case MapType.HEAD:
                  HeadquarterManager.addEventListener(FitmentEvent.USED_LIST,function(_arg_1:FitmentEvent):void
                  {
                     HeadquarterManager.removeEventListener(FitmentEvent.USED_LIST,arguments.callee);
                     _startSwitch(MapManager.styleID);
                  });
                  HeadquarterManager.getUsedInfo(this._newMapID);
                  break;
               default:
                  this._startSwitch();
            }
         }
         else
         {
            this._startSwitch();
         }
      }
      
      private function _startSwitch(_arg_1:uint = 0) : void
      {
         MapManager.addEventListener(MapEvent.MAP_INIT,this.onMapInit);
         MapManager.addEventListener(ErrorEvent.ERROR,this.onMapFail);
         MapManager.addEventListener(MapEvent.MAP_LOADER_CLOSE,this.onMapFail);
         this._mapModel = new MapModel(this._newMapID,!_isLogin,this._isShowLoading);
         MapManager.initPos = MapConfig.getMapPeopleXY(MainManager.actorInfo.mapID,this._newMapID);
         ResourceManager.stop();
      }
      
      private function comeInMap() : void
      {
         MainManager.actorModel.showClothLight(true);
         if(this._newMapID == MapManager.FRESH_TRIALS || this._newMapID == MapManager.TOWER_MAP || this.isChangeLocal)
         {
            this.initMapFunction(false);
            return;
         }
         if(this._newMapID < MapManager.ID_MAX)
         {
            MapManager.type = ConnectionType.MAIN;
            if(MainManager.actorInfo.mapID > MapManager.ID_MAX)
            {
               this._roomCol.outRoom(this._newMapID);
            }
         }
         else
         {
            MapManager.type = ConnectionType.ROOM;
            if(MainManager.actorInfo.mapID <= MapManager.ID_MAX)
            {
               this._roomCol.inRoom(this._mapType,MapManager.initPos.x,MapManager.initPos.y);
            }
         }
         SocketConnection.send(CommandID.ENTER_MAP,this._mapType,this._newMapID,MapManager.initPos.x,MapManager.initPos.y);
      }
      
      private function initMapFunction(isGetUser:Boolean = true) : void
      {
         var mte:MapTransEffect = null;
         var pinfo:PetShowInfo = null;
         MapManager.removeEventListener(MapEvent.MAP_LOADER_CLOSE,this.onMapFail);
         LevelManager.openMouseEvent();
         ResourceManager.play();
         mte = new MapTransEffect(this._mapModel,this._dir);
         mte.addEventListener(MapEvent.MAP_EFFECT_COMPLETE,function(_arg_1:MapEvent):void
         {
            DisplayUtil.removeAllChild(LevelManager.appLevel);
            DisplayUtil.removeAllChild(LevelManager.mapLevel);
            LevelManager.mapLevel.addChild(_mapModel.root);
         });
         mte.star();
         this.destroy();
         MapManager.isInMap = true;
         LevelManager.mapScroll = false;
         MapManager.prevMapID = MainManager.actorInfo.mapID;
         MainManager.actorInfo.mapType = this._mapType;
         MainManager.actorInfo.mapID = this._newMapID;
         MapManager.currentMap = this._mapModel;
         AStar.init(MapManager.currentMap,1500);
         MapConfig.configMap(MapManager.getResMapID(this._newMapID));
         MapManager.currentMap.depthLevel.addChild(MainManager.actorModel.sprite);
         if(!_isReMap)
         {
            MainManager.actorModel.pos = MapManager.initPos;
         }
         MapProcessConfig.configMap(MapManager.getResMapID(this._newMapID),this._mapType);
         MainManager.actorModel.direction = Direction.DOWN;
         if(Boolean(PetManager.showInfo))
         {
            pinfo = new PetShowInfo();
            pinfo.catchTime = PetManager.showInfo.catchTime;
            pinfo.petID = PetManager.showInfo.id;
            pinfo.userID = MainManager.actorID;
            pinfo.dv = PetManager.showInfo.dv;
            pinfo.shiny = PetManager.showInfo.shiny;
            pinfo.skinID = PetManager.showInfo.skinID;
            MainManager.actorModel.showPet(pinfo);
         }
         DepthManager.swapDepthAll(MapManager.currentMap.depthLevel);
         MouseController.addMouseEvent();
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_SWITCH_COMPLETE,MapManager.currentMap));
         this._mapModel.closeLoading();
         _isSwitching = false;
         if(MapManager.currentMap.width > MainManager.getStageWidth())
         {
            LevelManager.mapScroll = true;
         }
         if(isGetUser && this._newMapID != 515)
         {
            SocketConnection.send(CommandID.LIST_MAP_PLAYER);
         }
         MainManager.actorModel.showClothLight();
      }
      
      private function onLeaveMap(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         _local_2.position = 0;
         var _local_3:uint = _local_2.readUnsignedInt();
         if(this.isChangeLocal)
         {
            return;
         }
         if(_local_3 == MainManager.actorID)
         {
            if(_isChange)
            {
               _isChange = false;
               this.comeInMap();
            }
         }
         else
         {
            if(MapManager.currentMap == null)
            {
               return;
            }
            MapManager.currentMap.removeUser(_local_3);
         }
         MainManager.actorModel.delProtectMC();
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.CREATED_MAP_USER));
      }
      
      private function onEnterMap(_arg_1:SocketEvent) : void
      {
         var _local_2:PeopleModel = null;
         if(this._newMapID == MapManager.TOWER_MAP)
         {
            MapManager.changeMap(108);
            return;
         }
         if(this._newMapID == MapManager.FRESH_TRIALS)
         {
            MapManager.changeMap(101);
            return;
         }
         if(this.isChangeLocal)
         {
            return;
         }
         var _local_3:UserInfo = new UserInfo();
         UserInfo.setForPeoleInfo(_local_3,_arg_1.data as IDataInput);
         _local_3.serverID = MainManager.serverID;
         if(_local_3.userID == MainManager.actorID)
         {
            if(_isReMap)
            {
               MainManager.actorModel.pos = _local_3.pos;
            }
            MainManager.upDateForPeoleInfo(_local_3);
            this.initMapFunction();
         }
         else
         {
            if(MapManager.currentMap == null)
            {
               return;
            }
            _local_2 = new PeopleModel(_local_3);
            if(_local_3.actionType == 0)
            {
               _local_2.walk = new WalkAction();
            }
            else
            {
               _local_2.walk = new FlyAction(_local_2);
            }
            if(MainManager.actorInfo.mapType == MapType.PK_TYPE)
            {
               if(_local_3.teamInfo.id != MainManager.actorInfo.mapID)
               {
                  _local_2.x = _local_3.pos.x + TeamPKManager.REDX;
                  _local_2.additiveInfo.info = TeamPKManager.AWAY;
               }
               else
               {
                  _local_2.additiveInfo.info = TeamPKManager.HOME;
               }
               _local_2.interactiveAction = new PKInteractiveAction(_local_2);
            }
            MapManager.currentMap.addUser(_local_2);
            if(_local_3.teamInfo.isShow)
            {
               ShowTeamLogo.showLogo(_local_2);
            }
         }
         MainManager.actorModel.delProtectMC();
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.CREATED_MAP_USER));
      }
      
      private function onMapInit(_arg_1:Event) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_INIT,this.onMapInit);
         MapManager.removeEventListener(ErrorEvent.ERROR,this.onMapFail);
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_SWITCH_OPEN,MapManager.currentMap));
         if(_isLogin)
         {
            _isLogin = false;
            this.initMapFunction();
            SocketConnection.addCmdListener(CommandID.ENTER_MAP,this.onEnterMap);
            SocketConnection.addCmdListener(CommandID.LEAVE_MAP,this.onLeaveMap);
            SocketConnection.addCmdListener(CommandID.ON_MAP_SWITCH,this.onMapOnSwitch);
         }
         else if(MapManager.isInMap)
         {
            if(this._newMapID > MapManager.ID_MAX)
            {
               if(this._roomCol == null)
               {
                  this._roomCol = new RoomController();
               }
               this._roomCol.getRoomAddres(this._newMapID);
               SocketConnection.send(CommandID.LEAVE_MAP);
            }
            else if(RoomController.isClose)
            {
               RoomController.isClose = false;
               this.comeInMap();
            }
            else
            {
               if(this._newMapID == MapManager.FRESH_TRIALS || this._newMapID == MapManager.TOWER_MAP || this.isChangeLocal)
               {
                  this.comeInMap();
                  return;
               }
               SocketConnection.send(CommandID.LEAVE_MAP);
            }
         }
         else
         {
            this.initMapFunction(this._newMapID != 500);
         }
      }
      
      private function onMapOnSwitch(_arg_1:SocketEvent) : void
      {
         if(Boolean(this._mapModel))
         {
            this.onMapFail(null);
         }
      }
      
      private function onMapFail(_arg_1:Event) : void
      {
         this._mapModel.closeLoading();
         this._mapType = MainManager.actorInfo.mapType;
         this._newMapID = MainManager.actorInfo.mapID;
         MapManager.styleID = this._tempStyleID;
         LevelManager.openMouseEvent();
         MapManager.removeEventListener(MapEvent.MAP_INIT,this.onMapInit);
         MapManager.removeEventListener(ErrorEvent.ERROR,this.onMapFail);
         MapManager.removeEventListener(MapEvent.MAP_LOADER_CLOSE,this.onMapFail);
         MouseController.addMouseEvent();
         _isSwitching = false;
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_ERROR));
      }
      
      private function onRoomAddres(_arg_1:RobotEvent) : void
      {
         this._roomCol.removeEventListener(RobotEvent.GET_ROOM_ADDRES,this.onRoomAddres);
         SocketConnection.send(CommandID.LEAVE_MAP);
      }
      
      private function onRoomConnect(_arg_1:Event) : void
      {
         this._roomCol.removeEventListener(Event.CONNECT,this.onRoomConnect);
         this._roomCol.inRoom(this._mapType,MapManager.initPos.x,MapManager.initPos.y);
      }
      
      private function onRoomLeave(_arg_1:RobotEvent) : void
      {
         if(MapManager.type == ConnectionType.ROOM)
         {
            this._roomCol.addEventListener(Event.CONNECT,this.onRoomConnect);
            this._roomCol.connect();
         }
      }
      
      private function onRoomError(_arg_1:ErrorEvent) : void
      {
         this._roomCol.removeEventListener(Event.CONNECT,this.onRoomConnect);
         this._roomCol.removeEventListener(ErrorEvent.ERROR,this.onRoomError);
         if(Boolean(this._mapModel))
         {
            this._mapModel.closeLoading();
         }
         MapManager.styleID = this._tempStyleID;
         this._mapType = MainManager.actorInfo.mapType;
         this._newMapID = MainManager.actorInfo.mapID;
         _isReMap = true;
         RoomController.isClose = true;
         this.startSwitch();
      }
   }
}

