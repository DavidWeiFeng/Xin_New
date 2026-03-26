package com.robot.app.service
{
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class Service
   {
      
      setup();
      
      public function Service()
      {
         super();
      }
      
      private static function setup() : void
      {
         SocketConnection.addCmdListener(CommandID.USER_CONTRIBUTE,onContribute);
      }
      
      private static function onContribute(_arg_1:SocketEvent) : void
      {
         Alarm.show("邮件已发送成功！");
      }
      
      public static function contribute(_arg_1:String, _arg_2:String, _arg_3:uint = 0) : Boolean
      {
         if(_arg_1.replace(/ /g,"") == "")
         {
            Alarm.show("请输入标题！");
            return false;
         }
         if(_arg_2.replace(/ /g,"") == "")
         {
            Alarm.show("请输入内容！");
            return false;
         }
         var _local_4:ByteArray = new ByteArray();
         _local_4.writeUTFBytes(_arg_1);
         if(_local_4.length > 120)
         {
            Alarm.show("你输入的标题过长！");
            return false;
         }
         var _local_5:ByteArray = new ByteArray();
         _local_5.writeUTFBytes(_arg_2);
         if(120 + _local_5.length > 3600)
         {
            Alarm.show("你输入的内容过长！");
            return false;
         }
         _local_4.length = 120;
         var _local_6:uint = uint(120 + _local_5.length);
         SocketConnection.send(CommandID.USER_CONTRIBUTE,_arg_3,_local_6,_local_4,_local_5);
         return true;
      }
      
      public static function openNono() : void
      {
         var r:VipSession = new VipSession();
         r.addEventListener(VipSession.GET_SESSION,function(_arg_1:Event):void
         {
         });
         r.getSession();
      }
   }
}

