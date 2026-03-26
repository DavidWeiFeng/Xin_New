package com.robot.app.mapProcess
{
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.ui.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class MapProcess_33 extends BaseMapProcess
   {
      
      private var isShow:Boolean;
      
      private var powerMc:MovieClip;
      
      private var point:Point;
      
      public function MapProcess_33()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(TasksManager.getTaskStatus(10) == TasksManager.COMPLETE)
         {
            this.isShow = false;
            conLevel["lightMc"].gotoAndStop(2);
            conLevel["maskMc"].gotoAndPlay(2);
            conLevel["iconMc"].gotoAndStop(5);
            this.configKey();
            return;
         }
         if(TasksManager.getTaskStatus(10) == TasksManager.UN_ACCEPT)
         {
            this.isShow = true;
            this.configLock();
            conLevel["iconMc"].gotoAndStop(1);
            TasksManager.accept(10);
            return;
         }
         if(TasksManager.getTaskStatus(10) == TasksManager.ALR_ACCEPT)
         {
            this.isShow = true;
            conLevel["maskMc"].gotoAndPlay(2);
            conLevel["iconMc"].gotoAndStop(1);
            this.configLock();
            this.configKey();
         }
      }
      
      private function onTimerHandler(_arg_1:TimerEvent) : void
      {
         var _local_2:DialogBox = new DialogBox();
         _local_2.show("墙上的奇怪图案是一位赫星长老的留言。",0,-80,depthLevel["aliceMc"]);
      }
      
      override public function destroy() : void
      {
         var _local_1:int = 0;
         if(this.isShow)
         {
            _local_1 = 0;
            while(_local_1 < 9)
            {
               conLevel["lockMc"]["mc" + _local_1].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
               _local_1++;
            }
         }
      }
      
      private function configLock() : void
      {
         var _local_1:uint = 0;
         var _local_2:int = 0;
         while(_local_2 < 9)
         {
            _local_1 = uint(uint(Math.random() * 4) + 1);
            conLevel["lockMc"]["mc" + _local_2].buttonMode = true;
            conLevel["lockMc"]["mc" + _local_2].gotoAndStop(_local_1);
            conLevel["lockMc"]["mc" + _local_2].addEventListener(MouseEvent.CLICK,this.onClickHandler);
            _local_2++;
         }
      }
      
      private function onClickHandler(_arg_1:MouseEvent) : void
      {
         if(_arg_1.currentTarget.currentFrame == _arg_1.currentTarget.totalFrames)
         {
            _arg_1.currentTarget.gotoAndStop(1);
         }
         else
         {
            _arg_1.currentTarget.gotoAndStop(_arg_1.currentTarget.currentFrame + 1);
         }
         if(this.checkSuccess())
         {
            conLevel["iconMc"].gotoAndPlay(1);
            conLevel["maskMc"].gotoAndPlay(2);
            conLevel["lightMc"].gotoAndStop(2);
            conLevel["lockMc"].mouseChildren = false;
            this.configKey();
            TasksManager.complete(10,1);
         }
      }
      
      private function checkSuccess() : Boolean
      {
         var _local_1:int = 0;
         while(_local_1 < 9)
         {
            if(conLevel["lockMc"]["mc" + _local_1].currentFrame != 1)
            {
               return false;
            }
            _local_1++;
         }
         return true;
      }
      
      private function configKey() : void
      {
         var _local_1:int = 0;
         while(_local_1 < 8)
         {
            conLevel["key" + _local_1].buttonMode = true;
            conLevel["key" + _local_1].addEventListener(MouseEvent.MOUSE_DOWN,this.onKeyDownHandler);
            _local_1++;
         }
      }
      
      private function onKeyDownHandler(_arg_1:MouseEvent) : void
      {
         this.powerMc = _arg_1.currentTarget as MovieClip;
         this.point = new Point(this.powerMc.x,this.powerMc.y);
         if(conLevel.getChildIndex(conLevel["doorMc"]) > conLevel.getChildIndex(this.powerMc))
         {
            conLevel.swapChildren(conLevel["doorMc"],this.powerMc);
         }
         this.powerMc.startDrag();
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
      }
      
      private function onUpHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:int = 0;
         this.powerMc.stopDrag();
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
         if(conLevel.getChildIndex(conLevel["doorMc"]) < conLevel.getChildIndex(this.powerMc))
         {
            conLevel.swapChildren(conLevel["doorMc"],this.powerMc);
         }
         if(this.powerMc.hitTestObject(conLevel["hitMc"]) && this.powerMc == conLevel["key0"])
         {
            _local_2 = 0;
            while(_local_2 < 8)
            {
               conLevel["key" + _local_2].buttonMode = false;
               conLevel["key" + _local_2].removeEventListener(MouseEvent.MOUSE_DOWN,this.onKeyDownHandler);
               _local_2++;
            }
            conLevel["doorMc"].addEventListener(Event.ENTER_FRAME,this.onEnterHandler);
            conLevel["doorMc"].gotoAndPlay(2);
            this.powerMc.visible = false;
         }
         else
         {
            this.powerMc.x = this.point.x;
            this.powerMc.y = this.point.y;
         }
      }
      
      private function onEnterHandler(_arg_1:Event) : void
      {
         if(conLevel["doorMc"].currentFrame == conLevel["doorMc"].totalFrames)
         {
            conLevel["doorMc"].removeEventListener(Event.ENTER_FRAME,this.onEnterHandler);
         }
      }
   }
}

