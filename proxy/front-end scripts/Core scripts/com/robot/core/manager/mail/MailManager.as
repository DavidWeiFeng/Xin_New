package com.robot.core.manager.mail
{
   import com.robot.core.*;
   import com.robot.core.cmd.*;
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.info.mail.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.ui.loading.loadingstyle.*;
   import flash.display.InteractiveObject;
   import flash.events.*;
   import flash.filters.*;
   import flash.utils.*;
   import org.taomee.component.control.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class MailManager
   {
      
      public static var total:uint;
      
      private static var unReadCount:uint;
      
      private static var unreadTxt:MLabel;
      
      private static var icon:InteractiveObject;
      
      private static var panel:AppModel;
      
      private static var loadingView:ILoadingStyle;
      
      private static var delArray:Array;
      
      private static var _instance:EventDispatcher;
      
      private static var _hashMap:HashMap = new HashMap();
      
      private static var sysMailMap:HashMap = new HashMap();
      
      public function MailManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         EventManager.addEventListener(RobotEvent.BEAN_COMPLETE,onBeanComplete);
         addEventListener(MailEvent.MAIL_DELETE,onDelete);
         addEventListener(MailEvent.MAIL_CLEAR,onClear);
      }
      
      private static function onBeanComplete(_arg_1:Event) : void
      {
         getUnRead();
      }
      
      public static function getNew() : void
      {
         getUnRead();
      }
      
      public static function showIcon() : void
      {
         icon = TaskIconManager.getIcon("mail_icon");
         icon.x = 112;
         icon.y = 24;
         LevelManager.iconLevel.addChild(icon);
         ToolTipManager.add(icon,"星际邮件");
         icon.addEventListener(MouseEvent.CLICK,showMail);
         unreadTxt = new MLabel();
         unreadTxt.mouseEnabled = false;
         unreadTxt.mouseChildren = false;
         unreadTxt.width = 50;
         unreadTxt.blod = true;
         unreadTxt.fontSize = 14;
         unreadTxt.text = "";
         unreadTxt.textColor = 13311;
         unreadTxt.filters = [new GlowFilter(16777215,1,2,2,20)];
         unreadTxt.x = icon.x + 6;
         unreadTxt.y = icon.height + icon.y - 18;
         LevelManager.iconLevel.addChild(unreadTxt);
      }
      
      private static function showMail(_arg_1:MouseEvent) : void
      {
         if(!panel)
         {
            panel = new AppModel(ClientConfig.getAppModule("MailBox"),"正在打开邮箱");
            panel.loadingView = new MailLoadingStyle(LevelManager.appLevel);
            panel.setup();
         }
         panel.show();
      }
      
      public static function getUnRead() : void
      {
         SocketConnection.addCmdListener(CommandID.MAIL_GET_UNREAD,onGetUnRead);
         SocketConnection.send(CommandID.MAIL_GET_UNREAD);
      }
      
      private static function onGetUnRead(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.MAIL_GET_UNREAD,onGetUnRead);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         unReadCount = _local_2.readUnsignedInt();
         if(unReadCount > 0)
         {
            unreadTxt.text = unReadCount.toString();
         }
         else
         {
            unreadTxt.text = "";
         }
      }
      
      public static function sendMail(_arg_1:uint, _arg_2:String, _arg_3:Array) : void
      {
         var _local_4:uint = 0;
         var _local_5:ByteArray = new ByteArray();
         _local_5.writeUTFBytes(_arg_2 + "0");
         if(_local_5.length > 150)
         {
            Alarm.show("你输入的邮件内容过长");
            return;
         }
         if(_arg_3.length > 10)
         {
            Alarm.show("最多只能同时给10个人发送邮件哦！");
            return;
         }
         var _local_6:ByteArray = new ByteArray();
         for each(_local_4 in _arg_3)
         {
            _local_6.writeUnsignedInt(_local_4);
         }
         SocketConnection.send(CommandID.MAIL_SEND,_arg_1,_local_5.length,_local_5,_arg_3.length,_local_6);
      }
      
      public static function getMailContent(id:uint, fun:Function) : void
      {
         SocketConnection.addCmdListener(CommandID.MAIL_GET_CONTENT,function(_arg_1:SocketEvent):void
         {
            var _local_3:SingleMailInfo = null;
            SocketConnection.removeCmdListener(CommandID.MAIL_GET_CONTENT,arguments.callee);
            var _local_4:ByteArray = _arg_1.data as ByteArray;
            var _local_5:uint = _local_4.readUnsignedInt();
            var _local_6:uint = _local_4.readUnsignedInt();
            var _local_7:uint = _local_4.readUnsignedInt();
            var _local_8:uint = _local_4.readUnsignedInt();
            var _local_9:String = _local_4.readUTFBytes(16);
            var _local_10:Boolean = _local_4.readUnsignedInt() == 1;
            var _local_11:uint = _local_4.readUnsignedInt();
            var _local_12:String = _local_4.readUTFBytes(_local_11);
            if(_hashMap.containsKey(_local_5))
            {
               _local_3 = _hashMap.getValue(_local_5);
            }
            else
            {
               _local_3 = new SingleMailInfo();
               _hashMap.add(_local_5,_local_3);
            }
            _local_3.template = _local_6;
            _local_3.time = _local_7;
            _local_3.fromID = _local_8;
            _local_3.fromNick = _local_9;
            _local_3.readed = _local_10;
            _local_3.content = _local_12;
            if(fun != null)
            {
               fun(_local_3);
            }
         });
         SocketConnection.send(CommandID.MAIL_GET_CONTENT,id);
      }
      
      public static function setReaded(_arg_1:Array) : void
      {
         var _local_2:uint = 0;
         if(_arg_1.length == 0)
         {
            return;
         }
         var _local_3:ByteArray = new ByteArray();
         for each(_local_2 in _arg_1)
         {
            _local_3.writeUnsignedInt(_local_2);
         }
         SocketConnection.send(CommandID.MAIL_SET_READED,_arg_1.length,_local_3);
      }
      
      public static function delMail(_arg_1:Array) : void
      {
         var _local_2:uint = 0;
         if(_arg_1.length == 0)
         {
            return;
         }
         delArray = _arg_1.slice();
         var _local_3:ByteArray = new ByteArray();
         for each(_local_2 in _arg_1)
         {
            _local_3.writeUnsignedInt(_local_2);
         }
         SocketConnection.send(CommandID.MAIL_DELETE,_arg_1.length,_local_3);
      }
      
      public static function delAllMail() : void
      {
         SocketConnection.send(CommandID.MAIL_DEL_ALL);
      }
      
      public static function getMailList(_arg_1:uint = 1) : void
      {
         SocketConnection.addCmdListener(CommandID.MAIL_GET_LIST,onMailList);
         SocketConnection.send(CommandID.MAIL_GET_LIST,_arg_1);
      }
      
      private static function onMailList(_arg_1:SocketEvent) : void
      {
         var _local_2:SingleMailInfo = null;
         var _local_3:MailListInfo = _arg_1.data as MailListInfo;
         total = _local_3.total;
         for each(_local_2 in _local_3.mailList)
         {
            _hashMap.add(_local_2.id,_local_2);
         }
         if(_local_3.total > _hashMap.length)
         {
            getMailList(_hashMap.length + 1);
         }
         else
         {
            dispatchEvent(new MailEvent(MailEvent.MAIL_LIST));
         }
      }
      
      public static function getMailInfos() : Array
      {
         return _hashMap.getValues().sortOn("time",Array.NUMERIC | Array.DESCENDING);
      }
      
      public static function getMailIDs() : Array
      {
         return _hashMap.getKeys();
      }
      
      public static function getSingleMail(_arg_1:uint) : SingleMailInfo
      {
         return _hashMap.getValue(_arg_1);
      }
      
      private static function onDelete(_arg_1:MailEvent) : void
      {
         var _local_2:uint = 0;
         for each(_local_2 in delArray)
         {
            _hashMap.remove(_local_2);
         }
         dispatchEvent(new MailEvent(MailEvent.MAIL_LIST));
      }
      
      private static function onClear(_arg_1:MailEvent) : void
      {
         _hashMap.clear();
         dispatchEvent(new MailEvent(MailEvent.MAIL_LIST));
      }
      
      public static function addSysMail(_arg_1:uint) : void
      {
         sysMailMap.add(_arg_1,_arg_1);
      }
      
      public static function delSysMail() : void
      {
         MailCmdListener.isShowTip = false;
         var _local_1:Array = sysMailMap.getKeys();
         delMail(_local_1);
         sysMailMap.clear();
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

