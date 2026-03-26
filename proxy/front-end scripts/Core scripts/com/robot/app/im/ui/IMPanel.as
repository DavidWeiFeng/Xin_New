package com.robot.app.im.ui
{
   import com.robot.app.im.ui.tab.*;
   import com.robot.app.popup.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.uic.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.TextField;
   import org.taomee.ds.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class IMPanel extends UIPanel
   {
      
      private static const LIST_LENGTH:int = 8;
      
      private var _titleMc:MovieClip;
      
      private var _txt:TextField;
      
      private var _addBtn:SimpleButton;
      
      private var _delBtn:SimpleButton;
      
      private var _allowBtn:SimpleButton;
      
      private var _tabFriend:MovieClip;
      
      private var _tabBlack:MovieClip;
      
      private var _tabNewly:MovieClip;
      
      private var _tabOnline:MovieClip;
      
      private var _tabList:HashMap;
      
      private var _currentTab:IIMTab;
      
      private var _listCon:Sprite;
      
      private var _listData:Array;
      
      private var _scrollBar:UIScrollBar;
      
      public function IMPanel()
      {
         var _local_1:IMListItem = null;
         var _local_3:int = 0;
         this._listData = [];
         super(UIManager.getSprite("IMMC"));
         this._titleMc = _mainUI["titleMc"];
         this._txt = _mainUI["txt"];
         this._addBtn = _mainUI["addBtn"];
         this._delBtn = _mainUI["delBtn"];
         this._allowBtn = _mainUI["allowBtn"];
         var _local_2:Sprite = _mainUI["tabPanel"];
         this._tabFriend = _local_2["tabFriend"];
         this._tabOnline = _local_2["tabOnline"];
         this._tabBlack = _local_2["tabBlack"];
         this._titleMc.mouseEnabled = false;
         this._txt.mouseEnabled = false;
         this._allowBtn.visible = false;
         this._scrollBar = new UIScrollBar(_mainUI["barBall"],_mainUI["barBg"],LIST_LENGTH,_mainUI["upBtn"],_mainUI["downBtn"]);
         this._scrollBar.wheelObject = this;
         this._listCon = new Sprite();
         this._listCon.x = 35;
         this._listCon.y = 105;
         _mainUI.addChild(this._listCon);
         while(_local_3 < LIST_LENGTH)
         {
            _local_1 = new IMListItem();
            _local_1.y = (_local_1.height + 4) * _local_3;
            this._listCon.addChild(_local_1);
            _local_3++;
         }
         this._tabList = new HashMap();
         this._tabList.add(this._tabFriend,new TabFriend(1,this._tabFriend,this._listCon,this.refreshItem));
         this._tabList.add(this._tabOnline,new TabOnline(3,this._tabOnline,this._listCon,this.refreshItem));
         this._tabList.add(this._tabBlack,new TabBlack(4,this._tabBlack,this._listCon,this.refreshItem));
         this._currentTab = this._tabList.getValue(this._tabFriend);
         this._titleMc.gotoAndStop(this._currentTab.index);
      }
      
      public function show() : void
      {
         _show();
         LevelManager.appLevel.addChild(this);
         DisplayUtil.align(this,null,AlignType.MIDDLE_RIGHT,new Point(-10,0));
         this._currentTab.show();
      }
      
      override public function hide() : void
      {
         super.hide();
         this._currentTab.hide();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._titleMc = null;
         this._txt = null;
         this._addBtn = null;
         this._delBtn = null;
         this._listCon = null;
         this._listData = null;
         this._tabList = null;
         this._currentTab = null;
         this._scrollBar.destroy();
         this._scrollBar = null;
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._addBtn.addEventListener(MouseEvent.CLICK,this.onAddFriend);
         this._delBtn.addEventListener(MouseEvent.CLICK,this.onDelFriend);
         this._scrollBar.addEventListener(MouseEvent.MOUSE_MOVE,this.onScrollMove);
         this._tabFriend.addEventListener(MouseEvent.CLICK,this.onTabClick);
         this._tabBlack.addEventListener(MouseEvent.CLICK,this.onTabClick);
         this._tabOnline.addEventListener(MouseEvent.CLICK,this.onTabClick);
         ToolTipManager.add(this._addBtn,"寻找好友");
         ToolTipManager.add(this._delBtn,"禁加好友");
         ToolTipManager.add(this._tabFriend,"我的好友");
         ToolTipManager.add(this._tabBlack,"黑名单");
         ToolTipManager.add(this._tabOnline,"在线列表");
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.onAddFriend);
         this._delBtn.removeEventListener(MouseEvent.CLICK,this.onDelFriend);
         this._scrollBar.removeEventListener(MouseEvent.MOUSE_MOVE,this.onScrollMove);
         this._tabFriend.removeEventListener(MouseEvent.CLICK,this.onTabClick);
         this._tabBlack.removeEventListener(MouseEvent.CLICK,this.onTabClick);
         this._tabOnline.removeEventListener(MouseEvent.CLICK,this.onTabClick);
         ToolTipManager.remove(this._addBtn);
         ToolTipManager.remove(this._delBtn);
         ToolTipManager.remove(this._tabFriend);
         ToolTipManager.remove(this._tabBlack);
         ToolTipManager.remove(this._tabOnline);
      }
      
      private function refreshItem(_arg_1:Array, _arg_2:int) : void
      {
         var _local_3:IMListItem = null;
         var _local_4:UserInfo = null;
         var _local_5:IMListItem = null;
         var _local_6:int = 0;
         var _local_9:int = 0;
         while(_local_6 < LIST_LENGTH)
         {
            _local_3 = this._listCon.getChildAt(_local_6) as IMListItem;
            _local_3.mouseChildren = false;
            _local_3.mouseEnabled = false;
            _local_3.clear();
            _local_6++;
         }
         var _local_7:int = int(_arg_1.length);
         this._listData = _arg_1;
         this._scrollBar.totalLength = _local_7;
         this._txt.text = "(" + _local_7.toString() + "/" + _arg_2.toString() + ")";
         var _local_8:int = Math.min(LIST_LENGTH,_local_7);
         while(_local_9 < _local_8)
         {
            _local_4 = this._listData[_local_9 + this._scrollBar.index] as UserInfo;
            _local_5 = this._listCon.getChildAt(_local_9) as IMListItem;
            _local_5.info = _local_4;
            _local_5.mouseChildren = true;
            _local_5.mouseEnabled = true;
            _local_9++;
         }
      }
      
      private function onTabClick(_arg_1:MouseEvent) : void
      {
         this._currentTab.hide();
         this._currentTab = this._tabList.getValue(_arg_1.currentTarget);
         this._currentTab.show();
         this._titleMc.gotoAndStop(this._currentTab.index);
      }
      
      private function onScrollMove(_arg_1:MouseEvent) : void
      {
         var _local_2:UserInfo = null;
         var _local_3:IMListItem = null;
         var _local_4:int = 0;
         while(_local_4 < LIST_LENGTH)
         {
            _local_2 = this._listData[_local_4 + this._scrollBar.index] as UserInfo;
            _local_3 = this._listCon.getChildAt(_local_4) as IMListItem;
            _local_3.clear();
            _local_3.info = _local_2;
            _local_4++;
         }
      }
      
      private function onAddFriend(_arg_1:MouseEvent) : void
      {
         AddFriendPanel.show();
      }
      
      private function onDelFriend(_arg_1:MouseEvent) : void
      {
      }
   }
}

