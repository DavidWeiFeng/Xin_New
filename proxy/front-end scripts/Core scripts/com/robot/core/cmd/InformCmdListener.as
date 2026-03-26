package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.info.InformInfo;
   import com.robot.core.manager.MessageManager;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.DynamicEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class InformCmdListener
   {
      
      public function InformCmdListener()
      {
         super();
      }
      
      private static function onInform(_arg_1:SocketEvent) : void
      {
         var _local_2:InformInfo = _arg_1.data as InformInfo;
         if(_local_2.type == 1004)
         {
            EventManager.dispatchEvent(new DynamicEvent("DS_TASK",_local_2.accept));
         }
         else
         {
            MessageManager.addInformInfo(_local_2);
         }
      }
      
      public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.INFORM,onInform);
      }
   }
}

