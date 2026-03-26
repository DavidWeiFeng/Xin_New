package com.robot.app.task.books
{
   import com.robot.app.task.noviceGuide.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.*;
   
   public class FlyBook
   {
      
      private static var app:ApplicationDomain;
      
      private static var mainPanel:MovieClip;
      
      private static var PATH:String = "resource/book/flyBook.swf";
      
      public function FlyBook()
      {
         super();
      }
      
      public static function loadPanel() : void
      {
         var _local_1:MCLoader = null;
         if(!mainPanel)
         {
            _local_1 = new MCLoader(PATH,LevelManager.topLevel,1,"正在打开飞船手册");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,onLoad);
            _local_1.doLoad();
         }
         else
         {
            mainPanel.gotoAndStop(1);
            show();
         }
      }
      
      private static function onLoad(_arg_1:MCLoadEvent) : void
      {
         app = _arg_1.getApplicationDomain();
         mainPanel = new (app.getDefinition("flyBookMC") as Class)() as MovieClip;
         mainPanel.stop();
         mainPanel.cacheAsBitmap = true;
         show();
      }
      
      private static function show() : void
      {
         DisplayUtil.align(mainPanel,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(mainPanel);
         var _local_1:SimpleButton = mainPanel["exitBtn"];
         _local_1.addEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mainPanel);
         LevelManager.openMouseEvent();
         if(TasksManager.taskList[2] == 1 && !GuideTaskModel.bReadFlyBook)
         {
            GuideTaskModel.setTaskBuf("6");
         }
         if(TasksManager.taskList[2] == 0 && MapManager.currentMap.id == 8)
         {
            XixiDialog.showNextDialog();
         }
      }
   }
}

