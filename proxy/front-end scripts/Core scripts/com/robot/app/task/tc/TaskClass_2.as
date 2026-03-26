package com.robot.app.task.tc
{
   import com.robot.app.task.books.*;
   import com.robot.app.task.noviceGuide.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.event.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   
   public class TaskClass_2
   {
      
      public function TaskClass_2(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(2,TasksManager.COMPLETE);
         PetManager.addEventListener(PetEvent.ADDED,function():void
         {
            PetManager.removeEventListener(PetEvent.ADDED,arguments.callee);
            DoctorGuideDialog.removeDialog();
            DoGuideTask.doTask();
            NpcTipDialog.show("看到<font color=\'#FF0000\'>精灵包</font>里的那只精灵了吧，是不是有点激动。别着急，我先给你介绍下骄阳计划飞船，了解下我们远航的目的。",FlyBook.loadPanel,NpcTipDialog.CICI,-60);
         });
         PetManager.setIn(info.captureTm,1);
      }
   }
}

