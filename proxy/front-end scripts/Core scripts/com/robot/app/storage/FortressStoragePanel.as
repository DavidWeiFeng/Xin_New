package com.robot.app.storage
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.uic.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import gs.*;
   import gs.easing.*;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class FortressStoragePanel extends Sprite
   {
      
      private static const MAX:int = 10;
      
      private static const TABID:Array = [7,8,9,1,4];
      
      private var _mainUI:Sprite;
      
      private var _listCon:Sprite;
      
      private var _closeBtn:SimpleButton;
      
      private var _dragBtn:SimpleButton;
      
      private var _dataList:Array;
      
      private var _dataLen:int;
      
      private var _isTween:Boolean = false;
      
      private var _pageBar:UIPageBar;
      
      private var _type:uint = 7;
      
      private var _currTab:MovieClip;
      
      public function FortressStoragePanel()
      {
         var _local_1:FortressStorageListItem = null;
         var _local_2:uint = 0;
         var _local_3:MovieClip = null;
         var _local_4:int = 0;
         var _local_5:int = 0;
         super();
         this._mainUI = UIManager.getSprite("UI_ForStorage_ToolBar");
         this._dragBtn = this._mainUI["dragBtn"];
         this._closeBtn = this._mainUI["closeBtn"];
         this._mainUI.mouseEnabled = false;
         addChild(this._mainUI);
         this._listCon = new Sprite();
         this._listCon.x = 62;
         this._listCon.y = 11;
         addChild(this._listCon);
         while(_local_4 < MAX)
         {
            _local_1 = new FortressStorageListItem();
            _local_1.x = (_local_1.width + 8) * _local_4;
            this._listCon.addChild(_local_1);
            _local_4++;
         }
         this._pageBar = new UIPageBar(this._mainUI["preBtn"],this._mainUI["nextBtn"],new TextField(),MAX);
         while(_local_5 < 5)
         {
            _local_2 = uint(TABID[_local_5]);
            _local_3 = this._mainUI.getChildByName("tab_" + _local_2.toString()) as MovieClip;
            _local_3.buttonMode = true;
            _local_3.mouseChildren = false;
            _local_3.gotoAndStop(1);
            _local_3.addEventListener(MouseEvent.CLICK,this.onTabClick);
            _local_3.typeID = _local_2;
            if(_local_5 == 0)
            {
               this._currTab = _local_3;
            }
            _local_5++;
         }
         this._currTab.gotoAndStop(2);
         this._currTab.mouseEnabled = false;
         DepthManager.bringToTop(this._currTab);
      }
      
      public function show() : void
      {
         if(this._isTween)
         {
            return;
         }
         y = MainManager.getStageHeight();
         x = (MainManager.getStageWidth() - width) / 2;
         alpha = 1;
         LevelManager.appLevel.addChild(this);
         TweenLite.to(this,0.6,{
            "y":MainManager.getStageHeight() - height + 28,
            "ease":Expo.easeOut
         });
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         this._pageBar.addEventListener(MouseEvent.CLICK,this.onProPage);
         ArmManager.addEventListener(ArmEvent.ADD_TO_STORAGE,this.onUnUsedFitment);
         ArmManager.addEventListener(ArmEvent.REMOVE_TO_STORAGE,this.onUnUsedFitment);
         ArmManager.addEventListener(ArmEvent.ALL_LIST,this.onUnUsedFitment);
         ArmManager.addEventListener(ArmEvent.UP_ALL_LIST,this.onUnUsedFitment);
         this.reItem();
      }
      
      public function hide() : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         this._dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         this._pageBar.removeEventListener(MouseEvent.CLICK,this.onProPage);
         ArmManager.removeEventListener(ArmEvent.ADD_TO_STORAGE,this.onUnUsedFitment);
         ArmManager.removeEventListener(ArmEvent.REMOVE_TO_STORAGE,this.onUnUsedFitment);
         ArmManager.removeEventListener(ArmEvent.ALL_LIST,this.onUnUsedFitment);
         ArmManager.removeEventListener(ArmEvent.UP_ALL_LIST,this.onUnUsedFitment);
         TweenLite.to(this,0.6,{
            "alpha":0,
            "onComplete":this.onFinishTween
         });
         this._isTween = true;
      }
      
      public function destroy() : void
      {
         this.hide();
         this._pageBar.destroy();
         this._pageBar = null;
         this._dataList = null;
         this._listCon = null;
         this._dragBtn = null;
         this._closeBtn = null;
         this._mainUI = null;
      }
      
      public function reItem() : void
      {
         var _local_1:FortressStorageListItem = null;
         var _local_3:int = 0;
         this._dataList = ArmManager.getUnUsedListForType(this._type);
         this._dataLen = this._dataList.length;
         this.clearItem();
         if(this._dataLen == 0)
         {
            return;
         }
         this._pageBar.totalLength = this._dataLen;
         var _local_2:int = Math.min(MAX,this._dataLen);
         while(_local_3 < _local_2)
         {
            _local_1 = this._listCon.getChildAt(_local_3) as FortressStorageListItem;
            _local_1.info = this._dataList[_local_3 + this._pageBar.index];
            _local_1.addEventListener(MouseEvent.MOUSE_DOWN,this.onItemDown);
            _local_3++;
         }
      }
      
      private function clearItem() : void
      {
         var _local_1:FortressStorageListItem = null;
         var _local_3:int = 0;
         var _local_2:int = this._listCon.numChildren;
         while(_local_3 < _local_2)
         {
            _local_1 = this._listCon.getChildAt(_local_3) as FortressStorageListItem;
            _local_1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onItemDown);
            _local_1.destroy();
            _local_3++;
         }
      }
      
      private function onProPage(_arg_1:DynamicEvent) : void
      {
         var _local_2:FortressStorageListItem = null;
         var _local_5:int = 0;
         this.clearItem();
         var _local_3:uint = _arg_1.paramObject as uint;
         var _local_4:int = Math.min(MAX,this._pageBar.totalLength - this._pageBar.index * MAX);
         while(_local_5 < _local_4)
         {
            _local_2 = this._listCon.getChildAt(_local_5) as FortressStorageListItem;
            _local_2.destroy();
            _local_2.info = this._dataList[_local_5 + this._pageBar.index * MAX];
            _local_2.addEventListener(MouseEvent.MOUSE_DOWN,this.onItemDown);
            _local_5++;
         }
      }
      
      private function onFinishTween() : void
      {
         this._isTween = false;
         DisplayUtil.removeForParent(this);
      }
      
      private function onClose(_arg_1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function onDragDown(_arg_1:MouseEvent) : void
      {
         startDrag();
      }
      
      private function onDragUp(_arg_1:MouseEvent) : void
      {
         stopDrag();
      }
      
      private function onItemDown(_arg_1:MouseEvent) : void
      {
         var _local_2:Point = null;
         var _local_3:BitmapData = null;
         if(!ArmManager.dragInMapEnabled)
         {
            Alarm.show("当前战队等级最多只能摆放" + ArmManager.getMax() + "个可升级设施");
            return;
         }
         var _local_4:FortressStorageListItem = _arg_1.currentTarget as FortressStorageListItem;
         if(_local_4.info.type == SolidType.FRAME)
         {
            return;
         }
         var _local_5:Sprite = _local_4.obj as Sprite;
         if(Boolean(_local_5))
         {
            if(_local_4.info.unUsedCount > 1)
            {
               _local_2 = _local_5.localToGlobal(new Point());
               _local_3 = new BitmapData(_local_5.width,_local_5.height,true,0);
               _local_3.draw(_local_5);
               _local_5 = new Sprite();
               _local_5.addChild(new Bitmap(_local_3));
               _local_5.x = _local_2.x;
               _local_5.y = _local_2.y;
            }
            ArmManager.doDrag(_local_5,_local_4.info,_local_4,DragTargetType.STORAGE);
         }
      }
      
      private function onUnUsedFitment(_arg_1:ArmEvent) : void
      {
         this.reItem();
      }
      
      private function onTabClick(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = _arg_1.currentTarget as MovieClip;
         this._type = _local_2.typeID;
         this._currTab.gotoAndStop(1);
         DepthManager.bringToBottom(this._currTab);
         this._currTab.mouseEnabled = true;
         this._currTab = _local_2;
         this._currTab.gotoAndStop(2);
         DepthManager.bringToTop(this._currTab);
         this._currTab.mouseEnabled = false;
         this._pageBar.index = 0;
         this.reItem();
      }
   }
}

