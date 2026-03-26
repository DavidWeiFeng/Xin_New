package com.robot.app.mapProcess
{
   import com.robot.app.energy.utils.*;
   import com.robot.app.fightNote.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.task.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.SharedObject;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class MapProcess_106 extends BaseMapProcess
   {
      
      private var fightMC:MovieClip;
      
      private var timer:Timer;
      
      private var type:uint;
      
      private var makeTa_btn:SimpleButton;
      
      private var ta_mc:MovieClip;
      
      private var shieldGame:AppModel;
      
      public function MapProcess_106()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _local_1:SimpleButton = null;
         var _local_2:uint = 0;
         this.fightMC = conLevel["fightMC"];
         this.makeTa_btn = conLevel["makeTa_btn"];
         this.ta_mc = conLevel["ta_mc"];
         this.ta_mc.gotoAndStop(1);
         this.ta_mc.visible = true;
         ToolTipManager.add(this.ta_mc,"防空塔");
         this.makeTa_btn.visible = false;
         while(_local_2 < 2)
         {
            _local_1 = conLevel.getChildByName("btn_" + _local_2) as SimpleButton;
            _local_1.addEventListener(MouseEvent.CLICK,this.pull);
            _local_2++;
         }
         if(TasksManager.getTaskStatus(307) == TasksManager.COMPLETE)
         {
            this.fightMC.mouseEnabled = true;
            conLevel["bossMC"].gotoAndStop(3);
         }
         else
         {
            this.fightMC.mouseEnabled = false;
            conLevel["bossMC"].gotoAndStop(1);
         }
         this.ta_mc.buttonMode = true;
         this.ta_mc.addEventListener(MouseEvent.CLICK,this.clickTaMcHandler);
         this.timer = new Timer(10 * 1000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
      }
      
      private function clickTaMcHandler(_arg_1:MouseEvent) : void
      {
         if(this.ta_mc.currentFrame != 2)
         {
            SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onBeginGame);
            SocketConnection.send(CommandID.JOIN_GAME,1);
         }
      }
      
      private function onBeginGame(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onBeginGame);
         if(!this.shieldGame)
         {
            this.shieldGame = new AppModel(ClientConfig.getGameModule("ShieldGame"),"正在防护塔游戏");
            this.shieldGame.setup();
         }
         this.shieldGame.show();
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         SocketConnection.addCmdListener(CommandID.GAME_OVER,this.onGameOver);
      }
      
      private function onGameOver(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GAME_OVER,this.onGameOver);
      }
      
      private function makeTaClickHandler(_arg_1:MouseEvent) : void
      {
      }
      
      private function onWalk(_arg_1:RobotEvent) : void
      {
         var _local_2:String = null;
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         this.timer.stop();
         this.timer.reset();
         MainManager.actorModel.stop();
         MainManager.actorModel.scaleX = 1;
         if(this.type == 1)
         {
            _local_2 = "豆豆果实";
         }
         else
         {
            _local_2 = "纳格晶体";
         }
         Alarm.show("随便走动是无法挖到" + _local_2 + "的!");
      }
      
      override public function destroy() : void
      {
         this.ta_mc.removeEventListener(MouseEvent.CLICK,this.clickTaMcHandler);
         this.ta_mc = null;
         this.makeTa_btn.removeEventListener(MouseEvent.CLICK,this.makeTaClickHandler);
         this.makeTa_btn = null;
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         this.fightMC = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         this.timer = null;
      }
      
      private function pull(_arg_1:MouseEvent) : void
      {
         conLevel["bossMC"].nextFrame();
         if(conLevel["bossMC"].currentFrame == 3)
         {
            this.fightMC.mouseEnabled = true;
         }
      }
      
      public function fight() : void
      {
         FightInviteManager.fightWithBoss("纳多雷",0);
      }
      
      public function hitDoor() : void
      {
         MapManager.changeMap(46);
      }
      
      public function catchMine2() : void
      {
         this.type = 2;
         if(MainManager.actorInfo.actionType == 1)
         {
            NpcTipDialog.show("   你正处于飞行中,是不能进行能源采集的...",null,NpcTipDialog.SHU_KE,-80);
            return;
         }
         if(!this.checkCloth())
         {
            return;
         }
         EnergyController.exploit();
      }
      
      public function catchMine() : void
      {
         this.type = 1;
         if(MainManager.actorInfo.actionType == 1)
         {
            NpcTipDialog.show("   你正处于飞行中,是不能进行能源采集的...",null,NpcTipDialog.SHU_KE,-80);
            return;
         }
         if(!this.checkCloth())
         {
            return;
         }
         EnergyController.exploit(1);
      }
      
      private function timerHandler(_arg_1:TimerEvent) : void
      {
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         SocketConnection.addCmdListener(CommandID.TALK_CATE,this.onSuccess);
         if(this.type == 1)
         {
            SocketConnection.send(CommandID.TALK_CATE,11);
         }
         else
         {
            SocketConnection.send(CommandID.TALK_CATE,10);
         }
      }
      
      private function onSuccess(_arg_1:SocketEvent) : void
      {
         var _local_2:SharedObject = null;
         MainManager.actorModel.direction = Direction.DOWN;
         MainManager.actorModel.scaleX = 1;
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,this.onSuccess);
         var _local_3:DayTalkInfo = _arg_1.data as DayTalkInfo;
         var _local_4:CateInfo = _local_3.outList[0];
         var _local_5:String = ItemXMLInfo.getName(_local_4.id);
         NpcTipDialog.show("看样子你采集到了" + _local_4.count.toString() + "个" + _local_5 + "。" + _local_5 + "都已经放入你的储存箱里了。\n<font color=\'#FF0000\'> " + "   快去飞船动力室看看它有什么用</font>",null,NpcTipDialog.DOCTOR,-80);
         if(this.type == 1)
         {
            _local_2 = SOManager.getUserSO(SOManager.MINE_400012);
            if(!_local_2.data["isCatch"])
            {
               _local_2.data["isCatch"] = true;
               SOManager.flush(_local_2);
            }
         }
         else
         {
            _local_2 = SOManager.getUserSO(SOManager.MINE_400011);
            if(!_local_2.data["isCatch"])
            {
               _local_2.data["isCatch"] = true;
               SOManager.flush(_local_2);
            }
         }
      }
      
      private function checkCloth() : Boolean
      {
         var _local_1:Boolean = true;
         if(this.type == 1)
         {
            if(MainManager.actorInfo.clothIDs.indexOf(100059) == -1 && MainManager.actorInfo.clothIDs.indexOf(100717) == -1)
            {
               _local_1 = false;
               Alarm.show("你必须装备上" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(100059)) + "才能进行采集哦！");
            }
         }
         else if(MainManager.actorInfo.clothIDs.indexOf(100014) == -1 && MainManager.actorInfo.clothIDs.indexOf(100717) == -1)
         {
            _local_1 = false;
            Alarm.show("你必须装备上" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(100014)) + "才能进行采集哦！");
         }
         return _local_1;
      }
   }
}

