package com.robot.app.npc.npcClass
{
   import com.robot.app.task.control.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.npc.*;
   import flash.display.*;
   
   public class NpcClass_4 implements INpc
   {
      
      private var _curNpcModel:NpcModel;
      
      public function NpcClass_4(_arg_1:NpcInfo, _arg_2:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(_arg_1,_arg_2 as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
      }
      
      private function onClickNpc(e:NpcEvent) : void
      {
         this._curNpcModel.refreshTask();
         if(e.taskID == 42)
         {
            TasksManager.getProStatusList(42,function(arr:Array):void
            {
               if(Boolean(arr[4]) && !arr[5])
               {
                  NpcTipDialog.show("天啊……原来赫尔卡星历史书上记载的\"西塔\"和\"奇塔\"就是你设计出来的？这真是太棒了！看来我给你的这份礼物你真是当之无愧啊！",function():void
                  {
                     TasksManager.complete(TaskController_42.TASK_ID,5,null);
                  },NpcTipDialog.IRIS);
               }
            });
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.removeEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
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

