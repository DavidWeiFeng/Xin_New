package com.robot.app.bag
{
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.item.*;
   import com.robot.core.info.userItem.*;
   import com.robot.core.manager.*;
   import com.robot.core.utils.*;
   import flash.events.*;
   import org.taomee.events.DynamicEvent;
   
   public class BagClothModel
   {
      
      private var _view:BagPanel;
      
      private var _itemList:Array;
      
      private var _filList:Array;
      
      private var totalPage:uint;
      
      private var currentPage:uint = 1;
      
      private var PET_NUM:uint = 12;
      
      public function BagClothModel(_arg_1:BagPanel)
      {
         super();
         this._view = _arg_1;
         this._view.addEventListener(Event.COMPLETE,this.onPanelComplete);
         this._view.addEventListener(Event.CLOSE,this.onPanelClose);
         this._view.addEventListener(BagPanel.NEXT_PAGE,this.nextHandler);
         this._view.addEventListener(BagPanel.PREV_PAGE,this.prevHandler);
         this._view.addEventListener(BagPanel.SHOW_CLOTH,this.onShowTab);
         this._view.addEventListener(BagPanel.SHOW_COLLECTION,this.onShowTab);
         this._view.addEventListener(BagPanel.SHOW_NONO,this.onShowTab);
         this._view.addEventListener(BagPanel.SHOW_SOULBEAD,this.onShowTab);
         this._view.addEventListener(BagTypeEvent.SELECT,this.onTypeSelect);
      }
      
      private function onPanelComplete(_arg_1:Event) : void
      {
         this.currentPage = 1;
         this.init();
         ItemManager.addEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
         ItemManager.getCloth();
      }
      
      private function onPanelClose(_arg_1:Event) : void
      {
         this.currentPage = 1;
         this.clear();
      }
      
      private function init() : void
      {
         MainManager.actorModel.addEventListener(BagChangeClothAction.TAKE_OFF_CLOTH,this.actEventHandler);
         MainManager.actorModel.addEventListener(BagChangeClothAction.REPLACE_CLOTH,this.actEventHandler);
         MainManager.actorModel.addEventListener(BagChangeClothAction.USE_CLOTH,this.actEventHandler);
         MainManager.actorModel.addEventListener(BagChangeClothAction.CLOTH_CHANGE,this.onClothChange);
      }
      
      private function onShowTab(_arg_1:Event) : void
      {
         this._itemList = [];
         this._filList = [];
         switch(_arg_1.type)
         {
            case BagPanel.SHOW_CLOTH:
               ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
               ItemManager.removeEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
               ItemManager.addEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
               ItemManager.getCloth();
               return;
            case BagPanel.SHOW_COLLECTION:
               ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
               ItemManager.removeEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
               ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
               ItemManager.getCollection();
               return;
            case BagPanel.SHOW_NONO:
               ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
               ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
               ItemManager.addEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
               ItemManager.getSuper();
               return;
            case BagPanel.SHOW_SOULBEAD:
               ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
               ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
               ItemManager.removeEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
               ItemManager.addEventListener(ItemEvent.SOULBEAD_ITEM_LIST,this.onSoulBeadList);
               ItemManager.getSoulBead();
         }
      }
      
      private function getArray(_arg_1:Array, _arg_2:uint = 1, _arg_3:uint = 12) : Array
      {
         var _local_4:uint = (_arg_2 - 1) * _arg_3;
         var _local_5:uint = _arg_2 * _arg_3;
         return _arg_1.slice(_local_4,_local_5);
      }
      
      public function clear() : void
      {
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
         ItemManager.removeEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
         MainManager.actorModel.removeEventListener(BagChangeClothAction.TAKE_OFF_CLOTH,this.actEventHandler);
         MainManager.actorModel.removeEventListener(BagChangeClothAction.REPLACE_CLOTH,this.actEventHandler);
         MainManager.actorModel.removeEventListener(BagChangeClothAction.USE_CLOTH,this.actEventHandler);
         MainManager.actorModel.removeEventListener(BagChangeClothAction.CLOTH_CHANGE,this.onClothChange);
      }
      
      private function onClothList(e:Event) : void
      {
         var clothes:Array = MainManager.actorInfo.clothIDs;
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
         this._itemList = ItemManager.getClothInfos();
         this._itemList = this._itemList.filter(function(_arg_1:SingleItemInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(!ItemXMLInfo.getIsSuper(_arg_1.itemID))
            {
               return true;
            }
            return false;
         });
         this._filList = this._itemList.concat();
         this.showItem();
      }
      
      private function onCollectonList(e:Event) : void
      {
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
         this._itemList = ItemManager.getCollectionInfos();
         this._itemList = this._itemList.filter(function(_arg_1:SingleItemInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(!ItemXMLInfo.getIsSuper(_arg_1.itemID))
            {
               return true;
            }
            return false;
         });
         this._filList = this._itemList.concat();
         this.totalPage = Math.ceil(this._filList.length / this.PET_NUM);
         if(this.totalPage == 0)
         {
            this.totalPage = 1;
         }
         this._view.setPageNum(1,this.totalPage);
         this._view.showItem(this.getArray(this._filList));
      }
      
      private function onNoNoList(e:Event) : void
      {
         var clothes:Array = null;
         clothes = null;
         clothes = MainManager.actorInfo.clothIDs;
         ItemManager.removeEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
         this._itemList = ItemManager.getSuperInfos();
         this._itemList = this._itemList.filter(function(_arg_1:SingleItemInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(Boolean(ItemXMLInfo.getIsSuper(_arg_1.itemID)) && clothes.indexOf(_arg_1.itemID) == -1)
            {
               return true;
            }
            return false;
         });
         this._filList = this._itemList.concat();
         this.showItem();
      }
      
      private function onSoulBeadList(_arg_1:Event) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_3:uint = 0;
         ItemManager.removeEventListener(ItemEvent.SOULBEAD_ITEM_LIST,this.onSoulBeadList);
         this._itemList = ItemManager.getSoulBeadInfos();
         while(_local_3 < this._itemList.length)
         {
            _local_2 = new SingleItemInfo();
            _local_2.itemNum = 1;
            _local_2.itemID = this._itemList[_local_3].itemID;
            _local_2.leftTime = 365 * 24 * 60 * 60;
            this._filList.push(_local_2);
            _local_3++;
         }
         this.showItem();
      }
      
      private function showItem() : void
      {
         this.currentPage = 1;
         switch(BagPanel.currTab)
         {
            case BagTabType.CLOTH:
            case BagTabType.NONO:
               if(BagShowType.currType != BagShowType.SUIT && BagShowType.currType != BagShowType.ALL)
               {
                  this._filList = this._itemList.filter(function(_arg_1:SingleItemInfo, _arg_2:int, _arg_3:Array):Boolean
                  {
                     var _local_4:* = undefined;
                     if(_arg_1.type == ItemType.CLOTH)
                     {
                        if(ClothInfo.getItemInfo(_arg_1.itemID).type == BagShowType.typeNameListEn[BagShowType.currType])
                        {
                           _arg_2 = -1;
                           if(_view.bChangeClothes)
                           {
                              _arg_2 = int(MainManager.actorInfo.clothIDs.indexOf(_arg_1.itemID));
                              _view.bChangeClothes = false;
                           }
                           _local_4 = _view.clothPrev.getClothArray().indexOf(_arg_1.itemID);
                           if(_arg_2 == -1 && _local_4 == -1)
                           {
                              return true;
                           }
                        }
                     }
                     return false;
                  });
               }
               else
               {
                  this._filList = this._itemList.filter(function(_arg_1:SingleItemInfo, _arg_2:int, _arg_3:Array):Boolean
                  {
                     var _local_4:* = undefined;
                     if(_arg_1.type == ItemType.CLOTH)
                     {
                        _arg_2 = -1;
                        if(_view.bChangeClothes)
                        {
                           _arg_2 = int(MainManager.actorInfo.clothIDs.indexOf(_arg_1.itemID));
                           _view.bChangeClothes = false;
                        }
                        _local_4 = _view.clothPrev.getClothIDs().indexOf(_arg_1.itemID);
                        if(_arg_2 == -1 && _local_4 == -1)
                        {
                           return true;
                        }
                        return false;
                     }
                     return true;
                  });
               }
               break;
            case BagTabType.SOULBEAD:
               break;
            default:
               this._filList = this._itemList.concat();
         }
         this.totalPage = Math.ceil(this._filList.length / this.PET_NUM);
         if(this.totalPage == 0)
         {
            this.totalPage = 1;
         }
         this._view.setPageNum(1,this.totalPage);
         this._view.showItem(this.getArray(this._filList));
      }
      
      private function showSuit(arr:Array) : void
      {
         this.currentPage = 1;
         this.totalPage = Math.ceil(arr.length / this.PET_NUM);
         if(this.totalPage == 0)
         {
            this.totalPage = 1;
         }
         this._view.setPageNum(1,this.totalPage);
         arr = arr.slice(0,this.PET_NUM);
         arr = arr.map(function(_arg_1:uint, _arg_2:int, _arg_3:Array):SingleItemInfo
         {
            var _local_4:* = undefined;
            for each(_local_4 in _itemList)
            {
               if(_local_4.itemID == _arg_1)
               {
                  return _local_4;
               }
            }
            _local_4 = new SingleItemInfo();
            _local_4.itemID = _arg_1;
            return _local_4;
         });
         this._view.showItem(arr);
      }
      
      private function nextHandler(_arg_1:Event) : void
      {
         if(this.currentPage < this.totalPage)
         {
            ++this.currentPage;
            this._view.showItem(this.getArray(this._filList,this.currentPage));
            this._view.setPageNum(this.currentPage,this.totalPage);
         }
      }
      
      private function prevHandler(_arg_1:Event) : void
      {
         if(this.currentPage > 1)
         {
            --this.currentPage;
            this._view.showItem(this.getArray(this._filList,this.currentPage));
            this._view.setPageNum(this.currentPage,this.totalPage);
         }
      }
      
      private function actEventHandler(event:DynamicEvent) : void
      {
         var id:uint = 0;
         var info:SingleItemInfo = null;
         var _index:int = 0;
         id = 0;
         if(!this._filList)
         {
            return;
         }
         if(BagShowType.currType == BagShowType.ALL)
         {
            id = uint(event.paramObject);
            this._itemList.some(function(_arg_1:SingleItemInfo, _arg_2:int, _arg_3:Array):Boolean
            {
               if(_arg_1.itemID == id)
               {
                  info = _arg_1;
                  return true;
               }
               return false;
            });
            _index = -1;
            this._filList.some(function(_arg_1:SingleItemInfo, _arg_2:int, _arg_3:Array):Boolean
            {
               if(_arg_1.itemID == _view.clickItemID)
               {
                  _index = _arg_2;
                  return true;
               }
               return false;
            });
            switch(event.type)
            {
               case BagChangeClothAction.USE_CLOTH:
                  if(_index != -1)
                  {
                     this._filList.splice(_index,1);
                  }
                  break;
               case BagChangeClothAction.REPLACE_CLOTH:
                  if(_index != -1)
                  {
                     this._filList.splice(_index,1);
                     if(Boolean(info))
                     {
                        this._filList.unshift(info);
                     }
                  }
                  break;
               case BagChangeClothAction.TAKE_OFF_CLOTH:
                  if(id != 0)
                  {
                     if(Boolean(info))
                     {
                        this._filList.unshift(info);
                     }
                  }
            }
            this.totalPage = Math.ceil(this._filList.length / this.PET_NUM);
            if(this.totalPage == 0)
            {
               this.totalPage = 1;
            }
            if(this.currentPage > this.totalPage)
            {
               this.currentPage = this.totalPage;
            }
            this._view.setPageNum(this.currentPage,this.totalPage);
            if(BagPanel.currTab == BagTabType.COLLECTION)
            {
               this._view.goToCloth();
            }
            this._view.showItem(this.getArray(this._filList,this.currentPage));
         }
      }
      
      private function onClothChange(_arg_1:Event) : void
      {
         if(BagShowType.currType == BagShowType.SUIT)
         {
            this.showSuit(SuitXMLInfo.getClothsForItem(this._view.clickItemID));
         }
      }
      
      private function onTypeSelect(_arg_1:BagTypeEvent) : void
      {
         if(_arg_1.showType == BagShowType.SUIT)
         {
            this.showSuit(SuitXMLInfo.getCloths(_arg_1.suitID));
         }
         else
         {
            this.showItem();
         }
      }
   }
}

