package com.robot.app.ItemMixture
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.userItem.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.ui.itemTip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.system.ApplicationDomain;
   import flash.text.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ItemMixturePanel extends Sprite
   {
      
      private const _resetMixture:String = "RESET_MIXTURE";
      
      private var PATH:String = "module/com/robot/module/app/ItemMixturePanel.swf";
      
      private var app:ApplicationDomain;
      
      private var _mainUI:MovieClip;
      
      private var _closeBtn:SimpleButton;
      
      private var _totalPage:uint;
      
      private var _page:int = 1;
      
      private var _len:uint = 16;
      
      private var _costArray:Array = [100,500,1000,2000];
      
      private var _itemInfoArr:HashMap = new HashMap();
      
      private var _mixtureItemListHashMap:HashMap = new HashMap();
      
      private var _mixtureItemSeqHashMap:HashMap = new HashMap();
      
      private var _glow:GlowFilter = new GlowFilter(16737792,1,4,4,10);
      
      private var _preBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _addBtn:SimpleButton;
      
      private var _mixtureBtn:SimpleButton;
      
      private var _resetBtn:SimpleButton;
      
      private var _priceTxt:TextField;
      
      private var _numTxt:TextField;
      
      private var _currentChip:String = "";
      
      private var _currentItemInfo:SingleItemInfo;
      
      private var _currentPageData:Array;
      
      private var isAddingItem:Boolean = false;
      
      public function ItemMixturePanel()
      {
         super();
      }
      
      public function setup(event:MCLoadEvent) : void
      {
         var _chipMc:SimpleButton = null;
         var _prMc:MovieClip = null;
         var index:int = 0;
         var _prMcIndex:int = 0;
         this.app = event.getApplicationDomain();
         this._mainUI = new (this.app.getDefinition("item") as Class)() as MovieClip;
         addChild(this._mainUI);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(this);
         this._preBtn = this._mainUI["preBtn"];
         this._nextBtn = this._mainUI["nextBtn"];
         this._preBtn.visible = this._nextBtn.visible = false;
         this._preBtn.addEventListener(MouseEvent.CLICK,this.onPre);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.onNext);
         while(index < 4)
         {
            _chipMc = this._mainUI["chipMc" + index];
            ToolTipManager.add(_chipMc,index + 1 + "号芯片");
            _chipMc.addEventListener(MouseEvent.CLICK,this.onClickChip);
            index += 1;
         }
         while(_prMcIndex < 16)
         {
            _prMc = this._mainUI["_pr" + _prMcIndex];
            (_prMc["txt"] as TextField).text = "";
            _prMcIndex += 1;
         }
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.addItem);
         ItemManager.getCollection();
         this._closeBtn = this._mainUI["close"];
         this._mixtureBtn = this._mainUI["mixtureBtn"];
         this._addBtn = this._mainUI["addBtn"];
         this._resetBtn = this._mainUI["resetBtn"];
         this._priceTxt = this._mainUI["priceTxt"];
         this._numTxt = this._mainUI["NumTxt"];
         this._numTxt.restrict = "0-9";
         this._numTxt.maxChars = 6;
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this._resetBtn.addEventListener(MouseEvent.CLICK,function():void
         {
            reset();
         });
         this._addBtn.addEventListener(MouseEvent.CLICK,this.addSelectedItem);
      }
      
      private function onClickChip(_arg_1:MouseEvent) : void
      {
         var _local_3:SimpleButton = null;
         var _local_2:int = 0;
         while(_local_2 < 4)
         {
            _local_3 = this._mainUI["chipMc" + _local_2];
            if(_local_3.name == (_arg_1.currentTarget as SimpleButton).name)
            {
               this._currentChip = _local_3.name;
               _local_3.filters = [this._glow];
               this._priceTxt.text = this._costArray[_local_2];
            }
            else
            {
               _local_3.filters = [];
            }
            _local_2++;
         }
      }
      
      private function addSelectedItem(e:MouseEvent) : void
      {
         var num:int = 0;
         var bg:MovieClip = null;
         var _info:SingleItemInfo = null;
         var onLoadIcon:Function = null;
         if(this.isAddingItem)
         {
            Alarm.show("点击过快！");
            return;
         }
         if(!this._currentItemInfo || int(this._numTxt.text) < 1)
         {
            Alarm.show("请选择要放入的材料，并设置放入材料数量！");
            return;
         }
         if(this._mixtureItemListHashMap.length >= 6 && !this._mixtureItemListHashMap.containsKey(this._currentItemInfo.itemID))
         {
            Alarm.show("超过可放入材料的种类上限！");
            return;
         }
         if(this._currentItemInfo.itemNum == 0)
         {
            Alarm.show("选择的材料已达最大可选择数量！");
            return;
         }
         this.isAddingItem = true;
         if(this._mixtureItemListHashMap.containsKey(this._currentItemInfo.itemID))
         {
            if(int(this._numTxt.text) > int(this._currentItemInfo.itemNum))
            {
               this._numTxt.text = String((this._itemInfoArr.getValue(this._currentItemInfo.itemID) as SingleItemInfo).itemNum);
            }
            (this._itemInfoArr.getValue(this._currentItemInfo.itemID) as SingleItemInfo).itemNum = (this._itemInfoArr.getValue(this._currentItemInfo.itemID) as SingleItemInfo).itemNum - int(this._numTxt.text);
            this.changeItemNum();
            this._mixtureItemListHashMap.add(this._currentItemInfo.itemID,this._mixtureItemListHashMap.getValue(this._currentItemInfo.itemID) + int(this._numTxt.text));
            (this._mainUI["Mc" + this._mixtureItemSeqHashMap.getValue(this._currentItemInfo.itemID) + "_Txt"] as TextField).text = this._mixtureItemListHashMap.getValue(this._currentItemInfo.itemID);
         }
         else
         {
            num = this._mixtureItemListHashMap.length;
            if(int(this._numTxt.text) > int(this._currentItemInfo.itemNum))
            {
               this._numTxt.text = String(this._currentItemInfo.itemNum);
            }
            (this._itemInfoArr.getValue(this._currentItemInfo.itemID) as SingleItemInfo).itemNum = (this._itemInfoArr.getValue(this._currentItemInfo.itemID) as SingleItemInfo).itemNum - int(this._numTxt.text);
            this.changeItemNum();
            this._mixtureItemListHashMap.add(this._currentItemInfo.itemID,int(this._numTxt.text));
            this._mixtureItemSeqHashMap.add(this._currentItemInfo.itemID,num);
            (this._mainUI["Mc" + num + "_Txt"] as TextField).text = this._numTxt.text;
            bg = this._mainUI["Mc" + num]["bg"] as MovieClip;
            _info = this._currentItemInfo;
            onLoadIcon = function(o:DisplayObject):void
            {
               bg.addChild(o);
               o.addEventListener(MouseEvent.ROLL_OVER,function():void
               {
                  ItemInfoTip.show(_info);
               });
               o.addEventListener(MouseEvent.ROLL_OUT,function():void
               {
                  ItemInfoTip.hide();
               });
            };
            ResourceManager.getResource(ItemXMLInfo.getIconURL(this._currentItemInfo.itemID),onLoadIcon);
         }
         this.isAddingItem = false;
      }
      
      private function checkItemNum() : Boolean
      {
         var _local_1:int = 0;
         for each(_local_1 in this._mixtureItemListHashMap.getKeys())
         {
            if(this._mixtureItemListHashMap.getValue(_local_1) > this._itemInfoArr.getValue(_local_1))
            {
               return false;
            }
         }
         return true;
      }
      
      private function changeItemNum(_arg_1:uint = 0) : void
      {
         var _local_3:SingleItemInfo = null;
         var _local_2:int = 0;
         _arg_1 = _arg_1 != 0 ? _arg_1 : this._currentItemInfo.itemID;
         for each(_local_3 in this._currentPageData)
         {
            if(_local_3.itemID == _arg_1)
            {
               _local_3.itemNum = (this._itemInfoArr.getValue(_local_3.itemID) as SingleItemInfo).itemNum;
               (this._mainUI["_pr" + _local_2]["txt"] as TextField).text = String(_local_3.itemNum);
               break;
            }
            _local_2++;
         }
      }
      
      private function reset() : void
      {
         var _local_3:MovieClip = null;
         var _local_1:int = 0;
         var _local_2:int = 0;
         this._mixtureItemListHashMap.clear();
         this._mixtureItemSeqHashMap.clear();
         this._itemInfoArr.clear();
         this._mixtureBtn.mouseEnabled = true;
         this._currentItemInfo = null;
         this._currentChip = this._numTxt.text = "";
         while(_local_1 < 4)
         {
            this._mainUI["chipMc" + _local_1].filters = [];
            _local_1++;
         }
         while(_local_2 < 6)
         {
            _local_3 = this._mainUI["Mc" + _local_2];
            (this._mainUI["Mc" + _local_2 + "_Txt"] as TextField).text = "";
            while((_local_3["bg"] as MovieClip).numChildren > 0)
            {
               (_local_3["bg"] as MovieClip).removeChildAt(0);
            }
            _local_2++;
         }
         this.resetItemIcon();
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.addItem);
         ItemManager.getCollection();
      }
      
      private function addItem(_arg_1:ItemEvent) : void
      {
         var _local_2:SingleItemInfo = null;
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.addItem);
         var _local_3:Array = ItemManager.getCollectionInfos();
         for each(_local_2 in _local_3)
         {
            if(_local_2.itemID >= 400001 && _local_2.itemID <= 400049)
            {
               this._itemInfoArr.add(_local_2.itemID,_local_2);
            }
         }
         if(this._itemInfoArr.length > this._len)
         {
            this._nextBtn.visible = true;
         }
         this._totalPage = Math.ceil(this._itemInfoArr.length / this._len);
         if(this._totalPage > 1)
         {
            this._nextBtn.visible = true;
         }
         this.updateItemNumInfo(this._page);
      }
      
      private function updateItemNumInfo(_arg_1:uint) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_3:Array = null;
         var _local_4:uint = 0;
         _local_3 = this._itemInfoArr.getValues().slice(this._len * (this._page - 1),this._len * this._page);
         this._currentPageData = _local_3;
         this.setCurrentPageItem();
      }
      
      private function setCurrentPageItem() : void
      {
         var _local_4:MovieClip = null;
         var _local_5:ElementItem = null;
         var _local_1:MovieClip = null;
         var _local_2:uint = 0;
         var _local_3:SingleItemInfo = null;
         this.resetItemIcon();
         _local_2 = 0;
         while(_local_2 < this._currentPageData.length)
         {
            _local_3 = this._currentPageData[_local_2];
            _local_4 = this._mainUI["_pr" + _local_2];
            (_local_4["txt"] as TextField).text = String(_local_3.itemNum);
            _local_5 = new ElementItem(_local_4);
            _local_5.setIcon(_local_3);
            _local_4.buttonMode = true;
            _local_4.addEventListener(MouseEvent.CLICK,this.onSelectItem);
            if(_local_3 == this._currentItemInfo)
            {
               _local_4.filters = [this._glow];
            }
            _local_2++;
         }
      }
      
      private function onSelectItem(_arg_1:MouseEvent) : void
      {
         var _local_3:int = 0;
         var _local_2:int = int((_arg_1.currentTarget as MovieClip).name.split("pr")[1]);
         this._currentItemInfo = this._currentPageData[_local_2] as SingleItemInfo;
         while(_local_3 < 16)
         {
            if((_arg_1.currentTarget as MovieClip).name == (this._mainUI["_pr" + _local_3] as MovieClip).name)
            {
               (this._mainUI["_pr" + _local_3] as MovieClip).filters = [this._glow];
            }
            else
            {
               (this._mainUI["_pr" + _local_3] as MovieClip).filters = [];
            }
            _local_3++;
         }
         this._numTxt.text = "1";
      }
      
      private function resetItemIcon() : void
      {
         var _local_2:MovieClip = null;
         var _local_1:int = 0;
         while(_local_1 < 16)
         {
            _local_2 = this._mainUI["_pr" + _local_1];
            _local_2.filters = [];
            (_local_2["txt"] as TextField).text = "";
            while((_local_2["_icon"] as MovieClip).numChildren > 0)
            {
               (_local_2["_icon"] as MovieClip).removeChildAt(0);
            }
            _local_1++;
         }
      }
      
      private function onPre(_arg_1:MouseEvent) : void
      {
         this._nextBtn.visible = true;
         --this._page;
         if(this._page <= 1)
         {
            this._preBtn.visible = false;
         }
         this.updateItemNumInfo(this._page);
      }
      
      private function onNext(_arg_1:MouseEvent) : void
      {
         this._preBtn.visible = true;
         ++this._page;
         if(this._page == this._totalPage)
         {
            this._nextBtn.visible = false;
         }
         this.updateItemNumInfo(this._page);
      }
      
      private function onClose(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         LevelManager.openMouseEvent();
      }
      
      public function destroy() : void
      {
         if(Boolean(this._mainUI))
         {
            DisplayUtil.removeAllChild(this._mainUI);
            DisplayUtil.removeForParent(this._mainUI);
         }
         this._mainUI = null;
         this._closeBtn = null;
      }
      
      public function show() : void
      {
         var _local_1:MCLoader = null;
         if(!this._mainUI)
         {
            _local_1 = new MCLoader(this.PATH,this,1,"正在打开材料融合");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,this.setup);
            _local_1.doLoad();
         }
         else
         {
            DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
            LevelManager.closeMouseEvent();
            LevelManager.appLevel.addChild(this._mainUI);
            ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.addItem);
            ItemManager.getCollection();
         }
      }
   }
}

