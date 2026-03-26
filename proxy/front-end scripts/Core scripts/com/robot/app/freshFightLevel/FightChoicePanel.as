package com.robot.app.freshFightLevel
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.system.ApplicationDomain;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class FightChoicePanel
   {
      
      private const urlStr:String = "resource/freshFightLevel/fightLevel.swf";
      
      private var uiLoader:MCLoader;
      
      private var app:ApplicationDomain;
      
      private var panel:Sprite;
      
      private var b1:Boolean = false;
      
      private var currentBossId:Array;
      
      public function FightChoicePanel()
      {
         super();
      }
      
      public function show() : void
      {
         this.loaderUI(this.urlStr);
      }
      
      private function loaderUI(_arg_1:String) : void
      {
         this.uiLoader = new MCLoader(_arg_1,LevelManager.appLevel,1,"正在进入试炼之塔");
         this.uiLoader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadUISuccessHandler);
         this.uiLoader.doLoad();
      }
      
      private function onLoadUISuccessHandler(_arg_1:MCLoadEvent) : void
      {
         this.app = _arg_1.getApplicationDomain();
         this.panel = new (this.app.getDefinition("UI_FightPanel") as Class)() as Sprite;
         LevelManager.appLevel.addChild(this.panel);
         DisplayUtil.align(this.panel,null,AlignType.MIDDLE_CENTER);
         if(MainManager.actorInfo.maxFreshStage == 0)
         {
            this.panel["goOnBtn"].visible = false;
            this.panel["choiceBtn"].visible = false;
         }
         if(MainManager.actorInfo.curFreshStage >= 1 && MainManager.actorInfo.maxFreshStage > 0)
         {
            this.panel["startFightBtn"].visible = false;
         }
         if(MainManager.actorInfo.curFreshStage > FightLevelModel.maxLevel)
         {
            this.panel["goOnBtn"].visible = false;
         }
         this.setLevel(MainManager.actorInfo.curFreshStage.toString());
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this.panel["bgMc"].buttonMode = true;
         this.panel["bgMc"].addEventListener(MouseEvent.MOUSE_DOWN,this.onBgDownHandler);
         this.panel["closeBtn"].addEventListener(MouseEvent.CLICK,this.onCloseBtnClickHandler);
         this.panel["goOnBtn"].addEventListener(MouseEvent.CLICK,this.onGoonBtnClickHandler);
         this.panel["choiceBtn"].addEventListener(MouseEvent.CLICK,this.onChoiceClickHandler);
         this.panel["startFightBtn"].addEventListener(MouseEvent.CLICK,this.onStartFightClickHandler);
      }
      
      private function removeEvent() : void
      {
         this.panel["bgMc"].removeEventListener(MouseEvent.MOUSE_DOWN,this.onBgDownHandler);
         this.panel["closeBtn"].removeEventListener(MouseEvent.CLICK,this.onCloseBtnClickHandler);
         this.panel["goOnBtn"].removeEventListener(MouseEvent.CLICK,this.onGoonBtnClickHandler);
         this.panel["choiceBtn"].removeEventListener(MouseEvent.CLICK,this.onChoiceClickHandler);
         this.panel["startFightBtn"].removeEventListener(MouseEvent.CLICK,this.onStartFightClickHandler);
      }
      
      private function onBgDownHandler(_arg_1:MouseEvent) : void
      {
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
         this.panel.startDrag();
      }
      
      private function onUpHandler(_arg_1:MouseEvent) : void
      {
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
         this.panel.stopDrag();
      }
      
      private function onCloseBtnClickHandler(_arg_1:MouseEvent) : void
      {
         this.destroy();
      }
      
      private function onGoonBtnClickHandler(_arg_1:MouseEvent) : void
      {
         if(MainManager.actorInfo.curFreshStage > FightLevelModel.maxLevel)
         {
            Alarm.show("你已经到达最高层,不能再挑战了");
            return;
         }
         this.choiceFight(0);
      }
      
      private function onChoiceClickHandler(_arg_1:MouseEvent) : void
      {
         if(!this.b1)
         {
            FightListPanel.show(this.panel,new Point(this.panel.width,150),this.app,FightLevelModel.list);
            this.b1 = true;
         }
         else
         {
            FightListPanel.destroy();
            this.b1 = false;
         }
      }
      
      private function onStartFightClickHandler(_arg_1:MouseEvent) : void
      {
         this.choiceFight(0);
      }
      
      public function choiceFight(_arg_1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.FRESH_CHOICE_FIGHT_LEVEL,this.onChoiceSuccessHandler);
         SocketConnection.send(CommandID.FRESH_CHOICE_FIGHT_LEVEL,_arg_1);
      }
      
      private function onChoiceSuccessHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.FRESH_CHOICE_FIGHT_LEVEL,this.onChoiceSuccessHandler);
         var _local_2:FreshChoiceLevelRequestInfo = _arg_1.data as FreshChoiceLevelRequestInfo;
         this.currentBossId = _local_2.getBossId;
         this.destroy();
         FightLevelModel.setBossId = this.currentBossId;
         FightLevelModel.setCurLevel = _local_2.getLevel;
         MainManager.actorInfo.curFreshStage = _local_2.getLevel;
         MapManager.changeMap(600);
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         if(this.b1)
         {
            this.b1 = false;
            FightListPanel.destroy();
         }
         DisplayUtil.removeForParent(this.panel);
         this.panel = null;
         LevelManager.openMouseEvent();
      }
      
      private function setLevel(_arg_1:String) : void
      {
         this.panel["levelTxt"].text = _arg_1;
      }
   }
}

