package com.robot.app.npc.npcClass
{
   import com.robot.app.task.control.TaskController_90;
   import com.robot.core.event.NpcEvent;
   import com.robot.core.manager.CoreAssetsManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.INpc;
   import com.robot.core.npc.NpcInfo;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class NpcClass_50 implements INpc
   {
      
      private var _curNpcModel:NpcModel;
      
      private var _npc_mc:MovieClip;
      
      public function NpcClass_50(_arg_1:NpcInfo, _arg_2:DisplayObject)
      {
         super();
         if(TasksManager.getTaskStatus(TaskController_90.TASK_ID) == TasksManager.COMPLETE)
         {
            return;
         }
         this._curNpcModel = new NpcModel(_arg_1,_arg_2 as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onNpcClick);
         var _local_3:MovieClip = CoreAssetsManager.getMovieClip("lib_excalmatory_mark");
         _local_3.y = -this._curNpcModel.height;
         this._npc_mc = _arg_2 as MovieClip;
         this._npc_mc.addChild(_local_3);
      }
      
      private function onNpcClick(_arg_1:NpcEvent) : void
      {
         this._curNpcModel.refreshTask();
         TaskController_90.clickPIPI();
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

