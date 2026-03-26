package com.robot.core.teamPK
{
   import com.robot.core.*;
   import com.robot.core.controller.*;
   import com.robot.core.event.*;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.fightInfo.*;
   import com.robot.core.info.team.SimpleTeamInfo;
   import com.robot.core.info.teamPK.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.manager.map.config.*;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.PKArmModel;
   import com.robot.core.mode.spriteModelAdditive.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.teamInstallation.*;
   import com.robot.core.teamPK.shotActive.*;
   import com.robot.core.ui.alert.*;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class TeamPKManager
   {
      
      private static var homeTeamID:uint;
      
      private static var awayTeamID:uint;
      
      public static var sign:ByteArray;
      
      private static var homeList:Array;
      
      private static var awayList:Array;
      
      public static var TEAM:uint;
      
      private static var loader:Loader;
      
      private static var waitPanel:MovieClip;
      
      public static var enemyInfo:TeamPKTeamInfo;
      
      public static var enemyBuildingList:Array;
      
      public static var homeHeaderHp:uint;
      
      public static var awayHeaderHp:uint;
      
      public static var isShowPanel:Boolean;
      
      public static var myMaxHp:uint;
      
      public static var myHp:uint;
      
      private static var oldMap:uint;
      
      private static var infoIcon:InteractiveObject;
      
      private static var fun:Function;
      
      private static var infoPanel:MovieClip;
      
      private static var teamPKMessPanel:TeamPKMessPanel;
      
      private static var win_mc:MovieClip;
      
      public static var teamPkSituationInfo:TeamPkStInfo;
      
      private static var instance:EventDispatcher;
      
      private static var URL:String = "resource/eff/shotEffect.swf";
      
      private static const MAP_ID:uint = 700001;
      
      public static var PK_STATUS:uint = 0;
      
      public static const START:uint = 1;
      
      public static const OPEN_DOOR:uint = 2;
      
      public static const OVER:uint = 3;
      
      public static var inMap:Boolean = false;
      
      public static var isGetBuilding:Boolean = false;
      
      public static var buildingMap:HashMap = new HashMap();
      
      public static var homeBuildingMap:HashMap = new HashMap();
      
      public static var awayBuildingMap:HashMap = new HashMap();
      
      public static const HOME:uint = 1;
      
      public static const AWAY:uint = 2;
      
      private static var freezeIDs:Array = [];
      
      private static var noModelMaps:HashMap = new HashMap();
      
      public static const REDX:uint = 1880;
      
      public static const INIT_INFO:String = "initinfo";
      
      public static const INIT_HP:String = "inithp";
      
      private static var isSendB:Boolean = false;
      
      public function TeamPKManager()
      {
         super();
      }
      
      public static function closeWait() : void
      {
         setTimeout(function():void
         {
            if(oldMap != 0)
            {
               MapManager.changeMap(oldMap);
            }
            DisplayUtil.removeForParent(waitPanel,false);
         },200);
      }
      
      public static function setup() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_PK_SIGN,onGetTeamSign);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_NOTE,onTeamPKNote);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_JOIN,onPKJoin);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_SOMEONE_JOIN_INFO,onSomeoneJoin);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_GET_BUILDING_INFO,onGetBuildingInfo);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_BE_SHOT,beShotHandler);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_FREEZE,onFreeze);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_USE_SHIELD,onUseShield);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_RESULT,resultHandler);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_NO_PET,noPetHandler);
         EventManager.addEventListener(RobotEvent.CREATED_MAP_USER,onCreateMapUser);
         if(!enemyInfo)
         {
            enemyInfo = new TeamPKTeamInfo();
         }
         if(!infoIcon)
         {
            infoIcon = TaskIconManager.getIcon("TeamPK_icon");
            infoIcon.addEventListener(MouseEvent.CLICK,showTaskPanel);
            ToolTipManager.add(infoIcon,"对抗赛消息");
         }
      }
      
      private static function noPetHandler(_arg_1:SocketEvent) : void
      {
         Alarm.show("精灵对战失败！你没有可出战的精灵应对敌方的挑战。");
      }
      
      public static function showIcon() : void
      {
         TaskIconManager.addIcon(infoIcon);
      }
      
      public static function removeIcon() : void
      {
         TaskIconManager.delIcon(infoIcon);
         if(Boolean(teamPKMessPanel))
         {
            teamPKMessPanel.destroy();
         }
      }
      
      private static function showTaskPanel(_arg_1:MouseEvent) : void
      {
         if(!teamPKMessPanel)
         {
            teamPKMessPanel = new TeamPKMessPanel();
            teamPKMessPanel.setup();
         }
         else
         {
            teamPKMessPanel.setup();
         }
      }
      
      public static function register() : void
      {
         SocketConnection.send(CommandID.TEAM_PK_SIGN);
      }
      
      public static function joinPK() : void
      {
         oldMap = MainManager.actorInfo.mapID;
         if(MainManager.actorInfo.teamPKInfo.homeTeamID == 0)
         {
            Alarm.show("你现在不能进入对抗赛");
         }
         fun = join;
         var _local_1:MCLoader = new MCLoader(URL,LevelManager.appLevel,1,"正在进入对战系统");
         _local_1.addEventListener(MCLoadEvent.SUCCESS,onLoadByJoin);
         _local_1.doLoad();
      }
      
      private static function onLoadByRegister(event:MCLoadEvent) : void
      {
         var closeBtn:SimpleButton = null;
         var num:uint = 0;
         ShotBehaviorManager.setup(event.getLoader());
         waitPanel = ShotBehaviorManager.getMovieClip("pk_wait_panel");
         closeBtn = waitPanel["closeBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,function(_arg_1:MouseEvent):void
         {
            closeWait();
         });
         num = Math.ceil(Math.random() * 3);
         waitPanel["mc"].gotoAndStop(num);
         MainManager.getStage().addChild(waitPanel);
         fun();
      }
      
      private static function onLoadByJoin(_arg_1:MCLoadEvent) : void
      {
         ShotBehaviorManager.setup(_arg_1.getLoader());
         fun();
      }
      
      public static function initBuildList() : void
      {
         if(TEAM == HOME)
         {
            enemyBuildingList = awayBuildinList;
         }
         else
         {
            enemyBuildingList = homeBuildinList;
         }
      }
      
      private static function onCreateMapUser(_arg_1:RobotEvent) : void
      {
         var _local_2:uint = 0;
         var _local_3:TeamPKFreezeInfo = null;
         var _local_4:BasePeoleModel = null;
         var _local_5:uint = 0;
         var _local_6:uint = 0;
         var _local_7:BasePeoleModel = null;
         var _local_8:Point = null;
         var _local_9:Array = noModelMaps.getKeys();
         for each(_local_2 in _local_9)
         {
            _local_4 = UserManager.getUserModel(_local_2);
            if(Boolean(_local_4))
            {
               if(_local_4.info.teamInfo.id == homeTeamID)
               {
                  _local_4.bloodBar.colorType = PeopleBloodBar.RED;
               }
               else
               {
                  _local_4.bloodBar.colorType = PeopleBloodBar.BLUE;
               }
               noModelMaps.remove(_local_2);
            }
         }
         for each(_local_3 in freezeIDs)
         {
            _local_5 = _local_3.flag;
            _local_6 = _local_3.uid;
            _local_7 = UserManager.getUserModel(_local_6);
            if(Boolean(_local_7))
            {
               if(_local_5 == 1)
               {
                  _local_8 = MapConfig.getMapPeopleXY(0,homeTeamID);
                  if(_local_7.info.teamInfo.id == homeTeamID)
                  {
                     _local_7.x = _local_8.x;
                     _local_7.y = _local_8.y;
                  }
                  else
                  {
                     _local_7.x = _local_8.x + REDX;
                     _local_8.x += REDX;
                     _local_7.y = _local_8.y;
                  }
                  _local_7.additive = [new SpriteFreeze()];
                  if(_local_6 == MainManager.actorID)
                  {
                     if(TEAM == HOME)
                     {
                        LevelManager.moveToLeft();
                     }
                     else
                     {
                        LevelManager.moveToRight();
                     }
                     _local_7.walkAction(_local_8);
                     dispatchEvent(new Event(INIT_INFO));
                     LevelManager.closeMouseEvent();
                  }
               }
               else
               {
                  _local_7.filters = [];
                  if(_local_6 == MainManager.actorID)
                  {
                     LevelManager.openMouseEvent();
                  }
               }
            }
         }
         freezeIDs = [];
      }
      
      private static function showWin(_arg_1:uint) : void
      {
         if(_arg_1 != 2)
         {
            if(TEAM == HOME)
            {
               if(_arg_1 == 0)
               {
                  win_mc = ShotBehaviorManager.getMovieClip("AwayWin");
               }
               else
               {
                  win_mc = ShotBehaviorManager.getMovieClip("HomeWin");
               }
            }
            else if(_arg_1 == 0)
            {
               win_mc = ShotBehaviorManager.getMovieClip("HomeWin");
            }
            else
            {
               win_mc = ShotBehaviorManager.getMovieClip("AwayWin");
            }
            if(Boolean(win_mc))
            {
               win_mc.x = MainManager.getStageWidth() / 2 - 100;
               win_mc.y = MainManager.getStageHeight() / 2;
               win_mc.addFrameScript(win_mc.totalFrames - 1,onEnd);
               LevelManager.topLevel.addChild(win_mc);
            }
         }
      }
      
      private static function onEnd() : void
      {
         win_mc.addFrameScript(win_mc.totalFrames - 1,null);
         LevelManager.topLevel.removeChild(win_mc);
         win_mc = null;
      }
      
      public static function resultHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:TeamPKResultInfo = _arg_1.data as TeamPKResultInfo;
         var _local_3:TeamPKResultPanel = new TeamPKResultPanel();
         _local_3.setup(_local_2);
         showWin(_local_2.result);
         PK_STATUS = 0;
      }
      
      public static function getTeamSituation() : void
      {
         SocketConnection.send(CommandID.TEAM_PK_SITUATION);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_SITUATION,getPkSituationHandler);
      }
      
      private static function getPkSituationHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_PK_SITUATION,getPkSituationHandler);
         var _local_2:TeamPkStInfo = _arg_1.data as TeamPkStInfo;
         if(_local_2.flag == 0)
         {
            return;
         }
         teamPkSituationInfo = _local_2;
         dispatchEvent(new Event(INIT_INFO));
      }
      
      private static function _register() : void
      {
         MapManager.styleID = MAP_ID;
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onSwitchMap);
         MapManager.changeMap(MainManager.actorInfo.teamInfo.id,0,MapType.PK_TYPE);
      }
      
      private static function onGetTeamSign(_arg_1:SocketEvent) : void
      {
         var _local_2:TeamPKSignInfo = _arg_1.data as TeamPKSignInfo;
         sign = _local_2.sign;
         oldMap = MainManager.actorInfo.mapID;
         fun = _register;
         var _local_3:MCLoader = new MCLoader(URL,LevelManager.appLevel,1,"正在进入对战系统");
         _local_3.addEventListener(MCLoadEvent.SUCCESS,onLoadByRegister);
         _local_3.doLoad();
      }
      
      private static function onSwitchMap(_arg_1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onSwitchMap);
         SocketConnection.send(CommandID.TEAM_PK_REGISTER,TeamPKManager.sign);
      }
      
      private static function getEnamyTeamInfo() : void
      {
         if(awayTeamID == 0)
         {
            return;
         }
         TeamInfoManager.getSimpleTeamInfo(awayTeamID,function(info:SimpleTeamInfo):void
         {
            enemyInfo.ename = info.name;
            enemyInfo.elevel = info.level;
            enemyInfo.eInfo = info;
            UserInfoManager.getInfo(info.leader,function(_arg_1:UserInfo):void
            {
               enemyInfo.eLeader = _arg_1.nick;
               getMyTeamInfo();
            });
         });
      }
      
      private static function getMyTeamInfo() : void
      {
         TeamInfoManager.getSimpleTeamInfo(homeTeamID,function(info1:SimpleTeamInfo):void
         {
            enemyInfo.myName = info1.name;
            enemyInfo.myLevel = info1.level;
            enemyInfo.myInfo = info1;
            UserInfoManager.getInfo(info1.leader,function(_arg_1:UserInfo):void
            {
               enemyInfo.myLeader = _arg_1.nick;
            });
         });
      }
      
      private static function onTeamPKNote(_arg_1:SocketEvent) : void
      {
         var _local_2:TeamPKNoteInfo = _arg_1.data as TeamPKNoteInfo;
         homeTeamID = _local_2.homeTeamID;
         awayTeamID = _local_2.awayTeamID;
         PK_STATUS = _local_2.event;
         if(PK_STATUS == START || PK_STATUS == OPEN_DOOR)
         {
            if(!inMap)
            {
               TeamPKManager.showIcon();
            }
         }
         if((PK_STATUS == START || PK_STATUS == OPEN_DOOR) && inMap && !isGetBuilding)
         {
            if(inMap)
            {
               getBuildingList();
               AutoShotManager.setup();
            }
         }
         DisplayUtil.removeForParent(waitPanel);
         if(PK_STATUS == START)
         {
            MainManager.actorInfo.teamPKInfo.homeTeamID = _local_2.homeTeamID;
            if(_local_2.homeTeamID != _local_2.selfTeamID)
            {
               TEAM = AWAY;
               if(inMap)
               {
                  MapManager.styleID = MAP_ID;
                  MapManager.changeMap(_local_2.homeTeamID,0,MapType.PK_TYPE);
               }
            }
            else
            {
               TEAM = HOME;
            }
            if(!isSendB)
            {
               isSendB = true;
               initBuildList();
               if(inMap)
               {
                  getTeamSituation();
               }
            }
         }
         else if(PK_STATUS == OPEN_DOOR && inMap)
         {
            dispatchEvent(new TeamPKEvent(TeamPKEvent.OPEN_DOOR));
         }
         else if(PK_STATUS == OVER)
         {
            removeIcon();
            PK_STATUS = 0;
         }
      }
      
      public static function levelMapInt() : void
      {
         TEAM = 0;
         teamPkSituationInfo = null;
      }
      
      public static function outTeamMap() : void
      {
         levelMapInt();
         gameOver();
      }
      
      public static function gameOver() : void
      {
         MapManager.DESTROY_SWITCH = true;
         buildingMap.clear();
         homeBuildingMap.clear();
         awayBuildingMap.clear();
         MapManager.changeMap(1);
      }
      
      private static function join() : void
      {
         MapManager.styleID = MAP_ID;
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchWithJoin);
         if(MainManager.actorInfo.teamInfo.id == MainManager.actorInfo.teamPKInfo.homeTeamID)
         {
            TEAM = HOME;
         }
         else
         {
            TEAM = AWAY;
         }
         MapManager.changeMap(MainManager.actorInfo.teamPKInfo.homeTeamID,0,MapType.PK_TYPE);
      }
      
      private static function onMapSwitchWithJoin(_arg_1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchWithJoin);
         SocketConnection.send(CommandID.TEAM_PK_JOIN);
      }
      
      private static function isMySelf(_arg_1:BasePeoleModel) : Boolean
      {
         if(MainManager.actorInfo.userID == _arg_1.info.userID)
         {
            return true;
         }
         return false;
      }
      
      private static function onPKJoin(event:SocketEvent) : void
      {
         var data:TeamPKJoinInfo = null;
         data = null;
         data = event.data as TeamPKJoinInfo;
         homeTeamID = data.homeTeamId;
         awayTeamID = data.awayTeamId;
         getEnamyTeamInfo();
         setTimeout(function():void
         {
            var _local_1:TeamPkUserInfo = null;
            var _local_2:BasePeoleModel = null;
            for each(_local_1 in data.homeUserList)
            {
               _local_2 = UserManager.getUserModel(_local_1.uid);
               if(Boolean(_local_2))
               {
                  _local_2.bloodBar.colorType = PeopleBloodBar.RED;
                  _local_2.bloodBar.setHp(_local_1.hp,_local_1.maxHp);
                  if(isMySelf(_local_2))
                  {
                     myMaxHp = _local_1.maxHp;
                     myHp = _local_1.hp;
                     TeamPKManager.dispatchEvent(new Event(INIT_HP));
                  }
                  if(_local_1.isFreeze)
                  {
                  }
               }
               else
               {
                  noModelMaps.add(_local_1.uid,_local_1.uid);
               }
            }
            for each(_local_1 in data.awayUserList)
            {
               _local_2 = UserManager.getUserModel(_local_1.uid);
               if(Boolean(_local_2))
               {
                  _local_2.bloodBar.colorType = PeopleBloodBar.BLUE;
                  _local_2.bloodBar.setHp(_local_1.hp,_local_1.maxHp);
                  if(isMySelf(_local_2))
                  {
                     myMaxHp = _local_1.maxHp;
                     myHp = _local_1.hp;
                     TeamPKManager.dispatchEvent(new Event(INIT_HP));
                  }
                  if(_local_1.isFreeze)
                  {
                  }
               }
               else
               {
                  noModelMaps.add(_local_1.uid,_local_1.uid);
               }
            }
         },1000);
      }
      
      private static function onSomeoneJoin(event:SocketEvent) : void
      {
         var data:SomeoneJoinInfo = null;
         data = null;
         data = event.data as SomeoneJoinInfo;
         setTimeout(function():void
         {
            var _local_1:BasePeoleModel = null;
            if(data.userID != MainManager.actorID)
            {
               _local_1 = UserManager.getUserModel(data.userID);
               if(!_local_1)
               {
                  noModelMaps.add(data.userID,data.userID);
               }
               else
               {
                  if(_local_1.info.teamInfo.id == homeTeamID)
                  {
                     _local_1.bloodBar.colorType = PeopleBloodBar.RED;
                  }
                  else
                  {
                     _local_1.bloodBar.colorType = PeopleBloodBar.BLUE;
                  }
                  _local_1.bloodBar.setHp(data.hp,data.maxHp);
               }
            }
         },1000);
      }
      
      public static function petFight(_arg_1:uint) : void
      {
         PetFightModel.status = PetFightModel.FIGHT_WITH_PLAYER;
         PetFightModel.mode = PetFightModel.SINGLE_MODE;
         SocketConnection.send(CommandID.TEAM_PK_PET_FIGHT,_arg_1);
      }
      
      public static function shot(_arg_1:uint, _arg_2:uint, _arg_3:uint) : void
      {
         SocketConnection.send(CommandID.TEAM_PK_SHOT,_arg_1,_arg_2,_arg_3);
      }
      
      private static function beShotHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:BasePeoleModel = null;
         var _local_3:BasePeoleModel = null;
         var _local_4:PKArmModel = null;
         var _local_5:SpriteBloodBar = null;
         var _local_6:TeamPKBeShotInfo = _arg_1.data as TeamPKBeShotInfo;
         var _local_7:ShooterInfo = _local_6.shooter();
         var _local_8:ShooterInfo = _local_6.beShooer();
         switch(_local_6.shotType)
         {
            case TeamPKBeShotInfo.BUILDING_TO_PLAYER:
               _local_2 = UserManager.getUserModel(_local_8.userID);
               if(Boolean(_local_2))
               {
                  _local_2.bloodBar.setHp(_local_8.leftHp,_local_8.maxHp,_local_6.damage);
               }
               _local_5 = new SpriteBloodBar(ShotBehaviorManager.getMovieClip("pk_blood_bar"));
               _local_5.setHp(_local_7.leftHp,_local_7.maxHp);
               _local_4 = buildingMap.getValue(_local_7.buyTime);
               _local_4.additive = [_local_5];
               if(_local_7.leftHp == 0)
               {
                  _local_4.freeze();
               }
               _local_3 = _local_2;
               _local_4.shot(_local_2);
               if(TEAM == HOME)
               {
                  if(awayBuildingMap.containsKey(_local_7.buyTime) && _local_7.leftHp == 0)
                  {
                     win();
                  }
               }
               else if(homeBuildingMap.containsKey(_local_7.buyTime) && _local_7.leftHp == 0)
               {
                  win();
               }
               break;
            case TeamPKBeShotInfo.PLAYER_TO_BUILDING:
               _local_5 = new SpriteBloodBar(ShotBehaviorManager.getMovieClip("pk_blood_bar"));
               _local_4 = buildingMap.getValue(_local_8.buyTime);
               _local_4.additive = [_local_5];
               _local_5.setHp(_local_8.leftHp,_local_8.maxHp,_local_6.damage);
               if(_local_8.leftHp == 0)
               {
                  _local_4.freeze();
               }
               _local_2 = UserManager.getUserModel(_local_7.userID);
               if(Boolean(_local_2))
               {
                  _local_2.bloodBar.setHp(_local_7.leftHp,_local_7.maxHp);
               }
               if(TEAM == HOME)
               {
                  if(awayBuildingMap.containsKey(_local_8.buyTime) && _local_8.leftHp == 0)
                  {
                     win();
                  }
               }
               else if(homeBuildingMap.containsKey(_local_8.buyTime) && _local_8.leftHp == 0)
               {
                  win();
               }
               break;
            case TeamPKBeShotInfo.PLAYER_TO_PLAYER:
               _local_2 = UserManager.getUserModel(_local_8.userID);
               if(Boolean(_local_2))
               {
                  _local_2.bloodBar.setHp(_local_8.leftHp,_local_8.maxHp,_local_6.damage);
               }
               _local_3 = _local_2;
               _local_2 = UserManager.getUserModel(_local_7.userID);
               if(Boolean(_local_2))
               {
                  _local_2.bloodBar.setHp(_local_7.leftHp,_local_7.maxHp);
               }
         }
         if(!_local_3)
         {
            return;
         }
         if(isMySelf(_local_3))
         {
            myHp = _local_8.leftHp;
            TeamPKManager.dispatchEvent(new Event(INIT_HP));
         }
      }
      
      public static function updateDistance(_arg_1:Array) : void
      {
         var _local_2:PKArmModel = null;
         var _local_3:ByteArray = new ByteArray();
         var _local_4:uint = _arg_1.length;
         _local_3.writeUnsignedInt(_local_4);
         for each(_local_2 in _arg_1)
         {
            _local_3.writeUnsignedInt(_local_2.info.buyTime);
            _local_3.writeUnsignedInt(Point.distance(_local_2.info.pos,MainManager.actorModel.pos));
         }
         SocketConnection.send(CommandID.TEAM_PK_REFRESH_DISTANCE,_local_3);
      }
      
      public static function win() : void
      {
         SocketConnection.send(CommandID.TEAM_PK_WIN);
      }
      
      public static function getBuildingList() : void
      {
         SocketConnection.send(CommandID.TEAM_PK_GET_BUILDING_INFO);
      }
      
      private static function onGetBuildingInfo(_arg_1:SocketEvent) : void
      {
         MapManager.DESTROY_SWITCH = false;
         var _local_2:TeamPKBuildingListInfo = _arg_1.data as TeamPKBuildingListInfo;
         homeList = _local_2.homeList;
         awayList = _local_2.awayList;
         TeamPKManager.dispatchEvent(new TeamPKEvent(TeamPKEvent.GET_BUILDING_LIST));
         getEnamyTeamInfo();
      }
      
      public static function get homeBuildinList() : Array
      {
         return homeList;
      }
      
      public static function get awayBuildinList() : Array
      {
         return awayList;
      }
      
      private static function onFreeze(_arg_1:SocketEvent) : void
      {
         var _local_2:Point = null;
         var _local_3:TeamPKFreezeInfo = _arg_1.data as TeamPKFreezeInfo;
         var _local_4:uint = _local_3.flag;
         var _local_5:uint = _local_3.uid;
         var _local_6:BasePeoleModel = UserManager.getUserModel(_local_5);
         if(!_local_6)
         {
            freezeIDs.push(_local_3);
            return;
         }
         if(_local_4 == 1)
         {
            _local_6.additive = [new SpriteFreeze()];
            _local_2 = MapConfig.getMapPeopleXY(0,homeTeamID);
            if(_local_6.info.teamInfo.id == homeTeamID)
            {
               _local_6.x = _local_2.x;
               _local_6.y = _local_2.y;
            }
            else
            {
               _local_6.x = _local_2.x + REDX;
               _local_2.x += REDX;
               _local_6.y = _local_2.y;
            }
            if(_local_5 == MainManager.actorID)
            {
               if(TEAM == HOME)
               {
                  LevelManager.moveToLeft();
               }
               else
               {
                  LevelManager.moveToRight();
               }
               _local_6.walkAction(_local_2);
               MouseController.removeMouseEvent();
               TeamPKManager.dispatchEvent(new TeamPKEvent(TeamPKEvent.CLOSE_TOOL));
            }
         }
         else
         {
            _local_6.skeleton.getBodyMC().filters = [];
            if(_local_5 == MainManager.actorID)
            {
               myHp = TeamPKManager.myMaxHp;
               _local_6.bloodBar.setHp(myHp,myHp);
               dispatchEvent(new Event(INIT_HP));
               MouseController.addMouseEvent();
               TeamPKManager.dispatchEvent(new TeamPKEvent(TeamPKEvent.OPEN_TOOL));
            }
         }
      }
      
      private static function onUseShield(_arg_1:SocketEvent) : void
      {
         var _local_2:SuperNonoShieldInfo = _arg_1.data as SuperNonoShieldInfo;
         if(_local_2.uid == 0)
         {
            return;
         }
         var _local_3:BasePeoleModel = UserManager.getUserModel(_local_2.uid);
         _local_3.showNonoShield(_local_2.leftTime);
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            instance = new EventDispatcher();
         }
         return instance;
      }
      
      public static function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         getInstance().addEventListener(_arg_1,_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public static function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         getInstance().removeEventListener(_arg_1,_arg_2,_arg_3);
      }
      
      public static function dispatchEvent(_arg_1:Event) : void
      {
         getInstance().dispatchEvent(_arg_1);
      }
      
      public static function hasEventListener(_arg_1:String) : Boolean
      {
         return getInstance().hasEventListener(_arg_1);
      }
      
      public static function willTrigger(_arg_1:String) : Boolean
      {
         return getInstance().willTrigger(_arg_1);
      }
   }
}

