package com.robot.app.npc.npcClass
{
   import com.robot.app.task.noviceGuide.*;
   import com.robot.app.task.publicizeenvoy.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.npc.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.utils.*;
   
   public class NpcClass_1 implements INpc
   {
      
      private var _curNpcModel:NpcModel;
      
      public function NpcClass_1(_arg_1:NpcInfo, _arg_2:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(_arg_1,_arg_2 as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onNpcClick);
         this._curNpcModel.addEventListener(NpcEvent.TASK_WITHOUT_DES,this.onTaskWithoutDes);
         NpcTaskManager.addTaskListener(50001,this.onTaskHandler);
      }
      
      private function onTaskWithoutDes(_arg_1:NpcEvent) : void
      {
         var _local_2:uint = uint(_arg_1.taskID);
         var _local_3:* = getDefinitionByName("com.robot.app.task.control.TaskController_" + _local_2) as Class;
         _local_3.start();
      }
      
      private function onNpcClick(_arg_1:NpcEvent) : void
      {
         this._curNpcModel.refreshTask();
         TalkShiper.start(_arg_1.taskID);
      }
      
      private function onTaskHandler(event:Event) : void
      {
         if(TasksManager.getTaskStatus(25) != TasksManager.ALR_ACCEPT)
         {
            PublicizeEnvoyDialog.getInstance().show();
            return;
         }
         TasksManager.getProStatusList(25,function(_arg_1:Array):void
         {
            var _local_2:Boolean = Boolean(TasksManager.isComNoviceTask());
            var _local_3:Boolean = TasksManager.getTaskStatus(4) == TasksManager.COMPLETE;
            var _local_4:Boolean = TasksManager.getTaskStatus(94) == TasksManager.COMPLETE;
            var _local_5:Boolean = TasksManager.getTaskStatus(19) == TasksManager.COMPLETE;
            if(_local_2 && _local_3 && _local_4 && _local_5)
            {
               TasksManager.complete(25,5);
            }
            else
            {
               PublicizeEnvoyDialog.getInstance().show();
            }
         });
      }
      
      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onNpcClick);
            this._curNpcModel.destroy();
            this._curNpcModel = null;
         }
      }
      
      public function get npc() : NpcModel
      {
         return this._curNpcModel;
      }
   }
}

