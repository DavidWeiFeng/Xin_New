package com.robot.app.team
{
   import com.robot.app.im.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.info.team.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.geom.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class TeamController
   {
      
      private static var infoPanel:AppModel;
      
      private static var panel:AppModel;
      
      private static var searchPanel:MovieClip;
      
      private static var subMenu:MovieClip;
      
      public static const ADMIN:uint = 0;
      
      public static const MEMBER:uint = 1;
      
      public static const GUEST:uint = 2;
      
      public static const TEAM_INTEREST:Array = ["团结朋友","探索宇宙","精灵对战","对抗坏蛋","结识伙伴","维护正义","热爱自然","辛勤劳动","勤奋学习","公平竞争"];
      
      public static const ADMIN_STR:Array = ["指挥官","主将","副将","中坚","先锋","队员"];
      
      public function TeamController()
      {
         super();
      }
      
      public static function showSubMenu(_arg_1:DisplayObject) : void
      {
         var _local_2:Point = null;
         var _local_3:SimpleButton = null;
         var _local_4:SimpleButton = null;
         if(!subMenu)
         {
            subMenu = UIManager.getMovieClip("ui_teamBtnsPanel");
            _local_2 = _arg_1.localToGlobal(new Point());
            subMenu.x = _local_2.x;
            subMenu.y = _local_2.y - subMenu.height - 5;
            _local_3 = subMenu["enterTeamBtn"];
            _local_4 = subMenu["teamImBtn"];
            ToolTipManager.add(_local_3,"进入要塞");
            ToolTipManager.add(_local_4,"战队通迅");
            _local_3.addEventListener(MouseEvent.CLICK,enterHandler);
            _local_4.addEventListener(MouseEvent.CLICK,imHandler);
         }
         LevelManager.topLevel.addChild(subMenu);
         MainManager.getStage().addEventListener(MouseEvent.CLICK,onStageClick);
      }
      
      private static function onStageClick(_arg_1:MouseEvent) : void
      {
         MainManager.getStage().removeEventListener(MouseEvent.CLICK,onStageClick);
         if(!subMenu.hitTestPoint(_arg_1.stageX,_arg_1.stageY))
         {
            DisplayUtil.removeForParent(subMenu);
         }
      }
      
      private static function enterHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(subMenu);
         show();
      }
      
      private static function imHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(subMenu);
         TeamChatController.show();
      }
      
      public static function show(_arg_1:uint = 0) : void
      {
         var _local_2:uint = 0;
         if(_arg_1 == 0)
         {
            _local_2 = uint(MainManager.actorInfo.teamInfo.id);
         }
         else
         {
            _local_2 = _arg_1;
         }
         if(_local_2 == 0)
         {
            searchTeam();
            return;
         }
         enter(_local_2);
      }
      
      public static function searchTeam() : void
      {
         var closeBtn:SimpleButton = null;
         var okBtn:SimpleButton = null;
         if(!searchPanel)
         {
            searchPanel = CoreAssetsManager.getMovieClip("ui_findTeamAlarm");
            closeBtn = searchPanel["closeBtn"];
            okBtn = searchPanel["okBtn"];
            closeBtn.addEventListener(MouseEvent.CLICK,function(_arg_1:MouseEvent):void
            {
               DisplayUtil.removeForParent(searchPanel);
            });
            okBtn.addEventListener(MouseEvent.CLICK,function(_arg_1:MouseEvent):void
            {
               var _local_2:String = searchPanel["txt"].text;
               if(_local_2.replace(/" "/g,"") == "")
               {
                  return;
               }
               search(uint(_local_2));
               DisplayUtil.removeForParent(searchPanel);
            });
         }
         DisplayUtil.align(searchPanel,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(searchPanel);
      }
      
      private static function search(id:uint) : void
      {
         if(id <= 50000)
         {
            Alarm.show("战队不存在");
            return;
         }
         if(!SocketConnection.hasCmdListener(CommandID.TEAM_GET_INFO))
         {
            SocketConnection.addCmdListener(CommandID.TEAM_GET_INFO,function(_arg_1:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.TEAM_GET_INFO,arguments.callee);
               var _local_3:SimpleTeamInfo = _arg_1.data as SimpleTeamInfo;
               show(_local_3.teamID);
            });
         }
         SocketConnection.send(CommandID.TEAM_GET_INFO,id);
      }
      
      public static function create() : void
      {
         if(MainManager.actorInfo.teamInfo.id != 0)
         {
            Alarm.show("你已经加入了一个战队，如果想要创建一个战队的话，要先退出之前的战队哦！");
            return;
         }
         if(panel == null)
         {
            panel = ModuleManager.getModule(ClientConfig.getAppModule("TeamCreater"),"正在打开创建程序");
            panel.setup();
         }
         panel.show();
      }
      
      public static function join(_arg_1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_ADD,onTeamAdd);
         SocketConnection.send(CommandID.TEAM_ADD,_arg_1);
      }
      
      private static function onTeamAdd(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_ADD,onTeamAdd);
         var _local_2:TeamAddInfo = _arg_1.data as TeamAddInfo;
         if(_local_2.ret == 0)
         {
            Alarm.show("恭喜你加入战队成功");
            MainManager.actorInfo.teamInfo.id = _local_2.teamID;
            MainManager.actorInfo.teamInfo.priv = 5;
         }
         else if(_local_2.ret == 1)
         {
            Alarm.show("你的申请已经提交，等待对方验证");
         }
         else
         {
            Alarm.show("对不起，该战队不允许任何人加入");
         }
      }
      
      public static function enter(_arg_1:uint) : void
      {
         if(_arg_1 == 0)
         {
            Alarm.show("你还没有加入一个战队哦！");
            return;
         }
         MapManager.changeMap(_arg_1,0,MapType.CAMP);
      }
      
      public static function changePriv(uid:uint, priv:uint) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_DELET_MEMBER,arguments.callee);
         SocketConnection.addCmdListener(CommandID.TEAM_CHANGE_ADMIN,function(_arg_1:SocketEvent):void
         {
            Alarm.show("调整成功");
            SocketConnection.removeCmdListener(CommandID.TEAM_CHANGE_ADMIN,arguments.callee);
         });
         SocketConnection.send(CommandID.TEAM_CHANGE_ADMIN,uid,priv);
      }
      
      public static function del(uid:uint) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_DELET_MEMBER,arguments.callee);
         SocketConnection.addCmdListener(CommandID.TEAM_DELET_MEMBER,function(_arg_1:SocketEvent):void
         {
            Alarm.show("删除成功");
            SocketConnection.removeCmdListener(CommandID.TEAM_DELET_MEMBER,arguments.callee);
         });
         SocketConnection.send(CommandID.TEAM_DELET_MEMBER,uid);
      }
      
      public static function invite(_arg_1:uint) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_INVITE_TO_JOIN,onInvite);
         SocketConnection.addCmdListener(CommandID.TEAM_INVITE_TO_JOIN,onInvite);
         SocketConnection.send(CommandID.TEAM_INVITE_TO_JOIN,_arg_1);
      }
      
      private static function onInvite(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_INVITE_TO_JOIN,onInvite);
         Alarm.show("你的邀请已经发出，请耐心等待对方答复");
      }
   }
}

