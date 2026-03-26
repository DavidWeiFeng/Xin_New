package com.robot.core.manager
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.userItem.*;
   import com.robot.core.net.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   
   [Event(name="clothList",type="com.robot.core.event.ItemEvent")]
   [Event(name="collectionList",type="com.robot.core.event.ItemEvent")]
   [Event(name="throwList",type="com.robot.core.event.ItemEvent")]
   [Event(name="petItemList",type="com.robot.core.event.ItemEvent")]
   public class ItemManager
   {
      
      private static var _instance:EventDispatcher;
      
      private static var _clothMap:HashMap = new HashMap();
      
      private static var _collectionMap:HashMap = new HashMap();
      
      private static var _throwMap:HashMap = new HashMap();
      
      private static var _petItemMap:HashMap = new HashMap();
      
      private static var _soulBeadMap:HashMap = new HashMap();
      
      private static var _superMap:HashMap = new HashMap();
      
      public function ItemManager()
      {
         super();
      }
      
      public static function containsAll(_arg_1:uint) : Boolean
      {
         if(_clothMap.containsKey(_arg_1))
         {
            return true;
         }
         if(_collectionMap.containsKey(_arg_1))
         {
            return true;
         }
         return false;
      }
      
      public static function getInfo(_arg_1:uint) : SingleItemInfo
      {
         var _local_2:SingleItemInfo = _clothMap.getValue(_arg_1);
         if(_local_2 == null)
         {
            _local_2 = _collectionMap.getValue(_arg_1);
         }
         return _local_2;
      }
      
      public static function getCloth() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,onClothList);
         SocketConnection.send(CommandID.ITEM_LIST,100001,101001,2);
      }
      
      public static function containsCloth(_arg_1:uint) : Boolean
      {
         return _clothMap.containsKey(_arg_1);
      }
      
      public static function getClothInfo(_arg_1:uint) : SingleItemInfo
      {
         return _clothMap.getValue(_arg_1);
      }
      
      public static function getClothIDs() : Array
      {
         return _clothMap.getKeys();
      }
      
      public static function getClothInfos() : Array
      {
         return _clothMap.getValues();
      }
      
      public static function upDateCloth(id:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,function(_arg_1:SocketEvent):void
         {
            var _local_3:SingleItemInfo = null;
            var _local_6:int = 0;
            SocketConnection.removeCmdListener(CommandID.ITEM_LIST,arguments.callee);
            var _local_4:ByteArray = _arg_1.data as ByteArray;
            var _local_5:uint = _local_4.readUnsignedInt();
            while(_local_6 < _local_5)
            {
               _local_3 = new SingleItemInfo(_local_4);
               _clothMap.add(_local_3.itemID,_local_3);
               _local_6++;
            }
            dispatchEvent(new ItemEvent(ItemEvent.CLOTH_LIST));
         });
         SocketConnection.send(CommandID.ITEM_LIST,id,id,2);
      }
      
      private static function onClothList(_arg_1:SocketEvent) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_5:int = 0;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,onClothList);
         _clothMap.clear();
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         while(_local_5 < _local_4)
         {
            _local_2 = new SingleItemInfo(_local_3);
            _clothMap.add(_local_2.itemID,_local_2);
            _local_5++;
         }
         dispatchEvent(new ItemEvent(ItemEvent.CLOTH_LIST));
      }
      
      public static function getCollection() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,onCollectionList);
         SocketConnection.send(CommandID.ITEM_LIST,300001,500000,2);
      }
      
      public static function containsCollection(_arg_1:uint) : Boolean
      {
         return _collectionMap.containsKey(_arg_1);
      }
      
      public static function getCollectionInfo(_arg_1:uint) : SingleItemInfo
      {
         return _collectionMap.getValue(_arg_1);
      }
      
      public static function getCollectionIDs() : Array
      {
         return _collectionMap.getKeys();
      }
      
      public static function getCollectionInfos() : Array
      {
         return _collectionMap.getValues();
      }
      
      public static function upDateCollection(param1:uint, param2:Function = null, param3:uint = 0) : void
      {
         var processFun:Function = null;
         var sendIds:Array = null;
         var id:uint = 0;
         var callBack:Function = null;
         sendIds = null;
         id = param1;
         callBack = param2;
         var endId:uint = param3;
         endId = endId == 0 ? id : endId;
         sendIds = [];
         var i:int = int(id);
         while(i < endId + 1)
         {
            sendIds.push(i);
            i++;
         }
         processFun = function(param1:SocketEvent):void
         {
            var _loc2_:int = 0;
            var _loc3_:SingleItemInfo = null;
            var _loc4_:ByteArray = param1.data as ByteArray;
            _loc4_.position = 0;
            var _loc5_:uint = _loc4_.readUnsignedInt();
            var _loc6_:Array = [];
            var _loc7_:int = 0;
            while(_loc7_ < _loc5_)
            {
               _loc3_ = new SingleItemInfo(_loc4_);
               _collectionMap.add(_loc3_.itemID,_loc3_);
               _loc6_.push(_loc3_.itemID);
               _loc7_++;
            }
            for each(_loc2_ in sendIds)
            {
               if(_loc6_.indexOf(_loc2_) == -1)
               {
                  _collectionMap.remove(_loc2_);
               }
            }
            if(_loc5_ == 0)
            {
               _collectionMap.remove(id);
            }
            if(null != callBack)
            {
               callBack.call();
            }
            dispatchEvent(new ItemEvent(ItemEvent.COLLECTION_LIST));
         };
         SocketConnection.sendByQueue(CommandID.ITEM_LIST,[id,endId,2],processFun);
      }
      
      private static function onCollectionList(_arg_1:SocketEvent) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_5:int = 0;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,onCollectionList);
         _collectionMap.clear();
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         while(_local_5 < _local_4)
         {
            _local_2 = new SingleItemInfo(_local_3);
            _collectionMap.add(_local_2.itemID,_local_2);
            _local_5++;
         }
         dispatchEvent(new ItemEvent(ItemEvent.COLLECTION_LIST));
      }
      
      public static function getThrowThing() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,onThrowList);
         SocketConnection.send(CommandID.ITEM_LIST,600001,600100,2);
      }
      
      private static function onThrowList(_arg_1:SocketEvent) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_5:int = 0;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,onThrowList);
         _throwMap.clear();
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         while(_local_5 < _local_4)
         {
            _local_2 = new SingleItemInfo(_local_3);
            _throwMap.add(_local_2.itemID,_local_2);
            _local_5++;
         }
         dispatchEvent(new ItemEvent(ItemEvent.THROW_LIST));
      }
      
      public static function containsThrow(_arg_1:uint) : Boolean
      {
         return _throwMap.containsKey(_arg_1);
      }
      
      public static function getThrowInfo(_arg_1:uint) : SingleItemInfo
      {
         return _throwMap.getValue(_arg_1);
      }
      
      public static function getThrowIDs() : Array
      {
         return _throwMap.getKeys();
      }
      
      public static function getPetItem() : void
      {
         _petItemMap.clear();
         ItemManager.updataeItems(300011,300250,function():void
         {
            ItemManager.updataeItems(300601,300999,function():void
            {
               ItemManager.updataeItems(1600001,1600100,function():void
               {
                  var _loc1_:SingleItemInfo = null;
                  var _loc2_:int = 300011;
                  while(_loc2_ < 1600100)
                  {
                     if((_loc2_ <= 300250 || _loc2_ >= 1600001 || _loc2_ >= 300601 && _loc2_ <= 300999) && _loc2_ != 300658)
                     {
                        _loc1_ = ItemManager.getInfo(_loc2_);
                        if(null != _loc1_)
                        {
                           _petItemMap.add(_loc1_.itemID,_loc1_);
                        }
                     }
                     _loc2_++;
                  }
                  dispatchEvent(new ItemEvent(ItemEvent.PET_ITEM_LIST));
               });
            });
         });
      }
      
      public static function updataeItems(param1:int, param2:int, param3:Function = null) : void
      {
         if(param2 < param1)
         {
            throw new Error("endId < startId");
         }
         upDateCollection(param1,param3,param2);
      }
      
      private static function onPetItemList(_arg_1:SocketEvent) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_5:int = 0;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,onPetItemList);
         _petItemMap.clear();
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         while(_local_5 < _local_4)
         {
            _local_2 = new SingleItemInfo(_local_3);
            _petItemMap.add(_local_2.itemID,_local_2);
            _local_5++;
         }
         dispatchEvent(new ItemEvent(ItemEvent.PET_ITEM_LIST));
      }
      
      public static function containsPetItem(_arg_1:uint) : Boolean
      {
         return _petItemMap.containsKey(_arg_1);
      }
      
      public static function getPetItemInfo(_arg_1:uint) : SingleItemInfo
      {
         return _petItemMap.getValue(_arg_1);
      }
      
      public static function getPetItemIDs() : Array
      {
         return _petItemMap.getKeys();
      }
      
      public static function getSoulBead() : void
      {
      }
      
      private static function onSoulBeadList(_arg_1:SocketEvent) : void
      {
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_5:SoulBeadItemInfo = null;
         var _local_8:uint = 0;
         SocketConnection.removeCmdListener(CommandID.GET_SOUL_BEAD_List,arguments.callee);
         _soulBeadMap.clear();
         var _local_6:ByteArray = _arg_1.data as ByteArray;
         var _local_7:uint = _local_6.readUnsignedInt();
         while(_local_8 < _local_7)
         {
            _local_3 = _local_6.readUnsignedInt();
            _local_4 = _local_6.readUnsignedInt();
            _local_5 = new SoulBeadItemInfo();
            _local_5.obtainTime = _local_3;
            _local_5.itemID = _local_4;
            _soulBeadMap.add(_local_3,_local_5);
            _local_8++;
         }
         dispatchEvent(new ItemEvent(ItemEvent.SOULBEAD_ITEM_LIST));
      }
      
      public static function containsSoulBead(_arg_1:uint) : Boolean
      {
         return _soulBeadMap.containsKey(_arg_1);
      }
      
      public static function getSoulBeadInfo(_arg_1:uint) : SoulBeadItemInfo
      {
         return _soulBeadMap.getValue(_arg_1);
      }
      
      public static function getSBObtainTms() : Array
      {
         return _soulBeadMap.getKeys();
      }
      
      public static function getSoulBeadInfos() : Array
      {
         return _soulBeadMap.getValues();
      }
      
      public static function getSuper() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,onSuperList);
         SocketConnection.send(CommandID.ITEM_LIST,100001,500000,2);
      }
      
      public static function containsSuper(_arg_1:uint) : Boolean
      {
         return _superMap.containsKey(_arg_1);
      }
      
      public static function getSuperInfo(_arg_1:uint) : SingleItemInfo
      {
         return _superMap.getValue(_arg_1);
      }
      
      public static function getSuperIDs() : Array
      {
         return _superMap.getKeys();
      }
      
      public static function getSuperInfos() : Array
      {
         return _superMap.getValues();
      }
      
      public static function upDateSuper(id:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,function(_arg_1:SocketEvent):void
         {
            var _local_3:SingleItemInfo = null;
            var _local_6:int = 0;
            SocketConnection.removeCmdListener(CommandID.ITEM_LIST,arguments.callee);
            var _local_4:ByteArray = _arg_1.data as ByteArray;
            var _local_5:uint = _local_4.readUnsignedInt();
            while(_local_6 < _local_5)
            {
               _local_3 = new SingleItemInfo(_local_4);
               _superMap.add(_local_3.itemID,_local_3);
               _local_6++;
            }
            dispatchEvent(new ItemEvent(ItemEvent.SUPER_ITEM_LIST));
         });
         SocketConnection.send(CommandID.ITEM_LIST,id,id,2);
      }
      
      private static function onSuperList(_arg_1:SocketEvent) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_5:int = 0;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,onSuperList);
         _superMap.clear();
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         while(_local_5 < _local_4)
         {
            _local_2 = new SingleItemInfo(_local_3);
            _superMap.add(_local_2.itemID,_local_2);
            _local_5++;
         }
         dispatchEvent(new ItemEvent(ItemEvent.SUPER_ITEM_LIST));
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
      }
      
      public static function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         getInstance().addEventListener(_arg_1,_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public static function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         getInstance().removeEventListener(_arg_1,_arg_2,_arg_3);
      }
      
      public static function dispatchEvent(_arg_1:Event) : void
      {
         getInstance().dispatchEvent(_arg_1);
      }
      
      public static function hasEventListener(_arg_1:String) : Boolean
      {
         return getInstance().hasEventListener(_arg_1);
      }
   }
}

