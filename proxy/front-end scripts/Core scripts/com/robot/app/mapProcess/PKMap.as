package com.robot.app.mapProcess
{
   import com.robot.app.mapProcess.active.*;
   import com.robot.app.protectSys.*;
   import com.robot.app.toolBar.*;
   import com.robot.app.toolBar.pkTool.*;
   import com.robot.core.*;
   import com.robot.core.aimat.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.info.teamPK.TeamPkBuildingInfo;
   import com.robot.core.info.teamPK.TeamPkStInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.teamPK.*;
   import com.robot.core.teamPK.shotActive.*;
   import com.robot.core.ui.alert.*;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.utils.*;
   import org.taomee.component.containers.*;
   import org.taomee.component.control.*;
   import org.taomee.component.layout.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class PKMap extends BaseMapProcess
   {
      
      private var _teamPKST_icon:InteractiveObject;
      
      private var _teamPkSt_panel:AppModel;
      
      private var _radius:uint;
      
      private var _teaminfo_panel:MovieClip;
      
      private var _homeScore_txt:TextField;
      
      private var _awayScore_txt:TextField;
      
      private var _time_txt:TextField;
      
      private var _time:Timer;
      
      private var _mySt_panel:TeamPKMyHpPanel;
      
      private var _go_0:MovieClip;
      
      private var _go_1:MovieClip;
      
      private var box:HBox;
      
      private var quitBtn:SimpleButton;
      
      private var firstLogin:Boolean = true;
      
      private var active:PKMapActive;
      
      private var teamInfo_panel:TeamInfoPanel;
      
      private var dis:uint;
      
      private var les:uint;
      
      private var inBuildingArr:Array = new Array();
      
      private var outBuildingArr:Array;
      
      private var sendBuildArr:Array = new Array();
      
      private var building_txt:TextField;
      
      public function PKMap()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _local_1:Point = null;
         _local_1 = null;
         if(MainManager.actorInfo.actionType == 1)
         {
            SocketConnection.send(CommandID.NONO_FOLLOW_OR_HOOM,0);
         }
         ProtectSystem.canShow = false;
         LevelManager.iconLevel.visible = false;
         this.box = new HBox(30);
         this.box.halign = FlowLayout.RIGHT;
         this.box.valign = FlowLayout.MIDLLE;
         this.box.setSizeWH(950,70);
         this._go_0 = conLevel["go1_mc"];
         this._go_1 = conLevel["go2_mc"];
         this._go_0.gotoAndStop(1);
         this._go_1.gotoAndStop(1);
         TeamPkTool.instance.show();
         TeamPkTool.instance.open();
         TeamPKManager.addEventListener(TeamPKEvent.COUNT_TIME,this.onTimeCount);
         TeamPKManager.addEventListener(TeamPKEvent.GET_BUILDING_LIST,this.onGetBuilding);
         TeamPKManager.addEventListener(TeamPKEvent.OPEN_DOOR,this.onOpenDoor);
         TeamPKManager.inMap = true;
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
         AutoShotManager.setup();
         if(TeamPKManager.TEAM == TeamPKManager.AWAY)
         {
            _local_1 = new Point(MainManager.actorModel.pos.x + TeamPKManager.REDX,MainManager.actorModel.pos.y);
            MainManager.actorModel.x = _local_1.x;
            MainManager.actorModel.walkAction(_local_1);
            _local_1 = null;
            LevelManager.moveToRight();
            MainManager.actorModel.additiveInfo.info = TeamPKManager.AWAY;
         }
         else
         {
            MainManager.actorModel.additiveInfo.info = TeamPKManager.HOME;
         }
         LevelManager.topLevel.addChild(this.box);
         this._teamPKST_icon = TaskIconManager.getIcon("TeamPkSt_icon");
         LevelManager.iconLevel.addChild(this._teamPKST_icon);
         ToolTipManager.add(this._teamPKST_icon,"战队战况");
         this._teamPKST_icon.addEventListener(MouseEvent.CLICK,this.clickPkStHandler);
         this.quitBtn = ShotBehaviorManager.getButton("pk_quit_btn");
         this.quitBtn.addEventListener(MouseEvent.CLICK,this.quit);
         ToolTipManager.add(this.quitBtn,"离开战场");
         this.box.append(new UIMovieClip(this._teamPKST_icon));
         this.box.append(new UIMovieClip(this.quitBtn));
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.walkEnterHandler);
         ToolBarController.aimatOff();
         ToolBarController.bagOff();
         ToolBarController.homeOff();
         ToolBarController.panel.closeMap();
         this.teamInfo_panel = new TeamInfoPanel();
         this.teamInfo_panel.setup();
         TeamPKManager.addEventListener(TeamPKManager.INIT_INFO,this.initInfoHandler);
         TeamPKManager.addEventListener(TeamPKManager.INIT_HP,this.initHpHandler);
         this.initInfoHandler();
         this._time = new Timer(10000,0);
         this._time.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this._mySt_panel = new TeamPKMyHpPanel();
         this._mySt_panel.setup();
         this._mySt_panel.show();
         this.active = new PKMapActive();
      }
      
      private function quit(_arg_1:MouseEvent) : void
      {
         Answer.show("现在离开战场将无法返回本场保卫战，你确定要离开吗？",this.quitMap);
      }
      
      private function quitMap() : void
      {
         TeamPKManager.levelMapInt();
         MapManager.changeMap(1);
      }
      
      private function getStatus() : void
      {
         TeamPKManager.getTeamSituation();
      }
      
      private function initHpHandler(_arg_1:Event) : void
      {
         this._mySt_panel.init();
      }
      
      private function timerHandler(_arg_1:TimerEvent) : void
      {
         TeamPKManager.getTeamSituation();
      }
      
      private function initInfoHandler(_arg_1:Event = null) : void
      {
         TeamPKManager.getBuildingList();
         if(!TeamPKManager.teamPkSituationInfo)
         {
            return;
         }
         if(this.firstLogin)
         {
            this.firstLogin = false;
            TeamPKManager.PK_STATUS = TeamPKManager.teamPkSituationInfo.pkStatus;
            if(TeamPKManager.PK_STATUS == TeamPKManager.START || TeamPKManager.PK_STATUS == TeamPKManager.OPEN_DOOR)
            {
               if(TeamPKManager.PK_STATUS == TeamPKManager.OPEN_DOOR)
               {
                  this.onOpenDoor(null);
               }
            }
         }
         if(TeamPKManager.isShowPanel)
         {
            if(!this._teamPkSt_panel)
            {
               this._teamPkSt_panel = new AppModel(ClientConfig.getAppModule("TeamPkStPanel"),"打开战队战况");
               this._teamPkSt_panel.setup();
            }
            this._teamPkSt_panel.init(TeamPKManager.teamPkSituationInfo);
            this._teamPkSt_panel.show();
         }
         var _local_2:TeamPkStInfo = TeamPKManager.teamPkSituationInfo;
         var _local_3:uint = uint(_local_2.time);
         _local_3 = uint(Math.ceil(_local_3 / 60));
         var _local_4:uint = uint(_local_2.awayKillBuilding * 50 + _local_2.awayKillPlayer * 25);
         var _local_5:uint = uint(_local_2.homeKillBuilding * 50 + _local_2.homeKillPlayer * 25);
         this.teamInfo_panel.setTime(_local_3);
         this.teamInfo_panel.setAwayScore(_local_4);
         this.teamInfo_panel.setHomeScore(_local_5);
         this.walkEnterHandler();
      }
      
      private function walkEnterHandler(_arg_1:RobotEvent = null) : void
      {
         var _local_2:uint = 0;
         var _local_3:uint = 0;
         var _local_4:ByteArray = null;
         var _local_5:uint = 0;
         var _local_6:TeamPkBuildingInfo = null;
         if(TeamPKManager.PK_STATUS == TeamPKManager.OPEN_DOOR)
         {
            this.sendBuildArr = [];
            if(!this.outBuildingArr)
            {
               this.outBuildingArr = TeamPKManager.enemyBuildingList;
            }
            _local_2 = 0;
            while(_local_2 < this.outBuildingArr.length)
            {
               this.dis = Point.distance(this.outBuildingArr[_local_2].pos,MainManager.actorModel.pos);
               this.les = uint(FortressItemXMLInfo.getShootRadius(this.outBuildingArr[_local_2].id,this.outBuildingArr[_local_2].form));
               if(this.dis <= this.les)
               {
                  this.inBuildingArr.push(this.outBuildingArr[_local_2]);
                  this.sendBuildArr.push(this.outBuildingArr[_local_2]);
                  this.outBuildingArr.splice(_local_2,1);
               }
               _local_2++;
            }
            _local_3 = 0;
            while(_local_3 < this.inBuildingArr.length)
            {
               this.dis = Point.distance(this.inBuildingArr[_local_3].pos,MainManager.actorModel.pos);
               this.les = uint(FortressItemXMLInfo.getShootRadius(this.inBuildingArr[_local_3].id,this.inBuildingArr[_local_3].form));
               if(this.dis > this.les)
               {
                  this.outBuildingArr.push(this.inBuildingArr[_local_3]);
                  this.sendBuildArr.push(this.inBuildingArr[_local_3]);
                  this.inBuildingArr.splice(_local_3,1);
               }
               _local_3++;
            }
            if(this.sendBuildArr.length > 0)
            {
               _local_4 = new ByteArray();
               _local_5 = this.sendBuildArr.length;
               _local_4.writeUnsignedInt(_local_5);
               for each(_local_6 in this.sendBuildArr)
               {
                  _local_4.writeUnsignedInt(_local_6.buyTime);
                  _local_4.writeUnsignedInt(Point.distance(_local_6.pos,MainManager.actorModel.pos));
               }
               SocketConnection.send(CommandID.TEAM_PK_REFRESH_DISTANCE,_local_4);
            }
         }
      }
      
      private function clickPkStHandler(_arg_1:MouseEvent) : void
      {
         TeamPKManager.getTeamSituation();
         TeamPKManager.isShowPanel = true;
      }
      
      override public function destroy() : void
      {
         this.active.destroy();
         this.active = null;
         AutoShotManager.destroy();
         LevelManager.openMouseEvent();
         ProtectSystem.canShow = true;
         DisplayUtil.removeForParent(this.box);
         this.box.destroy();
         this.box = null;
         this._mySt_panel.destroy();
         MainManager.actorModel.removeBloodBar();
         MainManager.actorModel.hideRadius();
         MainManager.actorModel.removeAllAditive(true);
         TeamPkTool.instance.hide();
         TeamPKManager.removeEventListener(TeamPKEvent.COUNT_TIME,this.onTimeCount);
         TeamPKManager.removeEventListener(TeamPKEvent.GET_BUILDING_LIST,this.onGetBuilding);
         TeamPKManager.removeEventListener(TeamPKEvent.OPEN_DOOR,this.onOpenDoor);
         DisplayUtil.removeForParent(this._teamPKST_icon);
         TeamPKManager.gameOver();
         LevelManager.iconLevel.visible = true;
         if(Boolean(this._time))
         {
            this._time.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._time.stop();
            this._time = null;
         }
         this.teamInfo_panel.destroy();
         this.teamInfo_panel = null;
         TeamPKManager.removeEventListener(TeamPKManager.INIT_INFO,this.initInfoHandler);
         TeamPKManager.removeEventListener(TeamPKManager.INIT_HP,this.initHpHandler);
         this.inBuildingArr = null;
         this.outBuildingArr = null;
         this.sendBuildArr = null;
         this._mySt_panel = null;
         MainManager.actorModel.additiveInfo.destroy();
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.walkEnterHandler);
         if(Boolean(this._teamPkSt_panel))
         {
            this._teamPkSt_panel.destroy();
         }
         this._teamPkSt_panel = null;
         this._teamPKST_icon.removeEventListener(MouseEvent.CLICK,this.clickPkStHandler);
         this._teamPKST_icon = null;
         TeamPKManager.inMap = false;
         TeamPKManager.isGetBuilding = false;
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         ToolBarController.aimatOn();
         ToolBarController.bagOn();
         ToolBarController.homeOn();
         ToolBarController.panel.openMap();
      }
      
      private function onGetBuilding(_arg_1:TeamPKEvent) : void
      {
         var _local_2:PKArmModel = null;
         var _local_3:TeamPkBuildingInfo = null;
         TeamPKManager.isGetBuilding = true;
         TeamPKManager.removeEventListener(TeamPKEvent.GET_BUILDING_LIST,this.onGetBuilding);
         for each(_local_3 in TeamPKManager.homeBuildinList)
         {
            _local_2 = new PKArmModel(_local_3,true,TeamPKManager.HOME);
            if(TeamPKManager.TEAM == TeamPKManager.AWAY)
            {
               _local_2.isEnemy = true;
            }
            _local_2.x = MainManager.getStageWidth() - _local_2.pos.x;
            _local_2.info.pos.x = _local_2.x;
            _local_2.info.pos.y = _local_2.y;
            TeamPKManager.homeBuildingMap.add(_local_3.buyTime,_local_2);
            TeamPKManager.buildingMap.add(_local_3.buyTime,_local_2);
            depthLevel.addChild(_local_2);
            ToolTipManager.add(_local_2,FortressItemXMLInfo.getName(_local_2.info.id));
         }
         for each(_local_3 in TeamPKManager.awayBuildinList)
         {
            _local_2 = new PKArmModel(_local_3,false,TeamPKManager.AWAY);
            if(TeamPKManager.TEAM == TeamPKManager.HOME)
            {
               _local_2.isEnemy = true;
            }
            _local_2.x = _local_2.pos.x + TeamPKManager.REDX;
            _local_2.info.pos.x = _local_2.x;
            _local_2.info.pos.y = _local_2.y - _local_2.height;
            TeamPKManager.awayBuildingMap.add(_local_3.buyTime,_local_2);
            TeamPKManager.buildingMap.add(_local_3.buyTime,_local_2);
            depthLevel.addChild(_local_2);
            ToolTipManager.add(_local_2,FortressItemXMLInfo.getName(_local_2.info.id));
         }
         TeamPKManager.initBuildList();
         this._time.start();
         this.getStatus();
      }
      
      private function onOpenDoor(_arg_1:TeamPKEvent) : void
      {
         DisplayUtil.removeForParent(typeLevel["mask_1"]);
         DisplayUtil.removeForParent(typeLevel["mask_2"]);
         DisplayUtil.removeAllChild(btnLevel);
         MapManager.currentMap.makeMapArray();
         this._go_0.gotoAndPlay(2);
         this._go_1.gotoAndPlay(2);
         if(TeamPKManager.TEAM == TeamPKManager.HOME)
         {
            TeamPKManager.updateDistance(TeamPKManager.awayBuildingMap.getValues());
         }
         else
         {
            TeamPKManager.updateDistance(TeamPKManager.homeBuildingMap.getValues());
         }
      }
      
      private function onAimat(_arg_1:AimatEvent) : void
      {
         var _local_2:SpriteModel = null;
         if(TeamPKManager.PK_STATUS != TeamPKManager.OPEN_DOOR)
         {
            return;
         }
         var _local_3:AimatInfo = _arg_1.info;
         var _local_4:Array = UserManager.getUserModelList().concat(TeamPKManager.buildingMap.getValues());
         for each(_local_2 in _local_4)
         {
            if(Boolean(_local_2.hitTestPoint(_local_3.endPos.x + LevelManager.mapLevel.x,_local_3.endPos.y,true)) && _arg_1.info.userID == MainManager.actorID)
            {
               if(_local_2 is BasePeoleModel)
               {
                  if((_local_2 as BasePeoleModel).isShield)
                  {
                     (_local_2 as BasePeoleModel).showShieldMovie();
                  }
                  else
                  {
                     TeamPKManager.shot((_local_2 as BasePeoleModel).info.userID,0,Math.floor(Point.distance(_local_2.pos,MainManager.actorModel.pos)));
                  }
               }
               else
               {
                  TeamPKManager.shot(0,(_local_2 as PKArmModel).info.buyTime,Math.floor(Point.distance(_local_2.pos,MainManager.actorModel.pos)));
               }
               break;
            }
         }
      }
      
      private function onTimeCount(_arg_1:TeamPKEvent) : void
      {
      }
      
      public function clickPoit() : void
      {
         this.active.clickHandler();
      }
   }
}

