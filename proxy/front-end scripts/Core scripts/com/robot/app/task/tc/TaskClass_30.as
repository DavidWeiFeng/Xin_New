package com.robot.app.task.tc
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   
   public class TaskClass_30
   {
      
      public function TaskClass_30(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(30,TasksManager.COMPLETE);
         NpcTipDialog.show("答的不错，NoNo交给你我很放心。这些是给你的奖励！",function():void
         {
            var _local_1:Object = null;
            var _local_2:String = null;
            for each(_local_1 in info.monBallList)
            {
               _local_2 = ItemXMLInfo.getName(_local_1.itemID);
               Alarm.show("恭喜你获得了" + _local_1.itemCnt + "个<font color=\'#ff0000\'>" + _local_2 + "</font>");
            }
         },NpcTipDialog.SHAWN);
      }
   }
}

