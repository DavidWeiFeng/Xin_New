package com.robot.core.manager
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.ChatInfo;
   import com.robot.core.info.InformInfo;
   import com.robot.core.info.TeamChatInfo;
   import com.robot.core.info.team.TeamInformInfo;
   import flash.events.*;
   import org.taomee.ds.*;
   
   public class MessageManager
   {
      
      private static var instance:EventDispatcher;
      
      public static const SYS_TYPE:uint = 1;
      
      public static const TEAM_TYPE:uint = 2;
      
      public static const TEAM_CHAT_TYPE:uint = 3;
      
      private static const MAX:int = 300;
      
      private static var _userMap:HashMap = new HashMap();
      
      private static var _unReadList:Array = [];
      
      private static var teamAddInfoMap:HashMap = new HashMap();
      
      public static var inviteJoinTeamMap:HashMap = new HashMap();
      
      public static var friendAddInfoMap:HashMap = new HashMap();
      
      public static var friendAnswerInfoMap:HashMap = new HashMap();
      
      public static var friendRemoveInfoMap:HashMap = new HashMap();
      
      public function MessageManager()
      {
         super();
      }
      
      public static function addChatInfo(_arg_1:ChatInfo) : void
      {
         if(RelationManager.isBlack(_arg_1.senderID))
         {
            return;
         }
         var _local_2:String = ChatEvent.TALK + _arg_1.talkID.toString();
         if(hasEventListener(_local_2))
         {
            dispatchEvent(new ChatEvent(_local_2,_arg_1));
         }
         else
         {
            _unReadList.push({
               "_id":_arg_1.talkID,
               "_info":_arg_1
            });
            dispatchEvent(new RobotEvent(RobotEvent.MESSAGE));
         }
         var _local_3:Array = _userMap.getValue(_arg_1.talkID);
         if(_local_3 == null)
         {
            _local_3 = [];
            _userMap.add(_arg_1.talkID,_local_3);
         }
         _local_3.push(_arg_1);
         if(_local_3.length > MAX)
         {
            _local_3.shift();
         }
      }
      
      public static function addInformInfo(_arg_1:InformInfo) : void
      {
         if(_arg_1.type == CommandID.FRIEND_ADD)
         {
            if(RelationManager.friendLength >= RelationManager.F_MAX)
            {
               return;
            }
            if(friendAddInfoMap.containsKey(_arg_1.userID))
            {
               dispatchEvent(new RobotEvent(RobotEvent.ADD_FRIEND_MSG));
               return;
            }
            friendAddInfoMap.add(_arg_1.userID,_arg_1);
            dispatchEvent(new RobotEvent(RobotEvent.ADD_FRIEND_MSG));
            return;
         }
         if(_arg_1.type == CommandID.TEAM_ADD)
         {
            if(teamAddInfoMap.containsKey(_arg_1.userID))
            {
               return;
            }
            teamAddInfoMap.add(_arg_1.userID,_arg_1);
         }
         _unReadList.push({
            "_id":SYS_TYPE,
            "_info":_arg_1
         });
         dispatchEvent(new RobotEvent(RobotEvent.MESSAGE));
      }
      
      public static function addTeamInformInfo(_arg_1:TeamInformInfo) : void
      {
         if(_arg_1.type == CommandID.TEAM_INVITE_TO_JOIN)
         {
            inviteJoinTeamMap.add(_arg_1.userID,_arg_1);
            dispatchEvent(new RobotEvent(RobotEvent.ADD_TEAM_MSG));
            return;
         }
         _unReadList.push({
            "_id":TEAM_TYPE,
            "_info":_arg_1
         });
         dispatchEvent(new RobotEvent(RobotEvent.MESSAGE));
      }
      
      public static function addTeamChatInfo(_arg_1:TeamChatInfo) : void
      {
         var _local_2:Object = null;
         var _local_3:Boolean = false;
         for each(_local_2 in _unReadList)
         {
            if(_local_2._id == TEAM_CHAT_TYPE)
            {
               _local_3 = true;
               break;
            }
         }
         if(!_local_3)
         {
            _unReadList.push({
               "_id":TEAM_CHAT_TYPE,
               "_info":_arg_1
            });
            dispatchEvent(new RobotEvent(RobotEvent.MESSAGE));
         }
      }
      
      public static function removeUnUserID(userID:uint) : void
      {
         _unReadList = _unReadList.filter(function(_arg_1:Object, _arg_2:int, _arg_3:Array):Boolean
         {
            if(_arg_1._id == userID)
            {
               return false;
            }
            return true;
         });
      }
      
      public static function getChatInfo(_arg_1:uint) : Array
      {
         return _userMap.getValue(_arg_1);
      }
      
      public static function getInformInfo() : InformInfo
      {
         var _local_1:InformInfo = null;
         var _local_3:int = 0;
         var _local_2:int = int(_unReadList.length);
         while(_local_3 < _local_2)
         {
            if(_unReadList[_local_3]._id == SYS_TYPE)
            {
               _local_1 = _unReadList[_local_3]._info;
               _unReadList.splice(_local_3,1);
               if(_local_1.type == CommandID.TEAM_ADD)
               {
                  if(teamAddInfoMap.containsKey(_local_1.userID))
                  {
                     teamAddInfoMap.remove(_local_1.userID);
                  }
               }
               else if(_local_1.type == CommandID.FRIEND_ADD)
               {
                  if(friendAddInfoMap.containsKey(_local_1.userID))
                  {
                     friendAddInfoMap.remove(_local_1.userID);
                  }
               }
               return _local_1;
            }
            _local_3++;
         }
         return null;
      }
      
      public static function getInviteJoinTeamInfo(_arg_1:uint) : TeamInformInfo
      {
         if(inviteJoinTeamMap.containsKey(_arg_1))
         {
            return inviteJoinTeamMap.getValue(_arg_1);
         }
         return null;
      }
      
      public static function removeAddFridInfo(_arg_1:uint) : void
      {
         if(friendAddInfoMap.containsKey(_arg_1))
         {
            friendAddInfoMap.remove(_arg_1);
         }
      }
      
      public static function removeInviteJoinTeamInfo(_arg_1:uint) : void
      {
         if(inviteJoinTeamMap.containsKey(_arg_1))
         {
            inviteJoinTeamMap.remove(_arg_1);
         }
      }
      
      public static function getTeamInformInfo() : TeamInformInfo
      {
         var _local_1:TeamInformInfo = null;
         var _local_3:int = 0;
         var _local_2:int = int(_unReadList.length);
         while(_local_3 < _local_2)
         {
            if(_unReadList[_local_3]._id == TEAM_TYPE)
            {
               _local_1 = _unReadList[_local_3]._info;
               _unReadList.splice(_local_3,1);
               return _local_1;
            }
            _local_3++;
         }
         return null;
      }
      
      public static function getTeamChatInfo() : TeamChatInfo
      {
         var _local_1:TeamChatInfo = null;
         var _local_3:int = 0;
         var _local_2:int = int(_unReadList.length);
         while(_local_3 < _local_2)
         {
            if(_unReadList[_local_3]._id == TEAM_CHAT_TYPE)
            {
               _local_1 = _unReadList[_local_3]._info;
               _unReadList.splice(_local_3,1);
               return _local_1;
            }
            _local_3++;
         }
         return null;
      }
      
      public static function getFristUnReadID() : uint
      {
         if(_unReadList.length > 0)
         {
            return _unReadList[0]._id;
         }
         return 0;
      }
      
      public static function unReadLength() : int
      {
         return _unReadList.length;
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
         getInstance().dispatchEvent(_arg_1);
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

