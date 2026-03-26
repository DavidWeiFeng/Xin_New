package com.robot.app.task.taskUtils.baseAction
{
   import com.robot.core.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import flash.events.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class DeleteTask
   {
      
      private static var _taskId:uint;
      
      public static const DELETE_TASK_OK:String = "DELETE_TASK_OK";
      
      public function DeleteTask()
      {
         super();
      }
      
      public static function set taskId(_arg_1:uint) : void
      {
         _taskId = _arg_1;
      }
      
      public static function delTask() : void
      {
         SocketConnection.addCmdListener(CommandID.DELETE_TASK,onDelete);
         SocketConnection.send(CommandID.DELETE_TASK,_taskId);
      }
      
      private static function onDelete(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.DELETE_TASK,onDelete);
         TasksManager.taskList[_taskId - 1] = 2;
         EventManager.dispatchEvent(new Event(DELETE_TASK_OK));
      }
   }
}

