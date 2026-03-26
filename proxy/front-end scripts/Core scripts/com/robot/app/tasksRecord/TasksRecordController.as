package com.robot.app.tasksRecord
{
   import com.robot.core.config.*;
   import com.robot.core.event.TasksRecordEvent;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.SharedObject;
   import org.taomee.ds.*;
   import org.taomee.manager.*;
   
   public class TasksRecordController
   {
      
      private static var _allIdA:Array;
      
      private static var _icon:MovieClip;
      
      private static var _so:SharedObject;
      
      private static var _taskMainPanel:AppModel;
      
      private static var _normalMap:HashMap = new HashMap();
      
      private static var _superMap:HashMap = new HashMap();
      
      private static var _specialSupMap:HashMap = new HashMap();
      
      private static var _specialNorMap:HashMap = new HashMap();
      
      public function TasksRecordController()
      {
         super();
      }
      
      public static function setup() : void
      {
         _allIdA = TasksRecordConfig.getAllTasksId();
         makeData();
         addIcon();
      }
      
      private static function onHideHandler(_arg_1:TasksRecordEvent) : void
      {
         if(Boolean(_taskMainPanel))
         {
            _taskMainPanel.hide();
         }
      }
      
      private static function onTaskIntroductionHandler(_arg_1:TasksRecordEvent) : void
      {
         if(Boolean(_taskMainPanel))
         {
            _taskMainPanel.hide();
         }
      }
      
      private static function onTasksListHandler(_arg_1:TasksRecordEvent) : void
      {
         showListPanel();
      }
      
      private static function makeData() : void
      {
         var _local_1:TaskRecordInfo = null;
         var _local_2:uint = 0;
         var _local_3:uint = 0;
         var _local_4:int = 0;
         _specialSupMap = new HashMap();
         _specialNorMap = new HashMap();
         _superMap = new HashMap();
         _normalMap = new HashMap();
         while(_local_4 < _allIdA.length)
         {
            _local_1 = new TaskRecordInfo(_allIdA[_local_4]);
            if(_local_1.type == 1)
            {
               if(_local_1.offLine)
               {
                  _specialSupMap.add(_local_1.onlineData,_local_1);
                  if(_local_1.isVip == false)
                  {
                     _specialNorMap.add(_local_1.onlineData,_local_1);
                  }
               }
               else
               {
                  _local_2 = TasksRecordConfig.getParentId(_local_1.taskId);
                  if(_local_2 != 0)
                  {
                     if(TasksManager.getTaskStatus(TasksRecordConfig.getParentId(_local_1.taskId)) == TasksManager.COMPLETE)
                     {
                        _specialSupMap.add(_local_1.onlineData,_local_1);
                        if(_local_1.isVip == false)
                        {
                           _specialNorMap.add(_local_1.onlineData,_local_1);
                        }
                     }
                  }
                  else
                  {
                     _specialSupMap.add(_local_1.onlineData,_local_1);
                     if(_local_1.isVip == false)
                     {
                        _specialNorMap.add(_local_1.onlineData,_local_1);
                     }
                  }
               }
            }
            else if(_local_1.offLine)
            {
               _superMap.add(_local_1.onlineData,_local_1);
               if(_local_1.isVip == false)
               {
                  _normalMap.add(_local_1.onlineData,_local_1);
               }
            }
            else
            {
               _local_3 = TasksRecordConfig.getParentId(_local_1.taskId);
               if(_local_3 != 0)
               {
                  if(TasksManager.getTaskStatus(_local_3) == TasksManager.COMPLETE)
                  {
                     _superMap.add(_local_1.onlineData,_local_1);
                     if(_local_1.isVip == false)
                     {
                        _normalMap.add(_local_1.onlineData,_local_1);
                     }
                  }
               }
               else
               {
                  _superMap.add(_local_1.onlineData,_local_1);
                  if(_local_1.isVip == false)
                  {
                     _normalMap.add(_local_1.onlineData,_local_1);
                  }
               }
            }
            _local_4++;
         }
      }
      
      public static function get normalMap() : HashMap
      {
         makeData();
         return _normalMap;
      }
      
      public static function get superMap() : HashMap
      {
         makeData();
         return _superMap;
      }
      
      public static function get specialSupMap() : HashMap
      {
         makeData();
         return _specialSupMap;
      }
      
      public static function get specialNorMap() : HashMap
      {
         makeData();
         return _specialNorMap;
      }
      
      public static function addIcon() : void
      {
         _icon = TaskIconManager.getIcon("TaskMainIcon") as MovieClip;
         _so = SOManager.getUserSO(SOManager.TASK_RECORD);
         if(!_so.data.hasOwnProperty("isShow"))
         {
            _so.data["isShow"] = false;
            SOManager.flush(_so);
         }
         else if(_so.data["isShow"] == true)
         {
            _icon["mc"].gotoAndStop(1);
            _icon["mc"].visible = false;
         }
         TaskIconManager.addIcon(_icon);
         ToolTipManager.add(_icon,"赛尔任务档案");
         _icon.addEventListener(MouseEvent.CLICK,onIconClickHandler);
      }
      
      private static function onIconClickHandler(_arg_1:MouseEvent) : void
      {
         if(!TasksManager.isComNoviceTask())
         {
            Alarm.show("您还没有做完新船员任务，快去" + TextFormatUtil.getRedTxt("机械室") + "找" + TextFormatUtil.getRedTxt("茜茜吧！"));
         }
         else
         {
            _so.data["isShow"] = true;
            SOManager.flush(_so);
            _icon["mc"].gotoAndStop(1);
            _icon["mc"].visible = false;
            showListPanel();
         }
      }
      
      public static function showListPanel() : void
      {
         if(!_taskMainPanel)
         {
            _taskMainPanel = new AppModel(ClientConfig.getAppModule("TasksRecordPanel"),"正在打开");
            _taskMainPanel.setup();
         }
         _taskMainPanel.show();
      }
   }
}

