package com.robot.core.cmd.team
{
   import com.robot.core.CommandID;
   import com.robot.core.info.team.TeamInformInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MessageManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class TeamInformCmdListener
   {
      
      public function TeamInformCmdListener()
      {
         super();
      }
      
      public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_INFORM,this.onInform);
         SocketConnection.addCmdListener(CommandID.TEAM_QUIT,this.onQuit);
      }
      
      private function onInform(_arg_1:SocketEvent) : void
      {
         var _local_2:TeamInformInfo = _arg_1.data as TeamInformInfo;
         MessageManager.addTeamInformInfo(_local_2);
      }
      
      private function onQuit(_arg_1:SocketEvent) : void
      {
         Alarm.show("你已经退出了战队：" + (_arg_1.data as ByteArray).readUnsignedInt());
         MainManager.actorInfo.teamInfo.id = 0;
         MainManager.actorInfo.teamInfo.priv = 5;
      }
   }
}

