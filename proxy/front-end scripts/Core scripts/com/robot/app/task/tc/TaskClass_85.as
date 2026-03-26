package com.robot.app.task.tc
{
   import com.robot.app.task.newNovice.*;
   import com.robot.core.config.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import org.taomee.utils.*;
   
   public class TaskClass_85
   {
      
      private var _mc:MovieClip;
      
      private var _app:AppModel;
      
      public function TaskClass_85(_arg_1:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(85,TasksManager.COMPLETE);
         this._mc = MapManager.currentMap.controlLevel["itemMc"];
         this._mc.addEventListener(Event.ENTER_FRAME,this.onEnterHandler);
         this._mc.gotoAndPlay(3);
      }
      
      private function onEnterHandler(_arg_1:Event) : void
      {
         if(this._mc.currentFrame == this._mc.totalFrames)
         {
            this._mc.removeEventListener(Event.ENTER_FRAME,this.onEnterHandler);
            DisplayUtil.removeForParent(this._mc);
            this.showPanel();
         }
      }
      
      private function showPanel() : void
      {
         if(!this._app)
         {
            this._app = new AppModel(ClientConfig.getTaskModule("NewNoviceTaskGetItemPanel"),"正在打开");
            this._app.setup();
            this._app.sharedEvents.addEventListener(Event.CLOSE,this.onCloseHandler);
         }
         this._app.show();
      }
      
      private function onCloseHandler(_arg_1:Event) : void
      {
         this._app.sharedEvents.removeEventListener(Event.CLOSE,this.onCloseHandler);
         this._app.destroy();
         this._app = null;
         NewNoviceStepOneController.destroy();
         NewNoviceStepTwoController.start();
      }
   }
}

