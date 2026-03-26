package com.robot.app.task.tc
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   
   public class TaskClass_307
   {
      
      public function TaskClass_307(_arg_1:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(307,TasksManager.COMPLETE);
         var _local_2:uint = uint(_arg_1.monBallList[0].itemID);
         var _local_3:String = ItemXMLInfo.getName(_local_2);
         ItemInBagAlert.show(_local_2,"1个" + TextFormatUtil.getRedTxt(_local_3) + "已经放入你的储存箱");
      }
   }
}

