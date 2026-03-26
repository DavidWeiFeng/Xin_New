package com.robot.app.task.tc
{
   import com.robot.app.task.newNovice.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.utils.*;
   
   public class TaskClass_88
   {
      
      public function TaskClass_88(info:NoviceFinishInfo)
      {
         super();
         MainManager.actorInfo.coins += 5000;
         TasksManager.setTaskStatus(88,TasksManager.COMPLETE);
         TasksManager.setTaskStatus(4,TasksManager.COMPLETE);
         NewNoviceGuideTaskController.showTip(1);
         if(NewNoviceStepFourController.isPlay)
         {
            MapManager.currentMap.btnLevel["comMc"].gotoAndPlay(2);
            setTimeout(function():void
            {
               ItemInBagAlert.show(1,"5000" + TextFormatUtil.getRedTxt("个骄阳豆") + "已经放入你的存储箱",onHandler);
            },3700);
         }
         else
         {
            ItemInBagAlert.show(1,"5000" + TextFormatUtil.getRedTxt("个骄阳豆") + "已经放入你的存储箱",this.onHandler);
         }
      }
      
      private function onHandler() : void
      {
         NewNoviceGuideTaskController.destroy();
         NewNpcDiaDialog.destroy();
         MapManager.changeMap(8);
      }
   }
}

