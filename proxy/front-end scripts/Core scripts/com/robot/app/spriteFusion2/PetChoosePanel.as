package com.robot.app.spriteFusion2
{
   import com.robot.app.petbag.ui.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.effect.*;
   import org.taomee.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class PetChoosePanel extends Sprite
   {
      
      public static const MAIN_PET_CHOOSE:String = "Main_Pet_Choose";
      
      public static const SUB_PET_CHOOSE:String = "Sub_Pet_Choose";
      
      private static const LIST_LENGTH:int = 6;
      
      private var _listCon:Sprite;
      
      private var _chooseBtn:SimpleButton;
      
      private var _dragBtn:SimpleButton;
      
      private var _isMaster:Boolean = false;
      
      private var _chosPetIDArr:Array = [];
      
      private var _closeBtn:SimpleButton;
      
      private var _mainUI:Sprite;
      
      private var _curretItem:PetBagListItem;
      
      private var _app:ApplicationDomain;
      
      public function PetChoosePanel(_arg_1:ApplicationDomain)
      {
         super();
         this._app = _arg_1;
         this.setup();
      }
      
      public function hide() : void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this);
      }
      
      public function setup() : void
      {
         var _local_1:PetBagListItem = null;
         var _local_2:int = 0;
         this._mainUI = new (this._app.getDefinition("PetChoose_Panel") as Class)() as Sprite;
         this._chooseBtn = this._mainUI["chooseBtn"];
         this._closeBtn = this._mainUI["closeBtn"];
         this._dragBtn = this._mainUI["dragBtn"];
         addChild(this._mainUI);
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
      }
      
      public function init(_arg_1:Object = null) : void
      {
      }
      
      private function onClose(_arg_1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function hasChosPet(_arg_1:DynamicEvent) : void
      {
         this._chosPetIDArr = _arg_1.paramObject as Array;
         this.reItem();
      }
      
      private function unEableChoose(_arg_1:PetBagListItem) : void
      {
         _arg_1.filters = [ColorFilter.setGrayscale()];
         _arg_1.mouseEnabled = false;
         _arg_1.buttonMode = false;
         _arg_1.removeEventListener(MouseEvent.CLICK,this.onItemClick);
      }
      
      private function onItemClick(_arg_1:MouseEvent) : void
      {
         if(Boolean(this._curretItem))
         {
            this._curretItem.isSelect = false;
            this._curretItem = null;
         }
         this._curretItem = _arg_1.currentTarget as PetBagListItem;
         this._curretItem.isSelect = true;
      }
      
      private function onUpDate(_arg_1:PetEvent) : void
      {
         this.reItem();
      }
      
      private function onChoosePet(_arg_1:MouseEvent) : void
      {
         if(this._curretItem == null)
         {
            Alarm.show("请选择你的精灵噢!");
            return;
         }
         EventManager.dispatchEvent(new DynamicEvent(this._isMaster ? MAIN_PET_CHOOSE : SUB_PET_CHOOSE,this._curretItem.info));
         this.hide();
      }
      
      private function reItem() : void
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
         var _local_6:int = Math.min(LIST_LENGTH,_local_5.length);
         while(_local_7 < _local_6)
         {
            _local_2 = _local_5[_local_7] as PetInfo;
            _local_3 = this._listCon.getChildAt(_local_7) as PetBagListItem;
            _local_3.show(_local_2);
            _local_3.name = _local_2.id.toString();
            _local_3.filters = [];
            _local_3.buttonMode = true;
            _local_3.mouseEnabled = true;
            _local_3.addEventListener(MouseEvent.CLICK,this.onItemClick);
            if(this._isMaster)
            {
               if(!PetXMLInfo.isLarge(_local_3.info.id))
               {
                  this.unEableChoose(_local_3);
               }
            }
            else if(this._chosPetIDArr[0] != null && PetXMLInfo.getPetClass(_local_3.info.id) != PetXMLInfo.getPetClass((this._chosPetIDArr[0] as PetInfo).id) && PetXMLInfo.getPetClass(_local_3.info.id) != 29)
            {
               this.unEableChoose(_local_3);
            }
            else if(this._chosPetIDArr[0] == null)
            {
               this.unEableChoose(_local_3);
            }
            if(this._chosPetIDArr[0] != null && _local_3.info.catchTime == (this._chosPetIDArr[0] as PetInfo).catchTime)
            {
               this.unEableChoose(_local_3);
            }
            else if(this._chosPetIDArr[1] != null && _local_3.info.catchTime == (this._chosPetIDArr[1] as PetInfo).catchTime)
            {
               this.unEableChoose(_local_3);
            }
            _local_7++;
         }
      }
      
      private function onDragUp(_arg_1:MouseEvent) : void
      {
         stopDrag();
      }
      
      private function onDragDown(_arg_1:MouseEvent) : void
      {
         startDrag();
      }
      
      private function removeEvent() : void
      {
         this._chooseBtn.removeEventListener(MouseEvent.CLICK,this.onChoosePet);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         this._dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         PetManager.removeEventListener(PetEvent.UPDATE_INFO,this.onUpDate);
      }
      
      private function addEvent() : void
      {
         this._chooseBtn.addEventListener(MouseEvent.CLICK,this.onChoosePet);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         PetManager.addEventListener(PetEvent.UPDATE_INFO,this.onUpDate);
      }
      
      public function destroy() : void
      {
         this.hide();
         this._listCon = null;
         this._chooseBtn = null;
         this._mainUI = null;
         this._curretItem = null;
         this._dragBtn = null;
         this._closeBtn = null;
      }
      
      public function show(_arg_1:Boolean) : void
      {
         this._isMaster = _arg_1;
         LevelManager.appLevel.addChild(this);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         this.addEvent();
         PetManager.upDate();
      }
   }
}

