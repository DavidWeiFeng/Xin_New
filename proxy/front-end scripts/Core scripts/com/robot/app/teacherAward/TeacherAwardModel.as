package com.robot.app.teacherAward
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import org.taomee.events.SocketEvent;
   
   public class TeacherAwardModel
   {
      
      public function TeacherAwardModel()
      {
         super();
      }
      
      public static function sendCmd() : void
      {
         SocketConnection.addCmdListener(CommandID.TEACHERREWARD_COMPLETE,onSendCompleteHandler);
         SocketConnection.send(CommandID.TEACHERREWARD_COMPLETE);
      }
      
      private static function onSendCompleteHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:String = null;
         var _local_3:int = 0;
         SocketConnection.removeCmdListener(CommandID.TEACHERREWARD_COMPLETE,onSendCompleteHandler);
         var _local_4:TeacherAwardInfo = _arg_1.data as TeacherAwardInfo;
         if(_local_4.getInfo.length > 0)
         {
            _local_2 = "";
            _local_3 = 0;
            while(_local_3 < _local_4.getInfo.length)
            {
               _local_2 += ItemXMLInfo.getName(_local_4.getInfo[_local_3]) + ",";
               _local_3++;
            }
            Alarm.show("你是一名优秀的教官，奖励你:" + _local_2 + "希望你更加努力，培养更多精英。");
         }
      }
   }
}

