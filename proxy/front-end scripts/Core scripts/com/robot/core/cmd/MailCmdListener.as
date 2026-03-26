package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.MailEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.manager.mail.MailManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class MailCmdListener extends BaseBeanController
   {
      
      public static var isShowTip:Boolean = true;
      
      public function MailCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MAIL_NEW_NOTE,this.onNewMail);
         SocketConnection.addCmdListener(CommandID.MAIL_SEND,this.onSendMail);
         SocketConnection.addCmdListener(CommandID.MAIL_DEL_ALL,this.onDeleteAll);
         SocketConnection.addCmdListener(CommandID.MAIL_DELETE,this.onDelete);
         finish();
      }
      
      private function onNewMail(_arg_1:SocketEvent) : void
      {
         MailManager.getNew();
      }
      
      private function onSendMail(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         MainManager.actorInfo.coins = _local_3;
         Alarm.show("恭喜你，邮件发送成功！");
         MailManager.dispatchEvent(new MailEvent(MailEvent.MAIL_SEND));
      }
      
      private function onDelete(_arg_1:SocketEvent) : void
      {
         if(isShowTip)
         {
            Alarm.show("邮件删除成功");
         }
         else
         {
            isShowTip = true;
         }
         MailManager.dispatchEvent(new MailEvent(MailEvent.MAIL_DELETE));
      }
      
      private function onDeleteAll(_arg_1:SocketEvent) : void
      {
         Alarm.show("邮件删除成功");
         MailManager.dispatchEvent(new MailEvent(MailEvent.MAIL_CLEAR));
      }
   }
}

