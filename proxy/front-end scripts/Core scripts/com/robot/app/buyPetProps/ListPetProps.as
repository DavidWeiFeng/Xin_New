package com.robot.app.buyPetProps
{
   import com.robot.core.config.xml.PetShopXmlInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class ListPetProps
   {
      
      private var _mc:MovieClip;
      
      private var _itemID:uint;
      
      private var _iconMC:MovieClip;
      
      private var _point:Point;
      
      public function ListPetProps(_arg_1:MovieClip, _arg_2:uint, _arg_3:MovieClip, _arg_4:Point)
      {
         super();
         this._mc = _arg_1;
         this._itemID = _arg_2;
         this._iconMC = _arg_3;
         this._point = _arg_4;
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.onList);
         ItemManager.upDateCollection(_arg_2);
      }
      
      public function destroy() : void
      {
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onList);
      }
      
      private function onList(_arg_1:Event) : void
      {
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onList);
         var _local_2:SingleItemInfo = ItemManager.getCollectionInfo(this._itemID);
         var _local_3:String = PetShopXmlInfo.getNameByItemID(this._itemID);
         if(Boolean(_local_2))
         {
            if(_local_2.itemNum > 999999)
            {
               Alarm.show("你已经拥有了99个" + _local_3);
               return;
            }
         }
         BuyTipPanel.initPanel(this._mc,this._itemID,this._iconMC,this._point,this);
      }
   }
}

