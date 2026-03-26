package com.robot.app.sceneInteraction
{
   import com.robot.app.bag.*;
   import com.robot.app.info.*;
   import com.robot.core.*;
   import com.robot.core.controller.*;
   import com.robot.core.event.*;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.fightInfo.*;
   import com.robot.core.info.fightInfo.attack.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.*;
   import com.robot.core.skeleton.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ArenaController
   {
      
      private static var _instance:ArenaController;
      
      private static const UP_POS:Point = new Point(420,120);
      
      private static const DOWN_POS:Point = new Point(410,310);
      
      private var _oldHostID:uint;
      
      private var _oldChallengerID:uint;
      
      private var _currHostID:uint;
      
      private var _flag:uint;
      
      private var _arenaInfoPanel:MovieClip;
      
      private var _showMC:Sprite;
      
      private var _compose:BagClothPreview;
      
      public function ArenaController()
      {
         super();
      }
      
      public static function getInstance() : ArenaController
      {
         if(_instance == null)
         {
            _instance = new ArenaController();
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
            EventManager.addEventListener(PetFightEvent.ALARM_CLICK,onFightOver);
            SocketConnection.addCmdListener(CommandID.ARENA_OWENR_OUT,onOwenrOut);
         }
         return _instance;
      }
      
      private static function onMapSwitchComplete(_arg_1:MapEvent) : void
      {
         if(Boolean(_instance))
         {
            if(MapManager.prevMapID == 102)
            {
               if(MapManager.getMapController().newMapID != 102)
               {
                  MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
                  EventManager.removeEventListener(PetFightEvent.ALARM_CLICK,onFightOver);
                  SocketConnection.removeCmdListener(CommandID.ARENA_OWENR_OUT,onOwenrOut);
                  _instance.destroy();
                  _instance = null;
               }
            }
         }
      }
      
      private static function onFightOver(_arg_1:PetFightEvent) : void
      {
         var _local_2:FightOverInfo = _arg_1.dataObj as FightOverInfo;
         if(_local_2.winnerID == MainManager.actorID)
         {
            SocketConnection.send(CommandID.ARENA_OWENR_ACCE);
         }
      }
      
      private static function onOwenrOut(_arg_1:SocketEvent) : void
      {
         Alarm.show("很遗憾，你没有及时回到擂台应战，失去了擂主位置，你可以再次挑战，夺回擂主的资格。");
      }
      
      public function setup(_arg_1:MovieClip) : void
      {
         this._arenaInfoPanel = _arg_1;
         this._arenaInfoPanel.mouseChildren = false;
         this._arenaInfoPanel.mouseEnabled = false;
         this._arenaInfoPanel["colorMc"].gotoAndStop(1);
         SocketConnection.addCmdListener(CommandID.ARENA_GET_INFO,this.onArenaInfo);
         SocketConnection.send(CommandID.ARENA_GET_INFO);
         MapManager.addEventListener(MapEvent.MAP_ERROR,this.onMapError);
      }
      
      public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.ARENA_GET_INFO,this.onArenaInfo);
         MapManager.removeEventListener(MapEvent.MAP_ERROR,this.onMapError);
         this._oldHostID = 0;
         this._oldChallengerID = 0;
         this._currHostID = 0;
         this._compose = null;
         this._showMC = null;
         this._arenaInfoPanel = null;
      }
      
      public function strat() : void
      {
         if(this._flag == 1)
         {
            Alert.show("确定要挑战擂主吗？",function():void
            {
               PetFightModel.status = PetFightModel.FIGHT_WITH_PLAYER;
               PetFightModel.mode = PetFightModel.SINGLE_MODE;
               SocketConnection.send(CommandID.ARENA_FIGHT_OWENR);
            });
         }
         else if(this._flag == 0)
         {
            PetFightModel.status = PetFightModel.FIGHT_WITH_PLAYER;
            PetFightModel.mode = PetFightModel.SINGLE_MODE;
            SocketConnection.send(CommandID.ARENA_SET_OWENR);
         }
         else if(this._flag == 2)
         {
            Alarm.show("擂台赛战斗已经开始,等会再挑战吧！");
         }
      }
      
      public function figth() : void
      {
         SocketConnection.removeCmdListener(CommandID.ARENA_GET_INFO,this.onArenaInfo);
         MapManager.removeEventListener(MapEvent.MAP_ERROR,this.onMapError);
         if(Boolean(this._showMC))
         {
            DisplayUtil.removeForParent(this._showMC);
            EventManager.removeEventListener(UserEvent.INFO_CHANGE,this.onUserInfo);
         }
      }
      
      private function setUserMove(_arg_1:uint, _arg_2:Boolean = false) : void
      {
         var _local_4:BasePeoleModel = null;
         var _local_3:Point = null;
         _local_4 = null;
         if(Boolean(_arg_1))
         {
            if(_arg_2)
            {
               _local_3 = UP_POS;
            }
            else
            {
               _local_3 = DOWN_POS;
            }
            if(_arg_1 == MainManager.actorID)
            {
               MainManager.actorModel.stop();
               MainManager.actorModel.pos = _local_3;
               MainManager.actorModel.direction = Direction.DOWN;
               if(Boolean(MainManager.actorModel.pet))
               {
                  MainManager.actorModel.pet.pos = _local_3.add(new Point(40,5));
                  MainManager.actorModel.pet.direction = Direction.DOWN;
               }
               if(_arg_2)
               {
                  MouseController.removeMouseEvent();
                  MapManager.currentMap.controlLevel.mouseChildren = false;
                  MapManager.currentMap.btnLevel.mouseChildren = false;
                  MapManager.currentMap.spaceLevel.addEventListener(MouseEvent.MOUSE_UP,this.onMouseDown);
               }
               else
               {
                  MapManager.currentMap.spaceLevel.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseDown);
                  MapManager.currentMap.controlLevel.mouseChildren = true;
                  MapManager.currentMap.btnLevel.mouseChildren = true;
                  MouseController.addMouseEvent();
               }
            }
            else
            {
               _local_4 = UserManager.getUserModel(_arg_1);
               if(Boolean(_local_4))
               {
                  _local_4.stop();
                  _local_4.pos = _local_3;
                  _local_4.direction = Direction.DOWN;
                  if(Boolean(_local_4.pet))
                  {
                     _local_4.pet.pos = _local_3.add(new Point(40,5));
                     _local_4.pet.direction = Direction.DOWN;
                  }
               }
            }
         }
      }
      
      private function setArenaEmpty(_arg_1:uint, _arg_2:uint) : void
      {
         this.setUserMove(_arg_1);
         this.setUserMove(_arg_2);
         this._oldChallengerID = 0;
         this._oldHostID = 0;
         this._arenaInfoPanel["colorMc"].gotoAndStop(1);
         this._arenaInfoPanel["countTxt"].text = "0";
         this._arenaInfoPanel["nameTxt"].text = "";
         if(Boolean(this._showMC))
         {
            DisplayUtil.removeForParent(this._showMC);
            EventManager.removeEventListener(UserEvent.INFO_CHANGE,this.onUserInfo);
         }
      }
      
      private function setArenaInfo(info:ArenaInfo) : void
      {
         this._arenaInfoPanel["countTxt"].text = info.hostWins.toString();
         this._arenaInfoPanel["nameTxt"].text = info.hostNick.toString() + "\n(" + info.hostID.toString() + ")";
         if(this._showMC == null)
         {
            this._showMC = UIManager.getSprite("ComposeMC");
            this._showMC.mouseChildren = false;
            this._showMC.mouseEnabled = false;
            this._showMC.scaleX = 0.23;
            this._showMC.scaleY = 0.23;
            this._showMC.x = 14;
            this._showMC.y = 35;
            this._compose = new BagClothPreview(this._showMC,null,ClothPreview.MODEL_SHOW);
         }
         if(!DisplayUtil.hasParent(this._showMC))
         {
            EventManager.addEventListener(UserEvent.INFO_CHANGE,this.onUserInfo);
            this._arenaInfoPanel.addChild(this._showMC);
         }
         UserInfoManager.getInfo(info.hostID,function(_arg_1:UserInfo):void
         {
            _compose.changeColor(_arg_1.color);
            _compose.showCloths(_arg_1.clothes);
            _compose.showDoodle(_arg_1.texture);
         });
      }
      
      private function onArenaInfo(_arg_1:SocketEvent) : void
      {
         var _local_2:ArenaInfo = _arg_1.data as ArenaInfo;
         this._flag = _local_2.flag;
         this._currHostID = _local_2.hostID;
         if(_local_2.flag == 0)
         {
            this.setArenaEmpty(this._oldHostID,this._oldChallengerID);
            return;
         }
         if(_local_2.flag == 1)
         {
            this._arenaInfoPanel["colorMc"].gotoAndStop(1);
         }
         else if(_local_2.flag == 2)
         {
            this._arenaInfoPanel["colorMc"].gotoAndStop(2);
         }
         if(Boolean(this._oldHostID) && Boolean(this._oldChallengerID))
         {
            if(this._oldHostID == _local_2.hostID)
            {
               if(this._oldHostID == MainManager.actorID)
               {
                  Alarm.show("你赢得了这次对战的胜利，你现在的连胜次数是" + TextFormatUtil.getRedTxt(_local_2.hostWins.toString()) + "次。");
               }
               if(this._oldChallengerID == MainManager.actorID)
               {
                  Alarm.show("很遗憾，这次的战斗你没有获胜，你可以再次挑战。");
               }
            }
            else
            {
               if(this._oldHostID == MainManager.actorID)
               {
                  Alarm.show("很遗憾，这次的战斗你没有获胜，你可以再次挑战，夺回擂主的资格。");
               }
               if(this._oldChallengerID == _local_2.hostID)
               {
                  if(_local_2.hostID == MainManager.actorID)
                  {
                     Alarm.show("恭喜你获得了这次挑战的胜利，现在你是擂主了，接受其他赛尔的挑战，看看你能连胜多少次。");
                  }
               }
            }
         }
         this.setUserMove(_local_2.hostID,true);
         if(Boolean(this._oldHostID))
         {
            if(this._oldHostID == _local_2.hostID)
            {
               this.setUserMove(this._oldChallengerID);
            }
            else
            {
               this.setUserMove(this._oldHostID);
            }
         }
         this.setArenaInfo(_local_2);
         this._oldHostID = _local_2.hostID;
         this._oldChallengerID = _local_2.challengerID;
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         Alert.show("你确定要放弃擂台挑战吗？",function():void
         {
            SocketConnection.send(CommandID.ARENA_UPFIGHT);
         });
      }
      
      private function onUserInfo(_arg_1:UserEvent) : void
      {
         var _local_2:UserInfo = _arg_1.userInfo;
         if(_local_2.userID == this._currHostID)
         {
            this._arenaInfoPanel["nameTxt"].text = _local_2.nick.toString() + "\n(" + _local_2.userID.toString() + ")";
            this._compose.changeColor(_local_2.color);
            this._compose.showCloths(_local_2.clothes);
            this._compose.showDoodle(_local_2.texture);
         }
      }
      
      private function onMapError(_arg_1:MapEvent) : void
      {
         MouseController.removeMouseEvent();
         MapManager.currentMap.controlLevel.mouseChildren = false;
         MapManager.currentMap.btnLevel.mouseChildren = false;
         Alarm.show("你目前不能离开此场景！");
      }
   }
}

