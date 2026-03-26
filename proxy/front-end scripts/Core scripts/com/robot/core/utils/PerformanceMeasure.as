package com.robot.core.utils
{
   import flash.display.Sprite;
   import flash.events.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class PerformanceMeasure extends Sprite
   {
      
      private var _tf:TextField;
      
      private var _timer:Timer;
      
      private var _frameCount:int = 0;
      
      private var _fps:int;
      
      private var _gcCount:int;
      
      public function PerformanceMeasure(_arg_1:Boolean = true, _arg_2:Boolean = true)
      {
         super();
         if(_arg_2)
         {
            this.initialize(_arg_1);
         }
      }
      
      public function startGCCycle() : void
      {
         this._gcCount = 0;
         addEventListener(Event.ENTER_FRAME,this.doGC);
      }
      
      private function doGC(_arg_1:Event) : void
      {
         System.gc();
         if(++this._gcCount > 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.doGC);
            setTimeout(this.lastGC,40);
         }
      }
      
      private function lastGC() : void
      {
         System.gc();
      }
      
      private function initialize(_arg_1:Boolean = true) : void
      {
         this._tf = new TextField();
         this._tf.text = "";
         this._tf.autoSize = TextFieldAutoSize.LEFT;
         this._tf.background = true;
         this._tf.backgroundColor = 0;
         this._tf.textColor = 16777215;
         this._tf.selectable = false;
         addChild(this._tf);
         if(_arg_1)
         {
            buttonMode = true;
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.runT);
         this._timer.start();
         addEventListener(Event.ENTER_FRAME,this.runEf);
      }
      
      private function onMouseUp(_arg_1:MouseEvent) : void
      {
         stopDrag();
      }
      
      private function onMouseDown(_arg_1:MouseEvent) : void
      {
         startDrag(false);
      }
      
      private function runT(_arg_1:TimerEvent) : void
      {
         this._fps = this._frameCount;
         this._frameCount = 0;
      }
      
      private function runEf(_arg_1:Event) : void
      {
         this.mem();
         ++this._frameCount;
      }
      
      private function mem() : void
      {
         this._tf.text = this.format(System.totalMemory / 1024 / 1024) + " MB | " + this._fps + " FPS";
      }
      
      private function format(_arg_1:Number) : String
      {
         var _local_2:String = null;
         var _local_3:Number = Math.pow(10,2);
         _arg_1 = Math.round(_arg_1 * _local_3) / _local_3;
         if(_arg_1 <= 9)
         {
            _local_2 = "0" + _arg_1;
         }
         else
         {
            _local_2 = _arg_1.toString();
         }
         var _local_4:String = _local_2.split(".")[1];
         if(Boolean(_local_4))
         {
            if(_local_4.length < 2)
            {
               return _local_2 + "0";
            }
            return _local_2;
         }
         return _local_2 + ".00";
      }
      
      public function finalize() : void
      {
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER,this.runT);
         this._timer = null;
         removeEventListener(Event.ENTER_FRAME,this.runEf);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
   }
}

