package com.oaxoa.fx
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.utils.*;
   
   public class Lightning extends Sprite
   {
      
      private const SMOOTH_COLOR:uint = 8421504;
      
      private var holder:Sprite;
      
      private var sbd:BitmapData;
      
      private var bbd:BitmapData;
      
      private var soffs:Array;
      
      private var boffs:Array;
      
      private var glow:GlowFilter;
      
      public var lifeSpan:Number;
      
      private var lifeTimer:Timer;
      
      public var startX:Number;
      
      public var startY:Number;
      
      public var endX:Number;
      
      public var endY:Number;
      
      public var len:Number;
      
      public var multi:Number;
      
      public var multi2:Number;
      
      public var _steps:uint;
      
      public var stepEvery:Number;
      
      private var seed1:uint;
      
      private var seed2:uint;
      
      public var smooth:Sprite;
      
      public var childrenSmooth:Sprite;
      
      public var childrenArray:Array = [];
      
      public var _smoothPercentage:uint = 50;
      
      public var _childrenSmoothPercentage:uint;
      
      public var _color:uint;
      
      private var generation:uint;
      
      private var _childrenMaxGenerations:uint = 3;
      
      private var _childrenProbability:Number = 0.025;
      
      private var _childrenProbabilityDecay:Number = 0;
      
      private var _childrenMaxCount:uint = 4;
      
      private var _childrenMaxCountDecay:Number = 0.5;
      
      private var _childrenLengthDecay:Number = 0;
      
      private var _childrenAngleVariation:Number = 60;
      
      private var _childrenLifeSpanMin:Number = 0;
      
      private var _childrenLifeSpanMax:Number = 0;
      
      private var _childrenDetachedEnd:Boolean = false;
      
      private var _maxLength:Number = 0;
      
      private var _maxLengthVary:Number = 0;
      
      public var _isVisible:Boolean = true;
      
      public var _alphaFade:Boolean = true;
      
      public var parentInstance:Lightning;
      
      private var _thickness:Number;
      
      private var _thicknessDecay:Number;
      
      private var initialized:Boolean = false;
      
      private var _wavelength:Number = 0.3;
      
      private var _amplitude:Number = 0.5;
      
      private var _speed:Number = 1;
      
      private var calculatedWavelength:Number;
      
      private var calculatedSpeed:Number;
      
      public var alphaFadeType:String;
      
      public var thicknessFadeType:String;
      
      private var position:Number = 0;
      
      private var absolutePosition:Number = 1;
      
      private var dx:Number;
      
      private var dy:Number;
      
      private var soff:Number;
      
      private var soffx:Number;
      
      private var soffy:Number;
      
      private var boff:Number;
      
      private var boffx:Number;
      
      private var boffy:Number;
      
      private var angle:Number;
      
      private var tx:Number;
      
      private var ty:Number;
      
      public function Lightning(_arg_1:uint = 16777215, _arg_2:Number = 2, _arg_3:uint = 0)
      {
         super();
         mouseEnabled = false;
         this._color = _arg_1;
         this._thickness = _arg_2;
         this.alphaFadeType = LightningFadeType.GENERATION;
         this.thicknessFadeType = LightningFadeType.NONE;
         this.generation = _arg_3;
         if(this.generation == 0)
         {
            this.init();
         }
      }
      
      private function init() : void
      {
         this.randomizeSeeds();
         if(this.lifeSpan > 0)
         {
            this.startLifeTimer();
         }
         this.multi2 = 0.03;
         this.holder = new Sprite();
         this.holder.mouseEnabled = false;
         this.startX = 50;
         this.startY = 200;
         this.endX = 50;
         this.endY = 600;
         this.stepEvery = 4;
         this._steps = 50;
         this.sbd = new BitmapData(this._steps,1,false);
         this.bbd = new BitmapData(this._steps,1,false);
         this.soffs = [new Point(0,0),new Point(0,0)];
         this.boffs = [new Point(0,0),new Point(0,0)];
         if(this.generation == 0)
         {
            this.smooth = new Sprite();
            this.childrenSmooth = new Sprite();
            this.smoothPercentage = 50;
            this.childrenSmoothPercentage = 50;
         }
         else
         {
            this.smooth = this.childrenSmooth = this.parentInstance.childrenSmooth;
         }
         this.steps = 100;
         this.childrenLengthDecay = 0.5;
         addChild(this.holder);
         this.initialized = true;
      }
      
      private function randomizeSeeds() : void
      {
         this.seed1 = Math.random() * 100;
         this.seed2 = Math.random() * 100;
      }
      
      public function set steps(_arg_1:uint) : void
      {
         if(_arg_1 < 2)
         {
            _arg_1 = 2;
         }
         if(_arg_1 > 2880)
         {
            _arg_1 = 2880;
         }
         this._steps = _arg_1;
         this.sbd = new BitmapData(this._steps,1,false);
         this.bbd = new BitmapData(this._steps,1,false);
         if(this.generation == 0)
         {
            this.smoothPercentage = this.smoothPercentage;
         }
      }
      
      public function get steps() : uint
      {
         return this._steps;
      }
      
      public function startLifeTimer() : void
      {
         this.lifeTimer = new Timer(this.lifeSpan * 1000,1);
         this.lifeTimer.start();
         this.lifeTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function onTimer(_arg_1:TimerEvent) : void
      {
         this.kill();
      }
      
      public function kill() : void
      {
         var _local_1:uint = 0;
         var _local_2:Lightning = null;
         var _local_3:Object = null;
         this.killAllChildren();
         if(Boolean(this.lifeTimer))
         {
            this.lifeTimer.removeEventListener(TimerEvent.TIMER,this.kill);
            this.lifeTimer.stop();
         }
         if(this.parentInstance != null)
         {
            _local_1 = 0;
            _local_2 = this.parent as Lightning;
            for each(_local_3 in _local_2.childrenArray)
            {
               if(_local_3.instance == this)
               {
                  _local_2.childrenArray.splice(_local_1,1);
               }
               _local_1++;
            }
         }
         this.parent.removeChild(this);
      }
      
      public function killAllChildren() : void
      {
         var _local_1:Lightning = null;
         while(this.childrenArray.length > 0)
         {
            _local_1 = this.childrenArray[0].instance;
            _local_1.kill();
         }
      }
      
      public function generateChild(_arg_1:uint = 1, _arg_2:Boolean = false) : void
      {
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_5:uint = 0;
         var _local_6:uint = 0;
         var _local_8:Lightning = null;
         var _local_7:Number = NaN;
         if(this.generation < this.childrenMaxGenerations && this.childrenArray.length < this.childrenMaxCount)
         {
            _local_3 = this.steps * this.childrenLengthDecay;
            if(_local_3 >= 2)
            {
               _local_4 = 0;
               while(_local_4 < _arg_1)
               {
                  _local_5 = Math.random() * this.steps;
                  _local_6 = Math.random() * this.steps;
                  while(_local_6 == _local_5)
                  {
                     _local_6 = Math.random() * this.steps;
                  }
                  _local_7 = Math.random() * this.childrenAngleVariation - this.childrenAngleVariation / 2;
                  _local_8 = new Lightning(this.color,this.thickness,this.generation + 1);
                  _local_8.parentInstance = this;
                  _local_8.lifeSpan = Math.random() * (this.childrenLifeSpanMax - this.childrenLifeSpanMin) + this.childrenLifeSpanMin;
                  _local_8.position = 1 - _local_5 / this.steps;
                  _local_8.absolutePosition = this.absolutePosition * _local_8.position;
                  _local_8.alphaFadeType = this.alphaFadeType;
                  _local_8.thicknessFadeType = this.thicknessFadeType;
                  if(this.alphaFadeType == LightningFadeType.GENERATION)
                  {
                     _local_8.alpha = 1 - 1 / (this.childrenMaxGenerations + 1) * _local_8.generation;
                  }
                  if(this.thicknessFadeType == LightningFadeType.GENERATION)
                  {
                     _local_8.thickness = this.thickness - this.thickness / (this.childrenMaxGenerations + 1) * _local_8.generation;
                  }
                  _local_8.childrenMaxGenerations = this.childrenMaxGenerations;
                  _local_8.childrenMaxCount = this.childrenMaxCount * (1 - this.childrenMaxCountDecay);
                  _local_8.childrenProbability = this.childrenProbability * (1 - this.childrenProbabilityDecay);
                  _local_8.childrenProbabilityDecay = this.childrenProbabilityDecay;
                  _local_8.childrenLengthDecay = this.childrenLengthDecay;
                  _local_8.childrenDetachedEnd = this.childrenDetachedEnd;
                  _local_8.wavelength = this.wavelength;
                  _local_8.amplitude = this.amplitude;
                  _local_8.speed = this.speed;
                  _local_8.init();
                  this.childrenArray.push({
                     "instance":_local_8,
                     "startStep":_local_5,
                     "endStep":_local_6,
                     "detachedEnd":this.childrenDetachedEnd,
                     "childAngle":_local_7
                  });
                  addChild(_local_8);
                  _local_8.steps = this.steps * (1 - this.childrenLengthDecay);
                  if(_arg_2)
                  {
                     _local_8.generateChild(_arg_1,true);
                  }
                  _local_4++;
               }
            }
         }
      }
      
      public function update() : void
      {
         var _local_2:Object = null;
         var _local_3:Matrix = null;
         var _local_1:Number = NaN;
         var _local_4:Number = NaN;
         if(this.initialized)
         {
            this.dx = this.endX - this.startX;
            this.dy = this.endY - this.startY;
            this.len = Math.sqrt(this.dx * this.dx + this.dy * this.dy);
            this.soffs[0].x += this.steps / 100 * this.speed;
            this.soffs[0].y += this.steps / 100 * this.speed;
            this.sbd.perlinNoise(this.steps / 20,this.steps / 20,1,this.seed1,false,true,7,true,this.soffs);
            this.calculatedWavelength = this.steps * this.wavelength;
            this.calculatedSpeed = this.calculatedWavelength * 0.1 * this.speed;
            this.boffs[0].x -= this.calculatedSpeed;
            this.boffs[0].y += this.calculatedSpeed;
            this.bbd.perlinNoise(this.calculatedWavelength,this.calculatedWavelength,1,this.seed2,false,true,7,true,this.boffs);
            if(this.smoothPercentage > 0)
            {
               _local_3 = new Matrix();
               _local_3.scale(this.steps / this.smooth.width,1);
               this.bbd.draw(this.smooth,_local_3);
            }
            if(this.parentInstance != null)
            {
               this.isVisible = this.parentInstance.isVisible;
            }
            else if(this.maxLength == 0)
            {
               this.isVisible = true;
            }
            else
            {
               if(this.len <= this.maxLength)
               {
                  _local_4 = 1;
               }
               else if(this.len > this.maxLength + this.maxLengthVary)
               {
                  _local_4 = 0;
               }
               else
               {
                  _local_4 = 1 - (this.len - this.maxLength) / this.maxLengthVary;
               }
               this.isVisible = Math.random() < _local_4 ? true : false;
            }
            _local_1 = Math.random();
            if(_local_1 < this.childrenProbability)
            {
               this.generateChild();
            }
            if(this.isVisible)
            {
               this.render();
            }
            for each(_local_2 in this.childrenArray)
            {
               _local_2.instance.update();
            }
         }
      }
      
      public function render() : void
      {
         var _local_1:Object = null;
         var _local_7:uint = 0;
         var _local_2:Number = NaN;
         var _local_3:Number = NaN;
         var _local_4:Number = NaN;
         var _local_5:Number = NaN;
         var _local_6:Number = NaN;
         this.holder.graphics.clear();
         this.holder.graphics.lineStyle(this.thickness,this._color);
         this.angle = Math.atan2(this.endY - this.startY,this.endX - this.startX);
         while(_local_7 < this.steps)
         {
            _local_2 = 1 / this.steps * (this.steps - _local_7);
            _local_3 = 1;
            _local_4 = this.thickness;
            if(this.alphaFadeType == LightningFadeType.TIP_TO_END)
            {
               _local_3 = this.absolutePosition * _local_2;
            }
            if(this.thicknessFadeType == LightningFadeType.TIP_TO_END)
            {
               _local_4 = this.thickness * (this.absolutePosition * _local_2);
            }
            if(this.alphaFadeType == LightningFadeType.TIP_TO_END || this.thicknessFadeType == LightningFadeType.TIP_TO_END)
            {
               this.holder.graphics.lineStyle(int(_local_4),this._color,_local_3);
            }
            this.soff = (this.sbd.getPixel(_local_7,0) - 8421504) / 16777215 * this.len * this.multi2;
            this.soffx = Math.sin(this.angle) * this.soff;
            this.soffy = Math.cos(this.angle) * this.soff;
            this.boff = (this.bbd.getPixel(_local_7,0) - 8421504) / 16777215 * this.len * this.amplitude;
            this.boffx = Math.sin(this.angle) * this.boff;
            this.boffy = Math.cos(this.angle) * this.boff;
            this.tx = this.startX + this.dx / (this.steps - 1) * _local_7 + this.soffx + this.boffx;
            this.ty = this.startY + this.dy / (this.steps - 1) * _local_7 - this.soffy - this.boffy;
            if(_local_7 == 0)
            {
               this.holder.graphics.moveTo(this.tx,this.ty);
            }
            this.holder.graphics.lineTo(this.tx,this.ty);
            for each(_local_1 in this.childrenArray)
            {
               if(_local_1.startStep == _local_7)
               {
                  _local_1.instance.startX = this.tx;
                  _local_1.instance.startY = this.ty;
               }
               if(Boolean(_local_1.detachedEnd))
               {
                  _local_5 = this.angle + _local_1.childAngle / 180 * Math.PI;
                  _local_6 = this.len * this.childrenLengthDecay;
                  _local_1.instance.endX = _local_1.instance.startX + Math.cos(_local_5) * _local_6;
                  _local_1.instance.endY = _local_1.instance.startY + Math.sin(_local_5) * _local_6;
               }
               else if(_local_1.endStep == _local_7)
               {
                  _local_1.instance.endX = this.tx;
                  _local_1.instance.endY = this.ty;
               }
            }
            _local_7++;
         }
      }
      
      public function killSurplus() : void
      {
         var _local_1:Lightning = null;
         while(this.childrenArray.length > this.childrenMaxCount)
         {
            _local_1 = this.childrenArray[this.childrenArray.length - 1].instance;
            _local_1.kill();
         }
      }
      
      public function set smoothPercentage(_arg_1:Number) : void
      {
         var _local_2:Matrix = null;
         var _local_3:uint = 0;
         if(Boolean(this.smooth))
         {
            this._smoothPercentage = _arg_1;
            _local_2 = new Matrix();
            _local_2.createGradientBox(this.steps,1);
            _local_3 = uint(this._smoothPercentage / 100 * 128);
            this.smooth.graphics.clear();
            this.smooth.graphics.beginGradientFill("linear",[this.SMOOTH_COLOR,this.SMOOTH_COLOR,this.SMOOTH_COLOR,this.SMOOTH_COLOR],[1,0,0,1],[0,_local_3,255 - _local_3,255],_local_2);
            this.smooth.graphics.drawRect(0,0,this.steps,1);
            this.smooth.graphics.endFill();
         }
      }
      
      public function set childrenSmoothPercentage(_arg_1:Number) : void
      {
         this._childrenSmoothPercentage = _arg_1;
         var _local_2:Matrix = new Matrix();
         _local_2.createGradientBox(this.steps,1);
         var _local_3:uint = uint(this._childrenSmoothPercentage / 100 * 128);
         this.childrenSmooth.graphics.clear();
         this.childrenSmooth.graphics.beginGradientFill("linear",[this.SMOOTH_COLOR,this.SMOOTH_COLOR,this.SMOOTH_COLOR,this.SMOOTH_COLOR],[1,0,0,1],[0,_local_3,255 - _local_3,255],_local_2);
         this.childrenSmooth.graphics.drawRect(0,0,this.steps,1);
         this.childrenSmooth.graphics.endFill();
      }
      
      public function get smoothPercentage() : Number
      {
         return this._smoothPercentage;
      }
      
      public function get childrenSmoothPercentage() : Number
      {
         return this._childrenSmoothPercentage;
      }
      
      public function set color(_arg_1:uint) : void
      {
         var _local_2:Object = null;
         this._color = _arg_1;
         this.glow.color = _arg_1;
         this.holder.filters = [this.glow];
         for each(_local_2 in this.childrenArray)
         {
            _local_2.instance.color = _arg_1;
         }
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set childrenProbability(_arg_1:Number) : void
      {
         if(_arg_1 > 1)
         {
            _arg_1 = 1;
         }
         else if(_arg_1 < 0)
         {
            _arg_1 = 0;
         }
         this._childrenProbability = _arg_1;
      }
      
      public function get childrenProbability() : Number
      {
         return this._childrenProbability;
      }
      
      public function set childrenProbabilityDecay(_arg_1:Number) : void
      {
         if(_arg_1 > 1)
         {
            _arg_1 = 1;
         }
         else if(_arg_1 < 0)
         {
            _arg_1 = 0;
         }
         this._childrenProbabilityDecay = _arg_1;
      }
      
      public function get childrenProbabilityDecay() : Number
      {
         return this._childrenProbabilityDecay;
      }
      
      public function set maxLength(_arg_1:Number) : void
      {
         this._maxLength = _arg_1;
      }
      
      public function get maxLength() : Number
      {
         return this._maxLength;
      }
      
      public function set maxLengthVary(_arg_1:Number) : void
      {
         this._maxLengthVary = _arg_1;
      }
      
      public function get maxLengthVary() : Number
      {
         return this._maxLengthVary;
      }
      
      public function set thickness(_arg_1:Number) : void
      {
         if(_arg_1 < 0)
         {
            _arg_1 = 0;
         }
         this._thickness = _arg_1;
      }
      
      public function get thickness() : Number
      {
         return this._thickness;
      }
      
      public function set thicknessDecay(_arg_1:Number) : void
      {
         if(_arg_1 > 1)
         {
            _arg_1 = 1;
         }
         else if(_arg_1 < 0)
         {
            _arg_1 = 0;
         }
         this._thicknessDecay = _arg_1;
      }
      
      public function get thicknessDecay() : Number
      {
         return this._thicknessDecay;
      }
      
      public function set childrenLengthDecay(_arg_1:Number) : void
      {
         if(_arg_1 > 1)
         {
            _arg_1 = 1;
         }
         else if(_arg_1 < 0)
         {
            _arg_1 = 0;
         }
         this._childrenLengthDecay = _arg_1;
      }
      
      public function get childrenLengthDecay() : Number
      {
         return this._childrenLengthDecay;
      }
      
      public function set childrenMaxGenerations(_arg_1:uint) : void
      {
         this._childrenMaxGenerations = _arg_1;
         this.killSurplus();
      }
      
      public function get childrenMaxGenerations() : uint
      {
         return this._childrenMaxGenerations;
      }
      
      public function set childrenMaxCount(_arg_1:uint) : void
      {
         this._childrenMaxCount = _arg_1;
         this.killSurplus();
      }
      
      public function get childrenMaxCount() : uint
      {
         return this._childrenMaxCount;
      }
      
      public function set childrenMaxCountDecay(_arg_1:Number) : void
      {
         if(_arg_1 > 1)
         {
            _arg_1 = 1;
         }
         else if(_arg_1 < 0)
         {
            _arg_1 = 0;
         }
         this._childrenMaxCountDecay = _arg_1;
      }
      
      public function get childrenMaxCountDecay() : Number
      {
         return this._childrenMaxCountDecay;
      }
      
      public function set childrenAngleVariation(_arg_1:Number) : void
      {
         var _local_2:Object = null;
         this._childrenAngleVariation = _arg_1;
         for each(_local_2 in this.childrenArray)
         {
            _local_2.childAngle = Math.random() * _arg_1 - _arg_1 / 2;
            _local_2.instance.childrenAngleVariation = _arg_1;
         }
      }
      
      public function get childrenAngleVariation() : Number
      {
         return this._childrenAngleVariation;
      }
      
      public function set childrenLifeSpanMin(_arg_1:Number) : void
      {
         this._childrenLifeSpanMin = _arg_1;
      }
      
      public function get childrenLifeSpanMin() : Number
      {
         return this._childrenLifeSpanMin;
      }
      
      public function set childrenLifeSpanMax(_arg_1:Number) : void
      {
         this._childrenLifeSpanMax = _arg_1;
      }
      
      public function get childrenLifeSpanMax() : Number
      {
         return this._childrenLifeSpanMax;
      }
      
      public function set childrenDetachedEnd(_arg_1:Boolean) : void
      {
         this._childrenDetachedEnd = _arg_1;
      }
      
      public function get childrenDetachedEnd() : Boolean
      {
         return this._childrenDetachedEnd;
      }
      
      public function set wavelength(_arg_1:Number) : void
      {
         var _local_2:Object = null;
         this._wavelength = _arg_1;
         for each(_local_2 in this.childrenArray)
         {
            _local_2.instance.wavelength = _arg_1;
         }
      }
      
      public function get wavelength() : Number
      {
         return this._wavelength;
      }
      
      public function set amplitude(_arg_1:Number) : void
      {
         var _local_2:Object = null;
         this._amplitude = _arg_1;
         for each(_local_2 in this.childrenArray)
         {
            _local_2.instance.amplitude = _arg_1;
         }
      }
      
      public function get amplitude() : Number
      {
         return this._amplitude;
      }
      
      public function set speed(_arg_1:Number) : void
      {
         var _local_2:Object = null;
         this._speed = _arg_1;
         for each(_local_2 in this.childrenArray)
         {
            _local_2.instance.speed = _arg_1;
         }
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function set isVisible(_arg_1:Boolean) : void
      {
         this._isVisible = visible = _arg_1;
      }
      
      public function get isVisible() : Boolean
      {
         return this._isVisible;
      }
   }
}

