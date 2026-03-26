package com.robot.app.WheelChoice
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.*;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.newloader.MCLoader;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.*;
   
   public class WheelChoiceUI extends Sprite
   {
      
      private var _mainUI:MovieClip;
      
      private var app:ApplicationDomain;
      
      private var _closeBtn:SimpleButton;
      
      private var _highLvArr:Array = [0,0,0];
      
      private var _surplusNumArr:Array = [0,0,0];
      
      public function WheelChoiceUI()
      {
         super();
      }
      
      public function setup(event:MCLoadEvent) : void
      {
         this.app = event.getApplicationDomain();
         this._mainUI = event.getContent() as MovieClip;
         addChild(this._mainUI);
         LevelManager.appLevel.addChild(this);
         for(var i:int = 1; i <= 3; i++)
         {
            this._mainUI["btns_" + i].gotoAndStop(1);
            if(i == 4)
            {
               break;
            }
            this._mainUI["btns_" + i].addEventListener(MouseEvent.CLICK,this.onClickTab);
            this._mainUI["btns_" + i].buttonMode = true;
         }
         this._mainUI["mc"].gotoAndStop(1);
         this._closeBtn = this._mainUI["close"];
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
      }
      
      private function onClickClose(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         LevelManager.openMouseEvent();
      }
      
      private function onClickTab(e:MouseEvent) : void
      {
         var index:int = int(String(e.currentTarget.name).split("_")[1]);
         this.tab = index;
      }
      
      private function set tab(value:int) : void
      {
         this._mainUI["mc"].gotoAndStop(value);
         for(var i:int = 1; i <= 3; i++)
         {
            if(i == value)
            {
               this._mainUI["btns_" + i].gotoAndStop(2);
            }
            else
            {
               this._mainUI["btns_" + i].gotoAndStop(1);
            }
         }
         if(this._mainUI["mc"]["txt"] != null)
         {
            this._mainUI["mc"]["txt"].text = String(this._highLvArr[value - 1]);
         }
         if(this._mainUI["mc"]["numtxt"] != null)
         {
            this._mainUI["mc"]["numtxt"].text = String(this._surplusNumArr[value - 1]);
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(this._mainUI))
         {
            DisplayUtil.removeAllChild(this._mainUI);
            DisplayUtil.removeForParent(this._mainUI);
         }
         this._mainUI = null;
         this._closeBtn = null;
      }
      
      public function show() : void
      {
         var MC:MCLoader = null;
         if(this._mainUI == null)
         {
            MC = new MCLoader(ClientConfig.getResPath("/appRes/1211/WheelChoice_UI.swf"),this,1,"正在打开命运之轮...");
            MC.addEventListener(MCLoadEvent.SUCCESS,this.setup);
            MC.doLoad();
         }
         else
         {
            DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
            LevelManager.closeMouseEvent();
            LevelManager.appLevel.addChild(this._mainUI);
         }
      }
   }
}

