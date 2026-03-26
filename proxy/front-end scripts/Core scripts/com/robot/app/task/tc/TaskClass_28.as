package com.robot.app.task.tc
{
   import com.robot.app.task.control.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.event.*;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   
   public class TaskClass_28
   {
      
      private var info:NoviceFinishInfo;
      
      public function TaskClass_28(_arg_1:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(28,TasksManager.COMPLETE);
         this.info = _arg_1;
         NpcTipDialog.show("数千万年以前的赫尔卡星人拥有过人的智慧，很久以前就开始研究建立机械精灵的开发系统。这只精灵就是他们智慧的结晶，送给你咯，好好照顾它吧！",this.getQita,NpcTipDialog.DOCTOR,0,this.getQita);
      }
      
      private function getQita() : void
      {
         PetManager.addEventListener(PetEvent.ADDED,function(_arg_1:PetEvent):void
         {
            PetManager.removeEventListener(PetEvent.ADDED,arguments.callee);
            PetInBagAlert.show(info.petID,"奇塔已经放入了你的精灵背包。");
         });
         if(PetManager.length < 6)
         {
            PetManager.setIn(this.info.captureTm,1);
         }
         else
         {
            PetManager.addStorage(this.info.petID,this.info.captureTm);
            PetInStorageAlert.show(this.info.petID,"奇塔已经放入了你的精灵仓库。");
         }
         TaskController_28.delIcon();
      }
   }
}

