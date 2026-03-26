package com.robot.core.cmd.nono
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.*;
   import org.taomee.events.SocketEvent;
   
   public class ToolCmdListener extends BaseBeanController
   {
      
      public function ToolCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_IMPLEMENT_TOOL,this.onChange);
         finish();
      }
      
      private function onChange(_arg_1:SocketEvent) : void
      {
         var _local_2:NonoImplementsToolResquestInfo = _arg_1.data as NonoImplementsToolResquestInfo;
         if(_local_2.id != MainManager.actorID)
         {
            return;
         }
         if(Boolean(NonoManager.info))
         {
            NonoManager.info.power = _local_2.power;
            if(_local_2.ai > NonoManager.info.ai)
            {
               NonoManager.dispatchEvent(new NonoEvent(NonoEvent.INFO_CHANGE,NonoManager.info));
            }
            NonoManager.info.ai = _local_2.ai;
            NonoManager.info.mate = _local_2.mate;
            NonoManager.info.iq = _local_2.iq;
            if(_local_2.itemId <= 700060)
            {
               NonoManager.info.func[_local_2.itemId - 700001] = true;
            }
         }
         var _local_3:uint = ItemXMLInfo.getPlayID(_local_2.itemId);
         if(_local_3 != 0)
         {
            NonoManager.dispatchAction(_local_2.id,NonoActionEvent.NONO_PLAY,_local_3);
         }
      }
   }
}

