package com.robot.app.task.pioneerTaskList
{
   import com.robot.app.buyItem.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.*;
   
   public class BatteryTestTask extends Sprite
   {
      
      private const url_str:String = "resource/Games/BatteryTestTask.swf";
      
      private var uiLoader:MCLoader;
      
      private var app:ApplicationDomain;
      
      private var mainUI_mc:Sprite;
      
      private var status_str:String;
      
      private var isCorrect_b:*;
      
      private var left:uint = 3;
      
      private var isTask_b:Boolean;
      
      private var power_btn:MovieClip;
      
      private var left_mc:Sprite;
      
      private var right_mc:Sprite;
      
      private var xixi:String;
      
      private var status_mc:MovieClip;
      
      private var cur:String;
      
      private var idPower:*;
      
      private var batteryLevel:Sprite;
      
      private var omnipotence_mc:Sprite;
      
      private var nX:Number;
      
      private var nY:Number;
      
      private var total:Array;
      
      private var bb_a:Array;
      
      private var help_btn:SimpleButton;
      
      public function BatteryTestTask(_arg_1:Boolean = true)
      {
         super();
         this.isTask_b = _arg_1;
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
         this.xixi = NpcTipDialog.CICI;
         this.app = _arg_1.getApplicationDomain();
         this.mainUI_mc = new (this.app.getDefinition("ShipUI_MC") as Class)() as Sprite;
         this.addChild(this.mainUI_mc);
         this.power_btn = this.mainUI_mc["power_btn"];
         this.left_mc = this.mainUI_mc["left_mc"];
         this.right_mc = this.mainUI_mc["right_mc"];
         this.power_btn.gotoAndStop(1);
         this.mainUI_mc["motor_mc"].gotoAndStop(1);
         this.mainUI_mc["exit_btn"].addEventListener(MouseEvent.CLICK,this.onCloseBtnClickHnadler);
         this.mainUI_mc["hit_mc"].addEventListener(MouseEvent.CLICK,this.onAllClickHandler);
         this.setBattery(1);
         this.setLineVisible(false,false,false,false);
         this.setXYPoint(324,347,511,347);
         this.configPowerBtn(true);
         this.configLeftMc(true);
         this.configRightMc(true);
         this.addBattery();
         this.addShip();
         this.addHelp();
      }
      
      private function onAllClickHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:uint = uint(this.mainUI_mc["all_mc"].currentFrame);
         if(_local_2 > 1)
         {
            this.mainUI_mc["all_mc"].gotoAndStop(_local_2 - 1);
            this.bb_a[this.bb_a.length - 1].visible = true;
            this.bb_a.pop();
            this.total.pop();
         }
      }
      
      private function onCloseBtnClickHnadler(_arg_1:MouseEvent) : void
      {
         this.destroy();
      }
      
      private function configPowerBtn(_arg_1:Boolean) : void
      {
         this.power_btn.useHandCursor = _arg_1;
         this.power_btn.buttonMode = _arg_1;
         if(_arg_1 == true)
         {
            this.power_btn.gotoAndStop(1);
            this.power_btn.addEventListener(MouseEvent.CLICK,this.onPowerBtnClickHandler);
         }
         else
         {
            this.power_btn.removeEventListener(MouseEvent.CLICK,this.onPowerBtnClickHandler);
         }
      }
      
      private function onPowerBtnClickHandler(_arg_1:MouseEvent) : void
      {
         this.power_btn.gotoAndPlay(2);
         this.configPowerBtn(false);
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
      }
      
      private function onEnterFrameHandler(_arg_1:Event) : void
      {
         if(this.power_btn.totalFrames == this.power_btn.currentFrame)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
            --this.left;
            this.setShipAccount(3 - this.left);
            this.check();
         }
      }
      
      private function check() : void
      {
         if(this.idPower == null)
         {
            if(this.left == 0)
            {
               NpcTipDialog.show("你这次没有机会让潜艇模型正常行驶，下次再来试一试吧",this.destroy,this.xixi,-60,this.destroy);
            }
            else
            {
               NpcTipDialog.show("电池盒没有连入电路，没有电源给电动马达供电，你还有 " + this.left + " 次机会,再试一试",this.remain,this.xixi,-60,this.remain);
            }
         }
         else if(this.total.length == 0)
         {
            if(this.left == 0)
            {
               NpcTipDialog.show("你这次没有机会让潜艇模型正常行驶，下次再来试一试吧",this.destroy,this.xixi,-60,this.destroy);
            }
            else
            {
               NpcTipDialog.show("电池盒是空的，没有电源电动马达可没有办法工作。你还有" + this.left + "次机会,再试一试！",this.remain,this.xixi,-60,this.remain);
            }
         }
         else if(this.idPower == true)
         {
            if(this.total.length == 1)
            {
               this.addStatusMc("0");
               return;
            }
            if(this.total.length == 2)
            {
               this.addStatusMc("2");
               return;
            }
            if(this.total.length >= 3)
            {
               this.fire();
               return;
            }
         }
         else if(this.total.length <= 2)
         {
            this.addStatusMc("1");
         }
         else
         {
            this.fire();
         }
      }
      
      private function fire() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.onFireEnterFrameHandler);
         this.mainUI_mc["motor_mc"].gotoAndPlay(2);
      }
      
      private function onFireEnterFrameHandler(_arg_1:Event) : void
      {
         if(this.mainUI_mc["motor_mc"].totalFrames == this.mainUI_mc["motor_mc"].currentFrame)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onFireEnterFrameHandler);
            if(this.left != 0)
            {
               NpcTipDialog.show("电源电压太高，电动马达烧掉了，你还有" + this.left + "次机会,再试一试！",this.remain,this.xixi,-60,this.remain);
            }
            else
            {
               NpcTipDialog.show("你这次没有机会让潜艇模型正常行驶，下次再来试一试吧",this.destroy,this.xixi,-60,this.destroy);
            }
         }
      }
      
      private function remain() : void
      {
         var _local_2:int = 0;
         this.configPowerBtn(true);
         var _local_1:uint = uint(this.batteryLevel.numChildren);
         while(_local_2 < _local_1)
         {
            this.batteryLevel.getChildByName("battery" + _local_2).removeEventListener(MouseEvent.MOUSE_DOWN,this.onBatteryDownHandler);
            _local_2++;
         }
         DisplayUtil.removeAllChild(this.batteryLevel);
         this.addBattery();
         this.setBattery(1);
         this.setLineVisible(false,false,false,false);
         this.setXYPoint(324,347,511,347);
         this.mainUI_mc["motor_mc"].gotoAndStop(1);
         if(Boolean(this.status_mc))
         {
            DisplayUtil.removeAllChild(this.status_mc);
            this.removeChild(this.status_mc);
            this.status_mc = null;
         }
      }
      
      private function addStatusMc(_arg_1:String) : void
      {
         this.cur = _arg_1;
         this.status_mc = new (this.app.getDefinition("Status_MC") as Class)() as MovieClip;
         this.addChild(this.status_mc);
         this.status_mc["low_mc"].visible = false;
         this.status_mc["hout_mc"].visible = false;
         this.status_mc["qianj_mc"].visible = false;
         this.status_mc["low_mc"].gotoAndStop(1);
         this.status_mc["hout_mc"].gotoAndStop(1);
         this.status_mc["qianj_mc"].gotoAndStop(1);
         switch(_arg_1)
         {
            case "0":
               this.status_mc["low_mc"].gotoAndPlay(2);
               this.status_mc["low_mc"].visible = true;
               break;
            case "1":
               this.status_mc["hout_mc"].gotoAndPlay(2);
               this.status_mc["hout_mc"].visible = true;
               break;
            case "2":
               this.status_mc["qianj_mc"].gotoAndPlay(2);
               this.status_mc["qianj_mc"].visible = true;
         }
         this.addEventListener(Event.ENTER_FRAME,this.onPlayEnterHandler);
      }
      
      private function onPlayEnterHandler(_arg_1:Event) : void
      {
         switch(this.cur)
         {
            case "0":
               if(this.status_mc["low_mc"].totalFrames == this.status_mc["low_mc"].currentFrame)
               {
                  this.removeEventListener(Event.ENTER_FRAME,this.onPlayEnterHandler);
                  if(this.left == 0)
                  {
                     NpcTipDialog.show("你这次没有机会让潜艇模型正常行驶，下次再来试一试吧",this.destroy,this.xixi,-60,this.destroy);
                  }
                  else
                  {
                     NpcTipDialog.show("接入电路的电源电压太低，电机动力不足哟！你还有" + this.left + "次机会,再试一试！",this.remain,this.xixi,-60,this.remain);
                  }
               }
               return;
            case "1":
               if(this.status_mc["hout_mc"].totalFrames == this.status_mc["hout_mc"].currentFrame)
               {
                  this.removeEventListener(Event.ENTER_FRAME,this.onPlayEnterHandler);
                  if(this.left == 0)
                  {
                     NpcTipDialog.show("你这次没有机会让潜艇模型正常行驶，下次再来试一试吧",this.destroy,this.xixi,-60,this.destroy);
                  }
                  else
                  {
                     NpcTipDialog.show("电动马达极性不同转向就不同，你还有" + this.left + "次机会,换个接法再试一试！",this.remain,this.xixi,-60,this.remain);
                  }
               }
               return;
            case "2":
               if(this.status_mc["qianj_mc"].totalFrames == this.status_mc["qianj_mc"].currentFrame)
               {
                  this.removeEventListener(Event.ENTER_FRAME,this.onPlayEnterHandler);
                  this.mainUI_mc["exit_btn"].removeEventListener(MouseEvent.CLICK,this.onCloseBtnClickHnadler);
                  NpcTipDialog.show("电动马达不仅有额定电压，也有极性，正确连接电路，它就会按照你的意愿提供动力了。潜艇模型就放我这里，潜水套装送给你。有了它你就可以畅通无阻的前往深海了。",this.success,this.xixi,-60,this.success);
               }
         }
      }
      
      private function success() : void
      {
         ItemAction.buyMultiItem(3,"潜水套装",100024,100025,100026);
         this.destroy();
      }
      
      private function destroy() : void
      {
         var _local_2:int = 0;
         this.configPowerBtn(false);
         this.configLeftMc(false);
         this.configRightMc(false);
         this.mainUI_mc["exit_btn"].removeEventListener(MouseEvent.CLICK,this.onCloseBtnClickHnadler);
         this.help_btn.removeEventListener(MouseEvent.CLICK,this.onHelpHandler);
         var _local_1:uint = uint(this.batteryLevel.numChildren);
         while(_local_2 < _local_1)
         {
            this.batteryLevel.getChildByName("battery" + _local_2).removeEventListener(MouseEvent.MOUSE_DOWN,this.onBatteryDownHandler);
            _local_2++;
         }
         if(this.status_mc != null)
         {
            DisplayUtil.removeAllChild(this.status_mc);
            this.removeChild(this.status_mc);
         }
         DisplayUtil.removeAllChild(this.batteryLevel);
         DisplayUtil.removeForParent(this.mainUI_mc);
         DisplayUtil.removeForParent(this);
         this.power_btn = null;
         this.left_mc = null;
         this.right_mc = null;
         this.mainUI_mc = null;
         this.idPower = null;
         this.batteryLevel = null;
         this.omnipotence_mc = null;
         this.uiLoader.clear();
         this.uiLoader = null;
         this.status_mc = null;
         this.help_btn = null;
      }
      
      private function configLeftMc(_arg_1:Boolean) : void
      {
         this.left_mc.useHandCursor = _arg_1;
         this.left_mc.buttonMode = _arg_1;
         if(_arg_1)
         {
            this.left_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onLeftDownHandler);
         }
         else
         {
            this.left_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onLeftDownHandler);
         }
      }
      
      private function onLeftDownHandler(_arg_1:MouseEvent) : void
      {
         this.left_mc.startDrag();
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onLeftUpHandler);
      }
      
      private function onLeftUpHandler(_arg_1:MouseEvent) : void
      {
         this.left_mc.stopDrag();
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onLeftUpHandler);
         if(this.left_mc.hitTestObject(this.mainUI_mc["positive_mc"]))
         {
            this.idPower = true;
            this.setLineVisible(true,false,false,true);
            this.setXYPoint(423,305,423,385);
            return;
         }
         if(this.left_mc.hitTestObject(this.mainUI_mc["negative_mc"]))
         {
            this.idPower = false;
            this.setLineVisible(false,true,true,false);
            this.setXYPoint(423,385,423,305);
            return;
         }
         var _local_2:Sprite = new Sprite();
         if(this.left_mc.hitTestObject(this.mainUI_mc["positive_mc"]) == false && this.left_mc.hitTestObject(this.mainUI_mc["negative_mc"]) == false)
         {
            this.idPower = null;
            this.setXYPoint(324,347,511,348);
            this.setLineVisible(false,false,false,false);
            return;
         }
      }
      
      private function setXYPoint(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number) : void
      {
         this.left_mc.x = _arg_1;
         this.left_mc.y = _arg_2;
         this.right_mc.x = _arg_3;
         this.right_mc.y = _arg_4;
      }
      
      private function configRightMc(_arg_1:Boolean) : void
      {
         this.right_mc.useHandCursor = _arg_1;
         this.right_mc.buttonMode = _arg_1;
         if(_arg_1)
         {
            this.right_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onRightDownHandler);
         }
         else
         {
            this.right_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRightDownHandler);
         }
      }
      
      private function onRightDownHandler(_arg_1:MouseEvent) : void
      {
         this.right_mc.startDrag();
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onRightUpHandler);
      }
      
      private function onRightUpHandler(_arg_1:MouseEvent) : void
      {
         this.right_mc.stopDrag();
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onRightUpHandler);
         if(this.right_mc.hitTestObject(this.mainUI_mc["positive_mc"]))
         {
            this.idPower = false;
            this.setLineVisible(false,true,true,false);
            this.setXYPoint(423,385,423,305);
            return;
         }
         if(this.right_mc.hitTestObject(this.mainUI_mc["negative_mc"]))
         {
            this.idPower = true;
            this.setLineVisible(true,false,false,true);
            this.setXYPoint(423,305,423,385);
            return;
         }
         if(this.right_mc.hitTestObject(this.mainUI_mc["positive_mc"]) == false && this.left_mc.hitTestObject(this.mainUI_mc["negative_mc"]) == true)
         {
            this.idPower = null;
            this.setLineVisible(false,false,false,false);
            this.setXYPoint(324,347,511,348);
            return;
         }
      }
      
      private function setLineVisible(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean, _arg_4:Boolean) : void
      {
         this.mainUI_mc["line1_mc"].visible = _arg_1;
         this.mainUI_mc["line2_mc"].visible = _arg_2;
         this.mainUI_mc["line3_mc"].visible = _arg_3;
         this.mainUI_mc["line4_mc"].visible = _arg_4;
      }
      
      private function setBattery(_arg_1:uint) : void
      {
         this.mainUI_mc["all_mc"].gotoAndStop(_arg_1);
      }
      
      private function addBattery() : void
      {
         var _local_1:Sprite = null;
         var _local_2:int = 0;
         this.total = new Array();
         this.bb_a = new Array();
         this.batteryLevel = new Sprite();
         this.addChild(this.batteryLevel);
         while(_local_2 < 4)
         {
            _local_1 = new (this.app.getDefinition("battery_mc") as Class)() as Sprite;
            _local_1.name = "battery" + _local_2;
            _local_1.useHandCursor = true;
            _local_1.buttonMode = true;
            this.batteryLevel.addChild(_local_1);
            _local_1.x = 620 + (_local_1.width + 10) * _local_2;
            _local_1.y = 465;
            _local_1.addEventListener(MouseEvent.MOUSE_DOWN,this.onBatteryDownHandler);
            _local_2++;
         }
      }
      
      private function onBatteryDownHandler(_arg_1:MouseEvent) : void
      {
         this.omnipotence_mc = _arg_1.currentTarget as Sprite;
         this.nX = this.omnipotence_mc.x;
         this.nY = this.omnipotence_mc.y;
         (_arg_1.currentTarget as Sprite).startDrag();
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onBatteryUpHandler);
      }
      
      private function onBatteryUpHandler(_arg_1:MouseEvent) : void
      {
         this.omnipotence_mc.stopDrag();
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBatteryUpHandler);
         if(this.omnipotence_mc.hitTestObject(this.mainUI_mc["hit_mc"]))
         {
            this.total.push(0);
            this.setBattery(this.total.length + 1);
            this.omnipotence_mc.visible = false;
            this.bb_a.push(this.omnipotence_mc);
         }
         else
         {
            this.omnipotence_mc.visible = true;
         }
         this.omnipotence_mc.x = this.nX;
         this.omnipotence_mc.y = this.nY;
      }
      
      private function addHelp() : void
      {
         this.help_btn = new (this.app.getDefinition("Help_Btn") as Class)() as SimpleButton;
         this.help_btn.x = 15;
         this.help_btn.y = 15;
         this.help_btn.addEventListener(MouseEvent.CLICK,this.onHelpHandler);
         this.addChild(this.help_btn);
      }
      
      private function onHelpHandler(_arg_1:MouseEvent) : void
      {
         this.help_btn.removeEventListener(MouseEvent.CLICK,this.onHelpHandler);
         this.help_btn.mouseEnabled = false;
         NpcTipDialog.show("拖动电池放入电池盒，把它连入电路，合上开关，电动马达就可以工作了。不同的连接方法会让马达的转动方向不同。注意，别把电动马达烧坏了！",this.addHelpEvent,this.xixi,-60,this.addHelpEvent);
      }
      
      private function addHelpEvent() : void
      {
         this.help_btn.mouseEnabled = true;
         this.help_btn.addEventListener(MouseEvent.CLICK,this.onHelpHandler);
      }
      
      private function addShip() : void
      {
         var _local_1:Sprite = null;
         var _local_2:uint = 0;
         while(_local_2 < 3)
         {
            _local_1 = new (this.app.getDefinition("ship_mc") as Class)() as Sprite;
            this.addChild(_local_1);
            _local_1.name = "ship" + _local_2;
            (_local_1 as MovieClip).gotoAndStop(1);
            _local_1.x = 610 + (_local_1.width + 8) * _local_2;
            _local_1.y = 12;
            _local_2++;
         }
      }
      
      private function setShipAccount(_arg_1:uint) : void
      {
         var _local_2:uint = 0;
         while(_local_2 < _arg_1)
         {
            (this.getChildByName("ship" + _local_2) as MovieClip).gotoAndStop(2);
            _local_2++;
         }
      }
   }
}

