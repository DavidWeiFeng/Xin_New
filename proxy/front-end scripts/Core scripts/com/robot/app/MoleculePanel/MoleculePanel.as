package com.robot.app.MoleculePanel
{
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.userItem.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.uic.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.*;
   import org.taomee.events.DynamicEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MoleculePanel extends Sprite
   {
      
      private var _proBar:UIProPageBar;
      
      private var _dragBtn:SimpleButton;
      
      private var _closeBtn:SimpleButton;
      
      private var _mleList:Array;
      
      private var _nameTxt:TextField;
      
      private var _needA:Array = [400101,400102,400103,400104,400105,400106,400107,400108,400109,400110,400111,400112,400113,400114,400115,400116,400117,400118,400119,400120,400121,400122,400123,400124,400125,400126,400551];
      
      private var _applyBtn:SimpleButton;
      
      private var _mainUI:Sprite;
      
      private var _currUI:Sprite;
      
      private var _currID:uint;
      
      private var PATH:String = "module/com/robot/module/app/MoleculePanel.swf";
      
      public var app:ApplicationDomain;
      
      public function MoleculePanel()
      {
         super();
      }
      
      public function hide() : void
      {
         ResourceManager.cancel(ClientConfig.getResPath("item/doodle/icon/" + this._currID.toString() + ".swf"),this.onResLoad);
         this._currID = 0;
         if(Boolean(this._currUI))
         {
            DisplayUtil.removeForParent(this._currUI);
            this._currUI = null;
         }
         this.removeEvent();
         DisplayUtil.removeForParent(this._mainUI);
      }
      
      private function onResLoad(_arg_1:DisplayObject) : void
      {
         this._currUI = _arg_1 as Sprite;
         this._currUI.x = 120;
         this._currUI.y = 120;
         this._mainUI.addChild(this._currUI);
      }
      
      private function check(_arg_1:uint) : Boolean
      {
         var _local_2:int = 0;
         while(_local_2 < this._needA.length)
         {
            if(_arg_1 == this._needA[_local_2])
            {
               return true;
            }
            _local_2++;
         }
         return false;
      }
      
      private function onApply(e:MouseEvent) : void
      {
         if(this._currID == 0)
         {
            return;
         }
         SocketConnection.addCmdListener(CommandID.PET_HATCH,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.PET_HATCH,arguments.callee);
            Alarm.show("精元开始孵化,一天后可以领取精灵");
            hide();
         });
         SocketConnection.send(CommandID.PET_HATCH,this._currID);
      }
      
      public function init(_arg_1:Object = null) : void
      {
      }
      
      public function setup(_arg_1:MCLoadEvent) : void
      {
         this.app = _arg_1.getApplicationDomain();
         this._mainUI = new (this.app.getDefinition("UI_MoleculePanel") as Class)() as Sprite;
         this._closeBtn = this._mainUI["closeBtn"];
         this._dragBtn = this._mainUI["dragBtn"];
         this._applyBtn = this._mainUI["applyBtn"];
         this._nameTxt = this._mainUI["nameTxt"];
         this._proBar = new UIProPageBar(this._mainUI["preBtn"],this._mainUI["nextBtn"],1);
         LevelManager.appLevel.addChild(this._mainUI);
         DisplayUtil.align(this._mainUI,null,AlignType.MIDDLE_CENTER);
         this.addEvent();
         this._mleList = [];
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,this.onCollectionList);
         SocketConnection.send(CommandID.ITEM_LIST,this._needA[0],this._needA[this._needA.length - 1] + 1,2);
      }
      
      private function onCollectionList(_arg_1:SocketEvent) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_3:int = 0;
         var _local_6:int = 0;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,this.onCollectionList);
         var _local_4:ByteArray = _arg_1.data as ByteArray;
         var _local_5:uint = _local_4.readUnsignedInt();
         while(_local_6 < _local_5)
         {
            _local_2 = new SingleItemInfo(_local_4);
            if(this.check(_local_2.itemID))
            {
               _local_3 = 0;
               while(_local_3 < _local_2.itemNum)
               {
                  this._mleList.push(_local_2.itemID);
                  _local_3++;
               }
            }
            _local_6++;
         }
         this._proBar.totalLength = this._mleList.length;
         if(this._mleList.length == 0)
         {
            return;
         }
         this._currID = this._mleList[0];
         if(this._currID == 0)
         {
            return;
         }
         this._nameTxt.text = ItemXMLInfo.getName(this._currID);
         ResourceManager.getResource(ClientConfig.getResPath("item/doodle/icon/" + this._currID.toString() + ".swf"),this.onResLoad);
      }
      
      private function onClose(_arg_1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function onClick(_arg_1:DynamicEvent) : void
      {
         if(this._currID != 0)
         {
            ResourceManager.cancel(ClientConfig.getResPath("item/doodle/icon/" + this._currID.toString() + ".swf"),this.onResLoad);
         }
         if(Boolean(this._currUI))
         {
            DisplayUtil.removeForParent(this._currUI);
            this._currUI = null;
         }
         this._currID = this._mleList[_arg_1.paramObject as int];
         if(this._currID != 0)
         {
            this._nameTxt.text = ItemXMLInfo.getName(this._currID);
            ResourceManager.getResource(ClientConfig.getResPath("item/doodle/icon/" + this._currID.toString() + ".swf"),this.onResLoad);
         }
      }
      
      private function onDragUp(_arg_1:MouseEvent) : void
      {
         this._mainUI.stopDrag();
      }
      
      private function onDragDown(_arg_1:MouseEvent) : void
      {
         DepthManager.bringToTop(this._mainUI);
         this._mainUI.startDrag();
      }
      
      private function removeEvent() : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         this._dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         this._proBar.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._applyBtn.removeEventListener(MouseEvent.CLICK,this.onApply);
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,this.onCollectionList);
      }
      
      private function addEvent() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         this._proBar.addEventListener(MouseEvent.CLICK,this.onClick);
         this._applyBtn.addEventListener(MouseEvent.CLICK,this.onApply);
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mleList = null;
         this._proBar.destroy();
         this._proBar = null;
         this._closeBtn = null;
         this._dragBtn = null;
         this._mainUI = null;
         this._currUI = null;
      }
      
      public function show() : void
      {
         var _local_1:MCLoader = null;
         if(!this._mainUI)
         {
            _local_1 = new MCLoader(this.PATH,this,1,"正在打开分子转化仪面板");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,this.setup);
            _local_1.doLoad();
         }
         else
         {
            LevelManager.appLevel.addChild(this._mainUI);
            DisplayUtil.align(this._mainUI,null,AlignType.MIDDLE_CENTER);
            this.addEvent();
            this._mleList = [];
            SocketConnection.addCmdListener(CommandID.ITEM_LIST,this.onCollectionList);
            SocketConnection.send(CommandID.ITEM_LIST,this._needA[0],this._needA[this._needA.length - 1],2);
         }
      }
   }
}

