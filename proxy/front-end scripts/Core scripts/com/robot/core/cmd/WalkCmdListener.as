package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.nono.NonoShortcut;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class WalkCmdListener extends BaseBeanController
   {
      
      public function WalkCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PEOPLE_WALK,this.onWalk);
         finish();
      }
      
      private function onWalk(_arg_1:SocketEvent) : void
      {
         var _local_2:uint = 0;
         var _local_3:ByteArray = null;
         NonoShortcut.hide();
         var _local_4:ByteArray = _arg_1.data as ByteArray;
         _local_4.position = 0;
         var _local_5:uint = _local_4.readUnsignedInt();
         var _local_6:uint = _local_4.readUnsignedInt();
         var _local_7:Point = new Point(_local_4.readUnsignedInt(),_local_4.readUnsignedInt());
         if(_local_6 != MainManager.actorInfo.userID)
         {
            _local_2 = 0;
            if(_local_2 == 0)
            {
               UserManager.dispatchAction(_local_6,PeopleActionEvent.WALK,_local_7);
            }
            else
            {
               _local_3 = new ByteArray();
               _local_4.readBytes(_local_3,0,_local_2);
               UserManager.dispatchAction(_local_6,PeopleActionEvent.WALK,_local_3.readObject());
            }
         }
      }
   }
}

