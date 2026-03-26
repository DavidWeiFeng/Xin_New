package com.robot.app.task.noviceGuide.GuideTaskAfter
{
   import com.robot.app.fightNote.*;
   import com.robot.app.task.noviceGuide.*;
   import com.robot.app.task.taskUtils.manage.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   import org.taomee.manager.*;
   
   public class GuideTaskFight
   {
      
      private static var cLoader:Loader;
      
      private static var xixi:String;
      
      private static var fightData:FightOverInfo;
      
      private static var isEscape:Boolean;
      
      public static var bFightOK:Boolean = false;
      
      public function GuideTaskFight()
      {
         super();
      }
      
      public static function fight() : void
      {
         FightInviteManager.fightWithBoss("赛尔精灵");
         EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
         EventManager.addEventListener(RobotEvent.NO_PET_CAN_FIGHT,onNoPet);
         xixi = NpcTipDialog.CICI;
      }
      
      private static function onNoPet(_arg_1:Event) : void
      {
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
         EventManager.removeEventListener(RobotEvent.NO_PET_CAN_FIGHT,onNoPet);
      }
      
      private static function onCompleteAll() : void
      {
         GetMonsterCapsule.show("",showGetSyrup);
      }
      
      private static function showGetSyrup() : void
      {
         GetSyrup.show("",showTaskCompleteEffect);
      }
      
      private static function showTaskCompleteEffect() : void
      {
         cLoader = new Loader();
         cLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
         cLoader.load(new URLRequest("resource/task/taskComplete.swf"));
      }
      
      private static function onCloseFight(_arg_1:PetFightEvent) : void
      {
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
         var _local_2:* = getDefinitionByName("com.robot.petFightModule.PetFightEntry") as Class;
         isEscape = _local_2.fighterCon.isEscape;
         bFightOK = true;
         fightData = _arg_1.dataObj["data"];
         if(fightData.winnerID == MainManager.actorInfo.userID)
         {
            LevelManager.iconLevel.addChild(NpcTipDialog.show("不错嘛！竟然战胜了我的精灵，恭喜你完成了新船员任务！这些精灵胶囊送给你，你现在可以前往星球并使用精灵胶囊来捕捉精灵了。",onCompleteAll,xixi,-60));
         }
         else if(!isEscape)
         {
            LevelManager.iconLevel.addChild(NpcTipDialog.show("你的精灵没有体力了哦，赶快回基地帮你的精灵恢复体力吧。",null,xixi,-60));
         }
      }
      
      private static function onComplete(_arg_1:Event) : void
      {
         cLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
         LevelManager.topLevel.addChild((_arg_1.target as LoaderInfo).content);
         GuideTaskModel.removeIcon();
         TaskUIManage.destroyLoder(4);
      }
   }
}

