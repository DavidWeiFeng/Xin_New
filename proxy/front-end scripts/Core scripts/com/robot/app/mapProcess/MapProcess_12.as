package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.*;
   import com.robot.app.task.skeeClothTask.*;
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.utils.*;
   
   public class MapProcess_12 extends BaseMapProcess
   {
      
      private var stoneMC:MovieClip;
      
      private var pullArray:Array = [];
      
      private var _yiyiCount:uint;
      
      private var _yiyiMc:MovieClip;
      
      private var _yiyiTimer:uint;
      
      private var _yiyiPosList:Array = [new Point(110,160),new Point(210,140),new Point(280,140),new Point(110,260),new Point(240,250),new Point(100,325),new Point(215,350),new Point(150,395),new Point(70,440)];
      
      public function MapProcess_12()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _local_1:SimpleButton = null;
         var _local_2:uint = 0;
         this.stoneMC = conLevel["stoneMC"];
         this.stoneMC.buttonMode = true;
         this.stoneMC.gotoAndStop(1);
         while(_local_2 < 5)
         {
            _local_1 = depthLevel["sz_" + _local_2];
            _local_1.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
            _local_2++;
         }
         this._yiyiMc = MapLibManager.getMovieClip("UI_yiyi");
         this._yiyiTimer = setInterval(this.onInTime,10000);
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
      }
      
      override public function destroy() : void
      {
         var _local_1:SimpleButton = null;
         var _local_2:uint = 0;
         this.onMapDown(null);
         clearInterval(this._yiyiTimer);
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         while(_local_2 < 5)
         {
            _local_1 = depthLevel["sz_" + _local_2];
            _local_1.removeEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
            _local_2++;
         }
         this.stoneMC.removeEventListener(MouseEvent.CLICK,this.clickStone);
         this.stoneMC = null;
         this._yiyiPosList = null;
         DisplayUtil.removeForParent(this._yiyiMc);
         this._yiyiMc = null;
      }
      
      private function downHandler(_arg_1:MouseEvent) : void
      {
         if(!this.stoneMC.parent)
         {
            return;
         }
         var _local_2:SimpleButton = _arg_1.currentTarget as SimpleButton;
         var _local_3:uint = uint(_local_2.name.substr(-1,1));
         if(this.pullArray.indexOf(_local_3) == -1)
         {
            this.pullArray.push(_local_3);
            this.checkPull();
         }
      }
      
      private function checkPull() : void
      {
         var _local_1:uint = 0;
         var _local_2:SimpleButton = null;
         if(this.pullArray.length == 5)
         {
            this.stoneMC.play();
            this.addStoneEvent();
            this.pullArray = [];
            _local_1 = 0;
            while(_local_1 < 5)
            {
               _local_2 = depthLevel["sz_" + _local_1];
               _local_2.removeEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
               _local_1++;
            }
         }
         else
         {
            this.stoneMC.y += 8;
         }
      }
      
      private function addStoneEvent() : void
      {
         this.stoneMC.addEventListener(MouseEvent.CLICK,this.clickStone);
      }
      
      private function clickStone(_arg_1:MouseEvent) : void
      {
      }
      
      private function onCheckTask(b:Boolean) : void
      {
         if(b)
         {
            Alarm.show("你已经收集过植物纤维了！");
         }
         else
         {
            TasksManager.complete(SkeeClothTaskController.TASK_ID,0,function(_arg_1:Boolean):void
            {
               if(_arg_1)
               {
                  Alarm.show("恭喜你找到了<font color=\'#ff0000\'>植物纤维</font>");
                  DisplayUtil.removeForParent(stoneMC);
               }
               else
               {
                  Alarm.show("这次采集似乎失败了，再尝试一次吧！");
               }
            });
         }
      }
      
      private function onAimat(_arg_1:AimatEvent) : void
      {
         var _local_2:AimatInfo = _arg_1.info;
         if(_local_2.userID == MainManager.actorID)
         {
            if(_local_2.id == 10001)
            {
               if(this._yiyiMc.hitTestPoint(_local_2.endPos.x,_local_2.endPos.y))
               {
                  ++this._yiyiCount;
                  if(this._yiyiCount >= 3)
                  {
                     AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
                     clearInterval(this._yiyiTimer);
                     this._yiyiMc.gotoAndStop(20);
                     this._yiyiMc.buttonMode = true;
                     this._yiyiMc.addEventListener(MouseEvent.CLICK,this.onYiyiClick);
                  }
               }
            }
         }
      }
      
      private function onInTime() : void
      {
         var _local_1:Point = null;
         if(!DisplayUtil.hasParent(this._yiyiMc))
         {
            conLevel.addChild(this._yiyiMc);
         }
         var _local_2:int = int(this._yiyiPosList.length * Math.random());
         if(_local_2 == this._yiyiPosList.length)
         {
            _local_2 = this._yiyiPosList.length - 1;
         }
         _local_1 = this._yiyiPosList[_local_2];
         this._yiyiMc.x = _local_1.x;
         this._yiyiMc.y = _local_1.y;
         this._yiyiMc.gotoAndPlay(1);
      }
      
      private function onYiyiClick(_arg_1:MouseEvent) : void
      {
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         MainManager.actorModel.walkAction(new Point(this._yiyiMc.x,this._yiyiMc.y));
      }
      
      private function onWalk(_arg_1:Event) : void
      {
         if(Math.abs(Point.distance(new Point(this._yiyiMc.x,this._yiyiMc.y),MainManager.actorModel.pos)) < 30)
         {
            this.onMapDown(null);
            MainManager.actorModel.stop();
            FightInviteManager.fightWithBoss("依依",1);
         }
      }
      
      private function onMapDown(_arg_1:MapEvent) : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MapManager.removeEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
      }
   }
}

