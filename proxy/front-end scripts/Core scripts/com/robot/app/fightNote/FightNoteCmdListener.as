package com.robot.app.fightNote
{
   import com.robot.app.info.fightInvite.*;
   import com.robot.app.user.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.ui.loading.*;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class FightNoteCmdListener extends BaseBeanController
   {
      
      private var readyData:NoteReadyToFightInfo;
      
      private var DLL_PATH:String = "com.robot.petFightModule.PetFightEntry";
      
      public function FightNoteCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NOTE_INVITE_TO_FIGHT,this.noteInviteToFight);
         SocketConnection.addCmdListener(CommandID.NOTE_HANDLE_FIGHT_INVITE,this.noteHandlerFightInvite);
         SocketConnection.addCmdListener(CommandID.NOTE_READY_TO_FIGHT,this.noteReadyToFight);
         SocketConnection.addCmdListener(CommandID.NOTE_START_FIGHT,this.startFight);
         finish();
      }
      
      private function noteInviteToFight(_arg_1:SocketEvent) : void
      {
         var _local_2:InviteNoteInfo = _arg_1.data as InviteNoteInfo;
         FightInviteManager.add(_local_2);
      }
      
      private function noteHandlerFightInvite(event:SocketEvent) : void
      {
         var data:InviteHandleInfo = null;
         var sprite:Sprite = null;
         data = null;
         data = event.data as InviteHandleInfo;
         if(data.result == 0)
         {
            sprite = Alarm.show("<a href=\'event:\'><u><font color=\'#ff0000\'>" + data.nickName + "(" + data.userID + ")</font></u></a>拒绝了你的邀请");
            sprite.addEventListener(TextEvent.LINK,function():void
            {
               UserInfoController.show(data.userID);
               LevelManager.topLevel.addChild(UserInfoController.panel);
            });
            FightWaitPanel.hide();
         }
         else if(data.result == 2)
         {
            Alarm.show("对方在线时长超过6小时！");
            FightWaitPanel.hide();
         }
         else if(data.result == 3)
         {
            Alarm.show("对方没有可以出战的精灵");
            FightWaitPanel.hide();
         }
         else if(data.result == 4)
         {
            Alarm.show("对方不在线");
            FightWaitPanel.hide();
         }
      }
      
      private function noteReadyToFight(event:SocketEvent) : void
      {
         var loader:MCLoader = null;
         var cls:* = undefined;
         loader = null;
         this.readyData = event.data as NoteReadyToFightInfo;
         try
         {
            cls = getDefinitionByName(this.DLL_PATH);
            cls.setup(this.readyData.userInfoArray,this.readyData.petArray,this.readyData.skillArray,this.readyData.petInfoArray);
         }
         catch(e:Error)
         {
            loader = new MCLoader("dll/PetFightDLL.swf",LevelManager.topLevel,Loading.TITLE_AND_PERCENT,"正在进入对战系统",true,true);
            loader.setIsShowClose(false);
            loader.addEventListener(MCLoadEvent.SUCCESS,onLoadDLL);
            loader.doLoad();
         }
         FightWaitPanel.hide();
      }
      
      private function onLoadDLL(_arg_1:MCLoadEvent) : void
      {
         var _local_2:* = getDefinitionByName(this.DLL_PATH);
         _local_2.setup(this.readyData.userInfoArray,this.readyData.petArray,this.readyData.skillArray,this.readyData.petInfoArray);
      }
      
      private function startFight(_arg_1:SocketEvent) : void
      {
         var _local_2:FightStartInfo = _arg_1.data as FightStartInfo;
         EventManager.dispatchEvent(new PetFightEvent(PetFightEvent.START_FIGHT,[_local_2.myInfo,_local_2.otherInfo]));
         var _local_3:PetFightEvent = new PetFightEvent(PetFightEvent.START_FIGHT,_local_2);
         var _local_4:* = getDefinitionByName("com.robot.petFightModule.PetFightEntry") as Class;
         EventDispatcher(_local_4.fighterCon).dispatchEvent(_local_3);
      }
   }
}

