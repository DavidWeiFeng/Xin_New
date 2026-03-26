package com.robot.core.manager
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.info.team.*;
   import com.robot.core.net.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class HeadquarterManager
   {
      
      public static var isChange:Boolean;
      
      public static var storagePanel:Sprite;
      
      public static var teamID:uint;
      
      public static var headquartersID:uint;
      
      private static var _sprite:Sprite;
      
      private static var _info:FitmentInfo;
      
      private static var _parent:DisplayObjectContainer;
      
      private static var _type:int;
      
      private static var _offp:Point;
      
      private static var _wapmc:DisplayObject;
      
      private static var _flomc:DisplayObject;
      
      private static var _isMove:Boolean;
      
      private static var _instance:EventDispatcher;
      
      private static var usedList:Array = [];
      
      private static var storageMap:HashMap = new HashMap();
      
      private static var _isArrlowInMap:Boolean = true;
      
      public function HeadquarterManager()
      {
         super();
      }
      
      public static function doDrag(_arg_1:Sprite, _arg_2:FitmentInfo, _arg_3:DisplayObjectContainer, _arg_4:int, _arg_5:Point = null) : void
      {
         var _local_6:Point = null;
         _local_6 = null;
         _sprite = _arg_1;
         _sprite.mouseEnabled = false;
         _sprite.mouseChildren = false;
         _info = _arg_2;
         _parent = _arg_3;
         _type = _arg_4;
         if(Boolean(_arg_5))
         {
            _offp = _arg_5;
         }
         else
         {
            _offp = new Point();
         }
         _local_6 = DisplayUtil.localToLocal(_sprite,MainManager.getStage());
         _sprite.x = _local_6.x;
         _sprite.y = _local_6.y;
         MainManager.getStage().addChild(_sprite);
         MainManager.getStage().addEventListener(MouseEvent.MOUSE_UP,onUp);
         MainManager.getStage().addEventListener(MouseEvent.MOUSE_MOVE,onMove);
         var _local_7:Rectangle = _sprite.getRect(_sprite);
         _sprite.startDrag(false,new Rectangle(-_local_7.x,-_local_7.y,MainManager.getStageWidth() - _local_7.width,MainManager.getStageHeight() - _local_7.height));
         if(Boolean(MapManager.currentMap.animatorLevel))
         {
            _wapmc = MapManager.currentMap.animatorLevel.getChildByName("wapMC");
            _flomc = MapManager.currentMap.animatorLevel.getChildByName("floMC");
         }
         _isMove = false;
      }
      
      public static function saveInfo() : void
      {
         var _local_1:FitmentInfo = null;
         if(!isChange)
         {
            return;
         }
         isChange = false;
         var _local_2:int = int(usedList.length);
         var _local_3:ByteArray = new ByteArray();
         for each(_local_1 in usedList)
         {
            _local_3.writeUnsignedInt(_local_1.id);
            _local_3.writeUnsignedInt(_local_1.pos.x);
            _local_3.writeUnsignedInt(_local_1.pos.y);
            _local_3.writeUnsignedInt(_local_1.dir);
            _local_3.writeUnsignedInt(_local_1.status);
         }
         SocketConnection.send(CommandID.HEAD_SET_INFO,_local_2,_local_3);
      }
      
      public static function saveStyleType(info:FitmentInfo, event:Function) : void
      {
         var byData:ByteArray = new ByteArray();
         byData.writeUnsignedInt(headquartersID);
         byData.writeUnsignedInt(info.id);
         byData.writeUnsignedInt(info.pos.x);
         byData.writeUnsignedInt(info.pos.y);
         byData.writeUnsignedInt(info.dir);
         byData.writeUnsignedInt(info.status);
         SocketConnection.addCmdListener(CommandID.HEAD_SET_INFO,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.HEAD_SET_INFO,arguments.callee);
            event();
         });
         SocketConnection.send(CommandID.HEAD_SET_INFO,1,byData);
      }
      
      private static function onMove(_arg_1:MouseEvent) : void
      {
         _isMove = true;
         var _local_2:Point = new Point(DisplayObject(_arg_1.currentTarget).mouseX,DisplayObject(_arg_1.currentTarget).mouseY);
         _local_2 = _local_2.subtract(_offp);
         if(storagePanel.hitTestPoint(_local_2.x,_local_2.y))
         {
            _sprite.alpha = 1;
         }
         else
         {
            if(_info.type == SolidType.PUT)
            {
               if(_flomc.hitTestPoint(_local_2.x,_local_2.y,true))
               {
                  _isArrlowInMap = true;
                  _sprite.alpha = 1;
               }
               else
               {
                  _isArrlowInMap = false;
                  _sprite.alpha = 0.4;
               }
            }
            if(_info.type == SolidType.HANG)
            {
               if(_wapmc.hitTestPoint(_local_2.x,_local_2.y,true))
               {
                  _isArrlowInMap = true;
                  _sprite.alpha = 1;
               }
               else
               {
                  _isArrlowInMap = false;
                  _sprite.alpha = 0.4;
               }
            }
         }
      }
      
      private static function onUp(_arg_1:MouseEvent) : void
      {
         MainManager.getStage().removeEventListener(MouseEvent.MOUSE_UP,onUp);
         MainManager.getStage().removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
         var _local_2:Point = new Point(DisplayObject(_arg_1.currentTarget).mouseX,DisplayObject(_arg_1.currentTarget).mouseY);
         _local_2 = _local_2.subtract(_offp);
         _sprite.stopDrag();
         if(storagePanel.hitTestPoint(_local_2.x,_local_2.y))
         {
            dragInStorage();
         }
         else if(MapManager.currentMap.root.hitTestPoint(_local_2.x,_local_2.y))
         {
            if(_isArrlowInMap)
            {
               dragInMap(_local_2);
            }
            else
            {
               dragInNo();
            }
         }
         else
         {
            dragInNo();
         }
         _sprite = null;
         _parent = null;
         _info = null;
      }
      
      private static function dragInMap(_arg_1:Point) : void
      {
         isChange = true;
         if(_type == DragTargetType.MAP)
         {
            if(_info.isFixed)
            {
               _info.pos = MapXMLInfo.getHeadPos(MapManager.styleID);
            }
            else
            {
               _info.pos = _arg_1;
            }
            _sprite.x = 0;
            _sprite.y = 0;
            _sprite.mouseEnabled = true;
            _sprite.mouseChildren = true;
            _parent.x = _info.pos.x;
            _parent.y = _info.pos.y;
            _parent.addChild(_sprite);
            DepthManager.swapDepth(_parent,_parent.y);
         }
         else
         {
            if(_info.isFixed)
            {
               _info.pos = MapXMLInfo.getHeadPos(MapManager.styleID);
            }
            else
            {
               _info.pos = _arg_1;
            }
            addInMap(_info);
            if(_type == DragTargetType.STORAGE)
            {
               DisplayUtil.removeForParent(_sprite);
               removeInStorage(_info.id);
            }
         }
      }
      
      private static function dragInStorage() : void
      {
         if(_type == DragTargetType.STORAGE)
         {
            if(_isMove)
            {
               DisplayUtil.removeForParent(_sprite);
               dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_STORAGE,_info));
            }
            else
            {
               isChange = true;
               if(_info.isFixed)
               {
                  _info.pos = MapXMLInfo.getHeadPos(MapManager.styleID);
               }
               else if(_info.type == SolidType.PUT)
               {
                  _info.pos = MapXMLInfo.getRoomDefaultFloPos(MapManager.styleID);
               }
               else if(_info.type == SolidType.HANG)
               {
                  _info.pos = MapXMLInfo.getRoomDefaultWapPos(MapManager.styleID);
               }
               else
               {
                  _info.pos = MainManager.getStageCenterPoint();
               }
               addInMap(_info);
               removeInStorage(_info.id);
               DisplayUtil.removeForParent(_sprite);
            }
         }
         else
         {
            addInStorage(_info);
            if(_type == DragTargetType.MAP)
            {
               isChange = true;
               DisplayUtil.removeForParent(_sprite);
               removeInMap(_info);
            }
         }
      }
      
      private static function dragInNo() : void
      {
         if(_type == DragTargetType.STORAGE)
         {
            DisplayUtil.removeForParent(_sprite);
            dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_STORAGE,_info));
            return;
         }
         _sprite.alpha = 1;
         _sprite.x = 0;
         _sprite.y = 0;
         _sprite.mouseEnabled = true;
         _parent.addChild(_sprite);
      }
      
      public static function getUsedInfo(teamID:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.HEAD_GET_USED_INFO,function(_arg_1:SocketEvent):void
         {
            var _local_3:HeadquarterInfo = null;
            var _local_4:HeadquarterInfo = null;
            var _local_5:Boolean = false;
            var _local_8:int = 0;
            SocketConnection.removeCmdListener(CommandID.HEAD_GET_USED_INFO,arguments.callee);
            usedList = [];
            var _local_6:ByteArray = _arg_1.data as ByteArray;
            teamID = _local_6.readUnsignedInt();
            headquartersID = _local_6.readUnsignedInt();
            var _local_7:uint = _local_6.readUnsignedInt();
            while(_local_8 < _local_7)
            {
               _local_3 = new HeadquarterInfo();
               FitmentInfo.setFor10008(_local_3,_local_6);
               usedList.push(_local_3);
               if(_local_3.type == SolidType.FRAME)
               {
                  MapManager.styleID = _local_3.id;
                  _local_5 = true;
               }
               _local_8++;
            }
            if(!_local_5)
            {
               _local_4 = new HeadquarterInfo();
               MapManager.styleID = MapManager.defaultRoomStyleID;
               _local_4.id = MapManager.defaultRoomStyleID;
               usedList.push(_local_4);
            }
            dispatchEvent(new FitmentEvent(FitmentEvent.USED_LIST,null));
         });
         SocketConnection.send(CommandID.HEAD_GET_USED_INFO,teamID);
      }
      
      public static function addInMap(_arg_1:FitmentInfo) : void
      {
         var _local_2:HeadquarterInfo = new HeadquarterInfo();
         _local_2.id = _arg_1.id;
         _local_2.pos = _arg_1.pos.clone();
         _local_2.dir = _arg_1.dir;
         _local_2.status = _arg_1.status;
         usedList.push(_local_2);
         dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_MAP,_local_2));
      }
      
      public static function removeInMap(_arg_1:FitmentInfo) : void
      {
         var _local_2:int = int(usedList.indexOf(_arg_1));
         if(_local_2 != -1)
         {
            usedList.splice(_local_2,1);
            dispatchEvent(new FitmentEvent(FitmentEvent.REMOVE_TO_MAP,_arg_1));
         }
      }
      
      public static function removeAllInMap() : void
      {
         var f:FitmentInfo = null;
         usedList.forEach(function(_arg_1:FitmentInfo, _arg_2:int, _arg_3:Array):void
         {
            var _local_4:FitmentInfo = null;
            if(_arg_1.type == SolidType.FRAME)
            {
               f = _arg_1;
            }
            else
            {
               _local_4 = storageMap.getValue(_arg_1.id);
               if(Boolean(_local_4))
               {
                  ++_local_4.unUsedCount;
               }
               else
               {
                  _arg_1.allCount = 1;
                  storageMap.add(_arg_1.id,_arg_1);
               }
            }
         });
         if(Boolean(f))
         {
            usedList = [f];
         }
         dispatchEvent(new FitmentEvent(FitmentEvent.REMOVE_ALL_TO_MAP,null));
         dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_STORAGE,null));
      }
      
      public static function getUsedList() : Array
      {
         return usedList;
      }
      
      public static function containsUsed(id:uint) : Boolean
      {
         return usedList.some(function(_arg_1:FitmentInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(id == _arg_1.id)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function clearUsed() : void
      {
         usedList = [];
      }
      
      public static function getStorageInfo(teamID:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.HEAD_GET_ALL_INFO,function(_arg_1:SocketEvent):void
         {
            var _local_3:HeadquarterInfo = null;
            var _local_6:int = 0;
            SocketConnection.removeCmdListener(CommandID.HEAD_GET_ALL_INFO,arguments.callee);
            storageMap.clear();
            var _local_4:ByteArray = _arg_1.data as ByteArray;
            teamID = _local_4.readUnsignedInt();
            var _local_5:int = int(_local_4.readUnsignedInt());
            while(_local_6 < _local_5)
            {
               _local_3 = new HeadquarterInfo();
               FitmentInfo.setFor10007(_local_3,_local_4);
               storageMap.add(_local_3.id,_local_3);
               _local_6++;
            }
            dispatchEvent(new FitmentEvent(FitmentEvent.STORAGE_LIST,null));
         });
         SocketConnection.send(CommandID.HEAD_GET_ALL_INFO,teamID);
      }
      
      public static function addInStorage(_arg_1:FitmentInfo) : void
      {
         var _local_2:FitmentInfo = storageMap.getValue(_arg_1.id);
         if(Boolean(_local_2))
         {
            ++_local_2.unUsedCount;
            dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_STORAGE,_local_2));
         }
         else
         {
            _arg_1.allCount = 1;
            storageMap.add(_arg_1.id,_arg_1);
            dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_STORAGE,_arg_1));
         }
      }
      
      public static function removeInStorage(_arg_1:uint) : void
      {
         var _local_2:FitmentInfo = storageMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            if(_local_2.unUsedCount > 1)
            {
               --_local_2.allCount;
            }
            else
            {
               storageMap.remove(_arg_1);
            }
            dispatchEvent(new FitmentEvent(FitmentEvent.REMOVE_TO_STORAGE,_local_2));
         }
      }
      
      public static function getAllList() : Array
      {
         return storageMap.getValues();
      }
      
      public static function getUnUsedList() : Array
      {
         var data:Array = storageMap.getValues();
         return data.filter(function(_arg_1:FitmentInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(_arg_1.unUsedCount > 0)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function getUsedListForAll() : Array
      {
         var data:Array = storageMap.getValues();
         return data.filter(function(_arg_1:FitmentInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(_arg_1.usedCount > 0)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function getUnUsedListForType(t:uint) : Array
      {
         var data:Array = storageMap.getValues();
         return data.filter(function(_arg_1:FitmentInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(_arg_1.unUsedCount > 0)
            {
               if(_arg_1.type == t)
               {
                  return true;
               }
            }
            return false;
         });
      }
      
      public static function containsStorage(_arg_1:uint) : Boolean
      {
         var _local_2:FitmentInfo = storageMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            if(_local_2.unUsedCount > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function containsAll(_arg_1:uint) : Boolean
      {
         return storageMap.containsKey(_arg_1);
      }
      
      public static function clearAll() : void
      {
         return storageMap.clear();
      }
      
      public static function destroy() : void
      {
         _sprite = null;
         _parent = null;
         _info = null;
         storagePanel = null;
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
         if(hasEventListener(_arg_1.type))
         {
            getInstance().dispatchEvent(_arg_1);
         }
      }
      
      public static function hasEventListener(_arg_1:String) : Boolean
      {
         return getInstance().hasEventListener(_arg_1);
      }
      
      public static function willTrigger(_arg_1:String) : Boolean
      {
         return getInstance().willTrigger(_arg_1);
      }
   }
}

