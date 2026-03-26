package com.robot.core.teamInstallation
{
   import com.robot.core.*;
   import com.robot.core.info.team.*;
   import com.robot.core.net.*;
   import org.taomee.events.SocketEvent;
   
   public class TeamInfoManager
   {
      
      public function TeamInfoManager()
      {
         super();
      }
      
      public static function getSimpleTeamInfo(id:uint, fun:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_GET_INFO,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TEAM_GET_INFO,arguments.callee);
            var _local_3:SimpleTeamInfo = _arg_1.data as SimpleTeamInfo;
            if(fun != null)
            {
               fun(_local_3);
            }
         });
         SocketConnection.send(CommandID.TEAM_GET_INFO,id);
      }
      
      public static function getTeamLogoInfo(uid:uint, fun:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_GET_LOGO_INFO,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TEAM_GET_LOGO_INFO,arguments.callee);
            var _local_3:TeamLogoInfo = _arg_1.data as TeamLogoInfo;
            if(fun != null)
            {
               fun(_local_3);
            }
         });
         SocketConnection.send(CommandID.TEAM_GET_LOGO_INFO,uid);
      }
   }
}

