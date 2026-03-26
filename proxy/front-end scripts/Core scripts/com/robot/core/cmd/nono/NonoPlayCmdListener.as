package com.robot.core.cmd.nono
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.event.NonoEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class NonoPlayCmdListener extends BaseBeanController
   {
      
      public function NonoPlayCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_PLAY,this.onChanged);
         finish();
      }
      
      private function onChanged(_arg_1:SocketEvent) : void
      {
         var _local_2:uint = 0;
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         var _local_5:uint = _local_3.readUnsignedInt();
         var _local_6:uint = ItemXMLInfo.getPlayID(_local_5);
         if(_local_6 != 0)
         {
            NonoManager.dispatchAction(_local_4,NonoActionEvent.NONO_PLAY,_local_6);
         }
         if(_local_4 != MainManager.actorID)
         {
            return;
         }
         if(Boolean(NonoManager.info))
         {
            NonoManager.info.power = _local_3.readUnsignedInt() / 1000;
            _local_2 = _local_3.readUnsignedShort();
            if(_local_2 > NonoManager.info.ai)
            {
               NonoManager.dispatchEvent(new NonoEvent(NonoEvent.INFO_CHANGE,NonoManager.info));
            }
            NonoManager.info.ai = _local_2;
            NonoManager.info.mate = _local_3.readUnsignedInt() / 1000;
            NonoManager.info.iq = _local_3.readUnsignedInt();
         }
      }
   }
}

