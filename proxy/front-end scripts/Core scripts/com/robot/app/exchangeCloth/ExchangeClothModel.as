package com.robot.app.exchangeCloth
{
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import flash.events.Event;
   
   public class ExchangeClothModel
   {
      
      private var xmlClass:Class = ExchangeClothModel_xmlClass;
      
      private var xml:XML = XML(new this.xmlClass());
      
      private var info_a:Array;
      
      public function ExchangeClothModel()
      {
         super();
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.onList);
         ItemManager.getCollection();
      }
      
      private function getInfo() : void
      {
         var _local_1:Object = null;
         var _local_2:int = 0;
         while(_local_2 < this.xml.item.length())
         {
            if(ItemManager.getCollectionInfo(uint(this.xml.item[_local_2].@id)) != null)
            {
               _local_1 = new Object();
               _local_1.className = this.xml.item[_local_2].@className;
               _local_1.iconName = this.xml.item[_local_2].@iconName;
               _local_1.id = this.xml.item[_local_2].@id;
               _local_1.exName = this.xml.item[_local_2].@exName;
               _local_1.eName = ItemXMLInfo.getName(uint(_local_1.id));
               _local_1.des = ItemTipXMLInfo.getItemDes(uint(_local_1.id));
               this.info_a.push(_local_1);
            }
            _local_2++;
         }
      }
      
      public function onList(_arg_1:Event) : void
      {
         this.destroy();
         this.info_a = new Array();
         this.getInfo();
         if(this.info_a.length > 0)
         {
            ExchangeClothController.show(this.info_a);
         }
         else
         {
            Alarm.show("你还没有原材料打造装备，快去搜集吧!");
         }
      }
      
      public function destroy() : void
      {
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onList);
      }
   }
}

