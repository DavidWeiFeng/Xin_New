package com.robot.app.spacesurvey
{
   import com.robot.app.task.control.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.utils.*;
   import org.taomee.utils.*;
   
   public class SpaceSurveyTool extends Sprite
   {
      
      private static var _instance:SpaceSurveyTool;
      
      private const PATH:String = "module/surveyPole/surveyPole.swf";
      
      private var mainMC:MovieClip;
      
      private var _surveyPoleBtn:SimpleButton;
      
      private var _spaceName:String;
      
      private var nonoSuit:MovieClip;
      
      private var normalNonoSound:Sound;
      
      private var superNonoSound:Sound;
      
      private var sc1:SoundChannel;
      
      private var dict:Dictionary = new Dictionary();
      
      public function SpaceSurveyTool()
      {
         super();
         this.dict["10"] = new Point(243,384);
         this.dict["105"] = new Point(296,368);
         this.dict["15"] = new Point(405,317);
         this.dict["20"] = new Point(492,434);
         this.dict["25"] = new Point(371,206);
         this.dict["30"] = new Point(605,462);
         this.dict["40"] = new Point(473,422);
         this.dict["47"] = new Point(450,483);
         this.dict["51"] = new Point(180,470);
         this.dict["54"] = new Point(445,310);
      }
      
      public static function getInstance() : SpaceSurveyTool
      {
         _instance = new SpaceSurveyTool();
         return _instance;
      }
      
      public function hide() : void
      {
         if(Boolean(this.mainMC))
         {
            this.mainMC.removeEventListener(MouseEvent.CLICK,this.onPoleBtnClickHandler);
            this.mainMC.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler("*"));
         }
         if(Boolean(this.nonoSuit))
         {
            this.nonoSuit.removeEventListener(Event.ENTER_FRAME,this.onNonoSuitFrameHandler);
         }
         DisplayUtil.removeForParent(_instance);
         _instance = null;
      }
      
      public function show(str:String) : void
      {
         this._spaceName = str;
         if(TasksManager.getTaskStatus(TaskController_37.TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            NonoManager.addEventListener(NonoEvent.GET_INFO,function(_arg_1:NonoEvent):void
            {
               NonoManager.removeEventListener(NonoEvent.GET_INFO,arguments.callee);
               if(Boolean(NonoManager.info.func[7]))
               {
                  loadUI();
               }
            });
            NonoManager.getInfo();
         }
      }
      
      private function loadUI() : void
      {
         var _local_1:String = ClientConfig.getResPath(this.PATH);
         var _local_2:MCLoader = new MCLoader(_local_1,LevelManager.appLevel,1,"正在加载测绘标杆");
         _local_2.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         _local_2.doLoad();
      }
      
      private function onLoadSuccess(_arg_1:MCLoadEvent) : void
      {
         var _local_2:MCLoader = _arg_1.currentTarget as MCLoader;
         _local_2.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         var _local_3:Class = _arg_1.getApplicationDomain().getDefinition("normalNonoSound") as Class;
         this.normalNonoSound = new _local_3() as Sound;
         var _local_4:Class = _arg_1.getApplicationDomain().getDefinition("superNonoSound") as Class;
         this.superNonoSound = new _local_4() as Sound;
         var _local_5:Class = _arg_1.getApplicationDomain().getDefinition("mainUI") as Class;
         this.mainMC = new _local_5() as MovieClip;
         this.mainMC.scaleX = 0.7;
         this.mainMC.scaleY = 0.7;
         this._surveyPoleBtn = this.mainMC["surveyPoleBtn"];
         _local_2.clear();
         this.init();
      }
      
      private function init() : void
      {
         var _local_1:Point = this.dict[MainManager.actorInfo.mapID.toString()];
         this.x = _local_1.x;
         this.y = _local_1.y;
         this.addChild(this.mainMC);
         MapManager.currentMap.depthLevel.addChild(_instance);
         this.mainMC.addEventListener(MouseEvent.CLICK,this.onPoleBtnClickHandler);
      }
      
      private function onPoleBtnClickHandler(event:MouseEvent) : void
      {
         if(Boolean(MainManager.actorModel.nono))
         {
            if(!NonoManager.info.func[7])
            {
               Alarm.show("你的NoNo还没有装载<font color=\'#ff0000\'>星球测绘芯片</font>哦！！");
               return;
            }
            NpcTipDialog.showAnswer("这是专业的星球测绘工具，你要立即开始星球勘察么？",function():void
            {
               MainManager.actorModel.hideNono();
               LevelManager.closeMouseEvent();
               if(NonoManager.info.superNono)
               {
                  mainMC.gotoAndStop(3);
                  superNonoSound.play(0,0);
                  mainMC.addEventListener(Event.ENTER_FRAME,onFrameHandler("superNono"));
               }
               else
               {
                  mainMC.gotoAndStop(2);
                  normalNonoSound.play(0,0);
                  mainMC.addEventListener(Event.ENTER_FRAME,onFrameHandler("normalNono"));
               }
            },null,NpcTipDialog.IRIS);
            LevelManager.closeMouseEvent();
            return;
         }
         Alarm.show("带上你的NoNo试试哦！");
      }
      
      private function onFrameHandler(mcName:String) : Function
      {
         var func:Function = null;
         func = function(_arg_1:Event):void
         {
            var _local_3:ColorTransform = null;
            if(Boolean(mainMC.getChildByName(mcName)))
            {
               nonoSuit = (mainMC.getChildByName(mcName) as MovieClip).getChildByName("nonoSuit") as MovieClip;
               _local_3 = nonoSuit.transform.colorTransform;
               _local_3.color = MainManager.actorInfo.nonoColor;
               nonoSuit.transform.colorTransform = _local_3;
               nonoSuit.addEventListener(Event.ENTER_FRAME,onNonoSuitFrameHandler);
               mainMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
            }
            var _local_4:Function = arguments.callee as Function;
         };
         return func;
      }
      
      private function onNonoSuitFrameHandler(event:Event) : void
      {
         var i:uint = 0;
         i = 0;
         if(this.nonoSuit.currentFrame == this.nonoSuit.totalFrames)
         {
            LevelManager.openMouseEvent();
            this.nonoSuit.removeEventListener(Event.ENTER_FRAME,this.onNonoSuitFrameHandler);
            this.nonoSuit = null;
            this.mainMC.gotoAndStop(1);
            MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
            i = 0;
            while(i < 10)
            {
               if(TasksXMLInfo.getProName(TaskController_37.TASK_ID,i) == this._spaceName)
               {
                  TasksManager.getProStatus(TaskController_37.TASK_ID,i,function(b:Boolean):void
                  {
                     if(!b)
                     {
                        TasksManager.setProStatus(TaskController_37.TASK_ID,i,true,function():void
                        {
                        });
                     }
                  });
                  SpaceSurveyResultController.show(this._spaceName);
                  break;
               }
               i++;
            }
            LevelManager.openMouseEvent();
         }
      }
   }
}

