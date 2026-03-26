package com.robot.app.task.control
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.AppModel;
   
   public class TaskController_133
   {
      
      public static const TASK_ID:uint = 133;
      
      private static var panel:AppModel = null;
      
      public function TaskController_133()
      {
         super();
      }
      
      public static function showPanel() : void
      {
         TasksManager.getProStatusList(TaskController_133.TASK_ID,TaskController_133.tasksStates);
      }
      
      public static function setup() : void
      {
      }
      
      public static function start() : void
      {
      }
      
      public static function destroy() : void
      {
         if(Boolean(panel))
         {
            panel.destroy();
            panel = null;
         }
      }
      
      public static function tasksStates(_arg_1:Array) : void
      {
         var _local_2:String = "";
         if(!_arg_1[0])
         {
            NpcTipDialog.show("我们在<font color=\'#ff0000\'>遗忘领域</font>里竟然看到了一个奇怪的赛尔！他到底是谁呢？快去问问他吧……\r(快点击他问问吧)",null,NpcTipDialog.SEER);
            return;
         }
         if(Boolean(_arg_1[0]) && !_arg_1[1])
         {
            NpcTipDialog.show("根据史空说的琴谱点击铃铛草吧！他似乎相当的入迷陶醉哦！\r(根据琴谱来弹奏吧)",null,NpcTipDialog.SEER);
            return;
         }
         if(Boolean(_arg_1[1]))
         {
            NpcTipDialog.show("月影花园是最美丽的一个地方，这里曾经有着格林和布鲁的故事！快带史空去那里看看吧……\r(快去塔克星来到月影花园吧)",null,NpcTipDialog.SEER);
            return;
         }
      }
   }
}

