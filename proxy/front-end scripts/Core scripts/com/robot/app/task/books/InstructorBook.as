package com.robot.app.task.books
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.*;
   
   public class InstructorBook
   {
      
      private static var mc:MovieClip;
      
      private static var app:ApplicationDomain;
      
      private static var mainPanel:MovieClip;
      
      private static var PATH:String = "resource/book/instructorBook.swf";
      
      public function InstructorBook()
      {
         super();
      }
      
      public static function loadPanel() : void
      {
         var _local_1:MCLoader = null;
         if(!mc)
         {
            _local_1 = new MCLoader(PATH,LevelManager.topLevel,1,"正在打开教官手册");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,onLoad);
            _local_1.doLoad();
         }
         else
         {
            mc.gotoAndStop(1);
            mainPanel.gotoAndStop(1);
            show();
         }
      }
      
      private static function onLoad(_arg_1:MCLoadEvent) : void
      {
         app = _arg_1.getApplicationDomain();
         mc = new (app.getDefinition("instructorBook") as Class)() as MovieClip;
         mainPanel = mc["mainPanel"];
         mc.x = 496.55;
         mc.y = 276.7;
         mainPanel.stop();
         mc.cacheAsBitmap = true;
         show();
      }
      
      private static function show() : void
      {
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(mc);
         var _local_1:SimpleButton = mc["exitBtn"];
         _local_1.addEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mc);
         LevelManager.openMouseEvent();
      }
   }
}

