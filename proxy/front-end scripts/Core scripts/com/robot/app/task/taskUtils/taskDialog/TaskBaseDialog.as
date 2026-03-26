package com.robot.app.task.taskUtils.taskDialog
{
   import com.robot.core.manager.*;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.TextField;
   import org.taomee.utils.*;
   
   public class TaskBaseDialog
   {
      
      public static var dialogMC:MovieClip;
      
      private static var _fun:Function;
      
      private static var taskAwardDialog:MovieClip;
      
      public function TaskBaseDialog()
      {
         super();
      }
      
      public static function showNpcImgDialog(_arg_1:String = "", _arg_2:Function = null) : void
      {
         initDialog(new Point(0,-80),_arg_2);
         var _local_3:SimpleButton = dialogMC["closeBtn"];
         _local_3.addEventListener(MouseEvent.CLICK,onRemove);
      }
      
      private static function onRemove(_arg_1:MouseEvent) : void
      {
         removeDialog();
      }
      
      private static function removeDialog() : void
      {
         DisplayUtil.removeForParent(dialogMC);
         LevelManager.openMouseEvent();
         dialogMC = null;
         if(_fun != null)
         {
            _fun();
         }
      }
      
      public static function showAwardDialog(_arg_1:String = "", _arg_2:Function = null) : void
      {
         initDialog(null,_arg_2);
      }
      
      private static function initDialog(pt:Point = null, okFun:Function = null) : void
      {
         var dragMc:SimpleButton = null;
         var okBtn:SimpleButton = null;
         _fun = okFun;
         LevelManager.topLevel.addChild(dialogMC);
         DisplayUtil.align(dialogMC,null,AlignType.MIDDLE_CENTER,pt);
         LevelManager.closeMouseEvent();
         dragMc = dialogMC["dragMC"];
         dragMc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            dialogMC.startDrag();
         });
         dragMc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            dialogMC.stopDrag();
         });
         okBtn = dialogMC["okBtn"];
         okBtn.addEventListener(MouseEvent.CLICK,onRemove);
      }
      
      public static function showTaskAwardDialog(str:String = "", awardImg:DisplayObject = null, pt:Point = null, okFun:Function = null) : void
      {
         var dragMc:SimpleButton = null;
         var txt:TextField = null;
         var okBtn:SimpleButton = null;
         var remove:Function = null;
         okBtn = null;
         remove = null;
         remove = function(_arg_1:MouseEvent):void
         {
            LevelManager.openMouseEvent();
            okBtn.removeEventListener(MouseEvent.CLICK,remove);
            DisplayUtil.removeForParent(taskAwardDialog);
            awardImg = null;
            taskAwardDialog = null;
            dragMc = null;
            if(okFun != null)
            {
               okFun();
            }
         };
         if(pt == null)
         {
            pt = new Point(55,52);
         }
         taskAwardDialog = UIManager.getMovieClip("taskAwardDialog");
         if(Boolean(awardImg))
         {
            awardImg.x = pt.x;
            awardImg.y = pt.y;
            taskAwardDialog.addChild(awardImg);
         }
         LevelManager.topLevel.addChild(taskAwardDialog);
         DisplayUtil.align(taskAwardDialog,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         dragMc = taskAwardDialog["dragMC"];
         dragMc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            taskAwardDialog.startDrag();
         });
         dragMc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            taskAwardDialog.stopDrag();
         });
         txt = taskAwardDialog["txt"];
         txt.htmlText = str;
         okBtn = taskAwardDialog["okBtn"];
         okBtn.addEventListener(MouseEvent.CLICK,remove);
      }
   }
}

