package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class ChangeColorCmdListener extends BaseBeanController
   {
      
      public function ChangeColorCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHANGE_COLOR,this.onChange);
         finish();
      }
      
      private function onChange(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         var _local_5:uint = _local_2.readUnsignedInt();
         var _local_6:uint = _local_2.readUnsignedInt();
         UserManager.dispatchAction(_local_3,PeopleActionEvent.COLOR_CHANGE,{
            "color":_local_4,
            "coins":_local_6
         });
      }
   }
}

