package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.ChatEvent;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.ChatInfo;
   import com.robot.core.manager.MessageManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class ChatCmdListener
   {
      
      public function ChatCmdListener()
      {
         super();
      }
      
      public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHAT,this.onChat);
      }
      
      private function onChat(_arg_1:SocketEvent) : void
      {
         var _local_2:ChatInfo = _arg_1.data as ChatInfo;
         if(_local_2.toID == 0)
         {
            UserManager.dispatchAction(_local_2.senderID,PeopleActionEvent.CHAT,_local_2.msg);
            MessageManager.dispatchEvent(new ChatEvent(ChatEvent.CHAT_COM,_local_2));
         }
         else
         {
            MessageManager.addChatInfo(_local_2);
         }
      }
   }
}

