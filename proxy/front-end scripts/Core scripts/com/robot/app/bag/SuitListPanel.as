package com.robot.app.bag
{
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import com.robot.core.uic.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import flash.text.*;
   import org.taomee.events.*;
   import org.taomee.utils.*;
   
   public class SuitListPanel extends Sprite
   {
      
      private static const MAX:int = 6;
      
      private var _dataList:Array;
      
      private var _listCon:Sprite;
      
      private var _dataLen:int = 0;
      
      private var _proPageBar:UIPageBar;
      
      public function SuitListPanel(app:ApplicationDomain, isE:Boolean = false)
      {
         var bg:Sprite = null;
         var _dataLen:int = 0;
         var len:int = 0;
         var i:int = 0;
         var _preBtn:SimpleButton = null;
         var _nextBtn:SimpleButton = null;
         var id:uint = 0;
         var item:BagTypeListItem = null;
         super();
         bg = new (app.getDefinition("suitpanelMc") as Class)() as Sprite;
         bg.width = 120;
         bg.height = 276;
         bg.cacheAsBitmap = true;
         addChild(bg);
         this._listCon = new Sprite();
         this._listCon.x = 10;
         this._listCon.y = 34;
         addChild(this._listCon);
         if(isE)
         {
            this._dataList = SuitXMLInfo.getIsEliteItems(ItemManager.getClothIDs());
         }
         else
         {
            this._dataList = SuitXMLInfo.getIDsForItems(ItemManager.getClothIDs());
         }
         if(BagPanel.currTab == BagTabType.NONO)
         {
            this._dataList = this._dataList.filter(function(_arg_1:uint, _arg_2:int, _arg_3:Array):Boolean
            {
               if(SuitXMLInfo.getIsVip(_arg_1))
               {
                  return true;
               }
               return false;
            });
         }
         else
         {
            this._dataList = this._dataList.filter(function(_arg_1:uint, _arg_2:int, _arg_3:Array):Boolean
            {
               if(!SuitXMLInfo.getIsVip(_arg_1))
               {
                  return true;
               }
               return false;
            });
         }
         _dataLen = int(this._dataList.length);
         len = Math.min(MAX,_dataLen);
         i = 0;
         while(i < MAX)
         {
            id = uint(this._dataList[i]);
            item = new BagTypeListItem(app);
            item.width = 96;
            item.y = i * (item.height + 5);
            this._listCon.addChild(item);
            if(i < len)
            {
               item.setInfo(id,SuitXMLInfo.getName(id));
               item.addEventListener(MouseEvent.CLICK,this.onItemClick);
               if(BagShowType.currType == BagShowType.SUIT)
               {
                  if(item.id == BagShowType.currSuitID)
                  {
                     item.select = true;
                  }
               }
            }
            i += 1;
         }
         _preBtn = UIManager.getButton("Arrow_Icon");
         _preBtn.x = bg.width / 2 + _preBtn.width / 2;
         _preBtn.y = 5;
         _preBtn.rotation = 90;
         addChild(_preBtn);
         _nextBtn = UIManager.getButton("Arrow_Icon");
         _nextBtn.x = (bg.width - _nextBtn.width) / 2;
         _nextBtn.y = bg.height - 10;
         _nextBtn.rotation = -90;
         addChild(_nextBtn);
         this._proPageBar = new UIPageBar(_preBtn,_nextBtn,new TextField(),MAX);
         this._proPageBar.totalLength = _dataLen;
         this._proPageBar.addEventListener(MouseEvent.CLICK,this.onProPage);
      }
      
      public function destroy() : void
      {
         this._proPageBar.removeEventListener(MouseEvent.CLICK,this.onProPage);
         this._proPageBar.destroy();
         this._proPageBar = null;
         this._dataList = null;
         DisplayUtil.removeAllChild(this);
         this._listCon = null;
      }
      
      private function onItemClick(_arg_1:MouseEvent) : void
      {
         var _local_2:BagTypeListItem = _arg_1.currentTarget as BagTypeListItem;
         dispatchEvent(new DynamicEvent(Event.SELECT,_local_2.id));
      }
      
      private function onProPage(_arg_1:DynamicEvent) : void
      {
         var _local_2:BagTypeListItem = null;
         var _local_3:uint = 0;
         var _local_4:BagTypeListItem = null;
         var _local_6:int = 0;
         var _local_8:int = 0;
         var _local_5:uint = _arg_1.paramObject as uint;
         while(_local_6 < MAX)
         {
            _local_2 = this._listCon.getChildAt(_local_6) as BagTypeListItem;
            _local_2.clear();
            _local_6++;
         }
         var _local_7:int = Math.min(MAX,this._proPageBar.totalLength - this._proPageBar.index * MAX);
         while(_local_8 < _local_7)
         {
            _local_3 = uint(this._dataList[_local_8 + _local_5 * MAX]);
            _local_4 = this._listCon.getChildAt(_local_8) as BagTypeListItem;
            _local_4.setInfo(_local_3,SuitXMLInfo.getName(_local_3));
            if(BagShowType.currType == BagShowType.SUIT)
            {
               if(_local_4.id == BagShowType.currSuitID)
               {
                  _local_4.select = true;
               }
               else
               {
                  _local_4.select = false;
               }
            }
            _local_8++;
         }
      }
   }
}

