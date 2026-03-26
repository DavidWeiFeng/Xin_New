package com.robot.core.cmd.nono
{
   import com.robot.core.CommandID;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class ChangeNameCmdListener extends BaseBeanController
   {
      
      public function ChangeNameCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_CHANGE_NAME,this.onNameChanged);
         finish();
      }
      
      private function onNameChanged(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:String = _local_2.readUTFBytes(16);
         NonoManager.dispatchAction(_local_3,NonoActionEvent.NAME_CHANGE,_local_4);
      }
   }
}

