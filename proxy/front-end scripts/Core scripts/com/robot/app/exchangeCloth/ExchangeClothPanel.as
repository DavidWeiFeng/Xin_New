package com.robot.app.exchangeCloth
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class ExchangeClothPanel extends Sprite
   {
      
      private const url_str:String = "resource/exchangeCloth/blackExchange.swf";
      
      private var uiLoader:MCLoader;
      
      private var app:ApplicationDomain;
      
      private var main_mc:Sprite;
      
      private var close_btn:SimpleButton;
      
      private var left_mc:Sprite;
      
      private var right_mc:Sprite;
      
      private var exchange_btn:SimpleButton;
      
      private var currentObj:Object;
      
      private var sure_mc:Sprite;
      
      private var info_a:Array;
      
      private var currentIndex:uint;
      
      private var currentE:MovieClip;
      
      private var icon_mc:MovieClip;
      
      public function ExchangeClothPanel()
      {
         super();
      }
      
      public function show(_arg_1:Array) : void
      {
         this.info_a = _arg_1;
         this.currentObj = _arg_1[0];
         this.currentIndex = 0;
         LevelManager.topLevel.addChild(this);
         LevelManager.closeMouseEvent();
         this.loaderUI(this.url_str);
      }
      
      private function loaderUI(_arg_1:String) : void
      {
         this.uiLoader = new MCLoader(_arg_1,LevelManager.appLevel,1,"正在打开物资转换仪");
         this.uiLoader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadUISuccessHandler);
         this.uiLoader.doLoad();
      }
      
      private function onLoadUISuccessHandler(_arg_1:MCLoadEvent) : void
      {
         this.uiLoader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadUISuccessHandler);
         this.app = _arg_1.getApplicationDomain();
         this.main_mc = new (this.app.getDefinition("BlackMain_MC") as Class)() as Sprite;
         this.addChild(this.main_mc);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         this.close_btn = this.main_mc["close_btn"];
         this.left_mc = this.main_mc["left_mc"];
         this.right_mc = this.main_mc["right_mc"];
         this.exchange_btn = this.main_mc["exchange_btn"];
         this.addMaterial();
         this.setTxt();
         if(this.info_a.length > 1)
         {
            this.configRightMc(true);
            this.configLeftMc(true);
         }
         this.configCloseBtn(true);
         this.configExchangeBtn(true);
      }
      
      private function addMaterial() : void
      {
         if(Boolean(this.currentE))
         {
            DisplayUtil.removeForParent(this.currentE);
            this.currentE = null;
         }
         this.currentE = new (this.app.getDefinition(this.currentObj.className) as Class)() as MovieClip;
         this.main_mc.addChild(this.currentE);
         this.currentE.x = 182;
         this.currentE.y = 193;
      }
      
      private function setTxt() : void
      {
         this.main_mc["name_txt"].text = String(this.currentObj.eName);
         this.main_mc["dis_txt"].text = String(this.currentObj.des);
      }
      
      private function configCloseBtn(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            this.close_btn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClickHandler);
         }
         else
         {
            this.close_btn.removeEventListener(MouseEvent.CLICK,this.onCloseBtnClickHandler);
         }
      }
      
      private function onCloseBtnClickHandler(_arg_1:MouseEvent) : void
      {
         this.destroy();
      }
      
      private function configExchangeBtn(_arg_1:Boolean) : void
      {
         if(_arg_1 == true)
         {
            this.exchange_btn.addEventListener(MouseEvent.CLICK,this.onExchangeBtnClickHandler);
         }
         else
         {
            this.exchange_btn.removeEventListener(MouseEvent.CLICK,this.onExchangeBtnClickHandler);
         }
      }
      
      private function onExchangeBtnClickHandler(_arg_1:MouseEvent) : void
      {
         this.exchange_btn.mouseEnabled = false;
         this.exchange_btn.useHandCursor = false;
         this.configExchangeBtn(false);
         this.configCloseBtn(false);
         this.addEventListener(Event.ENTER_FRAME,this.onEnterHandler);
         this.currentE.gotoAndPlay(2);
      }
      
      private function onEnterHandler(_arg_1:Event) : void
      {
         if(this.currentE.totalFrames == this.currentE.currentFrame)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterHandler);
            SocketConnection.addCmdListener(CommandID.EXCHANGE_CLOTH_COMPLETE,this.onSuccess);
            SocketConnection.send(CommandID.EXCHANGE_CLOTH_COMPLETE,ExchangeClothXMLInfo.getExchangeIdByItemId(this.currentObj.id));
            this.destroy();
         }
      }
      
      private function onSuccess(_arg_1:SocketEvent) : void
      {
         this.sure_mc = new (this.app.getDefinition("Sure_MC") as Class)() as Sprite;
         this.sure_mc["name_txt"].text = this.currentObj.exName + " 已经放入了你的储存箱。";
         this.icon_mc = new (this.app.getDefinition(this.currentObj.iconName) as Class)() as MovieClip;
         this.sure_mc.addChild(this.icon_mc);
         this.icon_mc.y = 38.6;
         this.icon_mc.x = 36;
         this.sure_mc["sure_btn"].addEventListener(MouseEvent.CLICK,this.onSureClickHandler);
         this.sure_mc["bg"].buttonMode = true;
         this.sure_mc["bg"].addEventListener(MouseEvent.MOUSE_DOWN,this.onSureDownHandler);
         LevelManager.topLevel.addChild(this.sure_mc);
         DisplayUtil.align(this.sure_mc,null,AlignType.MIDDLE_CENTER);
      }
      
      private function onSureDownHandler(_arg_1:MouseEvent) : void
      {
         this.sure_mc.startDrag();
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageUpHandler);
      }
      
      private function onStageUpHandler(_arg_1:MouseEvent) : void
      {
         this.sure_mc.stopDrag();
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageUpHandler);
      }
      
      private function onSureClickHandler(_arg_1:MouseEvent) : void
      {
         this.sure_mc["bg"].removeEventListener(MouseEvent.MOUSE_DOWN,this.onSureDownHandler);
         this.sure_mc["sure_btn"].removeEventListener(MouseEvent.CLICK,this.onSureClickHandler);
         DisplayUtil.removeForParent(this.sure_mc);
         this.sure_mc = null;
         this.icon_mc = null;
      }
      
      private function configLeftMc(_arg_1:Boolean) : void
      {
         this.left_mc.buttonMode = _arg_1;
         if(_arg_1)
         {
            this.left_mc.addEventListener(MouseEvent.CLICK,this.onLeftMcClickHandler);
         }
         else
         {
            this.left_mc.removeEventListener(MouseEvent.CLICK,this.onLeftMcClickHandler);
         }
      }
      
      private function onLeftMcClickHandler(_arg_1:MouseEvent) : void
      {
         if(this.currentIndex > 0)
         {
            --this.currentIndex;
            this.currentObj = this.info_a[this.currentIndex];
            this.addMaterial();
            this.setTxt();
         }
      }
      
      private function configRightMc(_arg_1:Boolean) : void
      {
         this.right_mc.buttonMode = _arg_1;
         if(_arg_1)
         {
            this.right_mc.addEventListener(MouseEvent.CLICK,this.onRightMcClickHandler);
         }
         else
         {
            this.right_mc.removeEventListener(MouseEvent.CLICK,this.onRightMcClickHandler);
         }
      }
      
      private function onRightMcClickHandler(_arg_1:MouseEvent) : void
      {
         if(this.currentIndex < this.info_a.length - 1)
         {
            ++this.currentIndex;
            this.currentObj = this.info_a[this.currentIndex];
            this.addMaterial();
            this.setTxt();
         }
      }
      
      public function destroy() : void
      {
         this.configLeftMc(false);
         this.configRightMc(false);
         this.configCloseBtn(false);
         this.configExchangeBtn(false);
         DisplayUtil.removeForParent(this.main_mc);
         DisplayUtil.removeForParent(this);
         this.close_btn = null;
         this.left_mc = null;
         this.right_mc = null;
         this.exchange_btn = null;
         this.main_mc = null;
         this.currentE = null;
         LevelManager.openMouseEvent();
      }
   }
}

