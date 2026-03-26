package com.robot.app.task.control
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.manager.*;
   
   public class TaskController_31
   {
      
      private static var icon:InteractiveObject;
      
      private static var lightMC:MovieClip;
      
      public static const TASK_ID:uint = 31;
      
      private static var panel:AppModel = null;
      
      public function TaskController_31()
      {
         super();
      }
      
      public static function setup() : void
      {
         if(TasksManager.getTaskStatus(TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            showIcon();
         }
      }
      
      public static function start() : void
      {
         NpcTipDialog.show("不要轻敌，眼前的每一个敌人都是可怕，这是一场硬仗，只有胆大心细的小赛尔才能突破重重包围进入海盗基地，为赛尔大部队的开辟安全的进攻道路。",accept,NpcTipDialog.INSTRUCTOR);
      }
      
      private static function accept() : void
      {
         TasksManager.accept(TASK_ID);
         showIcon();
         var _local_1:MCLoader = new MCLoader("resource/bounsMovie/PirateFortFightTask.swf",LevelManager.topLevel,1,"正在打开任务...");
         _local_1.addEventListener(MCLoadEvent.SUCCESS,onLoaded);
         _local_1.doLoad();
      }
      
      private static function onLoaded(_arg_1:MCLoadEvent) : void
      {
         (_arg_1.currentTarget as MCLoader).removeEventListener(MCLoadEvent.SUCCESS,onLoaded);
         var _local_2:ApplicationDomain = _arg_1.getApplicationDomain();
         var _local_3:MovieClip = new (_local_2.getDefinition("ReceiveTaskMC") as Class)() as MovieClip;
         LevelManager.appLevel.addChild(_local_3);
         _local_3.x = 480;
         _local_3.y = 280;
      }
      
      public static function showIcon() : void
      {
         if(!icon)
         {
            icon = TaskIconManager.getIcon("icon_31");
            icon.addEventListener(MouseEvent.CLICK,clickHandler);
            ToolTipManager.add(icon,"海盗要塞前的战斗");
            lightMC = icon["lightMC"];
         }
         TaskIconManager.addIcon(icon);
      }
      
      public static function delIcon() : void
      {
         TaskIconManager.delIcon(icon);
      }
      
      private static function clickHandler(_arg_1:MouseEvent) : void
      {
         lightMC.gotoAndStop(lightMC.totalFrames);
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getTaskModule("PirateFortFight"),"正在打开任务信息");
            panel.setup();
         }
         panel.show();
      }
   }
}

