package com.robot.app.petbag.ui
{
   import com.robot.app.petUpdate.PetUpdatePropController;
   import com.robot.app.petbag.petPropsBag.*;
   import com.robot.app.petbag.petPropsBag.ui.*;
   import com.robot.app.picturebook.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.info.pet.update.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.uic.UIPanel;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class PetBagPanel extends UIPanel
   {
      
      private static const LIST_LENGTH:int = 6;
      
      private var petUpdatePropCon:PetUpdatePropController;
      
      private var _listCon:Sprite;
      
      private var _followBtn:MovieClip;
      
      private var _defaultBtn:SimpleButton;
      
      private var _storageBtn:SimpleButton;
      
      private var _pictureBookBtn:SimpleButton;
      
      private var _cureBtn:SimpleButton;
      
      private var _itemBtn:SimpleButton;
      
      private var _infoMc:PetDataPanel;
      
      private var _petPropsPanel:PetPropsPanel;
      
      private var _petBagModel:PetBagModel;
      
      private var _listData:Array;
      
      private var _curretItem:PetBagListItem;
      
      private var _arrowMc:MovieClip;
      
      private var _maskMc:Sprite;
      
      public function PetBagPanel()
      {
         var _local_1:PetBagListItem = null;
         var _local_2:int = 0;
         _local_1 = null;
         super(UIManager.getSprite("PetBagMc"));
         this._followBtn = _mainUI["followBtn"];
         this._defaultBtn = _mainUI["defaultBtn"];
         this._storageBtn = _mainUI["storageBtn"];
         this._pictureBookBtn = _mainUI["pictureBookBtn"];
         this._cureBtn = _mainUI["cureBtn"];
         this._itemBtn = _mainUI["itemBtn"];
         addChild(_mainUI);
         this._followBtn.gotoAndStop(1);
         this._listCon = new Sprite();
         this._listCon.x = 30;
         this._listCon.y = 70;
         addChild(this._listCon);
         while(_local_2 < LIST_LENGTH)
         {
            _local_1 = new PetBagListItem();
            _local_1.y = (_local_1.height + 6) * int(_local_2 / 2);
            _local_1.x = (_local_1.width + 6) * (_local_2 % 2);
            this._listCon.addChild(_local_1);
            _local_2++;
         }
         this._infoMc = new PetDataPanel(_mainUI["infoMc"]);
         this._petPropsPanel = new PetPropsPanel(_mainUI["itemMC"]);
         var _local_3:SimpleButton = _mainUI["itemMC"]["closeBtn"];
         _local_3.addEventListener(MouseEvent.CLICK,this.showInfoPanel);
      }
      
      public function show() : void
      {
         this.showInfoPanel(null);
         _show();
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         PetManager.upDate();
      }
      
      override public function hide() : void
      {
         super.hide();
         this.openEvent();
         this._infoMc.hide();
         this._curretItem = null;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._infoMc = null;
         this._listCon = null;
         this._curretItem = null;
         this._followBtn = null;
         this._defaultBtn = null;
         this._storageBtn = null;
         this._pictureBookBtn = null;
         this._arrowMc = null;
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._followBtn.addEventListener(MouseEvent.CLICK,this.onFollow);
         this._defaultBtn.addEventListener(MouseEvent.CLICK,this.onDefault);
         this._storageBtn.addEventListener(MouseEvent.CLICK,this.onStorage);
         this._pictureBookBtn.addEventListener(MouseEvent.CLICK,this.onBook);
         this._cureBtn.addEventListener(MouseEvent.CLICK,this.onCure);
         this._itemBtn.addEventListener(MouseEvent.CLICK,this.onItemBag);
         PetManager.addEventListener(PetEvent.SET_DEFAULT,this.onUpDate);
         PetManager.addEventListener(PetEvent.UPDATE_INFO,this.onUpDate);
         PetManager.addEventListener(PetEvent.ADDED,this.onUpDate);
         PetManager.addEventListener(PetEvent.REMOVED,this.onUpDate);
         PetManager.addEventListener(PetEvent.CURE_ONE_COMPLETE,this.onUpDate);
         ToolTipManager.add(this._followBtn,"身边跟随");
         ToolTipManager.add(this._storageBtn,"放回仓库");
         ToolTipManager.add(this._pictureBookBtn,"精灵培养");
         ToolTipManager.add(this._cureBtn,"精灵恢复");
         ToolTipManager.add(this._itemBtn,"道具");
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._followBtn.removeEventListener(MouseEvent.CLICK,this.onFollow);
         this._defaultBtn.removeEventListener(MouseEvent.CLICK,this.onDefault);
         this._storageBtn.removeEventListener(MouseEvent.CLICK,this.onStorage);
         this._pictureBookBtn.removeEventListener(MouseEvent.CLICK,this.onBook);
         this._cureBtn.removeEventListener(MouseEvent.CLICK,this.onCure);
         this._itemBtn.removeEventListener(MouseEvent.CLICK,this.onItemBag);
         PetManager.removeEventListener(PetEvent.SET_DEFAULT,this.onUpDate);
         PetManager.removeEventListener(PetEvent.UPDATE_INFO,this.onUpDate);
         PetManager.removeEventListener(PetEvent.ADDED,this.onUpDate);
         PetManager.removeEventListener(PetEvent.REMOVED,this.onUpDate);
         PetManager.removeEventListener(PetEvent.CURE_ONE_COMPLETE,this.onUpDate);
         ToolTipManager.remove(this._followBtn);
         ToolTipManager.remove(this._storageBtn);
         ToolTipManager.remove(this._defaultBtn);
         ToolTipManager.remove(this._pictureBookBtn);
         ToolTipManager.remove(this._cureBtn);
         ToolTipManager.remove(this._itemBtn);
      }
      
      public function refreshItem() : void
      {
         var _local_1:PetBagListItem = null;
         var _local_2:PetInfo = null;
         var _local_3:PetBagListItem = null;
         var _local_4:int = 0;
         var _local_7:int = 0;
         while(_local_4 < LIST_LENGTH)
         {
            _local_1 = this._listCon.getChildAt(_local_4) as PetBagListItem;
            _local_1.mouseEnabled = false;
            _local_1.hide();
            _local_1.removeEventListener(MouseEvent.CLICK,this.onItemClick);
            _local_4++;
         }
         var _local_5:Array = PetManager.infos;
         _local_5.sortOn("isDefault",Array.DESCENDING);
         var _local_6:int = Math.min(LIST_LENGTH,PetManager.length);
         while(_local_7 < _local_6)
         {
            _local_2 = _local_5[_local_7] as PetInfo;
            _local_3 = this._listCon.getChildAt(_local_7) as PetBagListItem;
            _local_3.show(_local_2);
            _local_3.name = _local_2.id.toString();
            _local_3.mouseEnabled = true;
            _local_3.addEventListener(MouseEvent.CLICK,this.onItemClick);
            _local_7++;
         }
         if(_local_6 == 0)
         {
            this._followBtn.alpha = 0.4;
            this._followBtn.mouseEnabled = false;
            this._defaultBtn.alpha = 0.4;
            this._defaultBtn.mouseEnabled = false;
            this._storageBtn.alpha = 0.4;
            this._storageBtn.mouseEnabled = false;
            this._cureBtn.alpha = 0.4;
            this._cureBtn.mouseEnabled = false;
            this._itemBtn.alpha = 0.4;
            this._itemBtn.mouseEnabled = false;
            this._pictureBookBtn.alpha = 0.4;
            this._pictureBookBtn.mouseEnabled = false;
            this._infoMc.clearInfo();
            return;
         }
         this._followBtn.alpha = 1;
         this._followBtn.mouseEnabled = true;
         this._defaultBtn.alpha = 1;
         this._defaultBtn.mouseEnabled = true;
         this._storageBtn.alpha = 1;
         this._storageBtn.mouseEnabled = true;
         this._cureBtn.alpha = 1;
         this._cureBtn.mouseEnabled = true;
         this._itemBtn.alpha = 1;
         this._itemBtn.mouseEnabled = true;
         if(this._curretItem == null || this._curretItem.info == null)
         {
            this._curretItem = this._listCon.getChildAt(0) as PetBagListItem;
            this._curretItem.setDefault(true);
         }
         else
         {
            (this._listCon.getChildAt(0) as PetBagListItem).setDefault(true);
         }
         this.setSelect(this._curretItem);
      }
      
      private function setSelect(_arg_1:PetBagListItem) : void
      {
         if(Boolean(this._curretItem))
         {
            this._curretItem.isSelect = false;
         }
         if(_arg_1.info.catchTime == PetManager.defaultTime)
         {
            this._defaultBtn.alpha = 0.4;
            ToolTipManager.remove(this._defaultBtn);
            this._defaultBtn.removeEventListener(MouseEvent.CLICK,this.onDefault);
         }
         else
         {
            this._defaultBtn.alpha = 1;
            ToolTipManager.add(this._defaultBtn,"设为首选");
            this._defaultBtn.addEventListener(MouseEvent.CLICK,this.onDefault);
         }
         this._curretItem = _arg_1;
         this._curretItem.isSelect = true;
         this._pictureBookBtn.alpha = 1;
         this._pictureBookBtn.mouseEnabled = true;
         this._infoMc.show(this._curretItem.info);
         this._petPropsPanel.getPetInfo(this._curretItem.info);
         this.upDateBtnState();
      }
      
      private function upDateBtnState() : void
      {
         if(Boolean(PetManager.showInfo))
         {
            if(this._curretItem.info.catchTime == PetManager.showInfo.catchTime)
            {
               this._followBtn.gotoAndStop(2);
               ToolTipManager.add(this._followBtn,"放入包内");
            }
            else
            {
               this._followBtn.gotoAndStop(1);
               ToolTipManager.add(this._followBtn,"身边跟随");
            }
         }
         else
         {
            this._followBtn.gotoAndStop(1);
            ToolTipManager.add(this._followBtn,"身边跟随");
         }
      }
      
      private function onItemClick(_arg_1:MouseEvent) : void
      {
         var _local_2:PetBagListItem = _arg_1.currentTarget as PetBagListItem;
         this.setSelect(_local_2);
      }
      
      private function onFollow(_arg_1:MouseEvent) : void
      {
         if(PetManager.length == 0)
         {
            Alarm.show("你还没有赛尔精灵");
            return;
         }
         PetManager.showPet(this._curretItem.info.catchTime);
         if(this._followBtn.currentFrame == 1)
         {
            this._followBtn.gotoAndStop(2);
            ToolTipManager.add(this._followBtn,"放入包内");
            this.hide();
         }
         else
         {
            this._followBtn.gotoAndStop(1);
            ToolTipManager.add(this._followBtn,"身边跟随");
         }
      }
      
      private function onDefault(_arg_1:MouseEvent) : void
      {
         PetManager.setDefault(this._curretItem.info.catchTime);
      }
      
      private function onStorage(_arg_1:MouseEvent) : void
      {
         if(Boolean(this._curretItem))
         {
            if(this._followBtn.currentFrame != 1 && MainManager.actorModel.pet != null)
            {
               if(MainManager.actorModel.pet.info.catchTime == this._curretItem.info.catchTime)
               {
                  this.onFollow(new MouseEvent(MouseEvent.CLICK));
               }
            }
            PetManager.bagToInStorage(this._curretItem.info.catchTime);
         }
      }
      
      private function onBook(_arg_1:MouseEvent) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         var tt:PetInfo = this.curretItem.info;
         tt.name = PetXMLInfo.getName(this.curretItem.info.id);
         ExternalInterface.call("petinfo",MainManager.actorInfo.evpool,JSON.stringify(tt));
      }
      
      private function onUpdateProp(_arg_1:SocketEvent) : void
      {
         this.petUpdatePropCon.setup(_arg_1.data as PetUpdatePropInfo);
      }
      
      private function onItemBag(_arg_1:MouseEvent) : void
      {
         this._infoMc.hide();
         this._petPropsPanel = new PetPropsPanel(_mainUI["itemMC"]);
         this._petBagModel = new PetBagModel(this._petPropsPanel);
         (_mainUI["itemMC"] as MovieClip).visible = true;
         this.setSelect(this._curretItem);
      }
      
      private function showInfoPanel(_arg_1:MouseEvent) : void
      {
         (_mainUI["infoMc"] as MovieClip).visible = true;
         (_mainUI["itemMC"] as MovieClip).visible = false;
      }
      
      private function onCure(_arg_1:MouseEvent) : void
      {
         if(Boolean(this._curretItem))
         {
            PetManager.cure(this._curretItem.info.catchTime);
         }
      }
      
      private function onUpDate(_arg_1:PetEvent) : void
      {
         this.refreshItem();
      }
      
      public function closeEvent() : void
      {
         this._maskMc = new Sprite();
         this._maskMc.alpha = 0;
         this._maskMc.graphics.lineStyle(1,0);
         this._maskMc.graphics.beginFill(0);
         this._maskMc.graphics.drawRect(0,0,this.width,this.height);
         this._maskMc.graphics.endFill();
         this.addChild(this._maskMc);
         this.addChild(closeBtn);
         this._arrowMc = TaskIconManager.getIcon("Arrows_MC") as MovieClip;
         this.addChild(this._arrowMc);
         this._arrowMc.x = closeBtn.x;
         this._arrowMc.y = closeBtn.y + closeBtn.height + 5;
         MovieClip(this._arrowMc["mc"]).rotation = -180;
         MovieClip(this._arrowMc["mc"]).play();
      }
      
      public function openEvent() : void
      {
         if(Boolean(this._maskMc))
         {
            DisplayUtil.removeForParent(this._maskMc);
            this._maskMc = null;
         }
         if(Boolean(this._arrowMc))
         {
            DisplayUtil.removeForParent(this._arrowMc);
         }
      }
      
      public function get curretItem() : PetBagListItem
      {
         return this._curretItem;
      }
   }
}

