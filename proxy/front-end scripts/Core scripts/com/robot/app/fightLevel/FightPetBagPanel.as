package com.robot.app.fightLevel
{
   import com.robot.app.petbag.ui.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.uic.UIPanel;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class FightPetBagPanel extends UIPanel
   {
      
      private static const LIST_LENGTH:int = 6;
      
      private var _listCon:Sprite;
      
      private var _defaultBtn:SimpleButton;
      
      private var _cureBtn:SimpleButton;
      
      private var _infoMc:PetDataPanel;
      
      private var _listData:Array;
      
      private var _curretItem:PetBagListItem;
      
      public function FightPetBagPanel()
      {
         var _local_2:int = 0;
         var _local_1:PetBagListItem = null;
         super(UIManager.getSprite("PetBagMc"));
         this._defaultBtn = _mainUI["defaultBtn"];
         this._cureBtn = _mainUI["cureBtn"];
         _mainUI["itemBtn"].visible = false;
         _mainUI["followBtn"].visible = false;
         _mainUI["storageBtn"].visible = false;
         _mainUI["pictureBookBtn"].visible = false;
         _mainUI["itemMC"].visible = false;
         this._defaultBtn.x += 20;
         this._cureBtn.x -= 20;
         addChild(_mainUI);
         this._listCon = new Sprite();
         this._listCon.x = 30;
         this._listCon.y = 70;
         addChild(this._listCon);
         _local_2 = 0;
         while(_local_2 < LIST_LENGTH)
         {
            _local_1 = new PetBagListItem();
            _local_1.y = (_local_1.height + 6) * int(_local_2 / 2);
            _local_1.x = (_local_1.width + 6) * (_local_2 % 2);
            this._listCon.addChild(_local_1);
            _local_2++;
         }
         this._infoMc = new PetDataPanel(_mainUI["infoMc"]);
      }
      
      public function show() : void
      {
         _show();
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         PetManager.upDate();
      }
      
      override public function hide() : void
      {
         super.hide();
         this._infoMc.hide();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._infoMc = null;
         this._listCon = null;
         this._curretItem = null;
         this._defaultBtn = null;
         this._cureBtn = null;
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._defaultBtn.addEventListener(MouseEvent.CLICK,this.onDefault);
         this._cureBtn.addEventListener(MouseEvent.CLICK,this.onCure);
         PetManager.addEventListener(PetEvent.SET_DEFAULT,this.onUpDate);
         PetManager.addEventListener(PetEvent.UPDATE_INFO,this.onUpDate);
         PetManager.addEventListener(PetEvent.ADDED,this.onUpDate);
         PetManager.addEventListener(PetEvent.REMOVED,this.onUpDate);
         PetManager.addEventListener(PetEvent.CURE_ONE_COMPLETE,this.onUpDate);
         ToolTipManager.add(this._cureBtn,"精灵恢复");
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._defaultBtn.removeEventListener(MouseEvent.CLICK,this.onDefault);
         this._cureBtn.removeEventListener(MouseEvent.CLICK,this.onCure);
         PetManager.removeEventListener(PetEvent.SET_DEFAULT,this.onUpDate);
         PetManager.removeEventListener(PetEvent.UPDATE_INFO,this.onUpDate);
         PetManager.removeEventListener(PetEvent.ADDED,this.onUpDate);
         PetManager.removeEventListener(PetEvent.REMOVED,this.onUpDate);
         PetManager.removeEventListener(PetEvent.CURE_ONE_COMPLETE,this.onUpDate);
         ToolTipManager.remove(this._defaultBtn);
         ToolTipManager.remove(this._cureBtn);
      }
      
      private function refreshItem() : void
      {
         var _local_1:PetBagListItem = null;
         var _local_2:PetInfo = null;
         var _local_3:PetBagListItem = null;
         var _local_4:int = 0;
         var _local_7:int = 0;
         this._curretItem = null;
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
            this._defaultBtn.alpha = 0.4;
            this._defaultBtn.mouseEnabled = false;
            this._cureBtn.alpha = 0.4;
            this._cureBtn.mouseEnabled = false;
            return;
         }
         this._defaultBtn.alpha = 1;
         this._defaultBtn.mouseEnabled = true;
         this._cureBtn.alpha = 1;
         this._cureBtn.mouseEnabled = true;
         this._curretItem = this._listCon.getChildAt(0) as PetBagListItem;
         this._curretItem.setDefault(true);
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
         this._infoMc.show(this._curretItem.info);
      }
      
      private function onItemClick(_arg_1:MouseEvent) : void
      {
         var _local_2:PetBagListItem = _arg_1.currentTarget as PetBagListItem;
         this.setSelect(_local_2);
      }
      
      private function onDefault(_arg_1:MouseEvent) : void
      {
         PetManager.setDefault(this._curretItem.info.catchTime);
      }
      
      private function onCure(e:MouseEvent) : void
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
   }
}

