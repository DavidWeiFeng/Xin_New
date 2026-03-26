package com.robot.app.npc.npcClass
{
   import com.robot.app.fightNote.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.task.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.npc.*;
   import flash.display.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class NpcClass_90001 implements INpc
   {
      
      private var _curNpcModel:NpcModel;
      
      public function NpcClass_90001(_arg_1:NpcInfo, _arg_2:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(_arg_1,_arg_2 as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
      }
      
      private function onClickNpc(e:NpcEvent) : void
      {
         this._curNpcModel.refreshTask();
         NpcDialog.show(90001,["终于潜入骄阳计划了#6。嘿嘿，让我来搞下破坏#1"],["受死吧！","装傻"],[function():void
         {
            SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(e:SocketEvent):void
            {
               var oreCountInfo:*;
               var count:*;
               SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
               oreCountInfo = e.data as MiningCountInfo;
               count = oreCountInfo.miningCount;
               if(count < 6)
               {
                  FightInviteManager.fightWithBoss("海盗",2);
                  EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onFightOver);
               }
               else
               {
                  NpcDialog.show(90001,["留得青山在，不怕没柴烧#4。臭小子你给我记着#5"],["(今天的海盗似乎清理干净了)"],[function():void
                  {
                     NpcController.curNpc.npc.npc.visible = false;
                  }]);
               }
            });
            SocketConnection.send(CommandID.TALK_COUNT,600012 - 500000);
         },null]);
      }
      
      private function onFightOver(e:PetFightEvent) : void
      {
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,this.onFightOver);
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
            var _local_3:MiningCountInfo = _arg_1.data as MiningCountInfo;
            var _local_4:uint = _local_3.miningCount;
            NpcDialog.show(90001,["留得青山在，不怕没柴烧#4。臭小子你给我记着#5"],[_local_4 >= 6 ? "(今天的海盗似乎清理干净了)" : "(去其他地方看看还有没有海盗吧)"],null);
         });
         SocketConnection.send(CommandID.TALK_COUNT,600012 - 500000);
         NpcController.curNpc.npc.npc.visible = false;
      }
      
      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.removeEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
            this._curNpcModel.destroy();
            this._curNpcModel = null;
         }
      }
      
      public function get npc() : NpcModel
      {
         return this._curNpcModel;
      }
   }
}

