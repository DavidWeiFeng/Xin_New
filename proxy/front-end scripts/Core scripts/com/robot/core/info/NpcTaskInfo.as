package com.robot.core.info
{
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.NpcModel;
   import flash.events.*;
   import org.taomee.ds.*;
   
   [Event(name="showYellowQuestion",type="com.robot.core.taskSys.TaskInfo")]
   [Event(name="showBlueQuestion",type="com.robot.core.taskSys.TaskInfo")]
   [Event(name="showYellowExcal",type="com.robot.core.taskSys.TaskInfo")]
   public class NpcTaskInfo extends EventDispatcher
   {
      
      public static const SHOW_YELLOW_QUESTION:String = "showYellowQuestion";
      
      public static const SHOW_BLUE_QUESTION:String = "showBlueQuestion";
      
      public static const SHOW_YELLOW_EXCAL:String = "showYellowExcal";
      
      private var tasks:Array = [];
      
      private var _acceptList:Array = [];
      
      private var endIDs:Array = [];
      
      private var proIDs:Array = [];
      
      private var canCompleteIDs:Array = [];
      
      private var model:NpcModel;
      
      private var alAcceptIDs:Array = [];
      
      private var alAcceptIndex:uint;
      
      private var _isRelate:Boolean;
      
      private var _relateIDs:HashMap = new HashMap();
      
      private var queueNum:uint = 0;
      
      private var isQueue:Boolean = false;
      
      public function NpcTaskInfo(_arg_1:Array, _arg_2:Array, _arg_3:Array, _arg_4:NpcModel)
      {
         super();
         this.model = _arg_4;
         this.tasks = _arg_1.slice();
         this.endIDs = _arg_2.slice();
         this.proIDs = _arg_3.slice();
         this.alAcceptIndex = 0;
         this.canCompleteIDs = [];
      }
      
      public function refresh() : void
      {
         ++this.queueNum;
         this.checkQueue();
      }
      
      private function checkQueue() : void
      {
         if(this.queueNum > 0 && !this.isQueue)
         {
            this.isQueue = true;
            --this.queueNum;
            this.alAcceptIndex = 0;
            this.canCompleteIDs = [];
            this._acceptList = [];
            this.alAcceptIDs = [];
            this._relateIDs = new HashMap();
            this.checkTaskStatus();
         }
      }
      
      public function destroy() : void
      {
         this.model = null;
      }
      
      public function checkTaskStatus() : void
      {
         var _local_1:uint = 0;
         var _local_2:int = 0;
         this.initAcceptList();
         this._isRelate = false;
         if(this.proIDs.indexOf(0) != -1 && TasksManager.getTaskStatus(4) != TasksManager.COMPLETE)
         {
            this._relateIDs.add(4,4);
            this._isRelate = true;
         }
         else
         {
            _local_1 = 1;
            while(_local_1 < TasksManager.taskList.length + 1)
            {
               if(TasksManager.getTaskStatus(_local_1) == TasksManager.ALR_ACCEPT)
               {
                  _local_2 = int(this.proIDs.indexOf(_local_1));
                  if(_local_2 != -1 || _local_1 <= 4)
                  {
                     this._relateIDs.add(_local_1,_local_1);
                     this._isRelate = true;
                  }
               }
               _local_1++;
            }
         }
         for each(_local_1 in this.tasks)
         {
            if(TasksManager.getTaskStatus(_local_1) == TasksManager.COMPLETE)
            {
               _local_2 = int(this.tasks.indexOf(_local_1));
               if(_local_2 != -1)
               {
                  this.tasks.splice(_local_2,1);
               }
            }
         }
         for each(_local_1 in this.endIDs)
         {
            if(TasksManager.getTaskStatus(_local_1) == TasksManager.ALR_ACCEPT)
            {
               this.alAcceptIDs.push(_local_1);
            }
         }
         if(this.alAcceptIDs.length > 0)
         {
            this.checkAlrAcceptProStatus();
         }
         else
         {
            if(this._acceptList.length > 0)
            {
               this.showYellowExcalMark();
            }
            this.isQueue = false;
            this.checkQueue();
         }
      }
      
      private function checkAlrAcceptProStatus() : void
      {
         if(this.alAcceptIndex == this.alAcceptIDs.length)
         {
            this.onCheckAlrAcceptTask();
            this.isQueue = false;
            this.checkQueue();
            return;
         }
         var _local_1:uint = uint(this.alAcceptIDs[this.alAcceptIndex]);
         TasksManager.getProStatusList(_local_1,this.onGetBuff);
      }
      
      private function onGetBuff(_arg_1:Array) : void
      {
         var _local_2:Boolean = false;
         var _local_3:uint = uint(this.alAcceptIDs[this.alAcceptIndex]);
         _arg_1.pop();
         var _local_4:Boolean = true;
         for each(_local_2 in _arg_1)
         {
            if(_local_2 == false)
            {
               _local_4 = false;
               break;
            }
         }
         if(_local_4 && _local_3 != 25)
         {
            this.canCompleteIDs.push(_local_3);
         }
         ++this.alAcceptIndex;
         this.checkAlrAcceptProStatus();
      }
      
      private function onCheckAlrAcceptTask() : void
      {
         if(this.canCompleteIDs.length > 0)
         {
            this.showYellowQuestionMark();
         }
         else
         {
            this.showBlueQuestionMark();
         }
      }
      
      private function initAcceptList() : void
      {
         var _local_1:uint = 0;
         var _local_2:Array = null;
         var _local_3:Boolean = false;
         var _local_4:uint = 0;
         this._acceptList = [];
         for each(_local_1 in this.tasks)
         {
            if(TasksManager.getTaskStatus(_local_1) != TasksManager.COMPLETE)
            {
               _local_2 = TasksXMLInfo.getParent(_local_1);
               _local_3 = true;
               for each(_local_4 in _local_2)
               {
                  if(TasksManager.getTaskStatus(_local_4) != TasksManager.COMPLETE)
                  {
                     _local_3 = false;
                     break;
                  }
               }
               if(_local_3)
               {
                  this._acceptList.push(_local_1);
               }
            }
         }
      }
      
      private function getNpcIndex(_arg_1:uint) : uint
      {
         var _local_2:uint = 0;
         switch(_arg_1)
         {
            case 1:
               _local_2 = 0;
               break;
            case 2:
               _local_2 = 5;
               break;
            case 3:
               _local_2 = 2;
               break;
            case 4:
               _local_2 = 6;
               break;
            case 5:
               _local_2 = 1;
               break;
            case 6:
               _local_2 = 4;
               break;
            case 8:
               _local_2 = 7;
               break;
            case 10:
               _local_2 = 3;
               break;
            default:
               _local_2 = 9;
         }
         return _local_2;
      }
      
      private function showYellowExcalMark() : void
      {
         if(!this.isQueue || this.queueNum == 0)
         {
            dispatchEvent(new Event(SHOW_YELLOW_EXCAL));
         }
      }
      
      private function showYellowQuestionMark() : void
      {
         if(!this.isQueue || this.queueNum == 0)
         {
            dispatchEvent(new Event(SHOW_YELLOW_QUESTION));
         }
      }
      
      private function showBlueQuestionMark() : void
      {
         if(!this.isQueue || this.queueNum == 0)
         {
            dispatchEvent(new Event(SHOW_BLUE_QUESTION));
         }
      }
      
      public function get taskIDList() : Array
      {
         return this.tasks;
      }
      
      public function get acceptList() : Array
      {
         var _local_1:uint = 0;
         var _local_2:Array = this._acceptList.slice();
         for each(_local_1 in this.proIDs)
         {
            if(TasksManager.getTaskStatus(_local_1) == TasksManager.ALR_ACCEPT)
            {
               if(_local_1 == 1 || _local_1 == 2 || _local_1 == 3 || _local_1 == 4)
               {
                  _local_1 = 4;
               }
               if(_local_2.indexOf(_local_1) == -1)
               {
                  _local_2.push(_local_1);
               }
            }
         }
         return _local_2;
      }
      
      public function get proList() : Array
      {
         return this.proIDs;
      }
      
      public function get completeList() : Array
      {
         return this.canCompleteIDs;
      }
      
      public function get alreadAcceptList() : Array
      {
         return this.alAcceptIDs;
      }
      
      public function get isRelateTask() : Boolean
      {
         return this._isRelate;
      }
      
      public function get relateIDs() : HashMap
      {
         return this._relateIDs;
      }
   }
}

