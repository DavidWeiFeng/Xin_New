package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   
   public class TaskClass_11
   {
      
      public function TaskClass_11(_arg_1:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(11,TasksManager.COMPLETE);
      }
   }
}

