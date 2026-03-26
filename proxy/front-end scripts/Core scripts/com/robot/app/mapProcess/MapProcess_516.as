package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.BossModel;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.utils.Direction;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_516 extends BaseMapProcess
   {
      
      private static var _map:BaseMapProcess;
      
      private var _bossMC:BossModel;
      
      public function MapProcess_516()
      {
         var _local_1:int = 0;
         super();
         _map = this;
         while(_local_1 < conLevel.numChildren)
         {
            conLevel.getChildAt(_local_1).visible = false;
            _local_1++;
         }
         this.inita();
      }
      
      override protected function init() : void
      {
      }
      
      override public function destroy() : void
      {
      }
      
      private function inita() : void
      {
         if(!this._bossMC)
         {
            this._bossMC = new BossModel(261,48);
            this._bossMC.setDirection(Direction.DOWN);
            this._bossMC.show(new Point(480,210),0);
            this._bossMC.scaleX = this._bossMC.scaleY = 2;
         }
         this._bossMC.mouseEnabled = true;
         this._bossMC.addEventListener(MouseEvent.CLICK,this.onBossClick);
         ToolTipManager.add(this._bossMC,"派送");
      }
      
      private function des() : void
      {
         ToolTipManager.remove(this._bossMC);
         this._bossMC.removeEventListener(MouseEvent.CLICK,this.onBossClick);
      }
      
      private function onBossClick(e:MouseEvent) : void
      {
         NpcDialog.show(NPC.LEIYI,["10.1日晚上8点以后和我对战可以每10分钟【0-9,10-19，20-29,30-49,50-59】可领取奖励哦"],["来吧","算了，我再看看"],[function():void
         {
            FightInviteManager.fightWithBoss("派送");
         },function():void
         {
            NpcDialog.show(NPC.LEIYI,["探索一下附近可能也有奇妙奖励哦（似乎和射击有关）"],["我来找找"],null);
         }]);
      }
   }
}

