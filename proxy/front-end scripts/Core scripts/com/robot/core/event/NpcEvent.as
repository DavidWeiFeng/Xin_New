package com.robot.core.event
{
   import com.robot.core.mode.NpcModel;
   import flash.events.Event;
   
   public class NpcEvent extends Event
   {
      
      public static const TASK_WITHOUT_DES:String = "taskWithoutDes";
      
      public static const NPC_CLICK:String = "npcClick";
      
      public static const SHOW_TASK_LIST:String = "showTaskList";
      
      public static const COMPLETE_TASK:String = "completeTask";
      
      public static const ORIGNAL_EVENT:String = "orignalEvent";
      
      private var _model:NpcModel;
      
      private var _taskID:uint;
      
      public function NpcEvent(_arg_1:String, _arg_2:NpcModel, _arg_3:uint = 0, _arg_4:Boolean = false, _arg_5:Boolean = false)
      {
         super(_arg_1,_arg_4,_arg_5);
         this._model = _arg_2;
         this._taskID = _arg_3;
      }
      
      public function get model() : NpcModel
      {
         return this._model;
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
   }
}

