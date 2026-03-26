package com.robot.app.task.books
{
   import com.robot.app.task.noviceGuide.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.*;
   
   public class TimesNewPanel
   {
      
      private static var mc:MovieClip;
      
      private static var app:ApplicationDomain;
      
      public static var messageIcon:MovieClip;
      
      private static var PATH:String = "resource/task/timeNews.swf";
      
      public function TimesNewPanel()
      {
         super();
      }
      
      public static function loadPanel() : void
      {
         var _local_1:MCLoader = null;
         if(!mc)
         {
            _local_1 = new MCLoader(PATH,LevelManager.topLevel,1,"正在打开《航行日志》");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,onLoad);
            _local_1.doLoad();
         }
         else
         {
            show();
            mc.stop();
            (mc["bookMC"] as MovieClip).gotoAndStop(1);
         }
      }
      
      private static function onLoad(_arg_1:MCLoadEvent) : void
      {
         app = _arg_1.getApplicationDomain();
         mc = new (app.getDefinition("timeNews") as Class)() as MovieClip;
         mc.stop();
         (mc["bookMC"] as MovieClip).stop();
         show();
      }
      
      private static function show() : void
      {
         mc.x = 567;
         mc.y = 294;
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(mc);
         var _local_1:SimpleButton = mc["exitBtn"];
         _local_1.addEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mc);
         LevelManager.openMouseEvent();
         if(GuideTaskModel.statusAry[0] == 1 && TasksManager.getTaskStatus(1) != TasksManager.COMPLETE)
         {
            SocketConnection.send(CommandID.COMPLETE_TASK,1,1);
         }
      }
      
      public static function closeBook() : void
      {
         DisplayUtil.removeForParent(mc);
         LevelManager.openMouseEvent();
      }
   }
}

