package com.robot.app.mapProcess
{
   import com.robot.app.magicPassword.*;
   import com.robot.app.paintBook.*;
   import com.robot.app.task.books.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_9 extends BaseMapProcess
   {
      
      private static var panel:AppModel;
      
      private var newsPaperBtn:SimpleButton;
      
      private var allBookPanel:MovieClip;
      
      private var cupBtn:SimpleButton;
      
      private var planBtn:SimpleButton;
      
      private var _nonoBookApp:AppModel;
      
      private var _nonoChipMix:AppModel;
      
      private var _superApp:AppModel;
      
      private var timePanel:AppModel;
      
      private var oldPaperPanel:AppModel;
      
      public function MapProcess_9()
      {
         super();
      }
      
      override protected function init() : void
      {
         ToolTipManager.add(conLevel["change_btn"],"分子频谱分析仪");
         ToolTipManager.add(conLevel["newsPaperBtn"],"往期航行日志");
         ToolTipManager.add(conLevel["spaceVurvey_mc"],"帕诺星系测绘图");
         conLevel["spaceVurvey_mc"].buttonMode = true;
         conLevel["spaceVurvey_mc"].mouseChildren = false;
         this.checkTask();
         this.newsPaperBtn = conLevel["newsPaperBtn"];
         this.newsPaperBtn.addEventListener(MouseEvent.CLICK,this.clickNewsPaper);
         this.planBtn = conLevel["planBtn"];
         this.planBtn.visible = true;
         this.planBtn.addEventListener(MouseEvent.CLICK,this.loadBook1);
         conLevel["bookBtn"].addEventListener(MouseEvent.CLICK,this.showAllBook);
         ToolTipManager.add(conLevel["bookBtn"],"赛尔资料库");
         ToolTipManager.add(conLevel["starGame"],"星座档案管理");
         this.cupBtn = conLevel["cupBtn"];
         this.cupBtn.addEventListener(MouseEvent.CLICK,this.loadBook);
      }
      
      private function checkTask() : void
      {
         conLevel["spaceVurvey_mc"].addEventListener(MouseEvent.CLICK,this.onSpaceVurveyMCClick);
         conLevel["spaceVurvey_mc"].addEventListener(MouseEvent.MOUSE_OVER,this.onSpaceVurveyMCOver);
         conLevel["spaceVurvey_mc"].addEventListener(MouseEvent.MOUSE_OUT,this.onSpaceVurveyMCOut);
      }
      
      private function onSpaceVurveyMCOver(_arg_1:MouseEvent) : void
      {
         conLevel["spaceVurvey_mc"].gotoAndStop(2);
      }
      
      private function onSpaceVurveyMCOut(_arg_1:MouseEvent) : void
      {
         conLevel["spaceVurvey_mc"].gotoAndStop(1);
      }
      
      private function onSpaceVurveyMCClick(_arg_1:MouseEvent) : void
      {
         if(!panel)
         {
            panel = new AppModel(ClientConfig.getTaskModule("SpaceSurveyView"),"正在打开测绘帕诺星系图");
            panel.setup();
         }
         panel.show();
      }
      
      private function loadBook1(_arg_1:MouseEvent) : void
      {
         var _local_2:MCLoader = new MCLoader("resource/module/greadPlan/greadPlan.swf",LevelManager.appLevel,1,"正在打开书本");
         _local_2.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess1);
         _local_2.doLoad();
      }
      
      private function onLoadSuccess1(_arg_1:MCLoadEvent) : void
      {
         var _local_2:ApplicationDomain = _arg_1.getApplicationDomain();
         var _local_3:* = _local_2.getDefinition("GreadPlanPanel");
         var _local_4:MovieClip = new _local_3() as MovieClip;
         LevelManager.appLevel.addChild(_local_4);
         DisplayUtil.align(_local_4,null,AlignType.MIDDLE_CENTER);
      }
      
      private function loadBook(_arg_1:MouseEvent) : void
      {
         var _local_2:MCLoader = new MCLoader("resource/module/book/book.swf",LevelManager.appLevel,1,"正在打开书本");
         _local_2.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         _local_2.doLoad();
      }
      
      private function onLoadSuccess(_arg_1:MCLoadEvent) : void
      {
         var _local_2:ApplicationDomain = _arg_1.getApplicationDomain();
         var _local_3:* = _local_2.getDefinition("Book");
         var _local_4:MovieClip = new _local_3() as MovieClip;
         LevelManager.appLevel.addChild(_local_4);
         DisplayUtil.align(_local_4,null,AlignType.MIDDLE_CENTER);
      }
      
      private function showAllBook(_arg_1:MouseEvent) : void
      {
         if(!this.allBookPanel)
         {
            this.allBookPanel = MapLibManager.getMovieClip("AllBookPanel");
            this.allBookPanel["petBtn"].addEventListener(MouseEvent.CLICK,this.showPetBook);
            this.allBookPanel["jgBtn"].addEventListener(MouseEvent.CLICK,this.showJgBook);
            this.allBookPanel["shipBtn"].addEventListener(MouseEvent.CLICK,this.showShipBook);
            this.allBookPanel["nonoBookBtn"].addEventListener(MouseEvent.CLICK,this.onNoNoBookHandler);
            this.allBookPanel["paintBtn"].addEventListener(MouseEvent.CLICK,this.onPaintBook);
         }
         DisplayUtil.align(this.allBookPanel,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this.allBookPanel);
      }
      
      private function onPaintBook(_arg_1:MouseEvent) : void
      {
         PaintBookController.show();
      }
      
      private function onNoNoBookHandler(_arg_1:MouseEvent) : void
      {
         if(Boolean(this._nonoChipMix))
         {
            this.onCloseMixHandler(null);
         }
         if(Boolean(this._nonoBookApp))
         {
            this.onNoNoBookCloseHandler(null);
         }
         if(!this._nonoBookApp)
         {
            this._nonoBookApp = new AppModel(ClientConfig.getBookModule("NoNoBook"),"正在打开NoNo手册");
            this._nonoBookApp.setup();
            this._nonoBookApp.sharedEvents.addEventListener(Event.CLOSE,this.onNoNoBookCloseHandler);
            this._nonoBookApp.sharedEvents.addEventListener(Event.OPEN,this.onOpenHandler);
            this._nonoBookApp.sharedEvents.addEventListener("supernonooper",this.onSuperNoOper);
         }
         this._nonoBookApp.show();
      }
      
      private function onNoNoSuperHandler(_arg_1:MouseEvent) : void
      {
         if(Boolean(this._nonoChipMix))
         {
            this.onCloseMixHandler(null);
         }
         if(!this._superApp)
         {
            this._superApp = new AppModel(ClientConfig.getBookModule("NoNoJieShaoBook"),"正在打开超能NoNo手册");
            this._superApp.setup();
            this._superApp.sharedEvents.addEventListener(Event.CLOSE,this.onNoNoJieShaoBookCloseHandler);
            this._superApp.sharedEvents.addEventListener(Event.OPEN,this.onOpenHandler);
            this._superApp.sharedEvents.addEventListener("nonobookchange",this.onOpenHandler1);
         }
         this._superApp.show();
      }
      
      private function onNoNoJieShaoBookCloseHandler(_arg_1:Event) : void
      {
         if(!this._superApp)
         {
            return;
         }
         this._superApp.sharedEvents.removeEventListener(Event.OPEN,this.onOpenHandler);
         this._superApp.sharedEvents.removeEventListener(Event.CLOSE,this.onNoNoJieShaoBookCloseHandler);
         this._superApp.sharedEvents.removeEventListener("nonobookchange",this.onOpenHandler1);
         this._superApp.destroy();
         this._superApp = null;
      }
      
      private function onNoNoBookCloseHandler(_arg_1:Event = null) : void
      {
         if(!this._nonoBookApp)
         {
            return;
         }
         this._nonoBookApp.sharedEvents.removeEventListener(Event.OPEN,this.onOpenHandler);
         this._nonoBookApp.sharedEvents.removeEventListener(Event.CLOSE,this.onNoNoBookCloseHandler);
         this._nonoBookApp.destroy();
         this._nonoBookApp = null;
      }
      
      private function onSuperNoOper(_arg_1:Event) : void
      {
         this.onCloseMixHandler(null);
         this.onNoNoSuperHandler(null);
         this.onNoNoBookCloseHandler(null);
      }
      
      private function onOpenHandler1(_arg_1:Event) : void
      {
         this.onCloseMixHandler(null);
         this.onNoNoBookHandler(null);
         this.onNoNoBookCloseHandler(null);
      }
      
      private function onOpenHandler(_arg_1:Event) : void
      {
         this.onNoNoBookCloseHandler(null);
         this.onChipMixHandler(null);
         this.onNoNoBookCloseHandler(null);
      }
      
      private function onChipMixHandler(_arg_1:MouseEvent) : void
      {
         if(Boolean(this._nonoBookApp))
         {
            this.onNoNoBookCloseHandler(null);
         }
         if(!this._nonoChipMix)
         {
            this._nonoChipMix = new AppModel(ClientConfig.getBookModule("NoNoChipMicBook"),"正在打开芯片合成书");
            this._nonoChipMix.setup();
            this._nonoChipMix.sharedEvents.addEventListener(Event.CLOSE,this.onCloseMixHandler);
         }
         this._nonoChipMix.show();
      }
      
      private function onCloseMixHandler(_arg_1:Event) : void
      {
         if(!this._nonoChipMix)
         {
            return;
         }
         this._nonoChipMix.sharedEvents.removeEventListener(Event.CLOSE,this.onCloseMixHandler);
         this._nonoChipMix.destroy();
         this._nonoChipMix = null;
      }
      
      private function showPetBook(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.allBookPanel);
         MonsterBook.loadPanel();
      }
      
      private function showJgBook(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.allBookPanel);
         InstructorBook.loadPanel();
      }
      
      private function showShipBook(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.allBookPanel);
         FlyBook.loadPanel();
      }
      
      override public function destroy() : void
      {
         if(Boolean(this._nonoChipMix))
         {
            this.onCloseMixHandler(null);
         }
         if(Boolean(this._nonoBookApp))
         {
            this.onNoNoBookCloseHandler(null);
         }
         this.planBtn.removeEventListener(MouseEvent.CLICK,this.loadBook1);
         this.planBtn = null;
         ToolTipManager.remove(conLevel["starGame"]);
         this.allBookPanel = null;
         conLevel["bookBtn"].removeEventListener(MouseEvent.CLICK,this.showAllBook);
         ToolTipManager.remove(conLevel["change_btn"]);
         ToolTipManager.remove(conLevel["newsPaperBtn"]);
         this.newsPaperBtn.removeEventListener(MouseEvent.CLICK,this.clickNewsPaper);
         this.newsPaperBtn = null;
         conLevel["spaceVurvey_mc"].removeEventListener(MouseEvent.CLICK,this.onSpaceVurveyMCClick);
         conLevel["spaceVurvey_mc"].removeEventListener(MouseEvent.MOUSE_OVER,this.onSpaceVurveyMCOver);
         conLevel["spaceVurvey_mc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onSpaceVurveyMCOut);
      }
      
      public function passExChangeHandler() : void
      {
         MagicPasswordController.show();
      }
      
      private function clickNewsPaper(_arg_1:MouseEvent) : void
      {
         if(this.oldPaperPanel == null)
         {
            this.oldPaperPanel = ModuleManager.getModule(ClientConfig.getAppModule("OldNewsPaper"),"正在打开往期日志");
            this.oldPaperPanel.setup();
         }
         this.oldPaperPanel.show();
      }
      
      public function starGame() : void
      {
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoin);
         SocketConnection.send(CommandID.JOIN_GAME,1);
      }
      
      private function onJoin(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoin);
         var _local_2:MCLoader = new MCLoader("resource/Games/theStarGame.swf",LevelManager.appLevel,1,"正在加载游戏");
         _local_2.addEventListener(MCLoadEvent.SUCCESS,this.onSuccess);
         _local_2.doLoad();
      }
      
      private function onSuccess(_arg_1:MCLoadEvent) : void
      {
         LevelManager.gameLevel.addChild(_arg_1.getContent());
      }
      
      public function timeMachine() : void
      {
         if(this.timePanel == null)
         {
            this.timePanel = ModuleManager.getModule(ClientConfig.getAppModule("TimePasswordMachine"),"正在打开时空密码机");
            this.timePanel.setup();
         }
         this.timePanel.show();
      }
   }
}

