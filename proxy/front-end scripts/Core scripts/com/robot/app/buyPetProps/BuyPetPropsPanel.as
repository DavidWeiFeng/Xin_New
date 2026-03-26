package com.robot.app.buyPetProps
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.text.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class BuyPetPropsPanel extends Sprite
   {
      
      private static var propsHashMap:HashMap;
      
      private var PATH:String = "resource/module/petProps/buyPetProps.swf?20250323-1";
      
      public var app:ApplicationDomain;
      
      private var mc:MovieClip;
      
      private var tipMc:MovieClip;
      
      private var _pageText:TextField;
      
      private var _preBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      public var goldCoinItemID:Number = 0;
      
      private var iconHashMap:HashMap = new HashMap();
      
      private var itemArray:Array;
      
      private var curPage:int = 0;
      
      private var totalPage:int = 1;
      
      private var itemMCHashMap:HashMap = new HashMap();
      
      private var isLoadingItem:Boolean = false;
      
      public function BuyPetPropsPanel()
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
      
      private function onLoad(event:MCLoadEvent) : void
      {
         var closeBtn:SimpleButton;
         this.itemArray = PetShopXmlInfo.getItemIdArray();
         this.app = event.getApplicationDomain();
         this.mc = new (this.app.getDefinition("petPropsPanel") as Class)() as MovieClip;
         this.tipMc = new (this.app.getDefinition("buyTipPanel") as Class)() as MovieClip;
         this._pageText = this.mc["pageText"] as TextField;
         this._preBtn = this.mc["preBtn"] as SimpleButton;
         this._nextBtn = this.mc["nextBtn"] as SimpleButton;
         this.totalPage = int(this.itemArray.length / 15) + 1;
         this._pageText.text = "1/" + this.totalPage.toString();
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.nextPage);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.prePage);
         closeBtn = this.mc["exitBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         addChild(this.mc);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(this);
         this.setupItemMC();
         setTimeout(function():void
         {
            showPage(0);
         },100);
      }
      
      private function setupItemMC() : void
      {
         var _local_2:ItemMC = null;
         var _local_1:int = 0;
         while(_local_1 < 15)
         {
            _local_2 = new ItemMC(this,_local_1);
            this.itemMCHashMap.add("itemMC_" + _local_1.toString(),_local_2);
            this.mc.addChild(_local_2.itemMC);
            _local_1++;
         }
      }
      
      private function showPage(_arg_1:int) : void
      {
         var _local_6:ItemMC = null;
         var _local_7:int = 0;
         var _local_5:int = 0;
         var _local_2:int = _arg_1 * 15;
         var _local_3:int = (_arg_1 + 1) * 15;
         if(_local_3 > this.itemArray.length)
         {
            _local_3 = int(this.itemArray.length);
         }
         var _local_4:int = _local_3 - _local_2;
         for each(_local_6 in this.itemMCHashMap.getValues())
         {
            _local_6.visible = false;
         }
         _local_7 = _local_2;
         while(_local_7 < _local_3)
         {
            (this.itemMCHashMap.getValue("itemMC_" + _local_5.toString()) as ItemMC).setup(this.itemArray[_local_7]);
            (this.itemMCHashMap.getValue("itemMC_" + _local_5.toString()) as ItemMC).visible = true;
            _local_5++;
            _local_7++;
         }
      }
      
      private function nextPage(_arg_1:MouseEvent) : void
      {
         this.curPage += 1;
         if(this.curPage >= this.totalPage)
         {
            this.curPage = this.totalPage - 1;
         }
         this._pageText.text = this.curPage + 1 + "/" + this.totalPage.toString();
         this.showPage(this.curPage);
      }
      
      private function prePage(_arg_1:MouseEvent) : void
      {
         this.curPage -= 1;
         if(this.curPage < 0)
         {
            this.curPage = 0;
         }
         this._pageText.text = this.curPage + 1 + "/" + this.totalPage.toString();
         this.showPage(this.curPage);
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
      
      public function showTipPanel(_arg_1:uint, _arg_2:MovieClip, _arg_3:Point) : void
      {
         if(MainManager.actorInfo.coins < Number(PetShopXmlInfo.getPriceByItemID(_arg_1)))
         {
            Alarm.show("你的骄阳豆不足");
            return;
         }
         new ListPetProps(this.tipMc,_arg_1,_arg_2,_arg_3);
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         LevelManager.openMouseEvent();
      }
      
      private function onCheckGold(event:SocketEvent) : void
      {
         var _local_2:ByteArray = event.data as ByteArray;
         var num:Number = _local_2.readUnsignedInt() / 100;
         var name:String = GoldProductXMLInfo.getNameByItemID(this.goldCoinItemID);
         var price:Number = Number(GoldProductXMLInfo.getPriceByItemID(this.goldCoinItemID));
         var coins:Number = _local_2.readUnsignedInt();
         MainManager.actorInfo.coins = coins;
         if(price > num)
         {
            Alarm.show("目前你拥有" + TextFormatUtil.getRedTxt(num.toString()) + "金豆，无法购买" + TextFormatUtil.getRedTxt(price.toString()) + "金豆的商品！");
         }
         else
         {
            Alert.show(TextFormatUtil.getRedTxt(name) + "需要花费" + TextFormatUtil.getRedTxt(price.toString()) + "金豆，" + "目前你拥有" + TextFormatUtil.getRedTxt(num.toString()) + "金豆，要确认购买吗？",function():void
            {
               var _local_1:ByteArray = new ByteArray();
               _local_1.writeShort(1);
               var _local_2:Number = Number(PetShopXmlInfo.getProductByItemId(goldCoinItemID));
               SocketConnection.addCmdListener(CommandID.GOLD_BUY_PRODUCT,onBuyGoldItem);
               SocketConnection.send(CommandID.GOLD_BUY_PRODUCT,_local_2,_local_1);
            });
         }
      }
      
      private function onBuyGoldItem(_arg_1:SocketEvent) : void
      {
         var _local_2:String = null;
         SocketConnection.removeCmdListener(CommandID.GOLD_BUY_PRODUCT,this.onBuyGoldItem);
         _local_2 = PetShopXmlInfo.getNameByItemID(this.goldCoinItemID);
         if(this.goldCoinItemID > 500000)
         {
            IconAlert.show("恭喜你购买成功，" + TextFormatUtil.getRedTxt(_local_2) + "已经放入你的基地仓库中",this.goldCoinItemID);
         }
         else
         {
            ItemInBagAlert.show(this.goldCoinItemID,"恭喜你购买成功，" + TextFormatUtil.getRedTxt(_local_2) + "已经放入你的储存箱中");
         }
      }
   }
}

