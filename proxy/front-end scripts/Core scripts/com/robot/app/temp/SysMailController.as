package com.robot.app.temp
{
   import com.robot.core.*;
   import com.robot.core.info.*;
   import com.robot.core.net.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class SysMailController
   {
      
      private static var timer:Timer;
      
      private static var obj:Object = new Object();
      
      public function SysMailController()
      {
         super();
      }
      
      public static function setup() : void
      {
         timer = new Timer(10 * 60 * 1000);
         timer.addEventListener(TimerEvent.TIMER,onTimer);
         timer.start();
      }
      
      private static function onTimer(event:TimerEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,arguments.callee);
            var _local_3:Date = (_arg_1.data as SystemTimeInfo).date;
            if(_local_3.getDate() == 5)
            {
               checkDate(_local_3);
            }
         });
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      
      private static function checkDate(_arg_1:Date) : void
      {
         var _local_2:SystemMsgInfo = new SystemMsgInfo();
         _local_2.msgTime = _arg_1.getTime() / 1000;
         _local_2.npc = 3;
      }
   }
}

