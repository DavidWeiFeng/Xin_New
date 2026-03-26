package com.robot.app.mapProcess
{
   import com.robot.app.energy.utils.*;
   import com.robot.app.fightNote.*;
   import com.robot.app.task.UnbelievableSpriteScholar.*;
   import com.robot.app.task.process.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_34 extends BaseMapProcess
   {
      
      private var _currYin:MovieClip;
      
      private var _currIndex:int = 0;
      
      private var mcA:Array;
      
      private var hitA:Array;
      
      private var curNameIndex:Number;
      
      private var curMc:MovieClip;
      
      private var curPoint:Point;
      
      private var time:uint = 0;
      
      private var _yaModel:OgreModel;
      
      private var shitou:MovieClip;
      
      private var xiangzi:MovieClip;
      
      public function MapProcess_34()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _local_1:String = null;
         var _local_2:MovieClip = null;
         var _local_3:uint = 0;
         var _local_4:int = 0;
         var _local_5:uint = 0;
         conLevel["lidMc"].gotoAndPlay(60);
         ToolTipManager.add(conLevel["door_0"],"神秘通道");
         while(_local_4 < 3)
         {
            conLevel["yin_" + _local_4.toString()].gotoAndStop(1);
            conLevel["yin_" + _local_4.toString()].visible = false;
            _local_4++;
         }
         this._currYin = conLevel["yin_" + this._currIndex.toString()];
         conLevel["treeMc"].buttonMode = true;
         conLevel["treeMc"].addEventListener(MouseEvent.CLICK,this.onTreeHandler);
         DisplayUtil.removeForParent(conLevel["tengmanMC"]);
         DisplayUtil.removeForParent(conLevel["templeDoorMC"]);
         DisplayUtil.removeForParent(conLevel["huahuaguoMC"]);
         while(_local_5 < 6)
         {
            _local_1 = "matter_" + _local_5;
            _local_2 = MapManager.currentMap.depthLevel.getChildByName(_local_1) as MovieClip;
            DisplayUtil.removeForParent(_local_2);
            _local_2 = null;
            _local_5++;
         }
         var _local_6:MovieClip = MapManager.currentMap.depthLevel.getChildByName("chosSuccseMC") as MovieClip;
         DisplayUtil.removeForParent(_local_6);
         _local_6 = null;
         var _local_7:MovieClip = MapManager.currentMap.depthLevel.getChildByName("chosFalseMC") as MovieClip;
         DisplayUtil.removeForParent(_local_7);
         _local_7 = null;
         this.shitou = conLevel["shitou"] as MovieClip;
         this.shitou.visible = false;
         this.xiangzi = conLevel["xiangzi"] as MovieClip;
         this.xiangzi.alpha = 0;
         if(TasksManager.getTaskStatus(12) == TasksManager.COMPLETE)
         {
            this.check();
            animatorLevel.visible = false;
            _local_3 = 1;
            while(_local_3 < 5)
            {
               conLevel["mc" + _local_3].visible = false;
               conLevel["hit" + _local_3].gotoAndPlay(2);
               conLevel["treeMc"].gotoAndStop(4);
               _local_3++;
            }
            return;
         }
         if(TasksManager.getTaskStatus(12) == TasksManager.ALR_ACCEPT)
         {
            this.configStone();
            return;
         }
         if(TasksManager.getTaskStatus(12) == TasksManager.UN_ACCEPT)
         {
            TasksManager.accept(12,this.acHandler);
            return;
         }
      }
      
      private function acHandler(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            this.configStone();
         }
      }
      
      private function configStone() : void
      {
         this.mcA = [1,2,3,4];
         this.hitA = [1,2,3,4];
         this.time = 0;
         var _local_1:uint = 1;
         while(_local_1 < 5)
         {
            conLevel["mc" + _local_1].buttonMode = true;
            conLevel["mc" + _local_1].addEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
            _local_1++;
         }
      }
      
      private function onTreeHandler(_arg_1:MouseEvent) : void
      {
         ++this.time;
         if(this.time > 3)
         {
            return;
         }
         conLevel["treeMc"].gotoAndStop(this.time + 1);
         if(this.time == 3)
         {
            conLevel["mc4"].gotoAndPlay(2);
         }
      }
      
      public function clickTengman() : void
      {
      }
      
      public function clickTempleDoor() : void
      {
         OpenTempleDoorController.show();
      }
      
      public function oreHandler() : void
      {
         var _local_1:String = NpcTipDialog.IRIS;
         NpcTipDialog.show("神秘的精灵圣殿被奇怪的晶体藤蔓缠绕着无法开启，得到电能锯子的赛尔们，快来帮忙吧！采集到的藤结晶可以拿到动力室换取骄阳豆哦！",this.handler,_local_1);
      }
      
      private function handler() : void
      {
         EnergyController.exploit();
      }
      
      private function onDownHandler(_arg_1:MouseEvent) : void
      {
         this.curPoint = new Point();
         this.curNameIndex = Number((_arg_1.currentTarget as MovieClip).name.slice(2,3));
         this.curMc = _arg_1.currentTarget as MovieClip;
         this.curPoint.x = _arg_1.currentTarget.x;
         this.curPoint.y = _arg_1.currentTarget.y;
         this.curMc.startDrag();
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUphandler);
      }
      
      private function onUphandler(_arg_1:MouseEvent) : void
      {
         var _local_2:int = 0;
         var _local_3:uint = 0;
         this.curMc.stopDrag();
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUphandler);
         while(_local_3 < this.hitA.length)
         {
            if(this.curMc.hitTestObject(conLevel["hit" + this.hitA[_local_3]]))
            {
               conLevel["hit" + this.hitA[_local_3]].gotoAndPlay(2);
               this.curMc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
               DisplayUtil.removeForParent(this.curMc);
               this.curMc = null;
               _local_2 = int(this.hitA.indexOf(this.hitA[_local_3]));
               this.hitA.splice(_local_2,1);
               _local_2 = int(this.mcA.indexOf(this.curNameIndex));
               this.mcA.splice(_local_2,1);
               if(this.hitA.length == 0)
               {
                  if(TasksManager.getTaskStatus(12) != TasksManager.COMPLETE)
                  {
                     TasksManager.complete(12,1);
                  }
                  animatorLevel.visible = false;
                  this.check();
               }
               return;
            }
            _local_3++;
         }
         this.curMc.x = this.curPoint.x;
         this.curMc.y = this.curPoint.y;
      }
      
      override public function destroy() : void
      {
         var _local_1:int = 0;
         ToolTipManager.remove(conLevel["door_0"]);
         this.onMapDown();
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimatEnd);
         this._currYin.removeEventListener(Event.ENTER_FRAME,this.onYinEnter);
         this._currYin.stop();
         this._currYin = null;
         if(Boolean(this.mcA))
         {
            if(this.mcA.length > 0)
            {
               _local_1 = 0;
               while(_local_1 < this.mcA.length)
               {
                  conLevel["mc" + this.mcA[_local_1]].removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
                  _local_1++;
               }
            }
         }
         if(Boolean(this._yaModel))
         {
            this._yaModel.removeEventListener(RobotEvent.OGRE_CLICK,this.onYaClick);
            this._yaModel.destroy();
            this._yaModel = null;
         }
      }
      
      private function check() : void
      {
         if(TaskProcess_11.isCatch)
         {
            return;
         }
         if(TasksManager.getTaskStatus(11) != TasksManager.COMPLETE)
         {
            this._currYin.gotoAndPlay(2);
            this._currYin.visible = true;
            this._currYin.addEventListener(Event.ENTER_FRAME,this.onYinEnter);
            TaskProcess_11.start();
            AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimatEnd);
         }
      }
      
      private function onYinEnter(_arg_1:Event) : void
      {
         if(this._currYin.currentFrame == this._currYin.totalFrames)
         {
            this._currYin.removeEventListener(Event.ENTER_FRAME,this.onYinEnter);
            this._currYin.gotoAndStop(1);
            this._currYin.visible = false;
            ++this._currIndex;
            if(this._currIndex >= 3)
            {
               this._currIndex = 0;
            }
            this._currYin = conLevel["yin_" + this._currIndex.toString()];
            this._currYin.addEventListener(Event.ENTER_FRAME,this.onYinEnter);
            this._currYin.gotoAndPlay(2);
            this._currYin.visible = true;
         }
      }
      
      private function onAimatEnd(_arg_1:AimatEvent) : void
      {
         var _local_2:AimatInfo = _arg_1.info;
         if(_local_2.userID == MainManager.actorID)
         {
            if(_local_2.id == 10003)
            {
               if(Boolean(this._currYin))
               {
                  if(this._currYin.hitTestPoint(_local_2.endPos.x,_local_2.endPos.y))
                  {
                     this._currYin.removeEventListener(Event.ENTER_FRAME,this.onYinEnter);
                     this._currYin.gotoAndStop(1);
                     this._currYin.visible = false;
                     this._yaModel = new OgreModel(0);
                     this._yaModel.show(74,_local_2.endPos,null);
                     this._yaModel.addEventListener(RobotEvent.OGRE_CLICK,this.onYaClick);
                  }
               }
            }
         }
      }
      
      private function onYaClick(_arg_1:Event) : void
      {
         if(Point.distance(this._yaModel.pos,MainManager.actorModel.pos) < 40)
         {
            MainManager.actorModel.stop();
            FightInviteManager.fightWithBoss("果冻鸭");
            return;
         }
         MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
         MainManager.actorModel.walkAction(this._yaModel.pos);
      }
      
      private function onWalkEnter(_arg_1:Event) : void
      {
         if(Point.distance(this._yaModel.pos,MainManager.actorModel.pos) < 40)
         {
            this.onMapDown();
            MainManager.actorModel.stop();
            FightInviteManager.fightWithBoss("果冻鸭");
         }
      }
      
      private function onMapDown(_arg_1:MapEvent = null) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
      }
      
      public function changeToHandler() : void
      {
         conLevel["lidMc"].addEventListener(Event.ENTER_FRAME,this.onEntHandler);
         conLevel["lidMc"].gotoAndPlay(60);
      }
      
      private function onEntHandler(_arg_1:Event) : void
      {
         if(conLevel["lidMc"].currentFrame == 70)
         {
            conLevel["lidMc"].removeEventListener(Event.ENTER_FRAME,this.onEntHandler);
            MapManager.changeMap(33);
         }
      }
      
      public function onClickShitou() : void
      {
      }
      
      private function onClickXiangzi(_arg_1:MouseEvent) : void
      {
         this.xiangzi.removeEventListener(MouseEvent.CLICK,this.onClickXiangzi);
         DisplayUtil.removeForParent(this.shitou);
         this.shitou = null;
         DisplayUtil.removeForParent(this.xiangzi);
         this.xiangzi = null;
         NpcTipDialog.show("恭喜你已经找到了遗迹宝箱，据这些机械残骸看来可能是属于机械精灵的，不过我们现在还缺少机械图纸，再去<font color=\'#ff0000\'>赫尔卡星</font>其他地方找找吧",null,NpcTipDialog.DOCTOR,-80);
         TasksManager.complete(28,0);
      }
   }
}

