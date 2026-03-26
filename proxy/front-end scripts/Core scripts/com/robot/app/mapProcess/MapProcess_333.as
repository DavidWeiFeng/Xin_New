package com.robot.app.mapProcess
{
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.utils.*;
   
   public class MapProcess_333 extends BaseMapProcess
   {
      
      private var _swiveMC:MovieClip;
      
      private var _rouletteMC:MovieClip;
      
      private var _ballMC:MovieClip;
      
      private var _swiveMc:MovieClip;
      
      private var _rouletteMc:MovieClip;
      
      private var _ballMc:MovieClip;
      
      private var _clickCnt:uint = 0;
      
      private var _psw:String;
      
      private var _boxPanel:MovieClip;
      
      private var _bArr:Array = [];
      
      private var _doFinishArr:Array = [false,false,false,false];
      
      private var _timer:Timer;
      
      public function MapProcess_333()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._swiveMC = animatorLevel["swiveMC"];
         this._swiveMC.gotoAndStop(1);
         this._rouletteMC = animatorLevel["rouletteMC"];
         this._rouletteMC.gotoAndStop(1);
         this._ballMC = animatorLevel["ballMC"];
         this._ballMC.gotoAndStop(1);
         this._swiveMc = conLevel["swiveMc"];
         this._swiveMc.buttonMode = true;
         this._swiveMc.addEventListener(MouseEvent.CLICK,this.onClickSwive);
         this._rouletteMc = conLevel["rouletteMc"];
         this._ballMc = conLevel["ballMc"];
         this._ballMc.buttonMode = false;
         this._ballMc.mouseEnabled = false;
         this._timer = new Timer(60000);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function onDoorClickHandler(_arg_1:MouseEvent) : void
      {
         MapManager.changeMap(339);
      }
      
      private function onTimer(_arg_1:TimerEvent) : void
      {
         var _local_2:MovieClip = null;
         if(this._swiveMC.currentFrame != 1)
         {
            this._swiveMC.gotoAndStop(1);
            this._swiveMc.buttonMode = true;
            this._swiveMc.addEventListener(MouseEvent.CLICK,this.onClickSwive);
         }
         if(this._ballMC.currentFrame != 1)
         {
            this._ballMC.gotoAndStop(1);
            this._ballMc.buttonMode = true;
            this._ballMc.mouseEnabled = true;
         }
         for each(_local_2 in this._bArr)
         {
            if(Boolean(_local_2))
            {
               if(_local_2.currentFrame != 1)
               {
                  _local_2.gotoAndStop(1);
                  _local_2.addEventListener(MouseEvent.CLICK,this.onClickB);
               }
            }
         }
      }
      
      override public function destroy() : void
      {
         var _local_1:MovieClip = null;
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer.stop();
            this._timer = null;
         }
         DisplayUtil.removeForParent(this._swiveMC);
         this._swiveMC = null;
         DisplayUtil.removeForParent(this._rouletteMC);
         this._rouletteMC = null;
         DisplayUtil.removeForParent(this._ballMC);
         this._ballMC = null;
         for each(_local_1 in this._bArr)
         {
            if(Boolean(_local_1))
            {
               _local_1.buttonMode = true;
               _local_1.addEventListener(MouseEvent.CLICK,this.onClickB);
               DisplayUtil.removeForParent(_local_1);
               _local_1 == null;
            }
         }
      }
      
      private function onClickSwive(_arg_1:MouseEvent) : void
      {
         this._swiveMC.gotoAndStop(2);
         this._swiveMc.buttonMode = false;
         this._swiveMc.removeEventListener(MouseEvent.CLICK,this.onClickSwive);
         this._doFinishArr[0] = true;
      }
      
      private function onClickNum(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = _arg_1.currentTarget as MovieClip;
         _local_2.nextFrame();
         if(_local_2.currentFrame == _local_2.totalFrames)
         {
            _local_2.gotoAndStop(1);
         }
         this._psw = (this._boxPanel["num_0"].currentFrame - 1).toString() + (this._boxPanel["num_1"].currentFrame - 1) + (this._boxPanel["num_2"].currentFrame - 1) + (this._boxPanel["num_3"].currentFrame - 1);
      }
      
      public function clickBall() : void
      {
         ++this._clickCnt;
         this._ballMc.mouseEnabled = false;
         this._ballMc.buttonMode = false;
         if(this._clickCnt == 1)
         {
            this._ballMC.gotoAndPlay(2);
            this._ballMC.addEventListener(Event.ENTER_FRAME,this.onBallMCEntFrame);
         }
         else if(this._clickCnt == 2)
         {
            this._ballMC.gotoAndPlay(54);
         }
         else
         {
            this._ballMC.gotoAndPlay(2);
         }
      }
      
      private function onBallMCEntFrame(_arg_1:Event) : void
      {
         if(this._ballMC.currentFrame == 53)
         {
            this._ballMC.stop();
            this._ballMC.removeEventListener(Event.ENTER_FRAME,this.onBallMCEntFrame);
            this._ballMc.mouseEnabled = true;
            this._ballMc.buttonMode = true;
            this._doFinishArr[2] = true;
         }
      }
      
      public function clickRoulette() : void
      {
         this._timer.start();
         this._rouletteMc.buttonMode = false;
         this._rouletteMc.mouseEnabled = false;
         this._rouletteMC.gotoAndStop(2);
         DisplayUtil.removeForParent(typeLevel["mc"]);
         MapManager.currentMap.makeMapArray();
         this._ballMc.buttonMode = true;
         this._ballMc.mouseEnabled = true;
         this._doFinishArr[1] = true;
      }
      
      public function clickBlock() : void
      {
         var _local_1:String = null;
         var _local_2:MovieClip = null;
         var _local_3:uint = 0;
         DisplayUtil.removeForParent(conLevel["blockMc"]);
         while(_local_3 < 8)
         {
            _local_1 = "b_" + _local_3;
            _local_2 = conLevel[_local_1];
            _local_2.buttonMode = true;
            _local_2.addEventListener(MouseEvent.CLICK,this.onClickB);
            this._bArr.push(_local_2);
            _local_3++;
         }
      }
      
      private function onClickB(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = _arg_1.currentTarget as MovieClip;
         _local_2.gotoAndPlay(2);
         _local_2.buttonMode = false;
         _local_2.removeEventListener(MouseEvent.CLICK,this.onClickB);
         this._doFinishArr[3] = true;
      }
      
      public function changeMap() : void
      {
         MapManager.changeMap(1);
      }
   }
}

