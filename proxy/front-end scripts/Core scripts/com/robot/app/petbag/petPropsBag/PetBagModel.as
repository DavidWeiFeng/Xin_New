package com.robot.app.petbag.petPropsBag
{
   import com.robot.app.petbag.petPropsBag.ui.PetPropsPanel;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.manager.ItemManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PetBagModel
   {
      
      private var view:PetPropsPanel;
      
      private var idArray:Array;
      
      private var totalPage:uint;
      
      private var currentPage:uint = 1;
      
      private var PET_NUM:uint = 12;
      
      private var doodleAry:Array;
      
      public function PetBagModel(_arg_1:Sprite)
      {
         super();
         this.view = _arg_1 as PetPropsPanel;
         this.addEvent();
         this.onShowCollection();
      }
      
      public function addEvent() : void
      {
         this.view.addEventListener(Event.CLOSE,this.onPanelClose);
         this.view.addEventListener(PetPropsPanel.NEXT_PAGE,this.nextHandler);
         this.view.addEventListener(PetPropsPanel.PREV_PAGE,this.prevHandler);
      }
      
      public function removeEvent() : void
      {
         this.view.removeEventListener(Event.CLOSE,this.onPanelClose);
         this.view.removeEventListener(PetPropsPanel.NEXT_PAGE,this.nextHandler);
         this.view.removeEventListener(PetPropsPanel.PREV_PAGE,this.prevHandler);
      }
      
      private function onPanelClose(_arg_1:Event) : void
      {
         this.currentPage = 1;
         this.clear();
      }
      
      public function clear() : void
      {
         ItemManager.removeEventListener(ItemEvent.PET_ITEM_LIST,this.onPetItemList);
      }
      
      private function onShowCollection() : void
      {
         this.currentPage = 1;
         ItemManager.addEventListener(ItemEvent.PET_ITEM_LIST,this.onPetItemList);
         ItemManager.getPetItem();
      }
      
      private function getArray(_arg_1:Boolean = true, _arg_2:uint = 1, _arg_3:uint = 12) : Array
      {
         var _local_4:uint = (_arg_2 - 1) * _arg_3;
         var _local_5:uint = _arg_2 * _arg_3;
         var _local_6:Array = this.doodleAry;
         return _local_6.slice(_local_4,_local_5);
      }
      
      private function onPetItemList(_arg_1:ItemEvent) : void
      {
         ItemManager.removeEventListener(ItemEvent.PET_ITEM_LIST,this.onPetItemList);
         this.showItem(ItemManager.getPetItemIDs());
      }
      
      private function showItem(_arg_1:Array) : void
      {
         var _local_2:uint = 0;
         this.doodleAry = [];
         for each(_local_2 in _arg_1)
         {
            if(ItemXMLInfo.getIsShowInPetBag(_local_2))
            {
               this.doodleAry.push(_local_2);
            }
         }
         this.totalPage = Math.ceil(this.doodleAry.length / this.PET_NUM);
         if(this.totalPage == 0)
         {
            this.totalPage = 1;
         }
         this.view.setPageNum(1,this.totalPage);
         this.view.showItem(this.getArray());
      }
      
      private function prevHandler(_arg_1:Event) : void
      {
         if(this.currentPage > 1)
         {
            --this.currentPage;
            this.view.showItem(this.getArray(false,this.currentPage));
            this.view.setPageNum(this.currentPage,this.totalPage);
         }
      }
      
      private function nextHandler(_arg_1:Event) : void
      {
         if(this.currentPage < this.totalPage)
         {
            ++this.currentPage;
            this.view.showItem(this.getArray(false,this.currentPage));
            this.view.setPageNum(this.currentPage,this.totalPage);
         }
      }
   }
}

