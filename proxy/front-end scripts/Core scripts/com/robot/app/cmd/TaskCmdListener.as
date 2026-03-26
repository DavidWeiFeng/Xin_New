package com.robot.app.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.DynamicEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.Utils;
   
   public class TaskCmdListener extends BaseBeanController
   {
      
      public function TaskCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.COMPLETE_TASK,this.onComplete);
         SocketConnection.addCmdListener(CommandID.COMPLETE_DAILY_TASK,this.onComplete);
         finish();
      }
      
      private function onComplete(e:SocketEvent) : void
      {
         var tcls:Class = null;
         var info:NoviceFinishInfo = e.data as NoviceFinishInfo;
         TasksManager.setTaskStatus(info.taskID,TasksManager.COMPLETE);
         EventManager.dispatchEvent(new DynamicEvent(RobotEvent.DAILY_TASK_COMPLETE,info.taskID));
         var cla:Class = Utils.getClass(TasksManager.PATH + info.taskID.toString());
         if(Boolean(cla))
         {
            new cla(info);
         }
         else
         {
            tcls = Utils.getClass("com.robot.app.task.tc.TaskClass");
            if(Boolean(tcls))
            {
               new tcls(info);
            }
         }
      }
   }
}

