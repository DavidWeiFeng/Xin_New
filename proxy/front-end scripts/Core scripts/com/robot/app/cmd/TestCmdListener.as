package com.robot.app.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class TestCmdListener extends BaseBeanController
   {
      
      public function TestCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.TEST,this.onTest);
         finish();
      }
      
      private function onTest(_arg_1:SocketEvent) : void
      {
         var data:ByteArray = _arg_1.data as ByteArray;
         var len:uint = uint(data.readUnsignedInt());
         var msg:String = data.readUTFBytes(len);
         Alarm.show(msg);
      }
   }
}

