package com.robot.app.task.tc
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   
   public class TaskClass_403
   {
      
      public function TaskClass_403(_arg_1:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(403,TasksManager.COMPLETE);
         var _local_2:uint = uint(_arg_1.monBallList[0]["itemCnt"]);
         var _local_3:String = NpcTipDialog.DOCTOR;
         NpcTipDialog.show("因为你和精灵的帮助，克洛斯花恢复了活力。奖励你<font color=\'#ff0000\'>" + _local_2 + "点</font>补充经验，快回基地打开<font color=\'#ff0000\'>经验分配器</font>看看吧。",null,_local_3);
      }
   }
}

