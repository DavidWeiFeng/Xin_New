package com.robot.app.mapProcess
{
   import com.robot.core.*;
   import com.robot.core.aimat.*;
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.info.fbGame.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_502 extends BaseMapProcess
   {
      
      private var _film:MovieClip;
      
      private var mode:ActorModel;
      
      private var isReady:Boolean = false;
      
      private var bossOutMC:MovieClip;
      
      private var bossMC:MovieClip;
      
      private var aimatTimer:Timer;
      
      private var startTime:Number;
      
      private var endTime:Number;
      
      private var aimatCount:uint = 0;
      
      private var rightStage:String;
      
      public function MapProcess_502()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.bossOutMC = conLevel["effectAndBoss"];
         this.mode = MainManager.actorModel;
         this.mode.addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
         SocketConnection.addCmdListener(CommandID.FB_GAME_OVER,this.onGameOverHandler);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchHandler);
      }
      
      private function onMapSwitchHandler(_arg_1:MapEvent) : void
      {
         if(this.isReady)
         {
            SocketConnection.addCmdListener(CommandID.LEAVE_GAME,this.onLeaveGameHandler);
            SocketConnection.send(CommandID.LEAVE_GAME,[1]);
            Alarm.show("你已经离开了游戏位置");
         }
      }
      
      private function onGameOverHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:GameOverUserInfo = null;
         var _local_6:uint = 0;
         this.isReady = false;
         this.mode.removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         SocketConnection.removeCmdListener(CommandID.FB_GAME_OVER,this.onGameOverHandler);
         this.conLevel[this.rightStage].filters = null;
         if(this.bossOutMC.currentFrame >= 2)
         {
            this.bossOutMC.gotoAndPlay(1);
         }
         this.bossOutMC.gotoAndPlay(2);
         this.bossOutMC.addEventListener(Event.ENTER_FRAME,this.onBossOutMCFrameHandler);
         var _local_3:FBGameOverInfo = _arg_1.data as FBGameOverInfo;
         var _local_4:Array = _local_3.userList as Array;
         var _local_5:uint = uint(MainManager.actorModel.info.userID);
         while(_local_6 < _local_4.length)
         {
            _local_2 = _local_4[_local_6] as GameOverUserInfo;
            if(_local_5 == _local_2.id)
            {
               MainManager.actorModel.walkAction(_local_2.pos);
            }
            _local_6++;
         }
      }
      
      private function onBossOutMCFrameHandler(_arg_1:Event) : void
      {
         if(this.bossOutMC.currentFrame == this.bossOutMC.totalFrames)
         {
            this.bossOutMC.removeEventListener(Event.ENTER_FRAME,this.onBossOutMCFrameHandler);
            this.bossMC = this.bossOutMC["bossMC"];
            this.bossMC.buttonMode = true;
            ResourceManager.getResource(ClientConfig.getResPath("eff/film.swf"),this.onLoad);
            this.aimatTimer = new Timer(1000);
            this.aimatTimer.addEventListener(TimerEvent.TIMER,this.onAimatTimerHandler);
            this.aimatTimer.start();
            this.startTime = new Date().getTime();
         }
      }
      
      private function onAimatTimerHandler(_arg_1:TimerEvent) : void
      {
         this.endTime = new Date().getTime();
         if(this.aimatCount >= 5)
         {
            if(Boolean(this._film))
            {
               AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
               this._film.addFrameScript(this._film.totalFrames - 1,this.onEnter);
               this._film.gotoAndPlay("s_3");
               this.bossMC.addEventListener(MouseEvent.CLICK,this.onBossClickHandler);
               this.aimatTimer.stop();
               this.aimatTimer.removeEventListener(TimerEvent.TIMER,this.onAimatTimerHandler);
               this.aimatTimer = null;
            }
         }
         if((this.endTime - this.startTime) / 1000 / 60 >= 1)
         {
            this.startTime = new Date().getTime();
            this.aimatCount = 0;
         }
      }
      
      private function onBossClickHandler(_arg_1:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.CHALLENGE_BOSS,this.onChallengeBOSSHandler);
         SocketConnection.send(CommandID.CHALLENGE_BOSS,0);
      }
      
      private function onEnter() : void
      {
         if(Boolean(this._film))
         {
            this._film.addFrameScript(this._film.totalFrames - 1,null);
         }
         DisplayUtil.removeForParent(this._film);
         this._film = null;
      }
      
      private function onLoad(_arg_1:DisplayObject) : void
      {
         this._film = _arg_1 as MovieClip;
         this._film.scaleY = 1.5;
         this._film.scaleX = 1.5;
         this._film.y = -10;
         this._film.gotoAndStop("s_1");
         this.bossMC.addChild(this._film);
      }
      
      private function onAimat(_arg_1:AimatEvent) : void
      {
         var _local_2:AimatInfo = _arg_1.info;
         if(_local_2.id == 10001)
         {
            if(Boolean(this._film))
            {
               if(this._film.hitTestPoint(_local_2.endPos.x,_local_2.endPos.y))
               {
                  ++this.aimatCount;
                  if(this._film.currentLabel != "s_2")
                  {
                     this._film.gotoAndPlay("s_2");
                  }
                  SocketConnection.send(CommandID.ATTACK_BOSS,0);
               }
            }
         }
      }
      
      private function onWalkStart(_arg_1:RobotEvent) : void
      {
         if(this.isReady)
         {
            SocketConnection.addCmdListener(CommandID.LEAVE_GAME,this.onLeaveGameHandler);
            SocketConnection.send(CommandID.LEAVE_GAME,[1]);
         }
      }
      
      private function onChallengeBOSSHandler(_arg_1:SocketEvent) : void
      {
      }
      
      override public function destroy() : void
      {
         this.isReady = false;
         this.aimatCount = 0;
         if(Boolean(this.aimatTimer))
         {
            this.aimatTimer.stop();
            this.aimatTimer.removeEventListener(TimerEvent.TIMER,this.onAimatTimerHandler);
            this.aimatTimer = null;
         }
         if(Boolean(this.mode))
         {
            this.mode.removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
            this.mode = null;
         }
         if(this.bossOutMC.hasEventListener(Event.ENTER_FRAME))
         {
            this.bossOutMC.removeEventListener(Event.ENTER_FRAME,this.onBossOutMCFrameHandler);
         }
         this.onEnter();
         SocketConnection.removeCmdListener(CommandID.FB_GAME_OVER,this.onGameOverHandler);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchHandler);
         SocketConnection.removeCmdListener(CommandID.CHALLENGE_BOSS,this.onChallengeBOSSHandler);
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         this.bossOutMC = null;
         this.bossMC = null;
      }
      
      public function onStand(_arg_1:MovieClip) : void
      {
         this.rightStage = _arg_1.name;
         var _local_2:Array = [];
         switch(_arg_1.name)
         {
            case "standMC_0":
               _local_2.push(1);
               break;
            case "standMC_1":
               _local_2.push(2);
               break;
            case "standMC_2":
               _local_2.push(3);
         }
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoinGameHandler);
         SocketConnection.send(CommandID.JOIN_GAME,_local_2);
      }
      
      private function onJoinGameHandler(_arg_1:SocketEvent) : void
      {
         this.isReady = true;
         var _local_2:GlowFilter = new GlowFilter();
         _local_2.blurX = 50;
         _local_2.blurY = 50;
         _local_2.strength = 8;
         _local_2.alpha = 1;
         _local_2.color = 16777215;
         var _local_3:Array = new Array(_local_2);
         this.conLevel[this.rightStage].filters = _local_3;
         this.conLevel["standMC_0"].mouseEnabled = false;
         this.conLevel["standMC_1"].mouseEnabled = false;
         this.conLevel["standMC_2"].mouseEnabled = false;
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoinGameHandler);
      }
      
      private function onLeaveGameHandler(_arg_1:SocketEvent) : void
      {
         this.conLevel[this.rightStage].filters = null;
         this.isReady = false;
         SocketConnection.removeCmdListener(CommandID.LEAVE_GAME,this.onLeaveGameHandler);
         this.conLevel["standMC_0"].mouseEnabled = true;
         this.conLevel["standMC_1"].mouseEnabled = true;
         this.conLevel["standMC_2"].mouseEnabled = true;
      }
   }
}

