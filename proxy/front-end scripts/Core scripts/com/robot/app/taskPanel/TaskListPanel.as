package com.robot.app.taskPanel
{
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.NpcTaskInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class TaskListPanel extends Sprite
   {
      
      private static const PATH:String = "com.robot.app.task.control";
      
      private var _info:NpcTaskInfo;
      
      private var npcType:String;
      
      private var bgMC:Sprite;
      
      private var closeBtn:SimpleButton;
      
      private var itemContainer:Sprite;
      
      private var npcIcon:Sprite;
      
      private var listArray:Array = [];
      
      private var npcModel:NpcModel;
      
      public function TaskListPanel()
      {
         super();
         this.bgMC = CoreAssetsManager.getSprite("ui_TaskListPanel");
         addChild(this.bgMC);
         this.closeBtn = this.bgMC["closeBtn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.npcIcon = new Sprite();
         this.npcIcon.x = 37;
         this.npcIcon.y = 65;
         this.itemContainer = new Sprite();
         this.itemContainer.x = 170;
         this.itemContainer.y = 78;
         this.bgMC.addChild(this.itemContainer);
         this.bgMC.addChild(this.npcIcon);
      }
      
      public function show() : void
      {
         if(this._info.acceptList.length == 1)
         {
            return;
         }
         LevelManager.appLevel.addChild(this);
      }
      
      public function setInfo(model:NpcModel) : void
      {
         var count:uint = 0;
         var item:TaskListItem = null;
         var i:uint = 0;
         var proStr:String = null;
         var arr:Array = null;
         item = null;
         this.npcModel = model;
         this._info = model.taskInfo;
         this.npcType = model.type;
         if(this._info.acceptList.length == 1)
         {
            item = new TaskListItem(this._info.acceptList[0]);
            if(Boolean(this._info.relateIDs.containsKey(item.id)) || item.id == 4)
            {
               this.npcModel.dispatchEvent(new NpcEvent(NpcEvent.NPC_CLICK,this.npcModel,item.id));
            }
            else if(item.status == TasksManager.ALR_ACCEPT)
            {
               proStr = TasksXMLInfo.getProDes(item.id);
               arr = this.getNpcDialogArr(proStr);
               NpcDialog.show(NpcController.curNpc.npc.id,arr[0],arr[1]);
            }
            else if(TasksXMLInfo.getIsCondition(item.id))
            {
               if(TaskConditionManager.getConditionStep(item.id) == TaskConditionManager.NPC_CLICK)
               {
                  if(TaskConditionManager.conditionTask(item.id,this.npcModel.type))
                  {
                     this.showTaskDes(item.id);
                  }
               }
               else
               {
                  this.showTaskDes(item.id);
               }
            }
            else
            {
               this.showTaskDes(item.id);
            }
            return;
         }
         this.clearOld();
         DisplayUtil.removeAllChild(this.itemContainer);
         DisplayUtil.removeAllChild(this.npcIcon);
         ResourceManager.getResource(ClientConfig.getNpcSwfPath(model.type),function(_arg_1:DisplayObject):void
         {
            _arg_1.scaleY = 0.6;
            _arg_1.scaleX = 0.6;
            npcIcon.addChild(_arg_1);
         },"npc");
         this.bgMC["npcNameTxt"].text = model.name;
         count = 0;
         for each(i in this._info.acceptList)
         {
            item = new TaskListItem(i);
            item.buttonMode = true;
            item.y = (item.height + 5) * count;
            item.addEventListener(MouseEvent.CLICK,this.showTaskAlert);
            this.itemContainer.addChild(item);
            this.listArray.push(item);
            count++;
         }
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function showTaskAlert(_arg_1:MouseEvent) : void
      {
         var _local_2:String = null;
         var _local_3:Array = null;
         var _local_4:TaskListItem = _arg_1.currentTarget as TaskListItem;
         this.hide();
         if(Boolean(this._info.relateIDs.containsKey(_local_4.id)) || _local_4.id == 4)
         {
            this.npcModel.dispatchEvent(new NpcEvent(NpcEvent.NPC_CLICK,this.npcModel,_local_4.id));
         }
         else if(_local_4.status == TasksManager.ALR_ACCEPT)
         {
            _local_2 = TasksXMLInfo.getProDes(_local_4.id);
            _local_3 = this.getNpcDialogArr(_local_2);
            NpcDialog.show(NpcController.curNpc.npc.id,_local_3[0],_local_3[1]);
         }
         else if(TasksXMLInfo.getIsCondition(_local_4.id))
         {
            if(TaskConditionManager.getConditionStep(_local_4.id) == TaskConditionManager.NPC_CLICK)
            {
               if(TaskConditionManager.conditionTask(_local_4.id,this.npcModel.type))
               {
                  this.showTaskDes(_local_4.id);
               }
            }
            else
            {
               this.showTaskDes(_local_4.id);
            }
         }
         else
         {
            this.showTaskDes(_local_4.id);
         }
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function clearOld() : void
      {
         var _local_1:TaskListItem = null;
         for each(_local_1 in this.listArray)
         {
            _local_1.removeEventListener(MouseEvent.CLICK,this.showTaskAlert);
         }
         this.listArray = [];
      }
      
      private function showTaskDes(id:uint) : void
      {
         var name:String = null;
         var array:Array = null;
         array = null;
         var showStep:Function = function():void
         {
            var reg:RegExp = null;
            var str:String = null;
            var npcID:uint = 0;
            var arr:Array = null;
            var npcStr:String = null;
            var eArr:Array = null;
            if(array.length > 1)
            {
               reg = /&[0-9]*&/;
               str = array.shift().toString();
               npcID = uint(NPC.SHIPER);
               if(str.search(reg) != -1)
               {
                  npcStr = str.match(reg)[0];
                  npcID = uint(npcStr.substring(1,npcStr.length - 1));
                  str = str.replace(reg,"");
               }
               else
               {
                  npcID = uint(NpcController.curNpc.npc.id);
               }
               arr = getNpcDialogArr(str);
               NpcDialog.show(npcID,arr[0],arr[1],[function():void
               {
                  showStep();
               }]);
            }
            else
            {
               eArr = getNpcDialogArr(array.shift().toString());
               NpcDialog.show(NpcController.curNpc.npc.id,eArr[0],eArr[1],[function():void
               {
                  if(checkCondition(id))
                  {
                     TasksManager.accept(id,function(_arg_1:Boolean):void
                     {
                        var _local_2:* = undefined;
                        if(_arg_1)
                        {
                           TasksManager.setTaskStatus(id,TasksManager.ALR_ACCEPT);
                           NpcController.refreshTaskInfo();
                           _local_2 = getDefinitionByName(PATH + "::TaskController_" + id);
                           _local_2.start();
                        }
                        else
                        {
                           Alarm.show("接受任务失败，请稍后再试！");
                        }
                     });
                  }
               }]);
            }
         };
         if(TasksXMLInfo.getEspecial(id))
         {
            NpcTaskManager.dispatchEvent(new Event(id.toString()));
            return;
         }
         name = TasksXMLInfo.getName(id);
         array = TasksXMLInfo.getTaskDes(id).split("$$");
         if(TasksXMLInfo.getTaskDes(id) == "")
         {
            this.npcModel.dispatchEvent(new NpcEvent(NpcEvent.TASK_WITHOUT_DES,this.npcModel,id));
            return;
         }
         showStep();
      }
      
      private function getNpcDialogArr(_arg_1:String) : Array
      {
         var _local_2:Array = _arg_1.split("@");
         var _local_3:Array = [];
         var _local_4:Array = [];
         _local_3.push(_local_2[0]);
         _local_4.push(_local_2[1]);
         if(Boolean(_local_2[2]))
         {
            _local_4.push(_local_2[2]);
         }
         return [_local_3,_local_4];
      }
      
      private function checkCondition(_arg_1:uint) : Boolean
      {
         if(TasksXMLInfo.getIsCondition(_arg_1))
         {
            if(TaskConditionManager.getConditionStep(_arg_1) == TaskConditionManager.BEFOR_ACCEPT)
            {
               return TaskConditionManager.conditionTask(_arg_1,this.npcModel.type);
            }
            return true;
         }
         return true;
      }
   }
}

