package com.robot.app.task.tc
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   
   public class TaskClass_39
   {
      
      public function TaskClass_39(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(39,TasksManager.COMPLETE);
         info.monBallList.forEach(function(_arg_1:Object, _arg_2:int, _arg_3:Array):void
         {
            Alarm.show(TextFormatUtil.getRedTxt(ItemXMLInfo.getItemVipName(_arg_1.itemID)) + "已放入你超能NoNo的储藏空间中。");
         });
      }
   }
}

