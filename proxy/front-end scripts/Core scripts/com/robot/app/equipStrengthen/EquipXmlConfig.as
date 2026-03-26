package com.robot.app.equipStrengthen
{
   import com.robot.core.event.*;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.*;
   
   public class EquipXmlConfig
   {
      
      private static var _allIdA:Array;
      
      private static var xmlClass:Class = EquipXmlConfig_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function EquipXmlConfig()
      {
         super();
      }
      
      public static function getAllEquipId() : Array
      {
         var _local_1:XML = null;
         var _local_2:XMLList = xml.elements("equip");
         _allIdA = new Array();
         for each(_local_1 in _local_2)
         {
            _allIdA.push(uint(_local_1.@id));
         }
         return _allIdA;
      }
      
      public static function getInfo(id:uint, lev:uint, func:Function) : void
      {
         var info:EquipStrengthenInfo = null;
         var ownA:Array = null;
         var xmlList:XMLList = null;
         var xml1:XML = null;
         var xmlList1:XMLList = null;
         var xml2:XML = null;
         var needA:Array = null;
         info = null;
         ownA = null;
         xmlList = xml.elements("equip");
         xml1 = xmlList.(@id == id.toString())[0];
         xmlList1 = xml1.elements("level");
         xml2 = xmlList1.(@levelId == lev.toString())[0];
         if(xml2 == null)
         {
            return;
         }
         info = new EquipStrengthenInfo();
         info.itemId = id;
         info.levelId = lev;
         info.sendId = uint(xml2.@sendId);
         needA = String(xml2.@needCatalystId).split("|");
         info.needCatalystId = needA[0];
         info.needCatalystNum = needA[1];
         info.needMatterA = String(xml2.@needMatterId).split("|");
         info.needMatterNumA = String(xml2.@needMatterNum).split("|");
         info.des = xml2.@des;
         info.prob = xml2.@odds;
         ownA = new Array();
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,function(_arg_1:ItemEvent):void
         {
            var _local_3:SingleItemInfo = null;
            var _local_4:int = 0;
            ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,arguments.callee);
            while(_local_4 < info.needMatterA.length)
            {
               _local_3 = ItemManager.getCollectionInfo(info.needMatterA[_local_4]);
               if(Boolean(_local_3))
               {
                  ownA.push(_local_3.itemNum);
               }
               else
               {
                  ownA.push(0);
               }
               _local_4++;
            }
            var _local_5:SingleItemInfo = ItemManager.getCollectionInfo(info.needCatalystId);
            if(Boolean(_local_5))
            {
               info.ownCatalystNum = _local_5.itemNum;
            }
            else
            {
               info.ownCatalystNum = 0;
            }
            info.ownNeedA = ownA;
            if(func != null)
            {
               func(info);
            }
         });
         ItemManager.getCollection();
      }
   }
}

