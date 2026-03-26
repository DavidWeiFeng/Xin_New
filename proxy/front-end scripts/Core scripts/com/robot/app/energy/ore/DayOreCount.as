package com.robot.app.energy.ore
{
   import com.robot.core.CommandID;
   import com.robot.core.info.task.MiningCountInfo;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.events.SocketEvent;
   
   public class DayOreCount extends EventDispatcher
   {
      
      public static var oreCount:uint;
      
      public static const countOK:String = "COUNT_OK";
      
      public static const countError:String = "COUNT_ERROR";
      
      public function DayOreCount()
      {
         super();
      }
      
      public function sendToServer(_arg_1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,this.onCount);
         SocketConnection.send(CommandID.TALK_COUNT,_arg_1);
      }
      
      private function onCount(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_COUNT,this.onCount);
         var _local_2:MiningCountInfo = _arg_1.data as MiningCountInfo;
         oreCount = _local_2.miningCount;
         dispatchEvent(new Event(countOK));
      }
   }
}

