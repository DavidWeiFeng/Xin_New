package com.robot.app.npc
{
   import com.robot.app.taskPanel.TaskPanelController;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.TasksXMLInfo;
   import com.robot.core.event.NpcEvent;
   import com.robot.core.info.NpcTaskInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.npc.NpcController;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class NpcInfoController extends BaseBeanController
   {
      
      public function NpcInfoController()
      {
         super();
      }
      
      private static function onDelTask(_arg_1:SocketEvent) : void
      {
         var _local_2:uint = (_arg_1.data as ByteArray).readUnsignedInt();
         TasksManager.setTaskStatus(_local_2,TasksManager.UN_ACCEPT);
         NpcController.refreshTaskInfo();
      }
      
      private static function onAddBuf(_arg_1:SocketEvent) : void
      {
         NpcController.refreshTaskInfo();
      }
      
      private static function onCompTask(_arg_1:SocketEvent) : void
      {
         var _local_2:NoviceFinishInfo = _arg_1.data as NoviceFinishInfo;
         TasksManager.setTaskStatus(_local_2.taskID,TasksManager.COMPLETE);
         NpcController.refreshTaskInfo();
      }
      
      override public function start() : void
      {
         EventManager.addEventListener(NpcEvent.SHOW_TASK_LIST,this.npcClickHandler);
         EventManager.addEventListener(NpcEvent.COMPLETE_TASK,this.completeTaskHandler);
         SocketConnection.addCmdListener(CommandID.ADD_TASK_BUF,onAddBuf);
         SocketConnection.addCmdListener(CommandID.COMPLETE_TASK,onCompTask);
         SocketConnection.addCmdListener(CommandID.DELETE_TASK,onDelTask);
         finish();
      }
      
      private function npcClickHandler(_arg_1:NpcEvent) : void
      {
         var _local_2:NpcModel = _arg_1.model;
         var _local_3:NpcTaskInfo = _local_2.taskInfo;
         if(_local_2.taskInfo.acceptList.length > 0)
         {
            TaskPanelController.show(_local_2);
         }
         else if(_local_2.des != "")
         {
            NpcDialog.show(_local_2.npcInfo.npcId,[_local_2.des],_local_2.npcInfo.questionA);
         }
         else
         {
            _local_2.dispatchEvent(new NpcEvent(NpcEvent.NPC_CLICK,_local_2));
         }
      }
      
      private function completeTaskHandler(event:NpcEvent) : void
      {
         var model:NpcModel = null;
         var id:uint = 0;
         model = null;
         id = 0;
         model = event.model;
         if(model.taskInfo.completeList.length > 0)
         {
            id = uint(model.taskInfo.completeList.slice().shift());
            TasksManager.complete(id,TasksXMLInfo.getTaskPorCount(id) - 1,function(_arg_1:Boolean):void
            {
               if(_arg_1)
               {
                  TasksManager.setTaskStatus(id,TasksManager.COMPLETE);
                  model.refreshTask();
               }
               else
               {
                  Alarm.show("提交任务失败，请稍后再试");
               }
            });
         }
      }
   }
}

