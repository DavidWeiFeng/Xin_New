package com.robot.core.cmd.nono
{
   import com.robot.core.CommandID;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.manager.NonoManager;
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
         SocketConnection.addCmdListener(CommandID.NONO_CHANGE_COLOR,this.onChange);
         finish();
      }
      
      private function onChange(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         NonoManager.dispatchAction(_local_3,NonoActionEvent.COLOR_CHANGE,_local_4);
      }
   }
}

