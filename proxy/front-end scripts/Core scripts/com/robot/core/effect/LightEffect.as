package com.robot.core.effect
{
   import com.oaxoa.fx.Lightning;
   import com.oaxoa.fx.LightningFadeType;
   import com.robot.core.manager.LevelManager;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   
   public class LightEffect
   {
      
      private var timer:Timer;
      
      private var ll:Lightning;
      
      public function LightEffect()
      {
         super();
         this.timer = new Timer(1500,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public function show(_arg_1:Point, _arg_2:Point, _arg_3:Boolean = true, _arg_4:uint = 16777215, _arg_5:uint = 16777215, _arg_6:Number = 1.8) : Sprite
      {
         var _local_7:Number = NaN;
         this.ll = new Lightning(_arg_4,2);
         this.ll.blendMode = BlendMode.ADD;
         this.ll.childrenDetachedEnd = false;
         this.ll.childrenLifeSpanMin = 0.1;
         this.ll.childrenLifeSpanMax = 2;
         this.ll.childrenMaxCount = 3;
         this.ll.childrenMaxCountDecay = 0.5;
         this.ll.steps = 350;
         this.ll.wavelength = 0.36;
         this.ll.amplitude = 0.76;
         if(_arg_3)
         {
            _local_7 = Point.distance(_arg_1,_arg_2);
            this.ll.maxLength = _local_7 * (2 / 3);
            this.ll.maxLengthVary = _local_7 * (1.5 / 3);
         }
         this.ll.startX = _arg_1.x;
         this.ll.startY = _arg_1.y;
         this.ll.endX = _arg_2.x;
         this.ll.endY = _arg_2.y;
         this.ll.alphaFadeType = LightningFadeType.GENERATION;
         var _local_8:GlowFilter = new GlowFilter(_arg_5);
         _local_8.strength = _arg_6;
         _local_8.quality = 3;
         _local_8.blurY = 10;
         _local_8.blurX = 10;
         this.ll.filters = [_local_8];
         LevelManager.mapLevel.addChild(this.ll);
         this.ll.childrenProbability = 0.3;
         this.ll.addEventListener(Event.ENTER_FRAME,this.onEnter);
         this.timer.start();
         return this.ll;
      }
      
      private function onTimer(_arg_1:TimerEvent) : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         this.ll.kill();
         this.ll.removeEventListener(Event.ENTER_FRAME,this.onEnter);
         DisplayUtil.removeForParent(this.ll);
         this.ll = null;
      }
      
      private function onEnter(_arg_1:Event) : void
      {
         this.ll.update();
      }
   }
}

