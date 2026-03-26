package com.robot.app.task.spacedoor
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
   
   public class SpaceTaskGame extends Sprite
   {
      
      private const url_str:String = "resource/Games/BallTaskGame.swf";
      
      private var uiLoader:MCLoader;
      
      private var mainUI_mc:Sprite;
      
      private var closeBtn:SimpleButton;
      
      private var panelMc:MovieClip;
      
      private var panelEffect:MovieClip;
      
      private var app:ApplicationDomain;
      
      private var startX:Number;
      
      private var startY:Number;
      
      private var counter:Number = 0;
      
      private var grass_mc:MovieClip;
      
      private var fire_mc:MovieClip;
      
      private var w_mc:MovieClip;
      
      private var stone_mc:MovieClip;
      
      private var land_mc:MovieClip;
      
      public function SpaceTaskGame()
      {
         super();
         LevelManager.topLevel.addChild(this);
         this.loadAssets(this.url_str);
      }
      
      private function loadAssets(_arg_1:String) : void
      {
         this.uiLoader = new MCLoader(_arg_1,LevelManager.appLevel,1,"正在打开任务");
         this.uiLoader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadUISuccessHandler);
         this.uiLoader.doLoad();
      }
      
      private function onLoadUISuccessHandler(_arg_1:MCLoadEvent) : void
      {
         this.app = _arg_1.getApplicationDomain();
         this.mainUI_mc = new (this.app.getDefinition("MainUI_MC") as Class)() as Sprite;
         this.addChild(this.mainUI_mc);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         this.panelMc = this.mainUI_mc["panel_mc"];
         this.panelMc.gotoAndStop(1);
         this.closeBtn = this.mainUI_mc["close_btn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClickHandler);
         this.grass_mc = this.mainUI_mc["grass_mc"];
         this.fire_mc = this.mainUI_mc["fire_mc"];
         this.w_mc = this.mainUI_mc["w_mc"];
         this.stone_mc = this.mainUI_mc["stone_mc"];
         this.land_mc = this.mainUI_mc["land_mc"];
         ToolTipManager.add(this.grass_mc,"草");
         this.grass_mc.buttonMode = true;
         ToolTipManager.add(this.fire_mc,"火");
         this.fire_mc.buttonMode = true;
         ToolTipManager.add(this.w_mc,"水");
         this.w_mc.buttonMode = true;
         ToolTipManager.add(this.stone_mc,"电");
         this.stone_mc.buttonMode = true;
         ToolTipManager.add(this.land_mc,"地");
         this.land_mc.buttonMode = true;
         this.grass_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
         this.grass_mc.addEventListener(MouseEvent.MOUSE_UP,this.dropIt);
         this.fire_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
         this.fire_mc.addEventListener(MouseEvent.MOUSE_UP,this.dropIt);
         this.w_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
         this.w_mc.addEventListener(MouseEvent.MOUSE_UP,this.dropIt);
         this.stone_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
         this.stone_mc.addEventListener(MouseEvent.MOUSE_UP,this.dropIt);
         this.land_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
         this.land_mc.addEventListener(MouseEvent.MOUSE_UP,this.dropIt);
      }
      
      private function pickUp(_arg_1:MouseEvent) : void
      {
         _arg_1.target.startDrag();
         _arg_1.target.parent.addChild(_arg_1.target);
         this.startX = _arg_1.target.x;
         this.startY = _arg_1.target.y;
      }
      
      private function dropIt(_arg_1:MouseEvent) : void
      {
         _arg_1.target.stopDrag();
         var _local_2:String = "target" + _arg_1.target.name;
         var _local_3:DisplayObject = this.mainUI_mc[_local_2];
         if(_arg_1.target.dropTarget != null && _arg_1.target.dropTarget.parent == _local_3)
         {
            _arg_1.target.removeEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
            _arg_1.target.removeEventListener(MouseEvent.MOUSE_UP,this.dropIt);
            _arg_1.target.buttonMode = false;
            _arg_1.target.x = _local_3.x;
            _arg_1.target.y = _local_3.y;
            ++this.counter;
         }
         else
         {
            _arg_1.target.x = this.startX;
            _arg_1.target.y = this.startY;
            this.onDropErrorHandler();
         }
         if(this.counter == 5)
         {
            this.onFinishedHander();
         }
      }
      
      private function onCloseBtnClickHandler(_arg_1:MouseEvent) : void
      {
         this.destroy();
      }
      
      private function destroy() : void
      {
         if(Boolean(this.panelEffect))
         {
            this.panelEffect.removeEventListener(Event.ENTER_FRAME,this.onEffectFrameHandler);
         }
         DisplayUtil.removeForParent(this.mainUI_mc);
         DisplayUtil.removeForParent(this);
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseBtnClickHandler);
         this.closeBtn = null;
         this.mainUI_mc = null;
         this.uiLoader.clear();
         this.uiLoader = null;
         this.grass_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
         this.grass_mc.removeEventListener(MouseEvent.MOUSE_UP,this.dropIt);
         this.fire_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
         this.fire_mc.removeEventListener(MouseEvent.MOUSE_UP,this.dropIt);
         this.w_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
         this.w_mc.removeEventListener(MouseEvent.MOUSE_UP,this.dropIt);
         this.stone_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
         this.stone_mc.removeEventListener(MouseEvent.MOUSE_UP,this.dropIt);
         this.land_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.pickUp);
         this.land_mc.removeEventListener(MouseEvent.MOUSE_UP,this.dropIt);
      }
      
      private function onDropErrorHandler() : void
      {
         Alarm.show("你放置的位置不属于这颗属性球，记得对照<font color=\'#ff0000\'>属性相克表</font>来排列哦！");
      }
      
      private function onFinishedHander() : void
      {
         this.panelMc.gotoAndStop(2);
         this.panelEffect = this.panelMc["panel_effect"];
         this.panelEffect.addEventListener(Event.ENTER_FRAME,this.onEffectFrameHandler);
      }
      
      private function onEffectFrameHandler(e:Event) : void
      {
         if(this.panelEffect.currentFrame == this.panelEffect.totalFrames)
         {
            this.panelEffect.removeEventListener(Event.ENTER_FRAME,this.onEffectFrameHandler);
            this.destroy();
            Alarm.show("我果然没有看错，你真行啊！时空之门已经开启，通过时空之门我们就可以穿梭到千年前的赫尔卡星，那里曾经遭遇了异常可怕的浩劫……",function():void
            {
            });
         }
      }
   }
}

