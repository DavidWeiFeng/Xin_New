package com.robot.core.cmd.nono
{
   import com.robot.core.CommandID;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class ChargeCmdListener extends BaseBeanController
   {
      
      public function ChargeCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_CHARGE,this.onChanged);
         finish();
      }
      
      private function onChanged(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:Boolean = Boolean(_local_2.readUnsignedInt());
         NonoManager.dispatchAction(_local_3,NonoActionEvent.CHARGEING,_local_4);
      }
   }
}

