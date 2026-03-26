package com.robot.app.cmd
{
   import com.robot.app.im.*;
   import com.robot.app.im.talk.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.*;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class TeamChatCmdListener extends BaseBeanController
   {
      
      public static const TEAM_CHAT_CUTBMP:String = "Team_Chat_CutBmp";
      
      private var icon:SimpleButton;
      
      public function TeamChatCmdListener()
      {
         super();
      }
      
      public static function sendTeamChatMsg(_arg_1:uint, _arg_2:ByteArray, _arg_3:uint, _arg_4:ByteArray) : void
      {
         SocketConnection.send(CommandID.TEAM_CHAT,_arg_1,_arg_2,_arg_3,_arg_4);
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_CHAT,this.getTeamChatMsg);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchMap);
         finish();
      }
      
      private function onSwitchMap(_arg_1:MapEvent) : void
      {
         TeamChatController.isOpen = false;
      }
      
      private function getTeamChatMsg(_arg_1:SocketEvent) : void
      {
         var _local_2:TeamChatInfo = null;
         var _local_3:SharedObject = SOManager.getUser_Info();
         if(!_local_3.data["isHackTeam"] || _local_3.data["isHackTeam"] == false)
         {
            _local_2 = _arg_1.data as TeamChatInfo;
            if(!TeamChatController.isOpen)
            {
               MessageManager.addTeamChatInfo(_local_2);
            }
            TeamChatData.addTeamChat(_local_2);
         }
      }
      
      private function showIcon() : void
      {
         if(!this.icon)
         {
            this.icon = UIManager.getButton("Talk_Icon");
            this.icon.x = 115;
            this.icon.y = 20;
            this.icon.addEventListener(MouseEvent.CLICK,this.showTeamChatMsg);
         }
         LevelManager.iconLevel.addChild(this.icon);
      }
      
      private function hideIcon() : void
      {
         DisplayUtil.removeForParent(this.icon);
      }
      
      private function showTeamChatMsg(_arg_1:MouseEvent) : void
      {
         TeamChatController.show();
         this.icon.visible = false;
      }
   }
}

