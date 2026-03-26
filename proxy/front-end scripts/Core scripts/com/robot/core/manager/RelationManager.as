package com.robot.core.manager
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.info.relation.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import flash.events.*;
   import flash.net.SharedObject;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   
   public class RelationManager
   {
      
      private static var _friendList:HashMap;
      
      private static var _blackList:HashMap;
      
      private static var _friendOnLineLength:uint;
      
      private static var _so:SharedObject;
      
      private static var _relSO:SharedObject;
      
      private static var _soFriendTimePokeSet:HashSet;
      
      private static var instance:EventDispatcher;
      
      private static const SO_FRIEND:String = "friend";
      
      private static const SO_BLACK:String = "black";
      
      private static var _allowAdd:Boolean = true;
      
      private static var _isFriendInfo:Boolean = true;
      
      private static var _isBlackInfo:Boolean = true;
      
      public function RelationManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _so = SOManager.getUser_Info();
         if(_so.data.hasOwnProperty("allowAdd"))
         {
            _allowAdd = _so.data.allowAdd;
         }
      }
      
      public static function get F_MAX() : int
      {
         if(MainManager.actorInfo == null)
         {
            return 100;
         }
         if(Boolean(MainManager.actorInfo.vip))
         {
            return 200;
         }
         return 100;
      }
      
      public static function get allowAdd() : Boolean
      {
         return _allowAdd;
      }
      
      public static function set allowAdd(_arg_1:Boolean) : void
      {
         _allowAdd = _arg_1;
         _so = SOManager.getUser_Info();
         _so.data.allowAdd = _arg_1;
         SOManager.flush(_so);
      }
      
      public static function getFriendInfos(prior:Boolean = true) : Array
      {
         var arr:Array = _friendList.getValues();
         if(prior)
         {
            arr.forEach(function(_arg_1:UserInfo, _arg_2:int, _arg_3:Array):void
            {
               _arg_1.priorLevel = 0;
               if(Boolean(_arg_1.vip))
               {
                  _arg_1.priorLevel += 2;
               }
               if(_arg_1.teacherID == MainManager.actorID)
               {
                  _arg_1.priorLevel += 1;
               }
               if(_arg_1.studentID == MainManager.actorID)
               {
                  _arg_1.priorLevel += 1;
               }
               if(Boolean(_arg_1.serverID))
               {
                  _arg_1.priorLevel += 3;
               }
            });
            arr.sortOn("priorLevel",Array.DESCENDING | Array.NUMERIC);
         }
         return arr;
      }
      
      public static function get friendIDs() : Array
      {
         return _friendList.getKeys();
      }
      
      public static function get blackInfos() : Array
      {
         return _blackList.getValues();
      }
      
      public static function get blackIDs() : Array
      {
         return _blackList.getKeys();
      }
      
      public static function get friendLength() : int
      {
         return _friendList.length;
      }
      
      public static function get blackLength() : int
      {
         return _blackList.length;
      }
      
      public static function get friendOnLineLength() : int
      {
         return _friendOnLineLength;
      }
      
      public static function init(_arg_1:IDataInput) : void
      {
         var _local_2:UserInfo = null;
         var _local_3:UserInfo = null;
         _friendList = new HashMap();
         soInit();
      }
      
      private static function soInit() : void
      {
         var _local_1:Array = null;
         var _local_2:Array = null;
         var _local_3:UserInfo = null;
         var _local_4:Boolean = false;
         var _local_5:Object = null;
         _relSO = SOManager.getUser_Relation();
         if(_relSO.data.hasOwnProperty(SO_FRIEND))
         {
            _soFriendTimePokeSet = new HashSet();
            _local_1 = _relSO.data[SO_FRIEND];
            _local_2 = _friendList.getValues();
            for each(_local_3 in _local_2)
            {
               _local_4 = false;
               for each(_local_5 in _local_1)
               {
                  if(_local_3.userID == _local_5.userID)
                  {
                     _local_4 = true;
                     if(_local_3.timePoke > _local_5.timePoke)
                     {
                        _soFriendTimePokeSet.add(_local_3);
                     }
                     _local_3.hasSimpleInfo = true;
                     _local_3.nick = _local_5.nick;
                     _local_3.color = _local_5.color;
                     _local_3.texture = _local_5.texture;
                     _local_3.vip = _local_5.vip;
                     _local_3.status = _local_5.status;
                     _local_3.mapID = _local_5.mapID;
                     _local_3.isCanBeTeacher = _local_5.isCanBeTeacher;
                     _local_3.teacherID = _local_5.teacherID;
                     _local_3.studentID = _local_5.studentID;
                     _local_3.graduationCount = _local_5.graduationCount;
                     _local_3.clothes = _local_5.clothes.slice();
                     break;
                  }
               }
               if(!_local_4)
               {
                  _soFriendTimePokeSet.add(_local_3);
               }
            }
         }
      }
      
      public static function isFriend(_arg_1:uint) : Boolean
      {
         return _friendList.containsKey(_arg_1);
      }
      
      public static function isBlack(_arg_1:uint) : Boolean
      {
         return _blackList.containsKey(_arg_1);
      }
      
      public static function getFriendInfo(_arg_1:uint) : UserInfo
      {
         return _friendList.getValue(_arg_1) as UserInfo;
      }
      
      public static function getBlackInfo(_arg_1:uint) : UserInfo
      {
         return _blackList.getValue(_arg_1) as UserInfo;
      }
      
      public static function addFriend(_arg_1:uint) : void
      {
         if(MainManager.actorID == _arg_1)
         {
            Alarm.show("不能把自己添加为好友！");
            return;
         }
         if(friendLength >= F_MAX)
         {
            Alarm.show("好友达到上限！");
            return;
         }
         if(_friendList.containsKey(_arg_1))
         {
            Alarm.show("好友已经存在！");
            return;
         }
         SocketConnection.send(CommandID.FRIEND_ADD,_arg_1);
      }
      
      public static function addFriendInfo(_arg_1:UserInfo) : void
      {
         if(MainManager.actorID == _arg_1.userID)
         {
            return;
         }
         if(friendLength >= F_MAX)
         {
            return;
         }
         if(_friendList.containsKey(_arg_1.userID))
         {
            return;
         }
         if(_blackList.remove(_arg_1.userID))
         {
            dispatchEvent(new RelationEvent(RelationEvent.BLACK_REMOVE,_arg_1.userID));
         }
         _friendList.add(_arg_1.userID,_arg_1);
         dispatchEvent(new RelationEvent(RelationEvent.FRIEND_ADD,_arg_1.userID));
      }
      
      public static function removeFriend(userID:uint) : void
      {
         if(!_friendList.containsKey(userID))
         {
            return;
         }
         SocketConnection.addCmdListener(CommandID.FRIEND_REMOVE,function(_arg_1:SocketEvent):void
         {
            if(_friendList.remove(userID))
            {
               dispatchEvent(new RelationEvent(RelationEvent.FRIEND_REMOVE,userID));
            }
            SocketConnection.removeCmdListener(CommandID.FRIEND_REMOVE,arguments.callee);
         });
         SocketConnection.send(CommandID.FRIEND_REMOVE,userID);
      }
      
      public static function addBlack(userID:uint) : void
      {
         if(MainManager.actorID == userID)
         {
            Alarm.show("不能把自己添加进黑名单！");
            return;
         }
         if(_blackList.containsKey(userID))
         {
            Alarm.show("用户已经存在于黑名单！");
            return;
         }
         SocketConnection.addCmdListener(CommandID.BLACK_ADD,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.BLACK_ADD,arguments.callee);
            var _local_3:ByteArray = _arg_1.data as ByteArray;
            var _local_4:uint = _local_3.readUnsignedInt();
            var _local_5:UserInfo = new UserInfo();
            _local_5.userID = _local_4;
            _local_5.timePoke = 0;
            if(_friendList.remove(_local_4))
            {
               dispatchEvent(new RelationEvent(RelationEvent.FRIEND_REMOVE,_local_4));
            }
            _blackList.add(_local_4,_local_5);
            dispatchEvent(new RelationEvent(RelationEvent.BLACK_ADD,_local_4));
            upDateInfo(_local_4);
         });
         SocketConnection.send(CommandID.BLACK_ADD,userID);
      }
      
      public static function addBlackInfo(_arg_1:UserInfo) : void
      {
         if(MainManager.actorID == _arg_1.userID)
         {
            return;
         }
         if(_blackList.containsKey(_arg_1.userID))
         {
            return;
         }
         if(_friendList.remove(_arg_1.userID))
         {
            dispatchEvent(new RelationEvent(RelationEvent.FRIEND_REMOVE,_arg_1.userID));
         }
         _blackList.add(_arg_1.userID,_arg_1);
         dispatchEvent(new RelationEvent(RelationEvent.BLACK_ADD,_arg_1.userID));
      }
      
      public static function removeBlack(userID:uint) : void
      {
         if(!_blackList.containsKey(userID))
         {
            return;
         }
         SocketConnection.addCmdListener(CommandID.BLACK_REMOVE,function(_arg_1:SocketEvent):void
         {
            if(_blackList.remove(userID))
            {
               dispatchEvent(new RelationEvent(RelationEvent.BLACK_REMOVE,userID));
            }
            SocketConnection.removeCmdListener(CommandID.BLACK_REMOVE,arguments.callee);
         });
         SocketConnection.send(CommandID.BLACK_REMOVE,userID);
      }
      
      public static function answerFriend(_arg_1:uint, _arg_2:Boolean) : void
      {
         SocketConnection.send(CommandID.FRIEND_ANSWER,_arg_1,uint(_arg_2));
      }
      
      public static function setOnLineFriend() : void
      {
         var k:int = 0;
         var info:UserInfo = null;
         var arr:Array = _friendList.getKeys();
         var arrLen:int = int(arr.length);
         k = 0;
         while(k < arrLen)
         {
            info = _friendList.getValue(arr[k]) as UserInfo;
            info.serverID = 0;
            k += 1;
         }
         UserInfoManager.seeOnLine(arr,function(_arg_1:Array):void
         {
            var _local_2:OnLineInfo = null;
            var _local_3:UserInfo = null;
            var _local_4:int = 0;
            _friendOnLineLength = _arg_1.length;
            if(_friendOnLineLength == 0)
            {
               dispatchEvent(new RelationEvent(RelationEvent.FRIEND_UPDATE_ONLINE));
               setFriendInfo();
               return;
            }
            while(_local_4 < _friendOnLineLength)
            {
               _local_2 = _arg_1[_local_4] as OnLineInfo;
               _local_3 = _friendList.getValue(_local_2.userID) as UserInfo;
               if(Boolean(_local_3))
               {
                  _local_3.mapID = _local_2.mapID;
                  _local_3.serverID = _local_2.serverID;
               }
               _local_4++;
            }
            dispatchEvent(new RelationEvent(RelationEvent.FRIEND_UPDATE_ONLINE));
            setFriendInfo();
         });
      }
      
      public static function setFriendInfo() : void
      {
         var _fInfos:Array = null;
         var _fKeyLen:int = 0;
         _fInfos = null;
         _fKeyLen = 0;
         var loopInfo:Function = function(i:int):void
         {
            if(i == _fKeyLen)
            {
               dispatchEvent(new RelationEvent(RelationEvent.UPDATE_INFO));
               _fInfos = null;
               _fKeyLen = NaN;
               if(Boolean(_relSO))
               {
                  _relSO.data[SO_FRIEND] = _friendList.getValues();
                  SOManager.flush(_relSO);
               }
               return;
            }
            UserInfoManager.upDateSimpleInfo(_fInfos[i],function():void
            {
               ++i;
               loopInfo(i);
            });
         };
         if(!_isFriendInfo)
         {
            return;
         }
         _isFriendInfo = false;
         if(_soFriendTimePokeSet == null)
         {
            _fInfos = _friendList.getValues();
         }
         else
         {
            _fInfos = _soFriendTimePokeSet.toArray();
         }
         _fKeyLen = int(_fInfos.length);
         if(_fKeyLen == 0)
         {
            return;
         }
         loopInfo(0);
      }
      
      public static function setBlackInfo() : void
      {
         var _fInfos:Array = null;
         var _fKeyLen:int = 0;
         _fInfos = null;
         _fKeyLen = 0;
         var loopInfo:Function = function(i:int):void
         {
            if(i == _fKeyLen)
            {
               dispatchEvent(new RelationEvent(RelationEvent.UPDATE_INFO));
               _fInfos = null;
               _fKeyLen = NaN;
               return;
            }
            UserInfoManager.upDateSimpleInfo(_fInfos[i],function():void
            {
               ++i;
               loopInfo(i);
            });
         };
         if(!_isBlackInfo)
         {
            return;
         }
         _isBlackInfo = false;
         _fInfos = _blackList.getValues();
         _fKeyLen = int(_fInfos.length);
         loopInfo(0);
      }
      
      public static function upDateInfo(id:uint) : void
      {
         var rel:UserInfo = null;
         rel = null;
         rel = _friendList.getValue(id) as UserInfo;
         if(rel == null)
         {
            rel = _blackList.getValue(id) as UserInfo;
         }
         if(Boolean(rel))
         {
            UserInfoManager.upDateSimpleInfo(rel,function():void
            {
               dispatchEvent(new RelationEvent(RelationEvent.UPDATE_INFO,rel.userID));
            });
         }
      }
      
      public static function upDateInfoForSimpleInfo(_arg_1:UserInfo) : void
      {
         var _local_2:UserInfo = _friendList.getValue(_arg_1.userID) as UserInfo;
         if(_local_2 == null)
         {
            _local_2 = _blackList.getValue(_arg_1.userID) as UserInfo;
         }
         if(Boolean(_local_2))
         {
            _local_2.hasSimpleInfo = true;
            _local_2.nick = _arg_1.nick;
            _local_2.color = _arg_1.color;
            _local_2.texture = _arg_1.texture;
            _local_2.vip = _arg_1.vip;
            _local_2.status = _arg_1.status;
            _local_2.mapID = _arg_1.mapID;
            _local_2.isCanBeTeacher = _arg_1.isCanBeTeacher;
            _local_2.teacherID = _arg_1.teacherID;
            _local_2.studentID = _arg_1.studentID;
            _local_2.graduationCount = _arg_1.graduationCount;
            _local_2.clothes = _arg_1.clothes.slice();
            dispatchEvent(new RelationEvent(RelationEvent.UPDATE_INFO,_local_2.userID));
         }
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            instance = new EventDispatcher();
         }
         return instance;
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

