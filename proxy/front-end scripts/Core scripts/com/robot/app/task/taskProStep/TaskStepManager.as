package com.robot.app.task.taskProStep
{
   import com.robot.app.fightNote.*;
   import com.robot.app.task.control.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.app.tasksRecord.*;
   import com.robot.core.animate.*;
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.*;
   import com.robot.core.mode.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import org.taomee.ds.*;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.*;
   
   public class TaskStepManager
   {
      
      private static var panel:AppModel;
      
      public static var taskStepMap:HashMap = new HashMap();
      
      public static var stepMap:HashMap = new HashMap();
      
      public static var optionID:uint = 0;
      
      private static var taskList:Array = [];
      
      private static var PATH:String = "resource/task/xml/task_";
      
      private static var taskCnt:uint = 0;
      
      private static var taskMapList:Array = [];
      
      private static var count:uint = 0;
      
      private static var isNowAccept:Boolean = false;
      
      public function TaskStepManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _local_1:uint = 0;
         var _local_2:uint = 0;
         var _local_3:Array = [];
         for each(_local_1 in TasksRecordConfig.getAllTasksId())
         {
            if(!TasksRecordConfig.getTaskOffLineForId(_local_1))
            {
               _local_3.push(_local_1);
            }
         }
         for each(_local_2 in _local_3)
         {
            if(TasksManager.getTaskStatus(_local_2) == TasksManager.ALR_ACCEPT)
            {
               loadTaskStepXml(_local_2);
               taskList.push(_local_2);
            }
         }
      }
      
      public static function addTaskStepMap(_arg_1:uint, _arg_2:XML) : void
      {
         taskStepMap.add(_arg_1,_arg_2);
      }
      
      public static function removeTaskStepMap(_arg_1:uint) : void
      {
         taskStepMap.remove(_arg_1);
      }
      
      public static function loadTaskStepXml(_arg_1:uint, _arg_2:Boolean = false) : void
      {
         var _local_3:String = PATH + _arg_1 + ".xml";
         var _local_4:URLRequest = new URLRequest(_local_3);
         var _local_5:URLLoader = new URLLoader();
         _local_5.addEventListener(Event.COMPLETE,onLoadedXML(_arg_1));
         _local_5.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         _local_5.load(_local_4);
         isNowAccept = _arg_2;
      }
      
      private static function onLoadedXML(taskID:uint) : Function
      {
         var func:Function = function(_arg_1:Event):void
         {
            var _local_2:URLLoader = _arg_1.currentTarget as URLLoader;
            var _local_3:XML = XML(_local_2.data);
            if(!taskStepMap.containsKey(taskID))
            {
               taskStepMap.add(taskID,_local_3);
            }
            ++taskCnt;
            if(isNowAccept)
            {
               setupTask();
            }
            else if(taskCnt == taskList.length)
            {
               setupTask();
               taskCnt = 0;
            }
         };
         return func;
      }
      
      private static function onIOError(_arg_1:IOErrorEvent) : void
      {
         throw new Error(_arg_1.text);
      }
      
      private static function setupTask() : void
      {
         var tasksArr:Array = null;
         var index:uint = 0;
         tasksArr = null;
         index = 0;
         var addTaskStepInfo:Function = function(id:uint):void
         {
            TasksManager.getProStatusList(id,function(_arg_1:Array):void
            {
               var _local_2:uint = 0;
               var _local_3:uint = 0;
               var _local_4:XML = null;
               var _local_5:TaskStepInfo = null;
               while(_local_2 < _arg_1.length)
               {
                  if(_arg_1[_local_2] == false)
                  {
                     TaskStepXMLInfo.setup(taskStepMap.getValue(id));
                     _local_3 = TaskStepXMLInfo.getProMapID(_local_2);
                     _local_4 = TaskStepXMLInfo.getStepXML(_local_2,0);
                     _local_5 = new TaskStepInfo(id,_local_2,_local_3,_local_4);
                     if(!stepMap.containsKey(id))
                     {
                        stepMap.add(id,_local_5);
                     }
                     ++count;
                     if(count == taskList.length)
                     {
                        MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onChangeMap);
                        count = 0;
                     }
                     ++index;
                     if(index == tasksArr.length)
                     {
                        return;
                     }
                     addTaskStepInfo(tasksArr[index]);
                     if(_local_3 == 0 || _local_4 == null)
                     {
                     }
                     return;
                  }
                  _local_2++;
               }
            });
         };
         tasksArr = taskStepMap.getKeys();
         index = 0;
         if(taskStepMap.length > 0)
         {
            addTaskStepInfo(tasksArr[index]);
         }
      }
      
      private static function onChangeMap(_arg_1:MapEvent) : void
      {
         var _local_2:TaskStepInfo = null;
         var _local_3:uint = uint(_arg_1.mapModel.id);
         for each(_local_2 in stepMap.getValues())
         {
            if(_local_3 == _local_2.mapID)
            {
               startDoTask(_local_2);
            }
         }
      }
      
      public static function doTaskProStep(_arg_1:uint, _arg_2:uint, _arg_3:uint) : void
      {
         TaskStepXMLInfo.setup(taskStepMap.getValue(_arg_1));
         var _local_4:uint = TaskStepXMLInfo.getProMapID(_arg_2);
         var _local_5:XML = TaskStepXMLInfo.getStepXML(_arg_2,_arg_3);
         var _local_6:TaskStepInfo = new TaskStepInfo(_arg_1,_arg_2,_local_4,_local_5);
         startDoTask(_local_6);
      }
      
      private static function startDoTask(_arg_1:TaskStepInfo) : void
      {
         TaskStepXMLInfo.setup(taskStepMap.getValue(_arg_1.taskID));
         var _local_2:XML = TaskStepXMLInfo.getStepXML(_arg_1.pro,_arg_1.stepID);
         switch(_arg_1.stepType)
         {
            case 0:
               chooseOptions(_arg_1);
               return;
            case 1:
               talkWithNpc(_arg_1);
               return;
            case 2:
               playSceenMovie(_arg_1);
               return;
            case 3:
               playFullMovie(_arg_1);
               return;
            case 4:
               game(_arg_1);
               return;
            case 5:
               fight(_arg_1);
               return;
            case 6:
               showPanel(_arg_1);
               return;
            case 7:
               mcAction(_arg_1);
         }
      }
      
      private static function chooseOptions(_arg_1:TaskStepInfo) : void
      {
         TaskStepXMLInfo.setup(taskStepMap.getValue(_arg_1.taskID));
         var _local_2:uint = TaskStepXMLInfo.getStepOptionCnt(_arg_1.pro,_arg_1.stepID);
         var _local_3:Array = TaskStepXMLInfo.getStepOptionGoto(_arg_1.pro,_arg_1.stepID,optionID);
         var _local_4:String = TaskStepXMLInfo.getStepOptionDes(_arg_1.pro,_arg_1.stepID,optionID);
         var _local_5:uint = uint(_local_3[0]);
         var _local_6:uint = uint(_local_3[1]);
         var _local_7:XML = TaskStepXMLInfo.getStepXML(_local_5,_local_6);
         var _local_8:uint = TaskStepXMLInfo.getProMapID(_local_5);
         var _local_9:TaskStepInfo = new TaskStepInfo(_arg_1.taskID,_local_5,_local_8,_local_7);
         startDoTask(_local_9);
      }
      
      private static function talkWithNpc(info:TaskStepInfo) : void
      {
         var talkMcName:String = null;
         var talkMc:MovieClip = null;
         var npcName:String = null;
         var array:Array = null;
         var func:String = null;
         npcName = null;
         array = null;
         func = null;
         var showStep:Function = function():void
         {
            var reg:RegExp = null;
            var str:String = null;
            var npcStr:String = null;
            var tempstr:String = null;
            if(array.length > 1)
            {
               reg = /&[a-zA-Z][a-zA-Z0-9_]*&/;
               str = array.shift().toString();
               if(str.search(reg) != -1)
               {
                  npcStr = str.match(reg)[0].toString();
                  tempstr = str.replace(reg,"");
                  NpcTipDialog.show(tempstr,function():void
                  {
                     showStep();
                  },npcStr.substring(1,npcStr.length - 1));
               }
               else
               {
                  NpcTipDialog.show(str,function():void
                  {
                     showStep();
                  },npcName);
               }
            }
            else
            {
               NpcTipDialog.show(array.shift().toString(),function():void
               {
                  checkStep(info,func);
               },npcName);
            }
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         npcName = TaskStepXMLInfo.getStepTalkNpc(info.pro,info.stepID);
         talkMcName = TaskStepXMLInfo.getStepTalkMC(info.pro,info.stepID);
         talkMc = MapManager.currentMap.depthLevel.getChildByName(talkMcName) as MovieClip;
         array = TaskStepXMLInfo.getStepTalkDes(info.pro,info.stepID).split("$$");
         func = TaskStepXMLInfo.getStepTalkFunc(info.pro,info.stepID);
         if(Boolean(talkMc))
         {
            talkMc.buttonMode = true;
            talkMc.addEventListener(MouseEvent.CLICK,function(_arg_1:MouseEvent):void
            {
               showStep();
            });
         }
         else
         {
            showStep();
         }
      }
      
      private static function playSceenMovie(info:TaskStepInfo) : void
      {
         var sparkMC:MovieClip = null;
         var sceneMC:MovieClip = null;
         var frame:uint = 0;
         var childMcName:String = null;
         var func:String = null;
         sparkMC = null;
         sceneMC = null;
         frame = 0;
         childMcName = null;
         func = null;
         var next:Function = function():void
         {
            checkStep(info,func);
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         sparkMC = MapManager.currentMap.controlLevel.getChildByName(TaskStepXMLInfo.getStepSmSparkMC(info.pro,info.stepID)) as MovieClip;
         sceneMC = MapManager.currentMap.animatorLevel.getChildByName(TaskStepXMLInfo.getStepSmPlaySceenMC(info.pro,info.stepID)) as MovieClip;
         frame = TaskStepXMLInfo.getStepSmPlayMcFrame(info.pro,info.stepID);
         childMcName = TaskStepXMLInfo.getStepSmPlayMcChild(info.pro,info.stepID);
         func = TaskStepXMLInfo.getStepSmFunc(info.pro,info.stepID);
         if(Boolean(sparkMC))
         {
            sparkMC.buttonMode = true;
            sparkMC.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent):void
            {
               sparkMC.buttonMode = false;
               sparkMC.removeEventListener(MouseEvent.CLICK,arguments.callee);
               if(sceneMC != null && frame != 0)
               {
                  AnimateManager.playMcAnimate(sceneMC,frame,childMcName,function():void
                  {
                     next();
                  });
               }
            });
         }
         else if(sceneMC != null && frame != 0)
         {
            if(childMcName != "" && childMcName != null)
            {
               AnimateManager.playMcAnimate(sceneMC,frame,childMcName,function():void
               {
                  next();
               });
            }
            else
            {
               sceneMC.gotoAndStop(frame);
               next();
            }
         }
      }
      
      private static function playFullMovie(info:TaskStepInfo) : void
      {
         var sparkMC:MovieClip = null;
         var swfUrl:String = null;
         var func:String = null;
         swfUrl = null;
         func = null;
         var playMC:Function = function():void
         {
            AnimateManager.playFullScreenAnimate(swfUrl,function():void
            {
               checkStep(info,func);
            });
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         sparkMC = MapManager.currentMap.controlLevel.getChildByName(TaskStepXMLInfo.getStepSmSparkMC(info.pro,info.stepID)) as MovieClip;
         swfUrl = TaskStepXMLInfo.getStepFullMovieUrl(info.pro,info.stepID);
         func = TaskStepXMLInfo.getStepFmFunc(info.pro,info.stepID);
         if(Boolean(sparkMC))
         {
            sparkMC.buttonMode = true;
            sparkMC.addEventListener(MouseEvent.CLICK,function(_arg_1:MouseEvent):void
            {
               playMC();
            });
         }
         else
         {
            playMC();
         }
      }
      
      private static function game(info:TaskStepInfo) : void
      {
         var sparkMC:MovieClip = null;
         var gameUrl:String = null;
         var gamePassFunc:String = null;
         var gameLossFunc:String = null;
         sparkMC = null;
         gameUrl = null;
         gamePassFunc = null;
         gameLossFunc = null;
         var playGame:Function = function():void
         {
            GamePlatformManager.join(gameUrl,false);
            GamePlatformManager.addEventListener(GamePlatformEvent.GAME_WIN,function(evt:GamePlatformEvent):void
            {
               var _local_4:* = undefined;
               GamePlatformManager.removeEventListener(GamePlatformEvent.GAME_WIN,arguments.callee);
               try
               {
                  _local_4 = MapProcessConfig.currentProcessInstance;
                  _local_4[gamePassFunc]();
               }
               catch(e:Error)
               {
                  throw new Error("找不到函数!");
               }
            });
            GamePlatformManager.addEventListener(GamePlatformEvent.GAME_LOST,function(evt:GamePlatformEvent):void
            {
               var _local_4:* = undefined;
               GamePlatformManager.removeEventListener(GamePlatformEvent.GAME_LOST,arguments.callee);
               try
               {
                  _local_4 = MapProcessConfig.currentProcessInstance;
                  _local_4[gameLossFunc]();
               }
               catch(e:Error)
               {
                  throw new Error("找不到函数!");
               }
            });
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         sparkMC = MapManager.currentMap.controlLevel.getChildByName(TaskStepXMLInfo.getStepGmSparkMC(info.pro,info.stepID)) as MovieClip;
         gameUrl = TaskStepXMLInfo.getStepGameUrl(info.pro,info.stepID);
         gamePassFunc = TaskStepXMLInfo.getStepGamePassFunc(info.pro,info.stepID);
         gameLossFunc = TaskStepXMLInfo.getStepGameLossFunc(info.pro,info.stepID);
         if(Boolean(sparkMC))
         {
            sparkMC.buttonMode = true;
            sparkMC.addEventListener(MouseEvent.CLICK,function(_arg_1:MouseEvent):void
            {
               sparkMC.buttonMode = false;
               sparkMC.removeEventListener(MouseEvent.CLICK,arguments.callee);
               playGame();
            });
         }
         else
         {
            playGame();
         }
      }
      
      private static function fight(info:TaskStepInfo) : void
      {
         var sparkMC:MovieClip = null;
         var bossName:String = null;
         var bossID:uint = 0;
         var fightSucsFunc:String = null;
         var fightLossFunc:String = null;
         bossName = null;
         bossID = 0;
         fightSucsFunc = null;
         fightLossFunc = null;
         var fightBoss:Function = function():void
         {
            FightInviteManager.fightWithBoss(bossName,bossID);
            EventManager.addEventListener(PetFightEvent.FIGHT_RESULT,function(evt:PetFightEvent):void
            {
               var fightData:FightOverInfo = null;
               var _local_4:* = undefined;
               EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,arguments.callee);
               fightData = evt.dataObj["data"];
               if(fightData.winnerID == MainManager.actorInfo.userID)
               {
                  try
                  {
                     _local_4 = MapProcessConfig.currentProcessInstance;
                     _local_4[fightSucsFunc]();
                  }
                  catch(e:Error)
                  {
                     throw new Error("找不到函数!");
                  }
               }
               else
               {
                  try
                  {
                     _local_4 = MapProcessConfig.currentProcessInstance;
                     _local_4[fightLossFunc]();
                  }
                  catch(e:Error)
                  {
                     throw new Error("找不到函数!");
                  }
               }
            });
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         sparkMC = MapManager.currentMap.controlLevel.getChildByName(TaskStepXMLInfo.getStepFtSparkMC(info.pro,info.stepID)) as MovieClip;
         bossName = TaskStepXMLInfo.getStepFtBossName(info.pro,info.stepID);
         bossID = TaskStepXMLInfo.getStepFtBossID(info.pro,info.stepID);
         fightSucsFunc = TaskStepXMLInfo.getStepFtSuccessFunc(info.pro,info.stepID);
         fightLossFunc = TaskStepXMLInfo.getStepFtLossFunc(info.pro,info.stepID);
      }
      
      private static function showPanel(info:TaskStepInfo) : void
      {
         var sparkMC:MovieClip = null;
         var className:String = null;
         var func:String = null;
         sparkMC = null;
         className = null;
         func = null;
         var show:Function = function():void
         {
            var showComplete:Function = null;
            var showPause:Function = null;
            showComplete = null;
            showPause = null;
            showComplete = function(_arg_1:DynamicEvent):void
            {
               EventManager.removeEventListener(TasksController.TASKPANEL_SHOW_COMPLETE,showComplete);
               checkStep(info,func);
            };
            showPause = function(_arg_1:DynamicEvent):void
            {
               EventManager.removeEventListener(TasksController.TASKPANEL_SHOW_PAUSE,showPause);
               doTaskProStep(info.taskID,info.pro,info.stepID);
            };
            if(Boolean(panel))
            {
               panel.destroy();
               panel = null;
            }
            panel = new AppModel(ClientConfig.getTaskModule(className),"正在加载面板");
            panel.setup();
            panel.show();
            EventManager.removeEventListener(TasksController.TASKPANEL_SHOW_COMPLETE,showComplete);
            EventManager.removeEventListener(TasksController.TASKPANEL_SHOW_PAUSE,showPause);
            EventManager.addEventListener(TasksController.TASKPANEL_SHOW_COMPLETE,showComplete);
            EventManager.addEventListener(TasksController.TASKPANEL_SHOW_PAUSE,showPause);
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         sparkMC = MapManager.currentMap.controlLevel.getChildByName(TaskStepXMLInfo.getStepPanelSparkMC(info.pro,info.stepID)) as MovieClip;
         className = TaskStepXMLInfo.getStepPanelClass(info.pro,info.stepID);
         func = TaskStepXMLInfo.getStepPanelFunc(info.pro,info.stepID);
         if(Boolean(sparkMC))
         {
            sparkMC.buttonMode = true;
            sparkMC.addEventListener(MouseEvent.CLICK,function(_arg_1:MouseEvent):void
            {
               sparkMC.buttonMode = false;
               sparkMC.removeEventListener(MouseEvent.CLICK,arguments.callee);
               show();
            });
         }
         else
         {
            show();
         }
      }
      
      private static function mcAction(_arg_1:TaskStepInfo) : void
      {
         var _local_2:MovieClip = null;
         TaskStepXMLInfo.setup(taskStepMap.getValue(_arg_1.taskID));
         var _local_3:uint = TaskStepXMLInfo.getStepMcType(_arg_1.pro,_arg_1.stepID);
         var _local_4:String = TaskStepXMLInfo.getStepMcName(_arg_1.pro,_arg_1.stepID);
         var _local_5:uint = TaskStepXMLInfo.getStepMcFrame(_arg_1.pro,_arg_1.stepID);
         var _local_6:String = TaskStepXMLInfo.getStepMcFunc(_arg_1.pro,_arg_1.stepID);
         switch(_local_3)
         {
            case 0:
               break;
            case 1:
               _local_2 = MapManager.currentMap.animatorLevel.getChildByName(_local_4) as MovieClip;
               break;
            case 2:
               _local_2 = MapManager.currentMap.controlLevel.getChildByName(_local_4) as MovieClip;
               break;
            case 3:
               _local_2 = MapManager.currentMap.depthLevel.getChildByName(_local_4) as MovieClip;
               break;
            case 4:
               _local_2 = MapManager.currentMap.btnLevel.getChildByName(_local_4) as MovieClip;
               break;
            case 5:
               _local_2 = MapManager.currentMap.spaceLevel.getChildByName(_local_4) as MovieClip;
               break;
            case 6:
               _local_2 = MapManager.currentMap.topLevel.getChildByName(_local_4) as MovieClip;
         }
         if(Boolean(_local_2))
         {
            _local_2.visible = TaskStepXMLInfo.getStepMcVisible(_arg_1.pro,_arg_1.stepID);
            if(_local_2.visible)
            {
               _local_2.gotoAndStop(_local_5);
            }
         }
         checkStep(_arg_1,_local_6);
      }
      
      private static function checkStep(info:TaskStepInfo, func:String = "") : void
      {
         var isCompletePro:Boolean = false;
         var taskPanelClose:Function = null;
         var _local_4:* = undefined;
         taskPanelClose = null;
         taskPanelClose = function(_arg_1:Event):void
         {
            EventManager.removeEventListener(TasksController.TASKPANEL_CLOSE,taskPanelClose);
            nextStep(info);
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         isCompletePro = TaskStepXMLInfo.getStepIsComplete(info.pro,info.stepID);
         if(isCompletePro)
         {
            TasksManager.complete(info.taskID,info.pro,function(_arg_1:Boolean):void
            {
               var _local_2:uint = 0;
               var _local_3:XML = null;
               var _local_4:TaskStepInfo = null;
               if(_arg_1)
               {
                  EventManager.removeEventListener(TasksController.TASKPANEL_CLOSE,taskPanelClose);
                  EventManager.addEventListener(TasksController.TASKPANEL_CLOSE,taskPanelClose);
                  _local_2 = TaskStepXMLInfo.getProMapID(_local_4.pro + 1);
                  _local_3 = TaskStepXMLInfo.getStepXML(_local_4.pro + 1,0);
                  _local_4 = new TaskStepInfo(_local_4.taskID,_local_4.pro + 1,_local_2,_local_3);
                  stepMap.add(_local_4.taskID,_local_4);
               }
            },true);
         }
         else if(func != "" && func != null)
         {
            try
            {
               _local_4 = MapProcessConfig.currentProcessInstance;
               _local_4[func]();
            }
            catch(e:Error)
            {
               throw new Error("找不到函数!");
            }
         }
         else
         {
            nextStep(info);
         }
      }
      
      private static function nextStep(_arg_1:TaskStepInfo) : void
      {
         var _local_2:uint = 0;
         TaskStepXMLInfo.setup(taskStepMap.getValue(_arg_1.taskID));
         var _local_3:Boolean = TaskStepXMLInfo.getStepIsComplete(_arg_1.pro,_arg_1.stepID);
         var _local_4:Array = TaskStepXMLInfo.getStepGoto(_arg_1.pro,_arg_1.stepID);
         var _local_5:uint = uint(_local_4[0]);
         var _local_6:uint = uint(_local_4[1]);
         var _local_7:XML = TaskStepXMLInfo.getStepXML(_local_5,_local_6);
         var _local_8:uint = TaskStepXMLInfo.getProMapID(_local_5);
         var _local_9:TaskStepInfo = new TaskStepInfo(_arg_1.taskID,_local_5,_local_8,_local_7);
         if(_arg_1.pro == TaskStepXMLInfo.proCnt - 1 && _local_3)
         {
            if(_arg_1.pro == _local_5 && _arg_1.stepID == _local_6)
            {
               stepMap.remove(_arg_1.taskID);
               taskStepMap.remove(_arg_1.taskID);
               _local_2 = 0;
               while(_local_2 < taskList.length)
               {
                  if(_arg_1.taskID == taskList[_local_2])
                  {
                     taskList.splice(_local_2,1);
                  }
                  _local_2++;
               }
            }
         }
         else
         {
            startDoTask(_local_9);
         }
      }
   }
}

