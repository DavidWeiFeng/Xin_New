package com.robot.app.task.taskUtils.baseAction
{
   import com.robot.core.*;
   import com.robot.core.info.task.novice.NoviceBufInfo;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import flash.events.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class AcceptTask
   {
      
      private static var _taskId:uint;
      
      private static var taskBuf:NoviceBufInfo;
      
      public static const ACCEPT_TASK_OK:String = "ACCEPT_TASK_OK";
      
      public function AcceptTask()
      {
         super();
      }
      
      public static function set taskId(_arg_1:uint) : void
      {
         _taskId = _arg_1;
      }
      
      public static function acceptTask() : void
      {
         SocketConnection.addCmdListener(CommandID.ACCEPT_TASK,onAccept);
         SocketConnection.send(CommandID.ACCEPT_TASK,_taskId);
      }
      
      private static function onAccept(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ACCEPT_TASK,onAccept);
         TasksManager.taskList[_taskId - 1] = 1;
         EventManager.dispatchEvent(new Event(ACCEPT_TASK_OK));
      }
   }
}

