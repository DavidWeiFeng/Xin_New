package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.info.team.TeamLogoInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.teamInstallation.TeamInfoManager;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class ShowLogoCmdListener extends BaseBeanController
   {
      
      private var _isShow:uint;
      
      private var _uid:uint;
      
      public function ShowLogoCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_SHOW_LOGO,this.onShowComHandler);
         finish();
      }
      
      private function onShowComHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:BasePeoleModel = null;
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         this._uid = _local_3.readUnsignedInt();
         this._isShow = _local_3.readUnsignedInt();
         if(this._uid == MainManager.actorInfo.userID)
         {
            MainManager.actorInfo.teamInfo.isShow = Boolean(this._isShow);
         }
         else
         {
            _local_2 = UserManager.getUserModel(this._uid);
            _local_2.info.teamInfo.isShow = Boolean(this._isShow);
         }
         this.setLogo(this._uid,Boolean(this._isShow));
      }
      
      private function setLogo(uid:uint, isShow:Boolean) : void
      {
         TeamInfoManager.getTeamLogoInfo(uid,function(_arg_1:TeamLogoInfo):void
         {
            var _local_2:BasePeoleModel = null;
            if(uid == MainManager.actorID)
            {
               _local_2 = MainManager.actorModel;
            }
            else
            {
               _local_2 = UserManager.getUserModel(uid);
            }
            if(Boolean(_local_2))
            {
               if(isShow)
               {
                  _local_2.showTeamLogo(_arg_1);
               }
               else
               {
                  _local_2.removeTeamLogo();
               }
            }
         });
      }
   }
}

