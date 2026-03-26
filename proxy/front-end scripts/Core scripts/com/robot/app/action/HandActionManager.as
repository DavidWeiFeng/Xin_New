package com.robot.app.action
{
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.Direction;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class HandActionManager
   {
      
      private static var waitTimer:Timer;
      
      private static var overFunc:Function;
      
      private static var walkFunc:Function;
      
      public function HandActionManager()
      {
         super();
      }
      
      public static function onHeadAction(_arg_1:uint, _arg_2:Function = null, _arg_3:uint = 10000, _arg_4:Function = null, _arg_5:Function = null, _arg_6:Boolean = true) : void
      {
         overFunc = _arg_4;
         walkFunc = _arg_5;
         if(MainManager.actorInfo.clothIDs.indexOf(_arg_1) == -1 && MainManager.actorInfo.clothIDs.indexOf(100717) == -1)
         {
            if(_arg_2 != null)
            {
               _arg_2();
            }
            else
            {
               Alarm.show("你没有相应的工具噢,装备好了它再来吧!");
            }
            return;
         }
         if(!_arg_6)
         {
            MainManager.actorModel.skeleton.getSkeletonMC().scaleX = -1;
         }
         if(MainManager.actorInfo.clothIDs.indexOf(_arg_1) == -1)
         {
            MainManager.actorModel.specialAction(100717);
         }
         else
         {
            MainManager.actorModel.specialAction(_arg_1);
         }
         var _local_7:Sprite = MainManager.actorModel.sprite;
         _local_7.parent.addChild(_local_7);
         if(waitTimer != null)
         {
            waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimeOver);
            waitTimer = null;
         }
         waitTimer = new Timer(_arg_3,1);
         waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimeOver);
         waitTimer.start();
         MainManager.actorModel.sprite.addEventListener(RobotEvent.WALK_START,onWalk);
      }
      
      private static function onTimeOver(_arg_1:TimerEvent) : void
      {
         waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimeOver);
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_START,onWalk);
         MainManager.actorModel.stopSpecialAct();
         MainManager.actorModel.skeleton.getSkeletonMC().scaleX = 1;
         if(overFunc != null)
         {
            overFunc();
         }
      }
      
      private static function onWalk(_arg_1:RobotEvent) : void
      {
         waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimeOver);
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_START,onWalk);
         waitTimer.stop();
         MainManager.actorModel.stop();
         MainManager.actorModel.stopSpecialAct();
         MainManager.actorModel.direction = Direction.DOWN;
         MainManager.actorModel.skeleton.getSkeletonMC().scaleX = 1;
         if(walkFunc != null)
         {
            walkFunc();
         }
         else
         {
            Alarm.show("不能随便走动噢");
         }
      }
   }
}

