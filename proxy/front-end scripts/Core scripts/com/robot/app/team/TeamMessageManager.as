package com.robot.app.team
{
   import com.robot.app.user.*;
   import com.robot.core.*;
   import com.robot.core.info.team.TeamInformInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.Sprite;
   import flash.events.*;
   
   public class TeamMessageManager
   {
      
      public function TeamMessageManager()
      {
         super();
      }
      
      public static function show(info:TeamInformInfo) : void
      {
         var sprite:Sprite = null;
         var type:uint = uint(info.type);
         switch(type)
         {
            case CommandID.TEAM_ANSWER:
               if(info.data1 == 0)
               {
                  Alarm.show("很遗憾，你申请加入战队的申请被拒绝了");
               }
               else
               {
                  Alarm.show("你的申请已经通过，恭喜你成功加入战队");
                  MainManager.actorInfo.teamInfo.id = info.data2;
                  MainManager.actorInfo.teamInfo.priv = 5;
               }
               return;
            case CommandID.TEAM_CHANGE_ADMIN:
               Alarm.show("你的级别被调整为：" + TextFormatUtil.getRedTxt(TeamController.ADMIN_STR[info.data1]));
               MainManager.actorInfo.teamInfo.priv = info.data1;
               return;
            case CommandID.TEAM_DELET_MEMBER:
               Alarm.show("你已经被移出战队了");
               MainManager.actorInfo.teamInfo.id = 0;
               return;
            case CommandID.TEAM_INVITE_TO_JOIN:
               sprite = Answer.show(TextFormatUtil.getEventTxt(info.nick + "(" + info.userID + ")",info.userID.toString()) + "邀请你加入他的战队，你愿意吗？",function():void
               {
                  TeamController.join(info.data2);
               });
               sprite.addEventListener(TextEvent.LINK,function(_arg_1:TextEvent):void
               {
                  UserInfoController.show(uint(_arg_1.text));
                  LevelManager.topLevel.addChild(UserInfoController.panel);
               });
         }
      }
   }
}

