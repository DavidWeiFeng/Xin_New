package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.*;
   import com.robot.app.mapProcess.active.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.*;
   
   public class MapProcess_53 extends BaseMapProcess
   {
      
      private static var isFightPet:Boolean = false;
      
      private var activePet:ActivePet;
      
      private var stoneMC:MovieClip;
      
      private var oldP:Point;
      
      private var rung:MovieClip;
      
      private var boss:MovieClip;
      
      private var bossMC:MovieClip;
      
      private var rungClickedCnt:uint = 1;
      
      public function MapProcess_53()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(!isFightPet)
         {
            this.activePet = new ActivePet(178);
         }
         this.stoneMC = conLevel["stoneMC"];
         this.stoneMC.buttonMode = true;
         this.oldP = new Point(this.stoneMC.x,this.stoneMC.y);
         this.stoneMC.addEventListener(MouseEvent.CLICK,this.clickStone);
         this.initTask_58();
      }
      
      private function clickStone(_arg_1:MouseEvent) : void
      {
         _arg_1.stopPropagation();
         this.stoneMC.startDrag(true);
         this.stoneMC.mouseEnabled = false;
         MainManager.getStage().addEventListener(MouseEvent.CLICK,this.dropStone);
      }
      
      private function dropStone(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = null;
         var _local_3:uint = 0;
         var _local_4:Boolean = false;
         MainManager.getStage().removeEventListener(MouseEvent.CLICK,this.dropStone);
         this.stoneMC.stopDrag();
         _local_3 = 0;
         while(_local_3 < 2)
         {
            _local_2 = conLevel["stoneHit_" + _local_3];
            if(_local_2.hitTestObject(this.stoneMC))
            {
               _local_4 = true;
               break;
            }
            _local_3++;
         }
         if(_local_4)
         {
            if(_local_3 == 0)
            {
               if(Boolean(this.activePet))
               {
                  this.activePet.fillLeft();
               }
            }
            else if(Boolean(this.activePet))
            {
               this.activePet.fillRight();
            }
            this.stoneMC.rotation = 90;
            this.stoneMC.y = 0;
            this.stoneMC.x = 0;
            _local_2.addChild(this.stoneMC);
         }
         else
         {
            this.stoneMC.rotation = 0;
            this.stoneMC.x = this.oldP.x;
            this.stoneMC.y = this.oldP.y;
            this.stoneMC.mouseEnabled = true;
         }
      }
      
      override public function destroy() : void
      {
         this.activePet.destroy();
         this.activePet = null;
         this.rung = null;
         this.boss = null;
         this.bossMC = null;
      }
      
      private function initTask_58() : void
      {
         this.rung = conLevel["rung"];
         this.bossMC = conLevel["bossMC"];
         this.bossMC.gotoAndStop(1);
         this.bossMC.visible = false;
         this.boss = conLevel["boss"];
         this.bossMC.visible = true;
         this.rung.buttonMode = true;
         this.rung.addEventListener(MouseEvent.CLICK,this.onClickRung);
      }
      
      private function onClickRung(_arg_1:MouseEvent) : void
      {
         ++this.rungClickedCnt;
         this.bossMC.gotoAndStop(this.rungClickedCnt);
         if(this.rungClickedCnt == 4)
         {
            this.boss.buttonMode = true;
            this.boss.addEventListener(MouseEvent.CLICK,this.onClickBoss);
         }
      }
      
      private function onClickBoss(_arg_1:MouseEvent) : void
      {
         FightInviteManager.fightWithBoss("魔狮迪露",1);
      }
   }
}

