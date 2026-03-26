package com.robot.app.leiyiTrain
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class LeiyiTrainPanel extends Sprite
   {
      
      private var _closeBtn:SimpleButton;
      
      private var _skillBtn:SimpleButton;
      
      private var _mainMc:Sprite;
      
      private var _energyBtn:SimpleButton;
      
      private var app:ApplicationDomain;
      
      private var PATH:String = "module/com/robot/module/app/LeiyiTrainPanel.swf";
      
      public function LeiyiTrainPanel()
      {
         super();
      }
      
      public function hide() : void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this._mainMc);
      }
      
      private function onSkillHandler(_arg_1:MouseEvent) : void
      {
         Alarm.show("即将开放");
      }
      
      public function show() : void
      {
         var _local_1:MCLoader = null;
         if(!this._mainMc)
         {
            _local_1 = new MCLoader(this.PATH,this,1,"正在打开雷伊特训面板");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,this.setup);
            _local_1.doLoad();
         }
      }
      
      public function init(_arg_1:Object = null) : void
      {
      }
      
      private function onEnergyHandler(_arg_1:MouseEvent) : void
      {
         this.hide();
         LeiyiTrainPanelController.check(LeiyiEnergyPanelController.show);
      }
      
      private function removeEvent() : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseHandler);
         this._energyBtn.removeEventListener(MouseEvent.CLICK,this.onEnergyHandler);
         this._skillBtn.removeEventListener(MouseEvent.CLICK,this.onSkillHandler);
         DragManager.remove(this._mainMc);
      }
      
      private function onCloseHandler(_arg_1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function addEvent() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseHandler);
         this._energyBtn.addEventListener(MouseEvent.CLICK,this.onEnergyHandler);
         this._skillBtn.addEventListener(MouseEvent.CLICK,this.onSkillHandler);
         DragManager.add(this._mainMc["dragMc"],this._mainMc);
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainMc = null;
         this._closeBtn = null;
         this._energyBtn = null;
         this._skillBtn = null;
      }
      
      public function setup(_arg_1:MCLoadEvent) : void
      {
         this.app = _arg_1.getApplicationDomain();
         this._mainMc = new (this.app.getDefinition("LeiyiTrain_Mc") as Class)() as Sprite;
         this._mainMc.x = 220;
         this._mainMc.y = 90;
         LevelManager.appLevel.addChild(this._mainMc);
         this._closeBtn = this._mainMc["closeBtn"];
         this._energyBtn = this._mainMc["energyBtn"];
         this._skillBtn = this._mainMc["skillBtn"];
         this.addEvent();
      }
   }
}

