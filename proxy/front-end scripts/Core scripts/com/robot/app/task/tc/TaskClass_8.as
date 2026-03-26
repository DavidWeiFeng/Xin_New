package com.robot.app.task.tc
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   
   public class TaskClass_8
   {
      
      public function TaskClass_8(_arg_1:NoviceFinishInfo)
      {
         var _local_2:FitmentInfo = null;
         super();
         TasksManager.setTaskStatus(8,TasksManager.COMPLETE);
         var _local_3:uint = uint(_arg_1.monBallList[0].itemID);
         if(_local_3.toString().charAt(0) == "5")
         {
            _local_2 = new FitmentInfo();
            _local_2.id = _local_3;
            FitmentManager.addInStorage(_local_2);
            Alarm.show("1个" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(_local_3)) + "已经放入你的仓库。");
         }
      }
   }
}

