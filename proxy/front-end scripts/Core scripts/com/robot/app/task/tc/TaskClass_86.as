package com.robot.app.task.tc
{
   import com.robot.app.task.newNovice.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import org.taomee.utils.*;
   
   public class TaskClass_86
   {
      
      private var mc:MovieClip;
      
      private var _info:NoviceFinishInfo;
      
      public function TaskClass_86(_arg_1:NoviceFinishInfo)
      {
         super();
         this._info = _arg_1;
         TasksManager.setTaskStatus(86,TasksManager.COMPLETE);
         PetManager.setIn(_arg_1.captureTm,1);
         this.mc = MapManager.currentMap.controlLevel["mc" + _arg_1.petID];
         this.mc.gotoAndPlay(2);
         this.mc.addEventListener(Event.ENTER_FRAME,this.onEnHandler);
      }
      
      private function onEnHandler(_arg_1:Event) : void
      {
         if(this.mc.currentFrame == this.mc.totalFrames)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.onEnHandler);
            DisplayUtil.removeForParent(this.mc);
            this.mc = null;
            PetInBagAlert.show(this._info.petID,"一只" + TextFormatUtil.getRedTxt(PetXMLInfo.getName(this._info.petID)) + "已经放入你的精灵背包,要好好照顾它哦！",LevelManager.appLevel,this.onHandler);
         }
      }
      
      private function onHandler() : void
      {
         this._info = null;
         NewNoviceStepTwoController.destroy();
         NewNoviceStepThreeController.start();
      }
   }
}

