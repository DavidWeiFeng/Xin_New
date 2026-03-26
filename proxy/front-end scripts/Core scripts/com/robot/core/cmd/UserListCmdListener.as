package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.aticon.FlyAction;
   import com.robot.core.aticon.WalkAction;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.manager.map.MapType;
   import com.robot.core.mode.PeopleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.teamPK.TeamPKManager;
   import com.robot.core.teamPK.shotActive.PKInteractiveAction;
   import com.robot.core.utils.Direction;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class UserListCmdListener extends BaseBeanController
   {
      
      public static var superList:Array = [];
      
      public function UserListCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.LIST_MAP_PLAYER,this.onUserList);
         finish();
      }
      
      private function onUserList(_arg_1:SocketEvent) : void
      {
         var _local_2:UserInfo = null;
         var _local_3:PeopleModel = null;
         var _local_6:int = 0;
         var _local_4:ByteArray = _arg_1.data as ByteArray;
         _local_4.position = 0;
         var _local_5:uint = _local_4.readUnsignedInt();
         superList = [];
         while(_local_6 < _local_5)
         {
            _local_2 = new UserInfo();
            UserInfo.setForPeoleInfo(_local_2,_local_4);
            _local_2.serverID = MainManager.serverID;
            if(_local_2.userID != MainManager.actorInfo.userID)
            {
               _local_3 = new PeopleModel(_local_2);
               if(_local_2.actionType == 0)
               {
                  _local_3.walk = new WalkAction();
               }
               else
               {
                  _local_3.walk = new FlyAction(_local_3);
               }
               MapManager.currentMap.addUser(_local_3);
               if(MainManager.actorInfo.mapType == MapType.PK_TYPE)
               {
                  if(_local_2.teamInfo.id != MainManager.actorInfo.mapID)
                  {
                     _local_3.additiveInfo.info = TeamPKManager.AWAY;
                  }
                  else
                  {
                     _local_3.additiveInfo.info = TeamPKManager.HOME;
                  }
                  _local_3.interactiveAction = new PKInteractiveAction(_local_3);
               }
               if(_local_2.curTitle > 0)
               {
                  UserManager.dispatchAction(_local_2.userID,PeopleActionEvent.SET_TITLE,_local_2.curTitle);
               }
            }
            else if(Boolean(MainManager.actorModel.nono))
            {
               MainManager.actorModel.nono.direction = Direction.DOWN;
            }
            if(_local_2.teamInfo.coreCount >= 10 && _local_2.teamInfo.isShow)
            {
               superList.push(_local_2.userID);
            }
            _local_6++;
         }
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.FILTER_SUPER_TEAM));
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.CREATED_MAP_USER));
      }
   }
}

