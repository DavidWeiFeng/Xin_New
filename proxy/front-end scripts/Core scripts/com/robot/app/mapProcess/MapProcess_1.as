package com.robot.app.mapProcess
{
   import com.robot.app.help.*;
   import com.robot.app.spt.*;
   import com.robot.app.superParty.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class MapProcess_1 extends BaseMapProcess
   {
      
      private var btn:Sprite;
      
      private var panel:AppModel;
      
      private var timer:Timer;
      
      private var timerIndex:uint = 0;
      
      private var jindan_btn:SimpleButton;
      
      private var niusiTalkArr:Array;
      
      private var m_1:MovieClip;
      
      private var m_2:MovieClip;
      
      private var m_3:MovieClip;
      
      private var m_4:MovieClip;
      
      private var wbMc:MovieClip;
      
      private var mbox:DialogBox;
      
      private var timePanel:AppModel;
      
      public function MapProcess_1()
      {
         super();
      }
      
      override protected function init() : void
      {
         try
         {
            this.m_1 = conLevel["m_0"];
            this.m_2 = conLevel["m_1"];
            this.m_3 = conLevel["m_2"];
            this.m_4 = conLevel["m_3"];
            this.m_4.gotoAndStop(1);
            this.m_1.gotoAndStop(1);
            this.m_2.gotoAndStop(1);
            this.m_3.gotoAndStop(1);
            SptChannelController.initMC(this.m_2);
            SPChannelController.initMC(this.m_3);
            this.niusiTalkArr = UpdateConfig.niusiArray.slice();
            depthLevel["npc"].buttonMode = true;
            depthLevel["npc"].addEventListener(MouseEvent.CLICK,this.showBrocast);
            this.timer = new Timer(9000);
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.start();
            this.onTimer();
            this.wbMc = conLevel["hitWbMC"];
            this.wbMc.addEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
            this.wbMc.addEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
            MapManager.addEventListener(MapConfigEvent.HIT_MAP_COMPONENT,this.onHitComponent);
            TasksManager.getProStatus(95,1,function(_arg_1:Boolean):void
            {
               if(_arg_1)
               {
                  TempPetManager.showTempPet(500);
               }
            });
            SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,this.onTimeHandler);
            SocketConnection.send(CommandID.SYSTEM_TIME);
         }
         catch(error:Error)
         {
         }
      }
      
      private function onTimeHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,this.onTimeHandler);
         var _local_2:SystemTimeInfo = _arg_1.data as SystemTimeInfo;
         var _local_3:Date = _local_2.date;
         if(_local_3.getFullYear() == 2010)
         {
            if(_local_3.getMonth() == 2)
            {
               if(_local_3.getDate() == 27)
               {
                  if(_local_3.getHours() == 20 || _local_3.getHours() == 21)
                  {
                     if(_local_3.getHours() == 20)
                     {
                        if(_local_3.getMinutes() >= 30)
                        {
                           topLevel["maskMc"].visible = true;
                        }
                     }
                     else if(_local_3.getMinutes() <= 30)
                     {
                        topLevel["maskMc"].visible = true;
                     }
                  }
               }
            }
         }
      }
      
      public function onCompDoor1() : void
      {
         if(TasksManager.getTaskStatus(95) == TasksManager.COMPLETE)
         {
            MapManager.changeMap(322);
            return;
         }
         if(TasksManager.getTaskStatus(95) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(95,function(_arg_1:Array):void
            {
               if(Boolean(_arg_1[0]))
               {
                  MapManager.changeLocalMap(322);
               }
               else
               {
                  Alarm.show("这个地方将通往旋涡深处！快去船长室接任务吧！");
               }
            });
         }
         else
         {
            Alarm.show("这个地方将通往旋涡深处！快去船长室接任务吧！");
         }
      }
      
      private function endDoor1() : void
      {
         MapManager.changeMap(10);
         this.m_1.gotoAndStop(this.m_1.totalFrames - 1);
         this.m_1.addFrameScript(this.m_1.totalFrames - 1,null);
      }
      
      public function onCompDoor4() : void
      {
         ModuleManager.showAppModule("MapsPanel");
         MainManager.actorModel.visible = false;
         this.m_4.gotoAndPlay(2);
         this.m_4.addFrameScript(this.m_1.totalFrames - 1,this.endDoor4);
      }
      
      private function endDoor4() : void
      {
         MapManager.changeMap(102);
         this.m_4.gotoAndStop(this.m_4.totalFrames - 1);
         this.m_4.addFrameScript(this.m_4.totalFrames - 1,null);
      }
      
      public function onSptHandler() : void
      {
         SptChannelController.show();
      }
      
      public function onSuperHandler() : void
      {
         if(!MainManager.actorInfo.superNono)
         {
            NpcTipDialog.show("只有" + TextFormatUtil.getRedTxt("超能NoNo") + "的超级能量才能承受时空穿梭带来的强大机体负荷，快去发明室开通" + TextFormatUtil.getRedTxt("超能NoNo") + "再来试试吧！",function():void
            {
            },NpcTipDialog.NONO);
            return;
         }
         SPChannelController.show();
      }
      
      private function wbmcOverHandler(_arg_1:MouseEvent) : void
      {
         this.mbox = new DialogBox();
         this.mbox.show("有什么需要我帮助您的吗？",0,-30,conLevel["wbNpc"]);
      }
      
      private function wbmcOUTHandler(_arg_1:MouseEvent) : void
      {
         this.mbox.hide();
      }
      
      public function showWbAction() : void
      {
         var _local_1:MovieClip = conLevel["wbNpc"] as MovieClip;
         _local_1.gotoAndPlay(2);
      }
      
      override public function destroy() : void
      {
         var _local_1:uint = 0;
         try
         {
            SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,this.onTimeHandler);
            if(Boolean(this.timePanel))
            {
               this.timePanel.destroy();
               this.timePanel = null;
            }
            _local_1 = 1;
            while(_local_1 < 5)
            {
               _local_1++;
            }
            this.wbMc.removeEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
            this.wbMc.removeEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
            this.wbMc = null;
            this.mbox = null;
            depthLevel["npc"].removeEventListener(MouseEvent.CLICK,this.showBrocast);
            if(Boolean(this.panel))
            {
               this.panel.destroy();
            }
            this.panel = null;
            MapManager.removeEventListener(MapConfigEvent.HIT_MAP_COMPONENT,this.onHitComponent);
         }
         catch(error:Error)
         {
         }
      }
      
      public function showWBTask() : void
      {
         HelpManager.show(0);
      }
      
      private function showBrocast(_arg_1:MouseEvent) : void
      {
         if(!this.panel)
         {
            ModuleManager.showAppModule("RarePetFeedBackPanel");
         }
         this.panel.show();
      }
      
      private function onTimer(_arg_1:TimerEvent = null) : void
      {
         if(this.timerIndex == this.niusiTalkArr.length)
         {
            this.timerIndex = 0;
         }
         var _local_2:DialogBox = new DialogBox();
         _local_2.show(this.niusiTalkArr[this.timerIndex],0,-85,depthLevel["npc"]);
         ++this.timerIndex;
      }
      
      public function hitScreen() : void
      {
      }
      
      private function onUseInviter(_arg_1:SocketEvent) : void
      {
         MainManager.actorInfo.canReadSchedule = true;
         NpcTipDialog.showAnswer("尊敬的" + MainManager.actorInfo.nick + "，查看<font color=\'#ff0000\'>稀有精灵大拜年时刻表</font>需要拿出你的" + "<font color=\'#ff0000\'>精灵邀请函</font>，你确定要查看吗？",this.lookHandler,null,NpcTipDialog.HELPMACH);
      }
      
      private function lookHandler() : void
      {
         if(!this.timePanel)
         {
            this.timePanel = new AppModel(ClientConfig.getAppModule("PetTimePanel"),"正在打开精灵时刻表");
            this.timePanel.setup();
         }
         this.timePanel.show();
      }
      
      private function onHitComponent(_arg_1:MapConfigEvent) : void
      {
      }
   }
}

