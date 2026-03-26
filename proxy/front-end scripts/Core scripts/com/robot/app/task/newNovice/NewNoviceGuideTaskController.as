package com.robot.app.task.newNovice
{
   import com.robot.app.fightNote.*;
   import com.robot.app.task.noviceGuide.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.attack.*;
   import com.robot.core.manager.*;
   import flash.display.Sprite;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class NewNoviceGuideTaskController
   {
      
      private static var _timeIcon:Sprite;
      
      private static var TASI_ID_A:Array = [85,86,87,88];
      
      public function NewNoviceGuideTaskController()
      {
         super();
      }
      
      public static function setup() : void
      {
         if(!MainManager.checkIsNovice())
         {
            GuideTaskModel.checkTaskStatus();
         }
      }
      
      public static function start() : void
      {
         var _local_1:int = 0;
         _timeIcon = UIManager.getSprite("news_Icon");
         _timeIcon.x = 24;
         _timeIcon.y = 20;
         LevelManager.appLevel.addChild(_timeIcon);
         _timeIcon.mouseChildren = false;
         _timeIcon.mouseEnabled = false;
         _timeIcon["ball"].visible = false;
         _timeIcon["ball"].gotoAndStop(1);
         while(_local_1 < TASI_ID_A.length)
         {
            if(TasksManager.getTaskStatus(TASI_ID_A[_local_1]) != TasksManager.COMPLETE)
            {
               playStep(_local_1 + 1);
               return;
            }
            _local_1++;
         }
      }
      
      public static function flash() : void
      {
         _timeIcon["ball"].visible = true;
         _timeIcon["ball"].play();
      }
      
      public static function stop() : void
      {
         _timeIcon["ball"].visible = false;
         _timeIcon["ball"].gotoAndStop(1);
      }
      
      public static function playStep(_arg_1:uint) : void
      {
         switch(_arg_1)
         {
            case 1:
               NewNoviceStepOneController.start();
               return;
            case 2:
               NewNoviceStepTwoController.start();
               return;
            case 3:
               NewNoviceStepThreeController.start();
               return;
            case 4:
               NewNoviceStepFourController.start();
         }
      }
      
      public static function comStep(_arg_1:uint) : void
      {
         TasksManager.complete(_arg_1,0);
      }
      
      public static function fightBoss() : void
      {
         FightInviteManager.fightWithBoss("赛尔精灵",0,true);
         EventManager.addEventListener(PetFightEvent.ALARM_CLICK,onCloseFight);
      }
      
      private static function onCloseFight(e:PetFightEvent) : void
      {
         var info:FightOverInfo = null;
         EventManager.removeEventListener(PetFightEvent.ALARM_CLICK,onCloseFight);
         info = e.dataObj as FightOverInfo;
         if(info.winnerID != MainManager.actorID)
         {
            NewNpcDiaDialog.show(["看来你现在还无法与精灵做到心灵相通。不过也不用心急，多多与它亲近，它会逐渐成长为你的有力助手的！这些精灵胶囊就送给你了，用它们去捕捉更多强大的精灵吧！"],[function():void
            {
               comStep(87);
            }]);
         }
         else
         {
            NewNpcDiaDialog.show(["不错嘛！竟然战胜了我的精灵。这些精灵胶囊就送给你了，用它们去捕捉更多强大的精灵作为你的伙伴吧！"],[function():void
            {
               comStep(87);
            }]);
         }
      }
      
      public static function showTip(_arg_1:uint, _arg_2:Boolean = true) : void
      {
         MapManager.currentMap.controlLevel["toolMc"].gotoAndStop(_arg_1);
         showMask(_arg_2);
      }
      
      public static function showMask(_arg_1:Boolean) : void
      {
         MapManager.currentMap.controlLevel["maskMc"].visible = _arg_1;
      }
      
      public static function destroy() : void
      {
         if(Boolean(_timeIcon))
         {
            DisplayUtil.removeForParent(_timeIcon);
            _timeIcon = null;
         }
         TASI_ID_A = null;
         EventManager.removeEventListener(PetFightEvent.ALARM_CLICK,onCloseFight);
      }
   }
}

