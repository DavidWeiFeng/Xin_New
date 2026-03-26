package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.*;
   import com.robot.app.sceneInteraction.*;
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   
   public class MapProcess_310 extends BaseMapProcess
   {
      
      private var lili:MovieClip;
      
      private var miaozhunMC:MovieClip;
      
      private var oilcanArr:Array = [];
      
      private var count:uint = 0;
      
      private var hitArr:Array = [];
      
      public function MapProcess_310()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _local_1:String = null;
         var _local_2:MovieClip = null;
         var _local_3:String = null;
         var _local_4:MovieClip = null;
         var _local_5:uint = 0;
         MazeController.setup();
         while(_local_5 < 8)
         {
            _local_1 = "oilcan_" + _local_5;
            _local_2 = conLevel[_local_1] as MovieClip;
            _local_2.gotoAndStop(1);
            this.oilcanArr.push(_local_2);
            _local_3 = "hitMC_" + _local_5;
            _local_4 = conLevel[_local_3] as MovieClip;
            _local_4.addEventListener(MouseEvent.MOUSE_OVER,this.onHitMcOver);
            _local_4.addEventListener(MouseEvent.MOUSE_OUT,this.onHitMcOut);
            this.hitArr.push(_local_4);
            _local_5++;
         }
         this.lili = conLevel["lili"];
         this.lili.visible = false;
         this.miaozhunMC = conLevel["miaozhunMC"];
         this.miaozhunMC.visible = false;
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
      }
      
      override public function destroy() : void
      {
         MazeController.destroy();
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
      }
      
      private function onAimat(_arg_1:AimatEvent) : void
      {
         var _local_5:uint = 0;
         var _local_2:Number = NaN;
         var _local_3:AimatInfo = _arg_1.info;
         if(_local_3.userID != MainManager.actorID)
         {
            return;
         }
         var _local_4:Point = _local_3.endPos;
         while(_local_5 < this.hitArr.length)
         {
            if(Boolean(this.hitArr[_local_5].hitTestPoint(_local_4.x,_local_4.y)))
            {
               if(this.oilcanArr[_local_5].currentFrame != 2)
               {
                  this.oilcanArr[_local_5].gotoAndStop(2);
                  this.hitArr[_local_5].removeEventListener(MouseEvent.MOUSE_OVER,this.onHitMcOver);
                  this.hitArr[_local_5].removeEventListener(MouseEvent.MOUSE_OUT,this.onHitMcOut);
                  ++this.count;
               }
            }
            _local_5++;
         }
         if(this.count == 8)
         {
            AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
            _local_2 = Math.random();
            if(_local_2 <= 0.1)
            {
               this.lili.visible = true;
               this.lili.buttonMode = true;
               this.lili.addEventListener(MouseEvent.CLICK,this.onFightLili);
            }
            if(_local_2 >= 0.9)
            {
               MapManager.changeMap(314);
            }
         }
      }
      
      private function onFightLili(_arg_1:MouseEvent) : void
      {
         FightInviteManager.fightWithBoss("果冻鸭");
      }
      
      private function onHitMcOver(_arg_1:MouseEvent) : void
      {
         this.miaozhunMC.visible = true;
         this.miaozhunMC.x = MainManager.getStage().mouseX;
         this.miaozhunMC.y = MainManager.getStage().mouseY;
      }
      
      private function onHitMcOut(_arg_1:MouseEvent) : void
      {
         this.miaozhunMC.visible = false;
      }
   }
}

