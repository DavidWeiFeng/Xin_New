package com.robot.app.task.tc
{
   import com.robot.app.messagetool.*;
   import com.robot.app.task.control.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   
   public class TaskClass_38
   {
      
      private var info:NoviceFinishInfo;
      
      public function TaskClass_38(_arg_1:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(TaskController_38.TASK_ID,TasksManager.COMPLETE);
         this.info = _arg_1;
         TaskController_38.delIcon();
         MessageTool.destroy();
         this.getReword();
      }
      
      private function getReword() : void
      {
         NpcTipDialog.show("辛苦了！\n    任务完成得非常好，骄阳计划的船员们都成长得非常快，让我感到非常欣喜。\n    这是给你的奖励！",function():void
         {
            Alarm.show("<font color=\'#ff0000\'>" + "南瓜铠甲" + "</font>套装已经放入你的储存箱！",function():void
            {
               ItemInBagAlert.show(info.monBallList[4].itemID,"<font color=\'#ff0000\'>" + info.monBallList[4].itemCnt + "</font>个骄阳豆已放入了你的储存箱。",function():void
               {
                  ItemInBagAlert.show(info.monBallList[5].itemID,"<font color=\'#ff0000\'>" + info.monBallList[5].itemCnt + "</font>扭蛋牌已放入了你的储存箱。");
               });
               MainManager.actorInfo.coins += info.monBallList[4].itemCnt;
            });
         },NpcTipDialog.IRIS);
      }
   }
}

