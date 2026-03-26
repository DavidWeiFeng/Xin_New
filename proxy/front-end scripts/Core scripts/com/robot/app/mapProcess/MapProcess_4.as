package com.robot.app.mapProcess
{
   import com.robot.app.energy.ore.*;
   import com.robot.app.energy.utils.EnergyController;
   import com.robot.app.help.*;
   import com.robot.app.newspaper.*;
   import com.robot.app.task.books.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.task.DayTalkInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_4 extends BaseMapProcess
   {
      
      private var loader:MCLoader;
      
      private var curDisplayObj:DisplayObject;
      
      private var flyBookBtn:SimpleButton;
      
      private var tgMC:SimpleButton;
      
      private var bookMC:SimpleButton;
      
      private var gyMC:SimpleButton;
      
      private var gyPanel:MovieClip;
      
      private var gyCloseBtn:SimpleButton;
      
      private var _npc:MovieClip;
      
      private var _shipBreakageMc:MovieClip;
      
      private var wbMc:MovieClip;
      
      private var mbox:DialogBox;
      
      public function MapProcess_4()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.flyBookBtn = conLevel["flyBookBtn"];
         this.bookMC = conLevel["bookMC"];
         this.flyBookBtn.addEventListener(MouseEvent.CLICK,this.showBook);
         this.bookMC.addEventListener(MouseEvent.CLICK,this.showBook);
         this.tgMC = conLevel["tgMC"];
         ToolTipManager.add(this.tgMC,"给船长写信");
         this.tgMC.addEventListener(MouseEvent.CLICK,this.tgFun);
         ToolTipManager.add(conLevel["gameMc"],"保护导航仪");
         ToolTipManager.add(this.flyBookBtn,"飞船手册");
         ToolTipManager.add(this.bookMC,"飞船手册");
         this.gyMC = conLevel["GY_MC"];
         this.gyMC.addEventListener(MouseEvent.CLICK,this.openGy);
         ToolTipManager.add(this.gyMC,"船员公约");
         DisplayUtil.removeForParent(depthLevel["wenMc"],false);
         DisplayUtil.removeForParent(depthLevel["wenMc"],false);
         var _local_1:SimpleButton = conLevel["nonoBtn"];
         ToolTipManager.add(_local_1,"超能NoNo骄阳豆领取");
         _local_1.addEventListener(MouseEvent.CLICK,this.clickNonoBtn);
         this.wbMc = conLevel["hitWbMC"];
         this.wbMc.addEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.addEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
      }
      
      private function wbmcOverHandler(_arg_1:MouseEvent) : void
      {
         this.mbox = new DialogBox();
         this.mbox.show("有什么需要我帮助您的吗？",0,-30,conLevel["wbNpc"]);
      }
      
      private function wbmcOUTHandler(_arg_1:MouseEvent) : void
      {
         this.mbox.hide();
      }
      
      private function clickNonoBtn(_arg_1:MouseEvent) : void
      {
         var _local_2:DayOreCount = null;
         if(!MainManager.actorModel.nono)
         {
            Alarm.show("你要带上NoNo才能领取物品哦！");
            return;
         }
         if(MainManager.actorInfo.superNono)
         {
            _local_2 = new DayOreCount();
            _local_2.addEventListener(DayOreCount.countOK,this.onCount);
            _local_2.sendToServer(2001);
         }
      }
      
      public function showWBTask() : void
      {
         HelpManager.show(0);
      }
      
      private function onCount(_arg_1:Event) : void
      {
         if(DayOreCount.oreCount < 1)
         {
            SocketConnection.addCmdListener(CommandID.TALK_CATE,this.onTalk);
            SocketConnection.send(CommandID.TALK_CATE,2001);
         }
         else
         {
            Alarm.show("本周你已经领取过骄阳豆了，下周再来吧。");
         }
      }
      
      private function onTalk(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,this.onTalk);
         var _local_3:DayTalkInfo = _arg_1.data as DayTalkInfo;
         EnergyController.showDayTalkInfo(_local_3);
      }
      
      private function onTaskComplete(_arg_1:Event) : void
      {
         DisplayUtil.removeForParent(depthLevel["wenMc"]);
      }
      
      private function tgFun(_arg_1:MouseEvent) : void
      {
         ContributeAlert.show(ContributeAlert.SHIPER_TYPE);
      }
      
      public function showWbAction() : void
      {
         var _local_1:MovieClip = conLevel["wbNpc"] as MovieClip;
         _local_1.gotoAndPlay(2);
      }
      
      override public function destroy() : void
      {
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         this.wbMc = null;
         this.mbox = null;
         ToolTipManager.remove(this.flyBookBtn);
         ToolTipManager.remove(this.bookMC);
         ToolTipManager.remove(this.tgMC);
         ToolTipManager.remove(conLevel["gameMc"]);
         this.curDisplayObj = null;
         this.loader = null;
         this.flyBookBtn.removeEventListener(MouseEvent.CLICK,this.showBook);
         this.tgMC.removeEventListener(MouseEvent.CLICK,this.tgFun);
         this.bookMC.removeEventListener(MouseEvent.CLICK,this.showBook);
         this.tgMC = null;
         this.bookMC = null;
         ToolTipManager.remove(this.gyMC);
         this.gyMC.removeEventListener(MouseEvent.CLICK,this.openGy);
         this.gyMC = null;
      }
      
      private function openGy(_arg_1:MouseEvent) : void
      {
         if(!this.gyPanel)
         {
            this.gyPanel = MapLibManager.getMovieClip("ui_gy_mc");
            this.gyCloseBtn = this.gyPanel["closeBtn"];
            this.gyCloseBtn.addEventListener(MouseEvent.CLICK,this.closeGy);
         }
         DisplayUtil.align(this.gyPanel,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this.gyPanel);
      }
      
      private function closeGy(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.gyPanel,false);
      }
      
      private function showBook(_arg_1:MouseEvent) : void
      {
         FlyBook.loadPanel();
      }
      
      public function showGame() : void
      {
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoinGame);
         SocketConnection.send(CommandID.JOIN_GAME,1);
      }
      
      private function onJoinGame(_arg_1:SocketEvent) : void
      {
         MapManager.destroy();
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoinGame);
         this.loader = new MCLoader("resource/Games/ShootGame.swf",LevelManager.topLevel,1,"正在加载保护导航仪游戏");
         this.loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadDLL);
         this.loader.doLoad();
      }
      
      private function onLoadDLL(_arg_1:MCLoadEvent) : void
      {
         this.loader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadDLL);
         LevelManager.topLevel.addChild(_arg_1.getContent());
         _arg_1.getContent().addEventListener("shootGameOver",this.onGameOver);
         this.curDisplayObj = _arg_1.getContent();
      }
      
      private function onGameOver(_arg_1:Event) : void
      {
         var _local_2:* = _arg_1.target as Sprite;
         var _local_3:Object = _local_2.scoreObj;
         var _local_4:uint = uint(_local_3.per);
         var _local_5:uint = uint(_local_3.score);
         MapManager.refMap();
         SocketConnection.send(CommandID.GAME_OVER,_local_4,_local_5);
      }
   }
}

