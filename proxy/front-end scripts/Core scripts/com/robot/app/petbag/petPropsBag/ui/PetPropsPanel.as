package com.robot.app.petbag.petPropsBag.ui
{
   import com.robot.app.bag.*;
   import com.robot.app.petbag.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.ui.itemTip.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class PetPropsPanel extends Sprite
   {
      
      public static const PREV_PAGE:String = "prevPage";
      
      public static const NEXT_PAGE:String = "nextPage";
      
      public static const SHOW_COLLECTION:String = "showCollection";
      
      private var _clickItemID:uint;
      
      private var petPropsPanel:Sprite;
      
      private var _listCon:Sprite;
      
      private var _itemArr:Array = [];
      
      private var _currentBagItem:BagListItem;
      
      private var _petInfo:PetInfo;
      
      private var itemID:uint;
      
      private var itemName:String;
      
      private var _propInfo:PetPropInfo;
      
      public function PetPropsPanel(_arg_1:Sprite)
      {
         super();
         this.petPropsPanel = _arg_1;
         this.show();
         this.addEvent();
      }
      
      public function hide() : void
      {
         this.petPropsPanel.visible = false;
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function addEvent() : void
      {
      }
      
      public function showItem(_arg_1:Array) : void
      {
         var _local_3:BagListItem = null;
         var _local_2:uint = 0;
         var _local_4:SingleItemInfo = null;
         var _local_5:Boolean = false;
         var _local_7:int = 0;
         _local_3 = null;
         this.clearItemPanel();
         var _local_6:int = int(_arg_1.length);
         while(_local_7 < _local_6)
         {
            _local_2 = uint(_arg_1[_local_7]);
            _local_3 = this._listCon.getChildAt(_local_7) as BagListItem;
            _local_4 = ItemManager.getPetItemInfo(_local_2);
            _local_5 = false;
            _local_3.buttonMode = true;
            _local_3.setInfo(_local_4,_local_5);
            _local_3.addEventListener(MouseEvent.ROLL_OVER,this.onShowItemInfo);
            _local_3.addEventListener(MouseEvent.ROLL_OUT,this.onHideItemInfo);
            _local_3.addEventListener(MouseEvent.CLICK,this.onPetPropsUsed);
            _local_7++;
         }
      }
      
      public function show() : void
      {
         this._listCon = new Sprite();
         this._listCon.x = 50;
         this._listCon.y = 20;
         this.petPropsPanel.addChild(this._listCon);
         this.createItemPanel();
         var _local_1:SimpleButton = this.petPropsPanel["prev_btn"];
         var _local_2:SimpleButton = this.petPropsPanel["next_btn"];
         _local_1.addEventListener(MouseEvent.CLICK,this.prevHandler);
         _local_2.addEventListener(MouseEvent.CLICK,this.nextHandler);
      }
      
      private function createItemPanel() : void
      {
         var _local_1:BagListItem = null;
         var _local_2:int = 0;
         _local_1 = null;
         while(_local_2 < 12)
         {
            _local_1 = new BagListItem(UIManager.getSprite("itemPanel"));
            _local_1.x = (_local_1.width + 10) * int(_local_2 % 3);
            _local_1.y = (_local_1.height + 10) * int(_local_2 / 3);
            this._listCon.addChild(_local_1);
            _local_2++;
         }
      }
      
      private function clearItemPanel() : void
      {
         var _local_1:BagListItem = null;
         var _local_3:int = 0;
         var _local_2:int = this._listCon.numChildren;
         while(_local_3 < _local_2)
         {
            _local_1 = this._listCon.getChildAt(_local_3) as BagListItem;
            _local_1.clear();
            _local_1.removeEventListener(MouseEvent.ROLL_OVER,this.onShowItemInfo);
            _local_1.removeEventListener(MouseEvent.ROLL_OUT,this.onHideItemInfo);
            _local_1.removeEventListener(MouseEvent.CLICK,this.onPetPropsUsed);
            _local_1.buttonMode = false;
            _local_3++;
         }
      }
      
      private function prevHandler(_arg_1:MouseEvent) : void
      {
         dispatchEvent(new Event(PREV_PAGE));
      }
      
      private function nextHandler(_arg_1:MouseEvent) : void
      {
         dispatchEvent(new Event(NEXT_PAGE));
      }
      
      public function setPageNum(_arg_1:uint, _arg_2:uint) : void
      {
         this.petPropsPanel["page_txt"].text = _arg_1 + "/" + _arg_2;
      }
      
      public function onPetPropsUsed(_arg_1:MouseEvent) : void
      {
         var _local_2:String = null;
         if(this._petInfo == null)
         {
            Alarm.show("你要先选择一个精灵噢");
            return;
         }
         this._currentBagItem = _arg_1.currentTarget as BagListItem;
         if(this._currentBagItem.info == null)
         {
            return;
         }
         this.itemID = this._currentBagItem.info.itemID;
         this.itemName = ItemXMLInfo.getName(this.itemID);
         if(this.itemID == 300028 || this.itemID == 300035)
         {
            _local_2 = "你确定要使用" + TextFormatUtil.getRedTxt(this.itemName) + "吗?";
         }
         else
         {
            _local_2 = "你确定要为你的<font color=\'#ff0000\'>" + PetXMLInfo.getName(this._petInfo.id) + "</font>使用" + TextFormatUtil.getRedTxt(this.itemName) + "吗?";
            PetManager.handleCatchTime = this._petInfo.catchTime;
         }
         this._propInfo = new PetPropInfo();
         this._propInfo.petInfo = this._petInfo;
         this._propInfo.itemId = this.itemID;
         this._propInfo.itemName = this.itemName;
         Alert.show(_local_2,this.onsureHandler);
      }
      
      private function onsureHandler() : void
      {
         var obj:Object = null;
         SocketConnection.addCmdListener(CommandID.USE_PET_ITEM_OUT_OF_FIGHT,this.onUpDate);
         try
         {
            obj = getDefinitionByName("com.robot.app.petbag.petPropsBag.petPropClass.PetPropClass_" + this.itemID);
         }
         catch(e:Error)
         {
            obj = getDefinitionByName("com.robot.app.petbag.petPropsBag.petPropClass.PetPropClass_default");
         }
         new obj(this._propInfo);
      }
      
      private function onUpDate(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.USE_PET_ITEM_OUT_OF_FIGHT,this.onUpDate);
         this.hide();
         PetManager.upDate();
         if(this._currentBagItem.info.itemNum > 0)
         {
            --this._currentBagItem.info.itemNum;
         }
         this._currentBagItem.setInfo(this._currentBagItem.info);
         var _local_2:uint = uint(this._currentBagItem.info.itemID);
         if(_local_2 == 300037 || _local_2 == 300038 || _local_2 == 300039 || _local_2 == 300040 || _local_2 == 300041 || _local_2 == 300042)
         {
            PetBagController.panel.curretItem.showClear();
         }
      }
      
      private function onShowItemInfo(_arg_1:MouseEvent) : void
      {
         var _local_2:BagListItem = _arg_1.currentTarget as BagListItem;
         if(_local_2.info == null)
         {
            return;
         }
         this._clickItemID = _local_2.info.itemID;
         ItemInfoTip.show(_local_2.info);
      }
      
      private function onHideItemInfo(_arg_1:MouseEvent) : void
      {
         ItemInfoTip.hide();
      }
      
      public function getPetInfo(_arg_1:PetInfo) : PetInfo
      {
         this._petInfo = _arg_1;
         return this._petInfo;
      }
      
      public function get clickItemID() : uint
      {
         return this._clickItemID;
      }
   }
}

