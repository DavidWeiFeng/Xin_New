package com.robot.app.systems
{
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.MessageManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import org.taomee.utils.DisplayUtil;
   
   public class MessageAlarm extends BaseBeanController
   {
      
      private static var _m:MessageAlarmImpl;
      
      public function MessageAlarm()
      {
         super();
      }
      
      private static function get ma() : MessageAlarmImpl
      {
         if(_m == null)
         {
            _m = new MessageAlarmImpl();
         }
         return _m;
      }
      
      public static function show() : void
      {
         if(MessageManager.unReadLength() > 0)
         {
            if(!DisplayUtil.hasParent(ma))
            {
               ma.show();
            }
            ma.setNum();
         }
      }
      
      public static function hide() : void
      {
      }
      
      override public function start() : void
      {
         MessageManager.addEventListener(RobotEvent.MESSAGE,this.onMessage);
         show();
         finish();
      }
      
      private function onMessage(_arg_1:RobotEvent) : void
      {
         show();
      }
   }
}

import com.robot.app.im.*;
import com.robot.app.im.talk.*;
import com.robot.app.user.*;
import com.robot.core.*;
import com.robot.core.event.*;
import com.robot.core.info.*;
import com.robot.core.info.team.TeamInformInfo;
import com.robot.core.manager.*;
import com.robot.core.net.*;
import com.robot.core.ui.alert.*;
import com.robot.core.utils.*;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.*;
import flash.text.TextField;
import org.taomee.events.SocketEvent;
import org.taomee.manager.*;
import org.taomee.utils.*;

class MessageAlarmImpl extends Sprite
{
   
   private var _mainUI:Sprite;
   
   private var _btn:SimpleButton;
   
   private var _txt:TextField;
   
   public function MessageAlarmImpl()
   {
      super();
      this._mainUI = UIManager.getSprite("Message_Icon");
      this._mainUI.buttonMode = true;
      this._btn = this._mainUI["msgBtn"];
      this._txt = this._mainUI["txt"];
      addChild(this._mainUI);
      this._txt.mouseEnabled = false;
      x = 180 + 70;
      y = 20;
   }
   
   public function show() : void
   {
      LevelManager.iconLevel.addChild(this);
      addEventListener(MouseEvent.CLICK,this.onClick);
   }
   
   public function hide() : void
   {
      removeEventListener(MouseEvent.CLICK,this.onClick);
      DisplayUtil.removeForParent(this,false);
   }
   
   public function setNum() : void
   {
      this._txt.text = MessageManager.unReadLength().toString();
   }
   
   private function onClick(_arg_1:MouseEvent) : void
   {
      var _local_2:InformInfo = null;
      var _local_3:TeamInformInfo = null;
      var _local_4:uint = uint(MessageManager.getFristUnReadID());
      if(_local_4 == 0)
      {
         return;
      }
      if(_local_4 == MessageManager.SYS_TYPE)
      {
         _local_2 = MessageManager.getInformInfo();
         if(Boolean(_local_2))
         {
            this.showInform(_local_2);
         }
      }
      else if(_local_4 == MessageManager.TEAM_TYPE)
      {
         _local_3 = MessageManager.getTeamInformInfo();
         if(Boolean(_local_3))
         {
         }
      }
      else if(_local_4 == MessageManager.TEAM_CHAT_TYPE)
      {
         MessageManager.getTeamChatInfo();
         TeamChatController.show();
      }
      else
      {
         MessageManager.removeUnUserID(_local_4);
         TalkPanelManager.showTalkPanel(_local_4);
      }
      if(MessageManager.unReadLength() == 0)
      {
         this.hide();
      }
      this.setNum();
   }
   
