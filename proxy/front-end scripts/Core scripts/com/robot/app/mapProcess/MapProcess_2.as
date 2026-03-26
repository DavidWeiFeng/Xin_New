package com.robot.app.mapProcess
{
   import com.robot.app.help.*;
   import com.robot.app.task.control.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.animate.*;
   import com.robot.core.info.task.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.*;
   import com.robot.core.npc.*;
   import com.robot.core.ui.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class MapProcess_2 extends BaseMapProcess
   {
      
      private var btn:Sprite;
      
      private var btn1:Sprite;
      
      private var guard:MovieClip;
      
      private var wbMc:MovieClip;
      
      private var mbox:DialogBox;
      
      public function MapProcess_2()
      {
         super();
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
      
      override public function destroy() : void
      {
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         this.wbMc = null;
         this.mbox = null;
         this.btn.removeEventListener(MouseEvent.CLICK,this.showTip);
         this.btn1.removeEventListener(MouseEvent.CLICK,this.showTip);
         this.btn = null;
         this.btn1 = null;
      }
      
      override protected function init() : void
      {
         this.showTask98();
         this.btn = new Sprite();
         this.btn.graphics.beginFill(65280);
         this.btn.graphics.drawRect(0,0,80,137);
         this.btn.width = 80;
         this.btn.height = 137;
         this.btn.x = 180;
         this.btn.y = 80;
         this.btn.alpha = 0;
         this.btn.buttonMode = true;
         conLevel.addChild(this.btn);
         this.btn.addEventListener(MouseEvent.CLICK,this.showTip);
         this.btn1 = new Sprite();
         this.btn1.graphics.beginFill(65280);
         this.btn1.graphics.drawRect(0,0,145,137);
         this.btn1.width = 145;
         this.btn1.height = 137;
         this.btn1.x = 670;
         this.btn1.y = 64;
         this.btn1.alpha = 0;
         this.btn1.buttonMode = true;
         conLevel.addChild(this.btn1);
         this.btn1.addEventListener(MouseEvent.CLICK,this.showTip);
         this.wbMc = conLevel["hitWbMC"];
         this.wbMc.addEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.addEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(e:SocketEvent):void
         {
            var oreCountInfo:MiningCountInfo;
            var count:uint;
            SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
            oreCountInfo = e.data as MiningCountInfo;
            count = oreCountInfo.miningCount;
            if(count >= 6 || count < 6 && Math.random() > 0.2)
            {
               EventManager.addEventListener(NpcController.GET_CURNPC,function(_arg_1:Event):void
               {
                  EventManager.removeEventListener(NpcController.GET_CURNPC,arguments.callee);
                  NpcController.curNpc.npc.npc.visible = false;
               });
            }
         });
         SocketConnection.send(CommandID.TALK_COUNT,600012 - 500000);
      }
      
      public function showTask() : void
      {
         HelpManager.show(0);
      }
      
      public function showWbAction() : void
      {
         var _local_1:MovieClip = conLevel["wbNpc"] as MovieClip;
         _local_1.gotoAndPlay(2);
      }
      
      private function showTip(_arg_1:MouseEvent) : void
      {
         NpcTipDialog.show("赛尔飞船的各个舱室是通过走廊来连接，你可以乘坐电梯穿梭于飞船各层。");
      }
      
      private function showTask98() : void
      {
         if(TasksManager.getTaskStatus(TaskController_98.TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(TaskController_98.TASK_ID,function(arr:Array):void
            {
               if(Boolean(arr[1]) && !arr[2])
               {
                  AnimateManager.playMcAnimate(btnLevel["task98_effect"],0,"",function():void
                  {
                     TasksManager.complete(TaskController_98.TASK_ID,2,function():void
                     {
                        btnLevel["task98_effect"].visible = false;
                     });
                  });
               }
            });
         }
      }
   }
}

