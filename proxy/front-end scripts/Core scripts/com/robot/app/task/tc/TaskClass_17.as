package com.robot.app.task.tc
{
   import com.robot.app.task.collectionExercise.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   
   public class TaskClass_17
   {
      
      public function TaskClass_17(_arg_1:NoviceFinishInfo)
      {
         var _local_2:Object = null;
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_5:String = null;
         super();
         TasksManager.setTaskStatus(CollectionExercise.TASK_ID,TasksManager.COMPLETE);
         CollectionExercise.delIcon();
         MainManager.actorInfo.coins += 2000;
         for each(_local_2 in _arg_1.monBallList)
         {
            _local_3 = uint(_local_2["itemID"]);
            _local_4 = uint(_local_2["itemCnt"]);
            _local_5 = ItemXMLInfo.getName(_local_3);
            ItemInBagAlert.show(_local_3,_local_4 + "个" + TextFormatUtil.getRedTxt(_local_5) + "已经放入你的储存箱中！");
         }
      }
   }
}

