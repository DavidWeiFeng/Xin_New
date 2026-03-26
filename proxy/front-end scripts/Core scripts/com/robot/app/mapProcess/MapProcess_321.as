package com.robot.app.mapProcess
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.utils.*;
   import org.taomee.utils.*;
   
   public class MapProcess_321 extends BaseMapProcess
   {
      
      private var sinNum:Number = 0;
      
      private var djMovieMC:MovieClip;
      
      private var boss_0:MovieClip;
      
      private var boss_1:MovieClip;
      
      private var enemyArr:Array = [];
      
      private var guarderArr:Array = [];
      
      private var shotedEnemy:MovieClip;
      
      private var shotCount:uint;
      
      private var intervalId_0:uint;
      
      private var intervalId_1:uint;
      
      private var intervalId_2:uint;
      
      public function MapProcess_321()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initTask();
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MainManager.actorModel.addEventListener(RobotEvent.WALK_END,this.onWalkEnd);
      }
      
      override public function destroy() : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         clearTimeout(this.intervalId_0);
         clearTimeout(this.intervalId_1);
         clearTimeout(this.intervalId_2);
      }
      
      private function onWalk(_arg_1:RobotEvent) : void
      {
         this.sinNum += 0.1;
         MainManager.actorModel.y += Math.sin(this.sinNum) * 10;
         MainManager.actorModel.x += Math.sin(this.sinNum) * 10;
      }
      
      private function onWalkEnd(_arg_1:RobotEvent) : void
      {
         this.sinNum = 0;
      }
      
      private function initTask() : void
      {
         var _local_1:String = null;
         var _local_2:MovieClip = null;
         var _local_3:String = null;
         var _local_4:MovieClip = null;
         var _local_5:uint = 0;
         var _local_6:uint = 0;
         this.djMovieMC = animatorLevel["djMovieMC"];
         this.djMovieMC.visible = false;
         this.djMovieMC.gotoAndStop(1);
         this.boss_0 = animatorLevel["boss_0"];
         this.boss_0.visible = false;
         this.boss_0.gotoAndStop(1);
         this.boss_1 = animatorLevel["boss_1"];
         this.boss_1.visible = false;
         this.boss_1.gotoAndStop(1);
         while(_local_5 < 3)
         {
            _local_1 = "enemy_" + _local_5;
            _local_2 = animatorLevel[_local_1];
            _local_2.shotCount = 0;
            _local_2.gotoAndStop(1);
            this.enemyArr.push(_local_2);
            _local_5++;
         }
         while(_local_6 < 4)
         {
            _local_3 = "guarder_" + _local_6;
            _local_4 = animatorLevel[_local_3];
            this.guarderArr.push(_local_4);
            _local_6++;
         }
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onShotEnemy);
      }
      
      private function onShotEnemy(_arg_1:AimatEvent) : void
      {
         var _local_2:MovieClip = null;
         var _local_3:Point = _arg_1.info.endPos;
         for each(_local_2 in this.enemyArr)
         {
            if(_local_2.hitTestPoint(_local_3.x,_local_3.y))
            {
               ++_local_2.shotCount;
               if(_local_2.shotCount == 2)
               {
                  _local_2.gotoAndStop(2);
                  this.checkDJ();
               }
            }
         }
      }
      
      private function checkDJ() : void
      {
         var mc:MovieClip = null;
         for each(mc in this.enemyArr)
         {
            if(mc.currentFrame != 2)
            {
               return;
            }
         }
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onShotEnemy);
         this.djMovieMC.visible = true;
         this.djMovieMC.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
         {
            if(djMovieMC.currentFrame == djMovieMC.totalFrames)
            {
               djMovieMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               boss_0.visible = true;
               boss_0.gotoAndStop(2);
               boss_1.visible = true;
               boss_1.gotoAndStop(2);
               AimatController.addEventListener(AimatEvent.PLAY_END,onShotBoss);
            }
         });
         this.djMovieMC.gotoAndPlay(2);
      }
      
      private function onShotBoss(evt:AimatEvent) : void
      {
         var p:Point = evt.info.endPos;
         if(this.boss_0.hitTestPoint(p.x,p.y))
         {
            this.boss_0.gotoAndStop(4);
            AimatController.removeEventListener(AimatEvent.PLAY_END,this.onShotBoss);
            this.intervalId_0 = setTimeout(function():void
            {
               clearTimeout(intervalId_0);
               boss_0.gotoAndStop(5);
            },2000);
            this.intervalId_1 = setTimeout(this.dialogBossOne,5000);
         }
         if(this.boss_1.hitTestPoint(p.x,p.y))
         {
            this.boss_1.gotoAndStop(3);
         }
      }
      
      private function dialogBossOne() : void
      {
         clearTimeout(this.intervalId_1);
         NpcTipDialog.show("哈哈哈哈～～\r    你们的射击在我眼里简直就像静止的一样。反正你们的飞船都会被击毁，就别浪费弹药了！",function():void
         {
            NpcTipDialog.show("艾里逊，你别在那里和他们闹着玩了。居然敢和我们为敌，我看你们这是自寻死路！",function():void
            {
               boss_1.gotoAndStop(4);
               intervalId_2 = setTimeout(function():void
               {
                  var mc:* = undefined;
                  clearTimeout(intervalId_2);
                  for each(mc in guarderArr)
                  {
                     DisplayUtil.removeForParent(mc);
                     mc = null;
                  }
                  NpcTipDialog.show("佐格，主舰上发信号来了。\r    别浪费能量对付他们了。只要主炮一发射他们就都会玩完。\r    看来我们是后会无期了，啊哈哈哈哈～～",function():void
                  {
                     var _local_1:* = new MCLoader("resource/bounsMovie/preemptiveOne.swf",LevelManager.appLevel,1,"加载动画...");
                     _local_1.addEventListener(MCLoadEvent.SUCCESS,onLoaded);
                     _local_1.doLoad();
                  },NpcTipDialog.ALLISON,0,null,null,false);
               },4200);
            },NpcTipDialog.ZOG,0,null,null,false);
         },NpcTipDialog.ALLISON,0,null,null,false);
      }
      
      private function onLoaded(evt:MCLoadEvent) : void
      {
         var mc:MovieClip = null;
         mc = null;
         var app:ApplicationDomain = evt.getApplicationDomain();
         mc = new (app.getDefinition("PreemptiveOne") as Class)() as MovieClip;
         LevelManager.appLevel.addChild(mc);
         mc.x = 480;
         mc.y = 280;
         mc.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
         {
            if(mc.currentFrame == mc.totalFrames)
            {
               mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               DisplayUtil.removeForParent(mc);
               mc = null;
               MapManager.changeMap(4);
               TasksManager.complete(69,1);
            }
         });
      }
   }
}

