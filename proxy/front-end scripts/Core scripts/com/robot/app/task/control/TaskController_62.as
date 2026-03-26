package com.robot.app.task.control
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class TaskController_62
   {
      
      private static var icon:InteractiveObject;
      
      private static var lightMC:MovieClip;
      
      public static const TASK_ID:uint = 62;
      
      private static var panel:AppModel = null;
      
      public function TaskController_62()
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
         accept();
      }
      
      private static function accept() : void
      {
         TasksManager.accept(TASK_ID);
         showIcon();
         var _local_1:MCLoader = new MCLoader("resource/bounsMovie/joinin.swf",LevelManager.topLevel,1,"精灵进场准备...");
         _local_1.addEventListener(MCLoadEvent.SUCCESS,onLoaded);
         _local_1.doLoad();
      }
      
      private static function onLoaded(event:MCLoadEvent) : void
      {
         var content:MovieClip = null;
         content = null;
         SoundManager.stopSound();
         (event.currentTarget as MCLoader).removeEventListener(MCLoadEvent.SUCCESS,onLoaded);
         content = event.getContent() as MovieClip;
         MainManager.getStage().addChild(content);
         content.addEventListener("EFFECT_END",function(event:Event):void
         {
            SoundManager.playSound();
            DisplayUtil.removeForParent(content);
            TasksManager.complete(TaskController_62.TASK_ID,0,function(_arg_1:Boolean):void
            {
               nextStep();
            });
         });
      }
      
      public static function nextStep() : void
      {
         NpcTipDialog.show("好壮观的场面啊！\n    差点给忘了！" + MainManager.actorInfo.nick + "，你还不知道冰系精灵争霸赛的比赛规则吧？要我给你介绍下吗？",function():void
         {
            loadRuleInfoSwf();
         },NpcTipDialog.IRIS);
      }
      
      private static function loadRuleInfoSwf() : void
      {
         var _local_1:MCLoader = new MCLoader("resource/book/gamerule.swf",LevelManager.topLevel,1,"正在打开");
         _local_1.addEventListener(MCLoadEvent.SUCCESS,onLoad);
         _local_1.doLoad();
      }
      
      private static function onLoad(event:MCLoadEvent) : void
      {
         var content:MovieClip = null;
         content = null;
         content = event.getContent() as MovieClip;
         LevelManager.appLevel.addChild(content);
         DisplayUtil.align(content,null,AlignType.MIDDLE_CENTER);
         content["close_btn"].addEventListener(MouseEvent.CLICK,function(_arg_1:MouseEvent):void
         {
            DisplayUtil.removeForParent(content);
         });
      }
      
      public static function showIcon() : void
      {
         if(!icon)
         {
            icon = TaskIconManager.getIcon("AwardIcon");
            icon.addEventListener(MouseEvent.CLICK,clickHandler);
            ToolTipManager.add(icon,"冰系精灵王争霸赛开幕式");
         }
         TaskIconManager.addIcon(icon);
      }
      
      public static function delIcon() : void
      {
         ToolTipManager.remove(icon);
         TaskIconManager.delIcon(icon);
         icon.removeEventListener(MouseEvent.CLICK,clickHandler);
         icon = null;
         if(Boolean(panel))
         {
            panel.destroy();
            panel = null;
         }
      }
      
      private static function clickHandler(_arg_1:MouseEvent) : void
      {
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getTaskModule("Task62Panel"),"正在打开斯诺冰牌信息");
            panel.setup();
            panel.show();
         }
         else
         {
            panel.show();
         }
      }
   }
}

