package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.*;
   import com.robot.app.sceneInteraction.*;
   import com.robot.core.*;
   import com.robot.core.info.task.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.*;
   import com.robot.core.npc.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class MapProcess_306 extends BaseMapProcess
   {
      
      private var btn_0:MovieClip;
      
      private var btn_1:MovieClip;
      
      private var btn_2:MovieClip;
      
      private var btnArr:Array = [];
      
      private var blockStone:MovieClip;
      
      private var blockRoad:MovieClip;
      
      private var xita:MovieClip;
      
      public function MapProcess_306()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _local_1:MovieClip = null;
         MazeController.setup();
         this.btn_0 = conLevel["btn_0"];
         this.btn_1 = conLevel["btn_1"];
         this.btn_2 = conLevel["btn_2"];
         this.btnArr = [this.btn_0,this.btn_1,this.btn_2];
         for each(_local_1 in this.btnArr)
         {
            _local_1.buttonMode = true;
            _local_1.gotoAndStop(1);
            _local_1.addEventListener(MouseEvent.CLICK,this.onClickBtn);
         }
         this.blockStone = conLevel["blockStone"];
         this.blockStone.mouseEnabled = false;
         this.xita = conLevel["xita"];
         this.xita.mouseEnabled = false;
         this.blockRoad = typeLevel["blockRoad"];
      }
      
      override public function destroy() : void
      {
         MazeController.destroy();
      }
      
      private function onClickBtn(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = null;
         var _local_3:MovieClip = _arg_1.currentTarget as MovieClip;
         if(_local_3.currentFrame == 1)
         {
            _local_3.gotoAndStop(2);
         }
         else
         {
            _local_3.gotoAndStop(1);
         }
         if(this.btn_0.currentFrame == 2 && this.btn_1.currentFrame == 2 && this.btn_2.currentFrame == 2)
         {
            for each(_local_2 in this.btnArr)
            {
               _local_2.buttonMode = false;
               _local_2.gotoAndStop(2);
               _local_2.removeEventListener(MouseEvent.CLICK,this.onClickBtn);
            }
            this.blockStone.gotoAndPlay(2);
            DisplayUtil.removeForParent(this.blockRoad);
            this.blockRoad = null;
            MapManager.currentMap.makeMapArray();
            this.xita.buttonMode = true;
            this.xita.mouseEnabled = true;
         }
      }
      
      public function fightWithXita() : void
      {
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
            var _local_3:MiningCountInfo = _arg_1.data as MiningCountInfo;
            var _local_4:uint = _local_3.miningCount;
            if(_local_4 == 0)
            {
               FightInviteManager.fightWithBoss("西塔");
            }
            else
            {
               NpcDialog.show(NPC.SEER,["已经达到捕捉上限了哟~"],["……"],null);
            }
         });
         SocketConnection.send(CommandID.TALK_COUNT,700014 - 500000);
      }
   }
}

