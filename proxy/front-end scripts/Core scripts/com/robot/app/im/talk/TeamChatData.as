package com.robot.app.im.talk
{
   import com.robot.core.info.TeamChatInfo;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.EventManager;
   
   public class TeamChatData
   {
      
      public static const TEAM_CHAT_EVENT:String = "TeamChat";
      
      private static var _chatList:Array = [];
      
      public function TeamChatData()
      {
         super();
      }
      
      public static function addTeamChat(_arg_1:TeamChatInfo) : void
      {
         _chatList.push(_arg_1);
         EventManager.dispatchEvent(new DynamicEvent(TEAM_CHAT_EVENT,_chatList));
      }
      
      public static function get chatList() : Array
      {
         return _chatList;
      }
   }
}

