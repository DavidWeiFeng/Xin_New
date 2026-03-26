package com.robot.app.task.noviceGuide
{
   import com.robot.app.newspaper.*;
   import com.robot.app.task.taskUtils.baseAction.*;
   import com.robot.app.task.taskUtils.manage.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.manager.*;
   
   public class GuideTaskModel
   {
      
      private static var iconMc:SimpleButton;
      
      private static var bufTmp:String;
      
      private static var _loader:MCLoader;
      
      public static var statusAry:Array = [0,1,0,1,1];
      
      public static var bAcptTask:Boolean = false;
      
      public static const NOVICE_TASK_COMPLETE:String = "noviceTaskComplete";
      
      public static var bDone:Boolean = true;
      
      private static var PATH:String = "resource/task/novice.swf";
      
      public static var bTaskDoctor:Boolean = false;
      
      public static var bReadMonBook:Boolean = false;
      
      public static var bReadFlyBook:Boolean = false;
      
      public function GuideTaskModel()
      {
         super();
      }
      
      public static function checkTaskStatus() : void
      {
         var _local_1:Array = TasksManager.taskList;
         if(TasksManager.taskList[1] == 3 && TasksManager.taskList[2] == 0)
         {
            DoGuideTask.doTask();
            return;
         }
         if(TasksManager.taskList[2] == 0 || TasksManager.taskList[3] == 3)
         {
            return;
         }
         if(_loader == null)
         {
            loadGuideTaskUI();
         }
         else
         {
            getTaskBuf();
         }
      }
      
      private static function loadGuideTaskUI() : void
      {
         _loader = new MCLoader(PATH,LevelManager.topLevel,1,"正在加载新手任务资源");
         _loader.addEventListener(MCLoadEvent.SUCCESS,onComplete);
         _loader.doLoad();
      }
      
      private static function onComplete(_arg_1:MCLoadEvent) : void
      {
         _loader.removeEventListener(MCLoadEvent.SUCCESS,onComplete);
         var _local_2:ApplicationDomain = _arg_1.getApplicationDomain();
         TaskUIManage.loadHash.add(4,_arg_1.getLoader());
         if(iconMc == null)
         {
            iconMc = TaskUIManage.getButton("guideTaskIcon",4);
            iconMc.addEventListener(MouseEvent.CLICK,showTaskPanel);
            TaskIconManager.addIcon(iconMc);
            ToolTipManager.add(iconMc,"新船员任务");
         }
         getTaskBuf();
      }
      
      private static function onSetTaskBufOk(_arg_1:Event) : void
      {
         EventManager.removeEventListener(SetTaskBuf.SET_BUF_OK,onSetTaskBufOk);
         checkTaskStatus();
      }
      
      private static function getTaskBuf() : void
      {
         GetTaskBuf.taskId = 3;
         GetTaskBuf.getBuf();
         EventManager.addEventListener(GetTaskBuf.GET_TASK_BUF_OK,onGetBufOk);
      }
      
      private static function showTaskPanel(_arg_1:MouseEvent) : void
      {
         GuideTaskController.showPanel();
      }
      
      public static function submitTask() : void
      {
         var _local_1:int = 0;
         bDone = true;
         while(_local_1 < statusAry.length)
         {
            if(statusAry[_local_1] != 1)
            {
               bDone = false;
               break;
            }
            _local_1++;
         }
         if(bDone && bReadMonBook)
         {
            SocketConnection.send(CommandID.COMPLETE_TASK,3,1);
         }
      }
      
      public static function removeIcon() : void
      {
         if(Boolean(iconMc))
         {
            TaskIconManager.delIcon(iconMc);
            ToolTipManager.remove(iconMc);
         }
      }
      
      public static function setGuideTaskBuf(_arg_1:uint, _arg_2:String) : void
      {
         if(statusAry[_arg_1] == 1)
         {
            return;
         }
         if(TasksManager.taskList[2] == 1)
         {
            statusAry[_arg_1] = 1;
            setTaskBuf(_arg_2);
         }
         if(TasksManager.taskList[0] != 3 && statusAry[0] == 1)
         {
            (NewsPaper.timeIcon["ball"] as MovieClip).play();
            (NewsPaper.timeIcon["ball"] as MovieClip).visible = true;
         }
      }
      
      public static function setTaskBuf(_arg_1:String) : void
      {
         GetTaskBuf.taskId = 3;
         GetTaskBuf.getBuf();
         EventManager.addEventListener(GetTaskBuf.GET_TASK_BUF_OK,onChangeBuf);
         bufTmp = _arg_1;
      }
      
      private static function onChangeBuf(_arg_1:Event) : void
      {
         EventManager.removeEventListener(GetTaskBuf.GET_TASK_BUF_OK,onChangeBuf);
         SetTaskBuf.taskId = 3;
         bufTmp += GetTaskBuf.taskBuf.buf;
         SetTaskBuf.buf = bufTmp;
         SetTaskBuf.setBuf();
         EventManager.addEventListener(SetTaskBuf.SET_BUF_OK,onSetTaskBufOk);
      }
      
      private static function onGetBufOk(_arg_1:Event) : void
      {
         var _local_3:int = 0;
         EventManager.removeEventListener(GetTaskBuf.GET_TASK_BUF_OK,onGetBufOk);
         var _local_2:String = GetTaskBuf.buf;
         while(_local_3 < statusAry.length)
         {
            if(_local_2.indexOf((_local_3 + 1).toString()) != -1)
            {
               statusAry[_local_3] = 1;
            }
            _local_3++;
         }
         if(_local_2.indexOf("9") != -1)
         {
            bAcptTask = true;
         }
         if(_local_2.indexOf("8") != -1)
         {
            bTaskDoctor = true;
            statusAry[2] = 1;
         }
         if(_local_2.indexOf("7") != -1)
         {
            bReadMonBook = true;
         }
         if(_local_2.indexOf("6") != -1)
         {
            bReadFlyBook = true;
         }
         if(TasksManager.taskList[0] == 3)
         {
            statusAry[0] = 1;
         }
         if(TasksManager.taskList[0] != 3 && statusAry[0] == 1)
         {
            (NewsPaper.timeIcon["ball"] as MovieClip).visible = true;
            (NewsPaper.timeIcon["ball"] as MovieClip).play();
         }
      }
   }
}

