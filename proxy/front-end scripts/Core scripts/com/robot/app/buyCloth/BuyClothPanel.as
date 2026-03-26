package com.robot.app.buyCloth
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.*;
   
   public class BuyClothPanel extends Sprite
   {
      
      private var PATH:String = "resource/module/clothBook/clothBook.swf";
      
      private var app:ApplicationDomain;
      
      private var _mainUI:MovieClip;
      
      private var _closeBtn:SimpleButton;
      
      public function BuyClothPanel()
      {
         super();
         var _local_1:MCLoader = new MCLoader(this.PATH,LevelManager.topLevel,1,"正在打开装备列表");
         _local_1.addEventListener(MCLoadEvent.SUCCESS,this.onLoad);
         _local_1.doLoad();
      }
      
      public function show() : void
      {
         var _local_1:MovieClip = null;
         if(Boolean(this._mainUI))
         {
            DisplayUtil.removeForParent(this._mainUI);
            this._mainUI = new (this.app.getDefinition("BookPanel") as Class)() as MovieClip;
            addChild(this._mainUI);
            (this._mainUI["buyPanel"] as MovieClip).gotoAndStop(1);
            _local_1 = this._mainUI["buyPanel"] as MovieClip;
            _local_1.gotoAndStop(1);
            LevelManager.appLevel.addChild(this);
            this._closeBtn = this._mainUI["closeBtn"];
            this._closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         }
      }
      
      public function destroy() : void
      {
         this.app = null;
         if(Boolean(this._mainUI))
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
            this._closeBtn = null;
            this._mainUI = null;
         }
      }
      
      private function onLoad(_arg_1:MCLoadEvent) : void
      {
         if(Boolean(this._mainUI))
         {
            DisplayUtil.removeForParent(this._mainUI);
         }
         this.app = _arg_1.getApplicationDomain();
         this._mainUI = new (this.app.getDefinition("BookPanel") as Class)() as MovieClip;
         var _local_2:MovieClip = this._mainUI["buyPanel"] as MovieClip;
         _local_2.gotoAndStop(1);
         (_local_2["coverMC"] as MovieClip).stop();
         addChild(this._mainUI);
         this.x = 94;
         this.y = 34;
         LevelManager.appLevel.addChild(this);
         LevelManager.closeMouseEvent();
         this._closeBtn = this._mainUI["closeBtn"];
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         LevelManager.openMouseEvent();
      }
   }
}

