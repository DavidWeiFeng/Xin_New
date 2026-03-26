package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   
   public class TaskClass_405
   {
      
      public function TaskClass_405(_arg_1:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(405,TasksManager.COMPLETE);
         var _local_2:uint = uint(_arg_1.monBallList[0].itemCnt);
         Alarm.show("    你和比比鼠可真是功不可没呢！为我们的骄阳计划航行能源补充了不少噢。<font color=\'#ff0000\'>" + _local_2 + "积累经验</font>已经存入你的经验分配器中。快回基地看看吧！");
      }
   }
}

