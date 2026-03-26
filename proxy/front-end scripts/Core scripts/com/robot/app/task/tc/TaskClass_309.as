package com.robot.app.task.tc
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   
   public class TaskClass_309
   {
      
      public function TaskClass_309(_arg_1:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(309,TasksManager.COMPLETE);
         var _local_2:uint = uint(_arg_1.monBallList[0].itemID);
         LevelManager.iconLevel.addChild(Alarm.show("你得到了1个" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(_local_2)) + "。"));
      }
   }
}

