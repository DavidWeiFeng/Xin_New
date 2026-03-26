package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.*;
   import com.robot.app.sceneInteraction.*;
   import com.robot.core.*;
   import com.robot.core.info.task.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.*;
   import com.robot.core.npc.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.events.SocketEvent;
   
   public class MapProcess_305 extends BaseMapProcess
   {
      
      private var jiantou_0:MovieClip;
      
      private var jiantou_1:MovieClip;
      
      private var qita:MovieClip;
      
      private var oilcanArr:Array = [];
      
      public function MapProcess_305()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _local_2:MovieClip = null;
         var _local_1:String = null;
         var _local_3:uint = 0;
         _local_2 = null;
         MazeController.setup();
         conLevel["door_0"].visible = false;
         conLevel["door_1"].visible = false;
         this.jiantou_0 = conLevel["jiantou_0"];
         this.jiantou_1 = conLevel["jiantou_1"];
         this.jiantou_0.visible = false;
         this.jiantou_1.visible = false;
         this.qita = conLevel["qita"];
         this.qita.visible = false;
         while(_local_3 < 8)
         {
            _local_1 = "oilcan_" + _local_3;
            _local_2 = conLevel[_local_1] as MovieClip;
            _local_2.buttonMode = true;
            _local_2.gotoAndStop(1);
            _local_2.addEventListener(MouseEvent.CLICK,this.onClickOilcan);
            this.oilcanArr.push(_local_2);
            _local_3++;
         }
      }
      
      private function onClickOilcan(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = null;
         var _local_3:MovieClip = null;
         var _local_4:MovieClip = _arg_1.currentTarget as MovieClip;
         if(_local_4.currentFrame == 1)
         {
            _local_4.gotoAndStop(2);
         }
         else
         {
            _local_4.gotoAndStop(1);
         }
         for each(_local_2 in this.oilcanArr)
         {
            if(_local_2.currentFrame != 2)
            {
               return;
            }
         }
         for each(_local_3 in this.oilcanArr)
         {
            _local_3.removeEventListener(MouseEvent.CLICK,this.onClickOilcan);
            _local_3.buttonMode = false;
         }
         conLevel["door_0"].visible = true;
         conLevel["door_1"].visible = true;
         this.jiantou_0.visible = true;
         this.jiantou_1.visible = true;
         if(Math.random() >= 0.5)
         {
            this.qita.visible = true;
            this.qita.buttonMode = true;
            this.qita.addEventListener(MouseEvent.CLICK,this.onFightQita);
         }
      }
      
      override public function destroy() : void
      {
         var _local_1:MovieClip = null;
         for each(_local_1 in this.oilcanArr)
         {
            _local_1.removeEventListener(MouseEvent.CLICK,this.onClickOilcan);
            this.qita.removeEventListener(MouseEvent.CLICK,this.onFightQita);
         }
         MazeController.destroy();
      }
      
      private function onFightQita(evt:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
            var _local_3:MiningCountInfo = _arg_1.data as MiningCountInfo;
            var _local_4:uint = _local_3.miningCount;
            if(_local_4 == 0)
            {
               FightInviteManager.fightWithBoss("奇塔");
            }
            else
            {
               NpcDialog.show(NPC.SEER,["已经达到捕捉上限了哟~"],["……"],null);
            }
         });
         SocketConnection.send(CommandID.TALK_COUNT,700013 - 500000);
      }
   }
}

