package com.robot.core.energyExchange
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   
   public class ExchangeOreModel
   {
      
      private static var _sucHandler:Function;
      
      private static var _handler:Function;
      
      private static var _desStr:String;
      
      private static var _infoMap:HashMap;
      
      private static var xmlClass:Class = ExchangeOreModel_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function ExchangeOreModel()
      {
         super();
      }
      
      public static function getData(_arg_1:Function, _arg_2:String) : void
      {
         _sucHandler = _arg_1;
         _desStr = _arg_2;
         _infoMap = new HashMap();
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,onList);
         ItemManager.getCollection();
      }
      
      private static function onList(_arg_1:ItemEvent) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_3:ExchangeItemInfo = null;
         var _local_4:int = 0;
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,onList);
         while(_local_4 < xml.item.length())
         {
            _local_2 = ItemManager.getCollectionInfo(uint(xml.item[_local_4].@id));
            if(Boolean(_local_2))
            {
               _local_3 = new ExchangeItemInfo(_local_2);
               _infoMap.add(_local_3.itemId,_local_3);
            }
            _local_4++;
         }
         if(_infoMap.length == 0)
         {
            if(_desStr != "")
            {
               Alarm.show(_desStr);
            }
            _sucHandler(null);
         }
         else
         {
            _sucHandler(_infoMap);
         }
      }
      
      public static function exchangeEnergy(_arg_1:uint, _arg_2:uint, _arg_3:Function) : void
      {
         _handler = _arg_3;
         SocketConnection.addCmdListener(CommandID.ITEM_SALE,onSuccess);
         SocketConnection.send(CommandID.ITEM_SALE,_arg_1,_arg_2);
      }
      
      private static function onSuccess(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ITEM_SALE,onSuccess);
         _handler();
      }
   }
}

