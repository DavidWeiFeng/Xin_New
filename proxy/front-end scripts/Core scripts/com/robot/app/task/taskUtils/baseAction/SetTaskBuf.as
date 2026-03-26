package com.robot.app.task.taskUtils.baseAction
{
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class SetTaskBuf
   {
      
      private static var _buf:String;
      
      private static var _taskId:uint;
      
      public static const SET_BUF_OK:String = "set_buf_ok";
      
      public function SetTaskBuf()
      {
         super();
      }
      
      public static function setBuf() : void
      {
         var _local_1:ByteArray = new ByteArray();
         _local_1.writeUTFBytes(_buf);
         _local_1.length = 100;
         SocketConnection.addCmdListener(CommandID.ADD_TASK_BUF,onAddBuf);
         SocketConnection.send(CommandID.ADD_TASK_BUF,_taskId,_local_1);
      }
      
      private static function onAddBuf(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ADD_TASK_BUF,onAddBuf);
         EventManager.dispatchEvent(new Event(SET_BUF_OK));
      }
      
      public static function set taskId(_arg_1:uint) : void
      {
         _taskId = _arg_1;
      }
      
      public static function set buf(_arg_1:String) : void
      {
         _buf = _arg_1;
      }
      
      public static function get bufValue() : String
      {
         return _buf;
      }
   }
}

