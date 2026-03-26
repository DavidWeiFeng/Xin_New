package com.robot.core.mode
{
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.info.clothInfo.*;
   import com.robot.core.manager.*;
   import com.robot.core.npc.*;
   import com.robot.core.ui.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   [Event(name="npcClick",type="com.robot.core.event.NpcEvent")]
   [Event(name="taskWithoutDes",type="com.robot.core.event.NpcEvent")]
   public class NpcModel extends BasePeoleModel
   {
      
      private var _taskInfo:NpcTaskInfo;
      
      private var _npc:Sprite;
      
      private var clickPoint:Point;
      
      private var _npcHit:Sprite;
      
      private var questionMark:MovieClip;
      
      private var excalMark:MovieClip;
      
      private var _type:String;
      
      private var _id:uint;
      
      private var dialogList:Array;
      
      public var des:String;
      
      private var timer:Timer;
      
      private var _npcInfo:NpcInfo;
      
      private var diaUint:uint = 0;
      
      private var posList:Array;
      
      private var npcTimer:Timer;
      
      public function NpcModel(_arg_1:NpcInfo, _arg_2:Sprite)
      {
         var _local_4:String = null;
         var _local_5:UserInfo = null;
         var _local_3:uint = 0;
         this.dialogList = [];
         this.posList = [];
         for each(_local_4 in _arg_1.posList)
         {
            this.posList.push(new Point(int(_local_4.split(",")[0]),int(_local_4.split(",")[1])));
         }
         this._npcInfo = _arg_1;
         this._id = this._npcInfo.npcId;
         this._type = this._npcInfo.type;
         this._npc = _arg_2;
         this._npcHit = this._npc;
         this.des = this._npcInfo.dialogList[0];
         this.dialogList = this._npcInfo.bubbingList;
         this.questionMark = CoreAssetsManager.getMovieClip("lib_question_mark");
         this.excalMark = CoreAssetsManager.getMovieClip("lib_excalmatory_mark");
         this.setNpcTaskIDs(this._npcInfo.startIDs,this._npcInfo.endIDs,this._npcInfo.proIDs);
         _local_5 = new UserInfo();
         _local_5.nick = this._npcInfo.npcName;
         _local_5.direction = 3;
         if(this._npcInfo.clothIds.length == 0)
         {
            MapManager.currentMap.depthLevel.addChild(this._npc);
            this._npc.x = this._npcInfo.point.x;
            this._npc.y = this._npcInfo.point.y;
            DepthManager.swapDepthAll(MapManager.currentMap.depthLevel);
         }
         else
         {
            for each(_local_3 in this._npcInfo.clothIds)
            {
               _local_5.clothes.push(new PeopleItemInfo(_local_3));
            }
            _local_5.color = this._npcInfo.color;
         }
         this._npc.buttonMode = true;
         super(_local_5);
         this.initNpc();
         this._npc.addEventListener(MouseEvent.CLICK,this.clickNpc);
         this.initDialog();
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      private function initDialog() : void
      {
         var _local_1:DialogBox = null;
         this.timer = new Timer(9000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         if(this.dialogList.length > 0)
         {
            this.timer.start();
            if(this.diaUint == this.dialogList.length - 1)
            {
               this.diaUint = 0;
            }
            else
            {
               ++this.diaUint;
            }
            if(this.dialogList[this.diaUint] == "")
            {
               return;
            }
            _local_1 = new DialogBox();
            _local_1.show(this.dialogList[this.diaUint],0,-100,this._npc);
         }
      }
      
      private function onTimer(_arg_1:TimerEvent) : void
      {
         if(this.diaUint == this.dialogList.length - 1)
         {
            this.diaUint = 0;
         }
         else
         {
            ++this.diaUint;
         }
         if(this.dialogList[this.diaUint] == "")
         {
            return;
         }
         var _local_2:DialogBox = new DialogBox();
         _local_2.show(this.dialogList[this.diaUint],0,-100,this._npc);
      }
      
      public function refreshTask() : void
      {
         DisplayUtil.removeForParent(this.questionMark,false);
         DisplayUtil.removeForParent(this.excalMark,false);
         if(Boolean(this._taskInfo))
         {
            this._taskInfo.refresh();
         }
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      override public function get name() : String
      {
         return this._npcInfo.npcName;
      }
      
      private function clickNpc(_arg_1:MouseEvent) : void
      {
         this.clickPoint = this._npcHit.localToGlobal(new Point(this._npcInfo.offSetPoint.x,this._npcInfo.offSetPoint.y));
         MainManager.actorModel.walkAction(this.clickPoint);
         this._npcHit.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(_arg_1:Event) : void
      {
         var _local_2:Point = MainManager.actorModel.sprite.localToGlobal(new Point());
         if(Point.distance(_local_2,this.clickPoint) < 15)
         {
            MainManager.actorModel.skeleton.stop();
            this._npcHit.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            if(TasksManager.getTaskStatus(25) == TasksManager.ALR_ACCEPT && this._id == 1)
            {
               NpcTaskManager.dispatchEvent(new Event("50001"));
            }
            if(this._taskInfo.completeList.length > 0)
            {
               EventManager.dispatchEvent(new NpcEvent(NpcEvent.COMPLETE_TASK,this));
            }
            else
            {
               EventManager.dispatchEvent(new NpcEvent(NpcEvent.SHOW_TASK_LIST,this));
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this._taskInfo))
         {
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_BLUE_QUESTION,this.showBlueQuestion);
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_YELLOW_EXCAL,this.showYellowExcal);
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_YELLOW_QUESTION,this.showYellowQuestion);
            this._taskInfo.destroy();
         }
         this._taskInfo = null;
         this._npcHit.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._npc = null;
         this._npcHit = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         if(Boolean(this.npcTimer))
         {
            this.npcTimer.stop();
            this.npcTimer.removeEventListener(TimerEvent.TIMER,this.onNpcTimer);
         }
         this.npcTimer = null;
         this._taskInfo = null;
      }
      
      private function showBlueQuestion(_arg_1:Event) : void
      {
         var _local_2:Number = this.npc.height;
         if(_local_2 > 110)
         {
            _local_2 = 120;
         }
         this.questionMark.y = -_local_2;
         this.npc.addChild(this.questionMark);
         this.questionMark.gotoAndStop(1);
      }
      
      private function showYellowExcal(_arg_1:Event) : void
      {
         if(this._taskInfo.isRelateTask)
         {
            return;
         }
         var _local_2:Number = this.npc.height;
         if(_local_2 > 110)
         {
            _local_2 = 120;
         }
         this.excalMark.y = -_local_2;
         this.npc.addChild(this.excalMark);
      }
      
      private function showYellowQuestion(_arg_1:Event) : void
      {
         var _local_2:Number = this.npc.height;
         if(_local_2 > 110)
         {
            _local_2 = 120;
         }
         this.questionMark.y = -_local_2;
         this.npc.addChild(this.questionMark);
         this.questionMark.gotoAndStop(2);
      }
      
      public function get npc() : Sprite
      {
         return this._npc;
      }
      
      public function hide() : void
      {
         if(Boolean(this._npc))
         {
            this._npc.visible = false;
         }
      }
      
      public function show() : void
      {
         if(Boolean(this._npc))
         {
            this._npc.visible = true;
         }
      }
      
      public function setNpcTaskIDs(_arg_1:Array, _arg_2:Array, _arg_3:Array) : void
      {
         if(Boolean(this._taskInfo))
         {
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_BLUE_QUESTION,this.showBlueQuestion);
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_YELLOW_EXCAL,this.showYellowExcal);
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_YELLOW_QUESTION,this.showYellowQuestion);
            this._taskInfo.destroy();
         }
         DisplayUtil.removeForParent(this.questionMark,false);
         DisplayUtil.removeForParent(this.excalMark,false);
         this._taskInfo = new NpcTaskInfo(_arg_1,_arg_2,_arg_3,this);
         this._taskInfo.addEventListener(NpcTaskInfo.SHOW_BLUE_QUESTION,this.showBlueQuestion);
         this._taskInfo.addEventListener(NpcTaskInfo.SHOW_YELLOW_EXCAL,this.showYellowExcal);
         this._taskInfo.addEventListener(NpcTaskInfo.SHOW_YELLOW_QUESTION,this.showYellowQuestion);
         this._taskInfo.checkTaskStatus();
      }
      
      public function get taskInfo() : NpcTaskInfo
      {
         return this._taskInfo;
      }
      
      private function initNpc() : void
      {
         if(this.id != NPC.IRIS && this.id < 90000)
         {
            return;
         }
         clickBtn.mouseChildren = clickBtn.mouseEnabled = false;
         var _local_1:MovieClip = CoreAssetsManager.getMovieClip("npc_shadow_mc");
         _local_1.y += 15;
         addChildAt(_local_1,0);
         this.mouseEnabled = true;
         this._npc = this;
         this._npcHit = this;
         this.buttonMode = true;
         _skeletonSys.getBodyMC().filters = [new GlowFilter(3355443,1,4,4)];
         _skeletonSys.getBodyMC().scaleX = _skeletonSys.getBodyMC().scaleY = 1.4;
         DisplayUtil.removeForParent(_skeletonSys.getSkeletonMC()["clickBtn"]);
         var _local_2:TextField = _nameTxt;
         _local_2.y += 15;
         var _local_3:TextFormat = new TextFormat();
         _local_3.size = 14;
         _local_3.color = 26367;
         _local_2.setTextFormat(_local_3);
         _local_2.filters = [new GlowFilter(16777215,1,3,3,5)];
         this.pos = new Point(704,405);
         this.npcTimer = new Timer(3000,0);
         this.npcTimer.addEventListener(TimerEvent.TIMER,this.onNpcTimer);
         this.npcTimer.start();
         MapManager.currentMap.depthLevel.addChild(this);
         this.pos = this._npcInfo.point;
      }
      
      private function onNpcTimer(_arg_1:TimerEvent) : void
      {
         var _local_2:Point = this.posList[Math.floor(Math.random() * this.posList.length)];
         while(_local_2.x == this.pos.x && _local_2.y == this.pos.y)
         {
            _local_2 = this.posList[Math.floor(Math.random() * this.posList.length)];
         }
         _walk.execute_point(this,_local_2,false);
      }
      
      override protected function onWalkEnd(_arg_1:Event) : void
      {
         _skeletonSys.stop();
         this.npcTimer.reset();
         this.npcTimer.start();
      }
      
      public function get npcInfo() : NpcInfo
      {
         return this._npcInfo;
      }
   }
}

