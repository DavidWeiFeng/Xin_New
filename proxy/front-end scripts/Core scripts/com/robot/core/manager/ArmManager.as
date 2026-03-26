package com.robot.core.manager
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.team.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ArmManager
   {
      
      public static var isChange:Boolean;
      
      public static var isChangeForUpgrade:Boolean;
      
      public static var storagePanel:Sprite;
      
      public static var teamID:uint;
      
      public static var headquartersID:uint;
      
      private static var _sprite:Sprite;
      
      private static var _info:ArmInfo;
      
      private static var _parent:DisplayObjectContainer;
      
      private static var _type:int;
      
      private static var _offp:Point;
      
      private static var _flomc:DisplayObject;
      
      private static var _isMove:Boolean;
      
      private static var _instance:EventDispatcher;
      
      private static var _isArrlowInMap:Boolean = true;
      
      private static var _usedList:Array = [];
      
      private static var _allMap:HashMap = new HashMap();
      
      private static var _upUsedList:Array = [];
      
      private static var _upAllMap:HashMap = new HashMap();
      
      public function ArmManager()
      {
         super();
      }
      
      public static function getMax() : uint
      {
         return 15;
      }
      
      public static function get dragInMapEnabled() : Boolean
      {
         if(_upUsedList.length < getMax())
         {
            return true;
         }
         return false;
      }
      
      public static function doDrag(_arg_1:Sprite, _arg_2:ArmInfo, _arg_3:DisplayObjectContainer, _arg_4:int, _arg_5:Point = null) : void
      {
         var _local_6:Point = null;
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
         _isMove = false;
         if(Boolean(MapManager.currentMap.animatorLevel))
         {
            _flomc = MapManager.currentMap.animatorLevel.getChildByName("floMC");
         }
      }
      
      public static function setIsChange(_arg_1:ArmInfo = null) : void
      {
         if(_arg_1 == null)
         {
            _arg_1 = _info;
         }
         if(_arg_1.buyTime == 0)
         {
            isChange = true;
         }
         else
         {
            isChangeForUpgrade = true;
         }
      }
      
      public static function saveInfo() : void
      {
         var _local_1:ArmInfo = null;
         var _local_2:int = 0;
         var _local_3:ByteArray = null;
         var _local_4:int = 0;
         var _local_5:ByteArray = null;
         if(isChange)
         {
            isChange = false;
            _local_2 = int(_usedList.length);
            _local_3 = new ByteArray();
            _local_3.writeUnsignedInt(_local_2);
            for each(_local_1 in _usedList)
            {
               _local_3.writeUnsignedInt(_local_1.id);
               _local_3.writeUnsignedInt(_local_1.pos.x);
               _local_3.writeUnsignedInt(_local_1.pos.y);
               _local_3.writeUnsignedInt(_local_1.dir);
               _local_3.writeUnsignedInt(_local_1.status);
            }
            SocketConnection.send(CommandID.ARM_SET_INFO,_local_3);
         }
         _local_1 = null;
         if(isChangeForUpgrade)
         {
            isChangeForUpgrade = false;
            _local_4 = _upUsedList.length - 1;
            _local_5 = new ByteArray();
            _local_5.writeUnsignedInt(_local_4);
            for each(_local_1 in _upUsedList)
            {
               if(_local_1.id != 1)
               {
                  _local_5.writeUnsignedInt(_local_1.id);
                  _local_5.writeUnsignedInt(_local_1.buyTime);
                  _local_5.writeUnsignedInt(_local_1.pos.x);
                  _local_5.writeUnsignedInt(_local_1.pos.y);
                  _local_5.writeUnsignedInt(_local_1.dir);
                  _local_5.writeUnsignedInt(_local_1.status);
               }
            }
            SocketConnection.send(CommandID.ARM_UP_SET_INFO,_local_5);
         }
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
         else if(_flomc.hitTestPoint(_local_2.x,_local_2.y,true))
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
         setIsChange();
         if(_type == DragTargetType.MAP)
         {
            _info.pos = _arg_1;
            _sprite.x = 0;
            _sprite.y = 0;
            _sprite.mouseEnabled = true;
            _sprite.mouseChildren = true;
            _parent.x = _arg_1.x;
            _parent.y = _arg_1.y;
            _parent.addChild(_sprite);
            DepthManager.swapDepth(_parent,_parent.y);
         }
         else
         {
            _info.pos = _arg_1;
            addInMap(_info);
            if(_type == DragTargetType.STORAGE)
            {
               DisplayUtil.removeForParent(_sprite);
               removeInStorage(_info);
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
               dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_STORAGE,_info));
            }
            else
            {
               setIsChange();
               if(_info.type == SolidType.PUT)
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
               removeInStorage(_info);
               DisplayUtil.removeForParent(_sprite);
            }
         }
         else
         {
            addInStorage(_info);
            if(_type == DragTargetType.MAP)
            {
               setIsChange();
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
            return;
         }
         _sprite.alpha = 1;
         _sprite.x = 0;
         _sprite.y = 0;
         _sprite.mouseEnabled = true;
         _parent.addChild(_sprite);
      }
      
      public static function getUsedInfoForServer(tID:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ARM_GET_USED_INFO,function(_arg_1:SocketEvent):void
         {
            var _local_3:ArmInfo = null;
            var _local_4:ArmInfo = null;
            var _local_5:Boolean = false;
            var _local_8:int = 0;
            SocketConnection.removeCmdListener(CommandID.ARM_GET_USED_INFO,arguments.callee);
            _usedList = [];
            var _local_6:ByteArray = _arg_1.data as ByteArray;
            teamID = _local_6.readUnsignedInt();
            headquartersID = _local_6.readUnsignedInt();
            var _local_7:uint = _local_6.readUnsignedInt();
            while(_local_8 < _local_7)
            {
               _local_3 = new ArmInfo();
               ArmInfo.setFor2941(_local_3,_local_6);
               if(_local_3.type == SolidType.FRAME)
               {
                  MapManager.styleID = _local_3.id;
                  _local_5 = true;
               }
               else
               {
                  _usedList.push(_local_3);
               }
               _local_8++;
            }
            if(!_local_5)
            {
               _local_4 = new ArmInfo();
               MapManager.styleID = MapManager.defaultArmStyleID;
               _local_4.id = MapManager.styleID;
               _usedList.push(_local_4);
            }
            dispatchEvent(new ArmEvent(ArmEvent.USED_LIST,null));
         });
         SocketConnection.send(CommandID.ARM_GET_USED_INFO,tID);
      }
      
      public static function getUsedInfoForServer_Up(tID:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ARM_UP_GET_USED_INFO,function(_arg_1:SocketEvent):void
         {
            var _local_3:ArmInfo = null;
            var _local_6:int = 0;
            SocketConnection.removeCmdListener(CommandID.ARM_UP_GET_USED_INFO,arguments.callee);
            _upUsedList = [];
            var _local_4:ByteArray = _arg_1.data as ByteArray;
            teamID = _local_4.readUnsignedInt();
            var _local_5:uint = _local_4.readUnsignedInt();
            while(_local_6 < _local_5)
            {
               _local_3 = new ArmInfo();
               ArmInfo.setFor2967_2965(_local_3,_local_4);
               _local_3.isUsed = true;
               _upUsedList.push(_local_3);
               _local_6++;
            }
            dispatchEvent(new ArmEvent(ArmEvent.UP_USED_LIST,null));
         });
         SocketConnection.send(CommandID.ARM_UP_GET_USED_INFO,tID);
      }
      
      public static function addInMap(_arg_1:ArmInfo) : void
      {
         var _local_2:ArmInfo = _arg_1.clone();
         if(_local_2.buyTime == 0)
         {
            _usedList.push(_local_2);
         }
         else
         {
            _local_2.isUsed = true;
            _upUsedList.push(_local_2);
         }
         dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_MAP,_local_2));
      }
      
      public static function removeInMap(_arg_1:ArmInfo) : void
      {
         var _local_2:int = 0;
         if(_arg_1.buyTime == 0)
         {
            _local_2 = int(_usedList.indexOf(_arg_1));
            if(_local_2 != -1)
            {
               _usedList.splice(_local_2,1);
               dispatchEvent(new ArmEvent(ArmEvent.REMOVE_TO_MAP,_arg_1));
            }
         }
         else
         {
            _local_2 = int(_upUsedList.indexOf(_arg_1));
            if(_local_2 != -1)
            {
               _upUsedList.splice(_local_2,1);
               dispatchEvent(new ArmEvent(ArmEvent.REMOVE_TO_MAP,_arg_1));
            }
         }
      }
      
      public static function removeAllInMap() : void
      {
         var f:ArmInfo = null;
         var uh:ArmInfo = null;
         _usedList.forEach(function(_arg_1:ArmInfo, _arg_2:int, _arg_3:Array):void
         {
            var _local_4:ArmInfo = null;
            if(_arg_1.type == SolidType.FRAME)
            {
               f = _arg_1;
            }
            else
            {
               _local_4 = _allMap.getValue(_arg_1.id);
               if(Boolean(_local_4))
               {
                  ++_local_4.unUsedCount;
               }
               else
               {
                  _arg_1.allCount = 1;
                  _allMap.add(_arg_1.id,_arg_1);
               }
            }
         });
         if(Boolean(f))
         {
            _usedList = [f];
         }
         _upUsedList.forEach(function(_arg_1:ArmInfo, _arg_2:int, _arg_3:Array):void
         {
            if(_arg_1.type == SolidType.HEAD)
            {
               uh = _arg_1;
            }
            else
            {
               _arg_1.isUsed = false;
               _upAllMap.add(_arg_1.buyTime,_arg_1);
            }
         });
         if(Boolean(uh))
         {
            _upUsedList = [uh];
         }
         dispatchEvent(new ArmEvent(ArmEvent.REMOVE_ALL_TO_MAP,null));
         dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_STORAGE,null));
      }
      
      public static function getUsedList() : Array
      {
         return _usedList;
      }
      
      public static function getUsedList_Up() : Array
      {
         return _upUsedList;
      }
      
      public static function containsUsed(_arg_1:uint) : Boolean
      {
         var _local_2:ArmInfo = null;
         for each(_local_2 in _usedList)
         {
            if(_arg_1 == _local_2.id)
            {
               return true;
            }
         }
         _local_2 = null;
         for each(_local_2 in _upUsedList)
         {
            if(_arg_1 == _local_2.id)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getAllInfoForServer(tid:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ARM_GET_ALL_INFO,function(_arg_1:SocketEvent):void
         {
            var _local_3:ArmInfo = null;
            var _local_6:int = 0;
            SocketConnection.removeCmdListener(CommandID.ARM_GET_ALL_INFO,arguments.callee);
            _allMap.clear();
            var _local_4:ByteArray = _arg_1.data as ByteArray;
            teamID = _local_4.readUnsignedInt();
            var _local_5:int = int(_local_4.readUnsignedInt());
            while(_local_6 < _local_5)
            {
               _local_3 = new ArmInfo();
               ArmInfo.setFor2942(_local_3,_local_4);
               _allMap.add(_local_3.id,_local_3);
               _local_6++;
            }
            dispatchEvent(new ArmEvent(ArmEvent.ALL_LIST,null));
         });
         SocketConnection.send(CommandID.ARM_GET_ALL_INFO,tid);
      }
      
      public static function getAllInfoForServer_Up(tid:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ARM_UP_GET_ALL_INFO,function(_arg_1:SocketEvent):void
         {
            var _local_3:ArmInfo = null;
            var _local_6:int = 0;
            SocketConnection.removeCmdListener(CommandID.ARM_UP_GET_ALL_INFO,arguments.callee);
            _upAllMap.clear();
            var _local_4:ByteArray = _arg_1.data as ByteArray;
            teamID = _local_4.readUnsignedInt();
            var _local_5:int = int(_local_4.readUnsignedInt());
            while(_local_6 < _local_5)
            {
               _local_3 = new ArmInfo();
               ArmInfo.setFor2966(_local_3,_local_4);
               _upAllMap.add(_local_3.buyTime,_local_3);
               _local_6++;
            }
            dispatchEvent(new ArmEvent(ArmEvent.UP_ALL_LIST,null));
         });
         SocketConnection.send(CommandID.ARM_UP_GET_ALL_INFO,tid);
      }
      
      public static function addInStorage(_arg_1:ArmInfo) : void
      {
         var _local_2:ArmInfo = null;
         if(_arg_1.buyTime == 0)
         {
            _local_2 = _allMap.getValue(_arg_1.id);
            if(Boolean(_local_2))
            {
               ++_local_2.unUsedCount;
               dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_STORAGE,_local_2));
            }
            else
            {
               _arg_1.allCount = 1;
               _allMap.add(_arg_1.id,_arg_1);
               dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_STORAGE,_arg_1));
            }
         }
         else
         {
            _arg_1.isUsed = false;
            _upAllMap.add(_arg_1.buyTime,_arg_1);
            dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_STORAGE,_arg_1));
         }
      }
      
      public static function removeInStorage(_arg_1:ArmInfo) : void
      {
         var _local_2:ArmInfo = null;
         if(_arg_1.buyTime == 0)
         {
            _local_2 = _allMap.getValue(_arg_1.id);
            if(Boolean(_local_2))
            {
               if(_local_2.unUsedCount > 1)
               {
                  --_local_2.allCount;
               }
               else
               {
                  _allMap.remove(_local_2.id);
               }
               dispatchEvent(new ArmEvent(ArmEvent.REMOVE_TO_STORAGE,_local_2));
            }
         }
         else if(_upAllMap.remove(_arg_1.buyTime))
         {
            dispatchEvent(new ArmEvent(ArmEvent.REMOVE_TO_STORAGE,_arg_1));
         }
      }
      
      public static function getAllList() : Array
      {
         return _allMap.getValues().concat(_upAllMap.getValues());
      }
      
      public static function getUnUsedList() : Array
      {
         var arr:Array = null;
         arr = null;
         arr = [];
         _allMap.eachValue(function(_arg_1:ArmInfo):void
         {
            if(_arg_1.unUsedCount > 0)
            {
               arr.push(_arg_1);
            }
         });
         _upAllMap.eachValue(function(_arg_1:ArmInfo):void
         {
            if(!_arg_1.isUsed)
            {
               arr.push(_arg_1);
            }
         });
         return arr;
      }
      
      public static function getUsedListForAll() : Array
      {
         var arr:Array = null;
         arr = null;
         arr = [];
         _allMap.eachValue(function(_arg_1:ArmInfo):void
         {
            if(_arg_1.usedCount > 0)
            {
               arr.push(_arg_1);
            }
         });
         return arr;
      }
      
      public static function getUnUsedListForType(t:uint) : Array
      {
         var arr:Array = null;
         arr = null;
         arr = [];
         if(t == SolidType.FRAME || t == SolidType.PUT)
         {
            _allMap.eachValue(function(_arg_1:ArmInfo):void
            {
               if(_arg_1.unUsedCount > 0)
               {
                  if(_arg_1.type == t)
                  {
                     arr.push(_arg_1);
                  }
               }
            });
         }
         else
         {
            _upAllMap.eachValue(function(_arg_1:ArmInfo):void
            {
               if(_arg_1.type == t)
               {
                  if(!_arg_1.isUsed)
                  {
                     arr.push(_arg_1);
                  }
               }
            });
         }
         return arr;
      }
      
      public static function containsStorage(_arg_1:uint) : Boolean
      {
         var _local_2:ArmInfo = _allMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            if(_local_2.unUsedCount > 0)
            {
               return true;
            }
         }
         _local_2 = null;
         var _local_3:Array = _upAllMap.getValues();
         for each(_local_2 in _local_3)
         {
            if(_local_2.id == _arg_1)
            {
               if(!_local_2.isUsed)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function containsAll(_arg_1:uint) : Boolean
      {
         var _local_2:Array = null;
         var _local_3:ArmInfo = null;
         if(_allMap.containsKey(_arg_1))
         {
            return true;
         }
         _local_2 = _upAllMap.getValues();
         for each(_local_3 in _local_2)
         {
            if(_local_3.id == _arg_1)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function destroy() : void
      {
         _sprite = null;
         _parent = null;
         _info = null;
         storagePanel = null;
         _flomc = null;
      }
      
      public static function getContributeBounds(func:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.Get_CONTRIBUTE_BOUNDS,function(_arg_1:SocketEvent):void
         {
            var _local_3:uint = 0;
            var _local_4:uint = 0;
            SocketConnection.removeCmdListener(CommandID.Get_CONTRIBUTE_BOUNDS,arguments.callee);
            var _local_5:ByteArray = _arg_1.data as ByteArray;
            var _local_6:uint = _local_5.readUnsignedInt();
            if(_local_6 > 0)
            {
               _local_5.readUnsignedInt();
               _local_3 = _local_5.readUnsignedInt();
               _local_4 = _local_5.readUnsignedInt();
               MainManager.actorInfo.teamInfo.canExContribution -= _local_6 * 10;
               if(MainManager.actorInfo.teamInfo.canExContribution < 0)
               {
                  MainManager.actorInfo.teamInfo.canExContribution = 0;
               }
               MainManager.actorInfo.coins += _local_3;
               if(func != null)
               {
                  func();
               }
               Alarm.show("祝贺你领取到了战队贡献奖励：\n" + _local_4 + "积累经验\n" + _local_3 + "个骄阳豆\n你的功绩将会在战队成员间传诵！");
            }
         });
         SocketConnection.send(CommandID.Get_CONTRIBUTE_BOUNDS);
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

