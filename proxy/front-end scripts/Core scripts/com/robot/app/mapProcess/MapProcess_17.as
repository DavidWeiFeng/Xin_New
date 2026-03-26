package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.*;
   import com.robot.app.task.SeerInstructor.*;
   import com.robot.app.task.boss.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.aimat.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.info.task.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.npc.*;
   import com.robot.core.ui.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_17 extends BaseMapProcess
   {
      
      public static var bFight:Boolean;
      
      private var npc:MovieClip;
      
      private var strArray:Array = ["快点来救我，旁边这个大怪物太可怕了","你就不能去找个工具铺条路出来","我这还被火烤着呢？！想办法把火灭了"];
      
      private var index:uint = 0;
      
      private var timer:Timer;
      
      private var stone1:MovieClip;
      
      private var stone2:MovieClip;
      
      private var bShoot1:Boolean;
      
      private var bShoot2:Boolean;
      
      private var bShootFire:Boolean;
      
      private var fire_mc:MovieClip;
      
      private var catchTimer:Timer;
      
      private var isCacthing:Boolean = false;
      
      private var gelin_mc:BossModel;
      
      private var buluIDs:Array = [108,109,110];
      
      public function MapProcess_17()
      {
         super();
      }
      
      override protected function init() : void
      {
         var msgBox:DialogBox = null;
         NewInstructorContoller.chekWaste();
         if(TasksManager.taskList[302] != 3)
         {
            this.npc = depthLevel["npc"];
            this.fire_mc = depthLevel["fire_mc"];
            this.timer = new Timer(8000);
            this.timer.addEventListener(TimerEvent.TIMER,this.timerEvent);
            this.timer.start();
            msgBox = new DialogBox();
            msgBox.show(this.strArray[this.index],10,-msgBox.height - 2,this.npc);
            ++this.index;
         }
         this.stone1 = conLevel["s1_mc"];
         this.stone2 = conLevel["s2_mc"];
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
         if(TasksManager.taskList[302] == 3)
         {
            depthLevel["npc"].visible = false;
            conLevel["bossHu1"].visible = false;
            DisplayUtil.removeForParent(typeLevel["thirdMC"]);
            depthLevel["fire_mc"].visible = false;
         }
         if(HuLiAo.changeStatus)
         {
            (depthLevel["fire_mc"] as MovieClip).stop();
            depthLevel["fire_mc"].visible = false;
            DisplayUtil.removeForParent(typeLevel["thirdMC"]);
            MapManager.currentMap.makeMapArray();
            this.bShootFire = true;
            HuLiAo.changeStatus = false;
         }
         if(HuLiAo.bFirstWin)
         {
            NpcTipDialog.show("感谢你来营救我，但你别得意，我们海盗和赛尔的事情没完，我们一定会战胜你的。后会有期！",this.getAward,NpcTipDialog.BAD_GUARD);
            HuLiAo.bFirstWin = false;
         }
         if(HuLiAo.bStart)
         {
            HuLiAo.removeListener();
            HuLiAo.bStart = false;
         }
         this.catchTimer = new Timer(10 * 1000,1);
         this.catchTimer.addEventListener(TimerEvent.TIMER,this.onCatchTimer);
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,arguments.callee);
            var _local_3:Date = (_arg_1.data as SystemTimeInfo).date;
            if([0,6].indexOf(_local_3.day) == -1)
            {
               return;
            }
            if(MainManager.actorModel.pet != null)
            {
               initGelin(buluIDs.indexOf(int(MainManager.actorModel.pet.info.petID)) > -1);
            }
            SocketConnection.addCmdListener(CommandID.PET_SHOW,petShowHandle);
         });
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      
      public function petShowHandle(_arg_1:SocketEvent) : void
      {
         var _local_2:PetShowInfo = _arg_1.data as PetShowInfo;
         if(_local_2.userID == MainManager.actorInfo.userID)
         {
            this.initGelin(this.buluIDs.indexOf(int(_local_2.petID)) > -1 && _local_2.flag == 1);
         }
      }
      
      public function initGelin(flag:Boolean) : void
      {
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
            var _local_3:MiningCountInfo = _arg_1.data as MiningCountInfo;
            var _local_4:uint = _local_3.miningCount;
            if(!gelin_mc)
            {
               gelin_mc = new BossModel(62,17);
               gelin_mc.show(new Point(480,240),0);
               gelin_mc.mouseEnabled = true;
               gelin_mc.addEventListener(MouseEvent.CLICK,fightGelin);
               ToolTipManager.add(gelin_mc,"格林");
            }
            gelin_mc.visible = _local_4 == 0 ? flag : false;
         });
         SocketConnection.send(CommandID.TALK_COUNT,700001 - 500000);
      }
      
      public function fightGelin(e:MouseEvent) : void
      {
         NpcDialog.show(62,["布鲁，我终于找到你啦！#1"],["(他看起来很高兴呢~[进入捕捉页面])","装傻"],[function():void
         {
            FightInviteManager.fightWithBoss("格林",1);
            EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onFightOver);
         },null]);
      }
      
      public function onFightOver(_arg_1:PetFightEvent) : void
      {
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,arguments.callee);
         this.initGelin(true);
      }
      
      public function clearWaste() : void
      {
         NewInstructorContoller.setWaste();
      }
      
      override public function destroy() : void
      {
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.timerEvent);
            this.timer = null;
         }
         if(Boolean(this.fire_mc))
         {
            this.fire_mc.removeEventListener(Event.ENTER_FRAME,this.onEnterFire);
            this.fire_mc = null;
         }
         if(Boolean(this.stone1))
         {
            this.stone1.removeEventListener(Event.ENTER_FRAME,this.onEnterStone1);
            this.stone1 = null;
         }
         if(Boolean(this.stone2))
         {
            this.stone2.removeEventListener(Event.ENTER_FRAME,this.onEnterStone2);
            this.stone2 = null;
         }
         this.npc = null;
         this.catchTimer.stop();
         this.catchTimer.removeEventListener(TimerEvent.TIMER,this.onCatchTimer);
         this.catchTimer = null;
         var _local_1:ActorModel = MainManager.actorModel;
         _local_1.removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         SocketConnection.removeCmdListener(CommandID.PET_SHOW,this.petShowHandle);
      }
      
      private function getAward() : void
      {
      }
      
      private function timerEvent(_arg_1:TimerEvent) : void
      {
         var _local_2:DialogBox = new DialogBox();
         _local_2.show(this.strArray[this.index],10,-_local_2.height - 2,this.npc);
         ++this.index;
         if(this.index > this.strArray.length - 1)
         {
            this.index = 0;
         }
      }
      
      private function onAimat(_arg_1:AimatEvent) : void
      {
         var _local_2:AimatInfo = _arg_1.info;
         if(_local_2.userID != MainManager.actorID)
         {
            return;
         }
         if(_local_2.id != 10002)
         {
            return;
         }
         if(this.bShoot1 && this.bShoot2 && this.bShootFire)
         {
            return;
         }
         if(this.stone1.hitTestPoint(_local_2.endPos.x,_local_2.endPos.y) && !this.bShoot1)
         {
            this.stone1.play();
            this.stone1.addEventListener(Event.ENTER_FRAME,this.onEnterStone1);
         }
         if(this.stone2.hitTestPoint(_local_2.endPos.x,_local_2.endPos.y) && !this.bShoot2)
         {
            this.stone2.play();
            this.stone2.addEventListener(Event.ENTER_FRAME,this.onEnterStone2);
         }
         if(this.fire_mc == null)
         {
            return;
         }
         if(this.fire_mc.hitTestPoint(_local_2.endPos.x,_local_2.endPos.y) && !this.bShootFire)
         {
            this.fire_mc.gotoAndStop(2);
            this.fire_mc.addEventListener(Event.ENTER_FRAME,this.onEnterFire);
         }
      }
      
      public function changeBoss() : void
      {
         if(TasksManager.taskList[302] == 3)
         {
            HuLiAo.startFight();
         }
         else
         {
            NpcTipDialog.show("赛尔机器人" + MainManager.actorInfo.nick + "，你真是好心人前来营救我！快点想办法击败身边这个精灵，我可打不过它，它要再扑过来，咱们都完蛋。",this.startFight,NpcTipDialog.BAD_GUARD);
         }
      }
      
      private function startFight() : void
      {
         HuLiAo.startFight();
      }
      
      private function onEnterFire(_arg_1:Event) : void
      {
         if(this.fire_mc.currentFrame == this.fire_mc.totalFrames)
         {
            this.fire_mc.removeEventListener(Event.ENTER_FRAME,this.onEnterFire);
            this.fire_mc.stop();
            DisplayUtil.removeForParent(typeLevel["thirdMC"]);
            MapManager.currentMap.makeMapArray();
            this.bShootFire = true;
            this.changeWord();
         }
      }
      
      private function changeWord() : void
      {
         if(this.bShoot1 && this.bShoot2 && this.bShootFire)
         {
            this.strArray = ["快点来救我，旁边这个大怪物太可怕了"];
         }
         if(this.bShoot1 && this.bShoot2)
         {
            this.strArray = ["快点来救我，旁边这个大怪物太可怕了","我这还被火烤着呢？！想办法把火灭了"];
         }
         if(this.bShootFire)
         {
            this.strArray = ["快点来救我，旁边这个大怪物太可怕了","你就不能去找个工具铺条路出来"];
         }
         this.index = 0;
      }
      
      private function onEnterStone2(_arg_1:Event) : void
      {
         if(this.stone2.currentFrame == this.stone2.totalFrames)
         {
            this.stone2.removeEventListener(Event.ENTER_FRAME,this.onEnterStone2);
            this.stone2.stop();
            DisplayUtil.removeForParent(typeLevel["secondMC"]);
            MapManager.currentMap.makeMapArray();
            this.bShoot2 = true;
            this.changeWord();
         }
      }
      
      private function onEnterStone1(_arg_1:Event) : void
      {
         if(this.stone1.currentFrame == this.stone1.totalFrames)
         {
            this.stone1.removeEventListener(Event.ENTER_FRAME,this.onEnterStone1);
            this.stone1.stop();
            DisplayUtil.removeForParent(typeLevel["firstMC"]);
            MapManager.currentMap.makeMapArray();
            this.bShoot1 = true;
            this.changeWord();
         }
      }
      
      public function clickBrume() : void
      {
         var mc:MovieClip = null;
         mc = null;
         mc = conLevel["brumeMC"];
         var mode:ActorModel = MainManager.actorModel;
         var petMode:PetModel = mode.pet;
         if(Boolean(petMode))
         {
            if(PetXMLInfo.getType(petMode.info.petID) == "2")
            {
               mc.mouseEnabled = false;
               mc.mouseChildren = false;
               mc["mc"].gotoAndPlay(3);
               mc.addFrameScript(62,function():void
               {
                  DisplayUtil.removeForParent(mc);
               });
            }
         }
      }
      
      public function catchStone() : void
      {
      }
      
      private function onCheckTask(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            Alarm.show("你已经收集过炎晶了");
            return;
         }
         if(MainManager.actorInfo.clothIDs.indexOf(100014) == -1)
         {
            Alarm.show("矿石挖掘需要专业工具挖矿钻头，若你已从机械室找到它，快把它装备上吧！");
            return;
         }
         this.catchTimer.stop();
         this.catchTimer.reset();
         this.catchTimer.start();
         this.isCacthing = true;
         var _local_2:ActorModel = MainManager.actorModel;
         _local_2.addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         _local_2.specialAction(100014);
         _local_2.parent.addChild(_local_2);
         _local_2.skeleton.getBodyMC().scaleX = -1;
      }
      
      private function onCatchTimer(_arg_1:TimerEvent) : void
      {
         this.isCacthing = false;
      }
      
      private function onWalkStart(_arg_1:RobotEvent) : void
      {
         var _local_2:ActorModel = null;
         if(this.isCacthing)
         {
            Alarm.show("随便走动是无法收集炎晶的哦！");
            this.isCacthing = false;
            _local_2 = MainManager.actorModel;
            _local_2.skeleton.getBodyMC().scaleX = 1;
            this.catchTimer.stop();
         }
      }
   }
}

