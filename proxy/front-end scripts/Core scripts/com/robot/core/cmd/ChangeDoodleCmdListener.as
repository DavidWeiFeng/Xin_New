package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.item.DoodleInfo;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class ChangeDoodleCmdListener extends BaseBeanController
   {
      
      public function ChangeDoodleCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHANGE_DOODLE,this.onChange);
         finish();
      }
      
      private function onChange(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:DoodleInfo = new DoodleInfo(_local_2);
         UserManager.dispatchAction(_local_3.userID,PeopleActionEvent.DOODLE_CHANGE,_local_3);
      }
   }
}

