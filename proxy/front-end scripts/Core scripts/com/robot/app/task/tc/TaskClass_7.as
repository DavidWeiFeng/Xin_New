package com.robot.app.task.tc
{
   import com.robot.app.task.skeeClothTask.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   
   public class TaskClass_7
   {
      
      private var itemID:uint;
      
      public function TaskClass_7(_arg_1:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(7,TasksManager.COMPLETE);
         this.itemID = uint(_arg_1.monBallList[0]["itemID"]);
         SkeeClothTaskController.delIcon();
         Alarm.show("<font color=\'#ff0000\'>" + "防寒服" + "</font>套装已经放入你的储存箱！");
      }
      
      private function onClick() : void
      {
         SkeeClothTaskController.delIcon();
         var _local_1:String = ItemXMLInfo.getName(this.itemID);
         Alarm.show("<font color=\'#ff0000\'>" + _local_1 + "</font>已经放入你的储存箱！");
      }
   }
}

