package com.robot.app.task
{
   import com.robot.app.automaticFight.*;
   import com.robot.app.control.*;
   import com.robot.app.other.filter.*;
   import com.robot.app.petItem.*;
   import com.robot.app.spt.*;
   import com.robot.app.sptGalaxy.XuanWuController;
   import com.robot.app.task.SeerInstructor.*;
   import com.robot.app.task.conscribeTeam.*;
   import com.robot.app.task.control.*;
   import com.robot.app.task.dailyTask.*;
   import com.robot.app.task.newNovice.*;
   import com.robot.app.task.publicizeenvoy.*;
   import com.robot.app.tasksRecord.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.npc.*;
   import com.robot.core.teamPK.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.*;
   
   public class TaskMain extends BaseBeanController
   {
      
      private var iconMc:MovieClip;
      
      public function TaskMain()
      {
         super();
      }
      
      override public function start() : void
      {
         PioneerTaskIconController.createIcon();
         DailyTaskController.setup();
         TasksRecordController.setup();
         NewInstructorContoller.setup();
         ConscribeTeam.setup();
         TaskController_25.start();
         EventManager.addEventListener("DS_TASK",this.onDsTask);
         if(MainManager.actorInfo.teamPKInfo.homeTeamID > 50000)
         {
            TeamPKManager.showIcon();
         }
         GuoqingsignupController.createIcon();
         this.createShinyIcon();
         finish();
         AutomaticFightManager.setup();
         StudyUpManager.setup();
         HatchTaskMapManager.setup();
         NewNoviceGuideTaskController.setup();
         NpcController.setup();
         XuanWuController.setup();
      }
      
      private function onDsTask(_arg_1:DynamicEvent) : void
      {
         MainManager.actorInfo.newInviteeCnt = uint(_arg_1.paramObject);
         if(MainManager.actorInfo.newInviteeCnt >= 2)
         {
            PublicizeEnvoyIconControl.lightIcon();
         }
      }
      
      private function createShinyIcon() : void
      {
         this.iconMc = TaskIconManager.getIcon("icon_31") as MovieClip;
         this.iconMc.x = 112;
         this.iconMc.y = 24;
         ToolTipManager.add(this.iconMc,"炫彩面板");
         LevelManager.iconLevel.addChild(this.iconMc);
         (this.iconMc["lightMC"] as MovieClip).visible = false;
         this.iconMc.addEventListener(MouseEvent.CLICK,function(_arg_1:MouseEvent):void
         {
            FilterPanelController.show();
         });
      }
   }
}