   private function showInform(info:InformInfo) : void
   {
      var sprite:Sprite = null;
      var mapName:String = null;
      var rel:UserInfo = new UserInfo();
      rel.userID = info.userID;
      rel.timePoke = 0;
      rel.nick = info.nick;
      rel.mapID = info.mapID;
      rel.serverID = info.serverID;
      switch(info.type)
      {
         case CommandID.FRIEND_ANSWER:
            if(Boolean(info.accept))
            {
               RelationManager.addFriendInfo(rel);
               RelationManager.upDateInfo(info.userID);
               sprite = Alarm.show(TextFormatUtil.getEventTxt(info.nick + "(" + info.userID + ")",info.userID.toString()) + "接受成为了你的好友！",null,false,true);
               sprite.addEventListener(TextEvent.LINK,function(_arg_1:TextEvent):void
               {
                  UserInfoController.show(uint(_arg_1.text));
                  LevelManager.topLevel.addChild(UserInfoController.panel);
               });
            }
            else
            {
               Alarm.show(info.nick + "拒绝成为你的好友！");
            }
            return;
         case CommandID.FRIEND_ADD:
            return;
         case CommandID.REQUEST_OUT:
            mapName = "";
            if(info.mapID > MapManager.ID_MAX)
            {
               mapName = info.nick + "的基地";
            }
            else
            {
               mapName = info.mapName;
            }
            sprite = Answer.show(TextFormatUtil.getEventTxt(info.nick + "(" + info.userID + ")",info.userID.toString()) + "邀请你前往<font color=\'#FF0000\'>" + mapName + "</font>，你同意吗？",function():void
            {
               SocketConnection.addCmdListener(CommandID.REQUEST_ANSWER,function(_arg_1:SocketEvent):void
               {
                  SocketConnection.removeCmdListener(CommandID.REQUEST_ANSWER,arguments.callee);
                  MapManager.changeMap(info.mapID);
               });
               SocketConnection.send(CommandID.REQUEST_ANSWER,info.userID,1);
            },function():void
            {
               SocketConnection.send(CommandID.REQUEST_ANSWER,info.userID,0);
            });
            sprite.addEventListener(TextEvent.LINK,function(_arg_1:TextEvent):void
            {
               UserInfoController.show(uint(_arg_1.text));
               LevelManager.topLevel.addChild(UserInfoController.panel);
            });
            return;
         case CommandID.REQUEST_ANSWER:
            if(Boolean(info.accept))
            {
               sprite = Alarm.show(info.nick + "接受了你的邀请!");
            }
            else
            {
               sprite = Alarm.show(info.nick + "拒绝了你的邀请!");
            }
            sprite.addEventListener(TextEvent.LINK,function(_arg_1:TextEvent):void
            {
               UserInfoController.show(uint(_arg_1.text));
               LevelManager.topLevel.addChild(UserInfoController.panel);
            });
            return;
         case CommandID.REQUEST_REGISTER:
            if(info.accept == 0)
            {
               return;
            }
            sprite = Alarm.show(TextFormatUtil.getEventTxt(info.nick + "(" + info.userID + ")",info.userID.toString()) + "\n    接受了你的邀请，并登陆骄阳计划，自动成为你的好友，快去打招呼吧");
            sprite.addEventListener(TextEvent.LINK,function(_arg_1:TextEvent):void
            {
               UserInfoController.show(uint(_arg_1.text));
               LevelManager.topLevel.addChild(UserInfoController.panel);
            });
            RelationManager.addFriendInfo(rel);
            RelationManager.upDateInfo(info.userID);
            return;
            break;
         case CommandID.REQUEST_ADD_TEACHER:
            EventManager.dispatchEvent(new TeacherEvent(TeacherEvent.REQUEST_ME_AS_TEACHER,info));
            return;
         case CommandID.REQUEST_ADD_STUDENT:
            EventManager.dispatchEvent(new TeacherEvent(TeacherEvent.REQUEST_ME_AS_STUDENT,info));
            return;
         case CommandID.ANSWER_ADD_TEACHER:
            EventManager.dispatchEvent(new TeacherEvent(TeacherEvent.REQUEST_TEACHER_HANDLED,info));
            return;
         case CommandID.ANSWER_ADD_STUDENT:
            EventManager.dispatchEvent(new TeacherEvent(TeacherEvent.REQUEST_STUDENT_HANDLED,info));
            return;
         case CommandID.DELETE_TEACHER:
            EventManager.dispatchEvent(new TeacherEvent(TeacherEvent.DELETE_AS_TEACHER,info));
            return;
         case CommandID.DELETE_STUDENT:
            EventManager.dispatchEvent(new TeacherEvent(TeacherEvent.DELETE_AS_STUDENT,info));
            return;
         case CommandID.EXPERIENCESHARED_COMPLETE:
            if(info.accept > 0)
            {
               MainManager.actorInfo.coins += info.accept;
               sprite = Alarm.show("你的学员:" + TextFormatUtil.getEventTxt(info.nick + "(" + info.userID + ")",info.userID.toString()) + "分享了你的经验,你获得了" + info.accept + "个骄阳豆");
               sprite.addEventListener(TextEvent.LINK,function(_arg_1:TextEvent):void
               {
                  UserInfoController.show(uint(_arg_1.text));
                  LevelManager.topLevel.addChild(UserInfoController.panel);
               });
            }
            return;
         case CommandID.TEAM_ADD:
            sprite = Answer.show(TextFormatUtil.getEventTxt(info.nick + "(" + info.userID + ")",info.userID.toString()) + "申请加入战队，你同意吗？",function():void
            {
               SocketConnection.send(CommandID.TEAM_ANSWER,info.userID,1);
            },function():void
            {
               SocketConnection.send(CommandID.TEAM_ANSWER,info.userID,0);
            });
            sprite.addEventListener(TextEvent.LINK,function(_arg_1:TextEvent):void
            {
               UserInfoController.show(uint(_arg_1.text));
               LevelManager.topLevel.addChild(UserInfoController.panel);
            });
      }
   }
}
