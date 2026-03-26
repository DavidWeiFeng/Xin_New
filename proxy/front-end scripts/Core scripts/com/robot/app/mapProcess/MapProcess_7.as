package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.animate.*;
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.npc.*;
   import com.robot.core.ui.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class MapProcess_7 extends BaseMapProcess
   {
      
      private var loader:MCLoader;
      
      private var npcMc:String;
      
      private var btn:Sprite;
      
      private var btn1:Sprite;
      
      private var waterEffect:MovieClip;
      
      private var curDisplayObj:DisplayObject;
      
      private var blueMC:MovieClip;
      
      private var greenMC:MovieClip;
      
      private var blue_index:uint = 0;
      
      private var blueArray:Array = [];
      
      private var timer:Timer;
      
      private var timerIndex:uint = 0;
      
      private var strArray:Array = [];
      
      private var npcArray:Array = [];
      
      private var npc:NpcModel;
      
      private var jiguMovie:MovieClip;
      
      private var _bossMC:BossModel;
      
      public function MapProcess_7()
      {
         super();
      }
      
      override protected function init() : void
      {
         var mc:MovieClip;
         this.initBoss();
         mc = MapManager.currentMap.animatorLevel as MovieClip;
         mc.gotoAndStop(4);
         this.blueArray = UpdateConfig.blueArray.slice();
         this.strArray = UpdateConfig.brotherArray.slice();
         ToolTipManager.add(conLevel["gameMC"],"舱外回收员");
         this.npcMc = NpcTipDialog.IRIS;
         this.btn = new Sprite();
         this.btn.graphics.beginFill(65280);
         this.btn.graphics.drawRect(0,0,145,80);
         this.btn.width = 145;
         this.btn.height = 80;
         this.btn.x = 255;
         this.btn.y = 295;
         this.btn.alpha = 0;
         this.btn.buttonMode = false;
         conLevel.addChild(this.btn);
         this.btn.addEventListener(MouseEvent.CLICK,this.showTip);
         this.btn1 = new Sprite();
         this.btn1.graphics.beginFill(65280);
         this.btn1.graphics.drawRect(0,0,145,80);
         this.btn1.width = 145;
         this.btn1.height = 80;
         this.btn1.x = 543;
         this.btn1.y = 280;
         this.btn1.alpha = 0;
         this.btn1.buttonMode = false;
         conLevel.addChild(this.btn1);
         this.btn1.addEventListener(MouseEvent.CLICK,this.showTip);
         this.blueMC = depthLevel["blueMC"];
         this.blueMC.addEventListener(MouseEvent.CLICK,this.clickBlue);
         this.timer = new Timer(9000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
         this.npcArray.push(this.blueMC);
         this.onTimer();
         EventManager.addEventListener(NpcController.GET_CURNPC,function(_arg_1:Event):void
         {
            if(Boolean(NpcController.curNpc.npc))
            {
               EventManager.removeEventListener(NpcController.GET_CURNPC,arguments.callee);
               npc = NpcController.curNpc.npc;
            }
         });
         this.initTask_95();
      }
      
      private function initBoss() : void
      {
         if(!this._bossMC)
         {
            this._bossMC = new BossModel(125,7);
            this._bossMC.show(new Point(480,200),0);
            this._bossMC.scaleX = this._bossMC.scaleY = 1.5;
         }
         this._bossMC.mouseEnabled = true;
         this._bossMC.addEventListener(MouseEvent.CLICK,this.onBossClick);
         ToolTipManager.add(this._bossMC,"萨格罗斯");
      }
      
      private function onBossClick(e:MouseEvent) : void
      {
         NpcDialog.show(10,["小赛尔快来救救我！我要被萨格罗斯欺负死了……"],["我来帮你！","装傻"],[function():void
         {
            FightInviteManager.fightWithBoss("萨格罗斯");
         },null]);
      }
      
      private function clickBlue(event:MouseEvent = null) : void
      {
         FightInviteManager.fightWithBoss("测试",2);
      }
      
      override public function destroy() : void
      {
         this.npcArray = [];
         this.loader = null;
         ToolTipManager.remove(conLevel["gameMC"]);
         this.btn.removeEventListener(MouseEvent.CLICK,this.showTip);
         this.btn1.removeEventListener(MouseEvent.CLICK,this.showTip);
         this.btn1 = null;
         this.btn = null;
         this.blueMC.removeEventListener(MouseEvent.CLICK,this.clickBlue);
         this.blueMC = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         ToolTipManager.remove(this._bossMC);
         this._bossMC.removeEventListener(MouseEvent.CLICK,this.onBossClick);
      }
      
      private function onTimer(_arg_1:TimerEvent = null) : void
      {
         if(this.timerIndex == this.strArray.length)
         {
            this.timerIndex = 0;
         }
         var _local_2:DialogBox = new DialogBox();
         _local_2.show(this.strArray[this.timerIndex],0,-75,this.npcArray[this.timerIndex]);
         ++this.timerIndex;
      }
      
      private function showTip(_arg_1:MouseEvent) : void
      {
      }
      
      public function showGame() : void
      {
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoinGame);
         SocketConnection.send(CommandID.JOIN_GAME,1);
      }
      
      private function onJoinGame(_arg_1:SocketEvent) : void
      {
         MapManager.destroy();
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoinGame);
         this.loader = new MCLoader("resource/Games/Miner.swf",LevelManager.topLevel,1,"正在加载游戏");
         this.loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadDLL);
         this.loader.doLoad();
      }
      
      private function onLoadDLL(_arg_1:MCLoadEvent) : void
      {
         this.loader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadDLL);
         LevelManager.topLevel.addChild(_arg_1.getContent());
         _arg_1.getContent().addEventListener("shootGameOver",this.onGameOver);
         this.curDisplayObj = _arg_1.getContent();
      }
      
      private function onGameOver(_arg_1:Event) : void
      {
         var _local_2:* = _arg_1.target as Sprite;
         var _local_3:Object = _local_2.scoreObj;
         var _local_4:uint = uint(_local_3.per);
         var _local_5:uint = uint(_local_3.score);
         MapManager.refMap();
         SocketConnection.send(CommandID.GAME_OVER,_local_4,_local_5);
      }
      
      private function initTask_95() : void
      {
         this.jiguMovie = conLevel["jiguMovie"];
         this.jiguMovie.gotoAndStop(1);
         if(TasksManager.getTaskStatus(95) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(95,function(arr:Array):void
            {
               if(!arr[0])
               {
                  NpcDialog.show(NPC.WULIGULA,["我……我们都准备好了！船……船长让我们跟随你一同进入黑洞深渊！#2此次任务我估计凶……凶多吉少！不管了！只要小赛尔们能够记得我们就……就好！"],["无论结果如何！至少我们努力了！起程吧！"],[function():void
                  {
                     if(Boolean(npc))
                     {
                        npc.npc.visible = false;
                     }
                     blueMC.visible = false;
                     MainManager.actorModel.visible = false;
                     AnimateManager.playMcAnimate(jiguMovie,0,"",function():void
                     {
                        var url:* = "resource/bounsMovie/task_95_0.swf";
                        AnimateManager.playFullScreenAnimate(url,function():void
                        {
                           MapManager.changeLocalMap(322);
                        });
                     });
                  }]);
               }
               if(Boolean(arr[0]))
               {
                  if(Boolean(npc))
                  {
                     npc.npc.visible = false;
                  }
                  blueMC.visible = false;
               }
            });
         }
      }
   }
}

