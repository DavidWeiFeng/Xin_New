package com.robot.app.task.tc
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   
   public class TaskClass_13
   {
      
      public function TaskClass_13(_arg_1:NoviceFinishInfo)
      {
         var _local_2:Object = null;
         var _local_3:String = null;
         super();
         TasksManager.setTaskStatus(306,TasksManager.COMPLETE);
         for each(_local_2 in _arg_1.monBallList)
         {
            _local_3 = ItemXMLInfo.getName(_local_2.itemID);
            ItemInBagAlert.show(_local_2.itemID,_local_2.itemCnt + "个<font color=\'#ff0000\'>" + _local_3 + "</font>已经放入你的储存箱中！");
         }
      }
   }
}

