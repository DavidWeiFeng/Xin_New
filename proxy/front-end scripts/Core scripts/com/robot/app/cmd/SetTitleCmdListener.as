package com.robot.app.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class SetTitleCmdListener extends BaseBeanController
   {
      
      public function SetTitleCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.SETTITLE,this.onSetTitle);
         finish();
      }
      
      private function onSetTitle(e:SocketEvent) : void
      {
         var titleid:uint = 0;
         trace("收到SetTitleCmdListener");
         var data:ByteArray = e.data as ByteArray;
         var userID:uint = data.readUnsignedInt();
         if(userID == MainManager.actorID)
         {
            MainManager.actorInfo.curTitle = titleid;
         }
         titleid = data.readUnsignedInt();
         UserManager.dispatchAction(userID,PeopleActionEvent.SET_TITLE,titleid);
      }
   }
}

