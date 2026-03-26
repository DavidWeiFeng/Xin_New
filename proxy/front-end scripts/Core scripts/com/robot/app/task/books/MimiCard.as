package com.robot.app.task.books
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.utils.*;
   
   public class MimiCard
   {
      
      private static var mc:MovieClip;
      
      private static var PATH:String = "resource/book/mimicard.swf";
      
      public function MimiCard()
      {
         super();
      }
      
      public static function loadPanel() : void
      {
         var _local_1:MCLoader = null;
         if(!mc)
         {
            _local_1 = new MCLoader(PATH,LevelManager.topLevel,1,"正在打开米米卡手册");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,onLoad);
            _local_1.doLoad();
         }
         else
         {
            mc.gotoAndStop(1);
            show();
         }
      }
      
      private static function onLoad(_arg_1:MCLoadEvent) : void
      {
         mc = _arg_1.getContent() as MovieClip;
         show();
      }
      
      private static function show() : void
      {
         DisplayUtil.align(mc,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(mc);
         var _local_1:SimpleButton = mc["closeBtn"];
         _local_1.addEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mc);
         LevelManager.openMouseEvent();
         mc = null;
      }
   }
}

