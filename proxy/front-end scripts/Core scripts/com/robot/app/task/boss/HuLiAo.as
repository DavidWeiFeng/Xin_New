package com.robot.app.task.boss
{
   import com.robot.app.fightNote.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.info.task.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class HuLiAo
   {
      
      public static var changeStatus:Boolean;
      
      public static var bWin:Boolean;
      
      public static var bFirstWin:Boolean;
      
      public static var bStart:Boolean;
      
      public function HuLiAo()
      {
         super();
      }
      
      public static function startFight() : void
      {
         if(bStart)
         {
            return;
         }
         bStart = true;
         setTimeout(function():void
         {
            bStart = false;
         },2000);
         FightInviteManager.fightWithBoss("里奥斯");
         EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
      }
      
      public static function removeListener() : void
      {
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
      }
      
      private static function onGetBossMonster(_arg_1:SocketEvent) : void
      {
         var _local_2:BossMonsterInfo = _arg_1.data as BossMonsterInfo;
         if(PetManager.length >= 6)
         {
            PetManager.addStorage(_local_2.petID,_local_2.captureTm);
            LevelManager.iconLevel.addChild(Alarm.show("恭喜你获得了<font color=\'#00CC00\'>胡里亚</font>，你可以在基地仓库里找到"));
            return;
         }
         PetManager.addEventListener(PetEvent.ADDED,onPetAddBag);
         PetManager.setIn(_local_2.captureTm,1);
      }
      
      private static function onPetAddBag(_arg_1:PetEvent) : void
      {
         PetManager.removeEventListener(PetEvent.ADDED,onPetAddBag);
         LevelManager.iconLevel.addChild(Alarm.show("恭喜你获得了<font color=\'#00CC00\'>胡里亚</font>，你可以点击右下方的精灵按钮来查看"));
      }
      
      private static function onCloseFight(_arg_1:PetFightEvent) : void
      {
         HuLiAo.changeStatus = true;
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
         SocketConnection.removeCmdListener(CommandID.GET_BOSS_MONSTER,onGetBossMonster);
         var _local_2:* = getDefinitionByName("com.robot.petFightModule.PetFightEntry") as Class;
         var _local_3:FightOverInfo = _arg_1.dataObj["data"];
         if(_local_3.winnerID == MainManager.actorInfo.userID)
         {
            bWin = true;
         }
      }
   }
}

