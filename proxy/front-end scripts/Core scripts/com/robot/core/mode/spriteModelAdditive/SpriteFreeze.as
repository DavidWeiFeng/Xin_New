package com.robot.core.mode.spriteModelAdditive
{
   import com.robot.core.CommandID;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.SpriteModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.teamPK.shotActive.AutoShotManager;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Timer;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class SpriteFreeze implements ISpriteModelAdditive
   {
      
      private var _model:SpriteModel;
      
      private var timer:Timer;
      
      private var mc:MovieClip;
      
      public function SpriteFreeze()
      {
         super();
         this.timer = new Timer(1000,15);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComp);
      }
      
      public function init() : void
      {
      }
      
      public function get model() : SpriteModel
      {
         return this._model;
      }
      
      public function set model(_arg_1:SpriteModel) : void
      {
         this._model = _arg_1;
      }
      
      public function show() : void
      {
         var _local_1:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,0,0,1,0,0,100,0,0,1,0,100,0,0,0,1,0]);
         if(this.model is BasePeoleModel)
         {
            (this.model as BasePeoleModel).skeleton.getBodyMC().filters = [_local_1];
         }
         else
         {
            this.model.filters = [_local_1];
         }
         this.timer.start();
         this.mc = ShotBehaviorManager.getMovieClip("pk_rest_mc");
         this.mc.gotoAndStop(1);
         this.mc.y = -this.model.height - 10;
         this.model.addChild(this.mc);
         ToolTipManager.add(this.mc,"原地整备15秒后你就能重新投入战斗了");
         if(this.model == MainManager.actorModel)
         {
            AutoShotManager.breakAuto();
         }
      }
      
      private function onTimerComp(_arg_1:TimerEvent) : void
      {
         if(this.model == MainManager.actorModel)
         {
            SocketConnection.send(CommandID.TEAM_PK_UNFREEZE);
            AutoShotManager.openAuto();
         }
         this.model.removeAdditive(this);
      }
      
      private function onTimer(_arg_1:TimerEvent) : void
      {
         var _local_2:Number = this.timer.currentCount / this.timer.repeatCount;
         this.mc.gotoAndStop(Math.floor(this.mc.totalFrames * _local_2) + 1);
      }
      
      public function hide() : void
      {
      }
      
      public function destroy() : void
      {
         this.hide();
         if(this.model is BasePeoleModel)
         {
            (this.model as BasePeoleModel).skeleton.getBodyMC().filters = [];
         }
         else
         {
            this.model.filters = [];
         }
         this.model = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         ToolTipManager.remove(this.mc);
         DisplayUtil.removeForParent(this.mc);
         this.mc = null;
      }
   }
}

