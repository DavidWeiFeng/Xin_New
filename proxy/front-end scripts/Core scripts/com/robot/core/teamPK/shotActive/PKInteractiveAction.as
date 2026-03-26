package com.robot.core.teamPK.shotActive
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.mode.SpriteModel;
   import com.robot.core.mode.spriteInteractive.ISpriteInteractiveAction;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   
   public class PKInteractiveAction implements ISpriteInteractiveAction
   {
      
      private var model:SpriteModel;
      
      private var mouseIcon:Sprite;
      
      private var timer:Timer;
      
      private var isCanShot:Boolean = true;
      
      public function PKInteractiveAction(_arg_1:SpriteModel)
      {
         super();
         this.model = _arg_1;
         this.mouseIcon = new Sprite();
         var _local_2:MovieClip = ShotBehaviorManager.getMovieClip("pk_mouseIcon_shot");
         var _local_3:Bitmap = DisplayUtil.copyDisplayAsBmp(_local_2);
         this.mouseIcon.graphics.beginFill(0,0);
         this.mouseIcon.graphics.drawRect(_local_3.x,_local_3.y,_local_3.width,_local_3.height);
         this.mouseIcon.addChild(_local_3);
         this.mouseIcon.mouseChildren = false;
         this.mouseIcon.mouseEnabled = false;
         this.timer = new Timer(3000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function onTimer(_arg_1:TimerEvent) : void
      {
         this.isCanShot = true;
      }
      
      public function click() : void
      {
         if(this.isCanShot)
         {
            AutoShotManager.shot(this.model);
            this.isCanShot = false;
            this.timer.start();
         }
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.mouseIcon);
         this.mouseIcon = null;
         this.model = null;
         Mouse.show();
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
      }
      
      public function rollOut() : void
      {
         DisplayUtil.removeForParent(this.mouseIcon);
         Mouse.show();
      }
      
      public function rollOver() : void
      {
         MainManager.getStage().addChild(this.mouseIcon);
         this.mouseIcon.startDrag(true);
         Mouse.hide();
      }
   }
}

