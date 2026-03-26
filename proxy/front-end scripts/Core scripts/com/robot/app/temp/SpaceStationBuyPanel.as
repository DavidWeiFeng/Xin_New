package com.robot.app.temp
{
   import com.robot.app.buyPetProps.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.system.ApplicationDomain;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class SpaceStationBuyPanel extends Sprite
   {
      
      private static var propsHashMap:HashMap;
      
      private var PATH:String = "resource/module/petProps/buyPetProps2.swf";
      
      private var app:ApplicationDomain;
      
      private var mc:MovieClip;
      
      private var tipMc:MovieClip;
      
      private var buyPropsBtn:SimpleButton;
      
      private var buyPrimaryBtn:SimpleButton;
      
      private var buyMidBtn:SimpleButton;
      
      private var buyHighBtn:SimpleButton;
      
      private var propsMC:MovieClip;
      
      private var midPropsMC:MovieClip;
      
      private var primaryMC:MovieClip;
      
      private var midMC:MovieClip;
      
      private var highMC:MovieClip;
      
      private var buyPrEnergyBtn:SimpleButton;
      
      private var priEnergyMC:MovieClip;
      
      private var buyCoverBtn:SimpleButton;
      
      private var midPropsBtn:SimpleButton;
      
      public function SpaceStationBuyPanel()
      {
         super();
      }
      
      public function show() : void
      {
         var _local_1:MCLoader = null;
         if(!this.mc)
         {
            _local_1 = new MCLoader(this.PATH,this,1,"正在打开精灵道具列表");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,this.onLoad);
            _local_1.doLoad();
         }
         else
         {
            DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
            LevelManager.closeMouseEvent();
            LevelManager.appLevel.addChild(this);
         }
      }
      
      private function onLoad(_arg_1:MCLoadEvent) : void
      {
         this.app = _arg_1.getApplicationDomain();
         this.mc = new (this.app.getDefinition("petPropsPanel") as Class)() as MovieClip;
         this.tipMc = new (this.app.getDefinition("buyTipPanel") as Class)() as MovieClip;
         this.primaryMC = new (this.app.getDefinition("primaryMC") as Class)() as MovieClip;
         this.midMC = new (this.app.getDefinition("midMC") as Class)() as MovieClip;
         this.highMC = new (this.app.getDefinition("highMC") as Class)() as MovieClip;
         this.priEnergyMC = new (this.app.getDefinition("priEnergyMC") as Class)() as MovieClip;
         addChild(this.mc);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(this);
         var _local_2:SimpleButton = this.mc["exitBtn"];
         _local_2.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.initPanel();
         if(propsHashMap == null)
         {
            propsHashMap = new HashMap();
            propsHashMap.add(300011,20);
            propsHashMap.add(300012,40);
            propsHashMap.add(300013,80);
            propsHashMap.add(300001,200);
            propsHashMap.add(300016,30);
            propsHashMap.add(300002,400);
         }
      }
      
      private function initPanel() : void
      {
         this.buyPrimaryBtn = this.mc["buyPrimaryBtn"] as SimpleButton;
         this.buyPrimaryBtn.addEventListener(MouseEvent.CLICK,this.showPrimaryTip);
         this.buyMidBtn = this.mc["buyMidBtn"] as SimpleButton;
         this.buyMidBtn.addEventListener(MouseEvent.CLICK,this.showMidTip);
         this.buyHighBtn = this.mc["buyHighBtn"] as SimpleButton;
         this.buyHighBtn.addEventListener(MouseEvent.CLICK,this.showHighTip);
         this.buyPrEnergyBtn = this.mc["buyPrEnergyBtn"] as SimpleButton;
         this.buyPrEnergyBtn.addEventListener(MouseEvent.CLICK,this.showPriEnergyTip);
      }
      
      private function getCover(_arg_1:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.BUY_FITMENT,this.onBuyFitment);
         SocketConnection.send(CommandID.BUY_FITMENT,500502,1);
      }
      
      private function onBuyFitment(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.BUY_FITMENT,this.onBuyFitment);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         var _local_5:uint = _local_2.readUnsignedInt();
         MainManager.actorInfo.coins = _local_3;
         var _local_6:FitmentInfo = new FitmentInfo();
         _local_6.id = _local_4;
         FitmentManager.addInStorage(_local_6);
         Alarm.show("精灵恢复仓已经放入你的基地仓库");
      }
      
      private function showMidPropsTip(_arg_1:MouseEvent) : void
      {
         this.showTipPanel(300002,this.midPropsMC,new Point(173,45));
      }
      
      private function showPropsTip(_arg_1:MouseEvent) : void
      {
         this.showTipPanel(300001,this.propsMC,new Point(173,45));
      }
      
      private function showPriEnergyTip(_arg_1:MouseEvent) : void
      {
         this.showTipPanel(300016,this.priEnergyMC,new Point(185,47));
      }
      
      private function showHighTip(_arg_1:MouseEvent) : void
      {
         this.showTipPanel(300013,this.highMC,new Point(182,45));
      }
      
      private function showMidTip(_arg_1:MouseEvent) : void
      {
         this.showTipPanel(300012,this.midMC,new Point(167,45));
      }
      
      private function showPrimaryTip(_arg_1:MouseEvent) : void
      {
         this.showTipPanel(300011,this.primaryMC,new Point(185,45));
      }
      
      private function showTipPanel(_arg_1:uint, _arg_2:MovieClip, _arg_3:Point) : void
      {
         if(MainManager.actorInfo.coins < propsHashMap.getValue(_arg_1))
         {
            Alarm.show("你的骄阳豆不足");
            return;
         }
         DisplayUtil.removeForParent(this);
         new ListPetProps(this.tipMc,_arg_1,_arg_2,_arg_3);
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         LevelManager.openMouseEvent();
      }
   }
}

