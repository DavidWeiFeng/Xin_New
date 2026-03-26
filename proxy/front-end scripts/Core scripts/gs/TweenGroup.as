package gs
{
   import flash.events.*;
   import flash.utils.*;
   
   use namespace flash_proxy;
   
   public dynamic class TweenGroup extends Proxy implements IEventDispatcher
   {
      
      protected static var _classInitted:Boolean;
      
      protected static var _TweenMax:Class;
      
      public static const version:Number = 1.02;
      
      public static const ALIGN_INIT:String = "init";
      
      public static const ALIGN_START:String = "start";
      
      public static const ALIGN_END:String = "end";
      
      public static const ALIGN_SEQUENCE:String = "sequence";
      
      public static const ALIGN_NONE:String = "none";
      
      protected static var _overwriteMode:int = OverwriteManager.enabled ? OverwriteManager.mode : OverwriteManager.init();
      
      protected static var _unexpired:Array = [];
      
      protected static var _prevTime:uint = 0;
      
      protected var _align:String;
      
      protected var _tweens:Array;
      
      protected var _reversed:Boolean;
      
      public var loop:Number;
      
      public var expired:Boolean;
      
      public var yoyo:Number;
      
      public var onComplete:Function;
      
      protected var _dispatcher:EventDispatcher;
      
      public var endTime:Number;
      
      protected var _startTime:Number;
      
      protected var _initTime:Number;
      
      public var onCompleteParams:Array;
      
      protected var _pauseTime:Number;
      
      protected var _stagger:Number;
      
      protected var _repeatCount:Number;
      
      public function TweenGroup($tweens:Array = null, $DefaultTweenClass:Class = null, $align:String = "none", $stagger:Number = 0)
      {
         super();
         if(!_classInitted)
         {
            if(TweenLite.version < 9.291)
            {
            }
            try
            {
               _TweenMax = getDefinitionByName("gs.TweenMax") as Class;
            }
            catch($e:Error)
            {
               _TweenMax = Array;
            }
            TweenLite.timingSprite.addEventListener(Event.ENTER_FRAME,checkExpiration,false,-1,true);
            _classInitted = true;
         }
         this.expired = true;
         this._repeatCount = 0;
         this._align = $align;
         this._stagger = $stagger;
         this._dispatcher = new EventDispatcher(this);
         if($tweens != null)
         {
            this._tweens = parse($tweens,$DefaultTweenClass);
            this.updateTimeSpan();
            this.realign();
         }
         else
         {
            this._tweens = [];
            this._initTime = this._startTime = this.endTime = 0;
         }
      }
      
      protected static function checkExpiration(_arg_1:Event) : void
      {
         var _local_2:TweenGroup = null;
         var _local_3:int = 0;
         var _local_4:uint = TweenLite.currentTime;
         var _local_5:Array = _unexpired;
         _local_3 = _local_5.length - 1;
         while(_local_3 > -1)
         {
            _local_2 = _local_5[_local_3];
            if(_local_2.endTime > _prevTime && _local_2.endTime <= _local_4 && !_local_2.paused)
            {
               _local_5.splice(_local_3,1);
               _local_2.expired = true;
               _local_2.handleCompletion();
            }
            _local_3--;
         }
         _prevTime = _local_4;
      }
      
      public static function allFrom(_arg_1:Array, _arg_2:Number, _arg_3:Object, _arg_4:Class = null) : TweenGroup
      {
         _arg_3.runBackwards = true;
         return allTo(_arg_1,_arg_2,_arg_3,_arg_4);
      }
      
      public static function parse(_arg_1:Array, _arg_2:Class = null) : Array
      {
         var _local_3:int = 0;
         var _local_4:Object = null;
         var _local_5:Number = NaN;
         if(_arg_2 == null)
         {
            _arg_2 = TweenLite;
         }
         var _local_6:Array = [];
         _local_3 = 0;
         while(_local_3 < _arg_1.length)
         {
            if(_arg_1[_local_3] is TweenLite)
            {
               _local_6[_local_6.length] = _arg_1[_local_3];
            }
            else
            {
               _local_4 = _arg_1[_local_3].target;
               _local_5 = Number(_arg_1[_local_3].time);
               delete _arg_1[_local_3].target;
               delete _arg_1[_local_3].time;
               _local_6[_local_6.length] = new _arg_2(_local_4,_local_5,_arg_1[_local_3]);
            }
            _local_3++;
         }
         return _local_6;
      }
      
      public static function allTo(_arg_1:Array, _arg_2:Number, _arg_3:Object, _arg_4:Class = null) : TweenGroup
      {
         var _local_5:int = 0;
         var _local_6:Object = null;
         var _local_7:String = null;
         if(_arg_4 == null)
         {
            _arg_4 = TweenLite;
         }
         var _local_8:TweenGroup = new TweenGroup(null,_arg_4,ALIGN_INIT,Number(_arg_3.stagger) || 0);
         _local_8.onComplete = _arg_3.onCompleteAll;
         _local_8.onCompleteParams = _arg_3.onCompleteAllParams;
         delete _arg_3.stagger;
         delete _arg_3.onCompleteAll;
         delete _arg_3.onCompleteAllParams;
         _local_5 = 0;
         while(_local_5 < _arg_1.length)
         {
            _local_6 = {};
            for(_local_7 in _arg_3)
            {
               _local_6[_local_7] = _arg_3[_local_7];
            }
            _local_8[_local_8.length] = new _arg_4(_arg_1[_local_5],_arg_2,_local_6);
            _local_5++;
         }
         if(_local_8.stagger < 0)
         {
            _local_8.progressWithDelay = 0;
         }
         return _local_8;
      }
      
      protected function offsetTime(_arg_1:Array, _arg_2:Number) : void
      {
         var _local_5:Array = null;
         var _local_6:Boolean = false;
         var _local_7:TweenLite = null;
         var _local_8:Boolean = false;
         var _local_11:int = 0;
         var _local_12:Array = null;
         var _local_3:Number = NaN;
         var _local_4:Number = NaN;
         var _local_9:Number = NaN;
         var _local_10:Number = NaN;
         if(_arg_1.length != 0)
         {
            _local_3 = _arg_2 * 1000;
            _local_4 = isNaN(this._pauseTime) ? TweenLite.currentTime : this._pauseTime;
            _local_5 = this.getRenderOrder(_arg_1,_local_4);
            _local_12 = [];
            _local_11 = _local_5.length - 1;
            while(_local_11 > -1)
            {
               _local_7 = _local_5[_local_11];
               _local_7.initTime += _local_3;
               _local_6 = Boolean(_local_7.startTime == 999999999999999);
               _local_9 = _local_7.initTime + _local_7.delay * (1000 / _local_7.combinedTimeScale);
               _local_10 = this.getEndTime(_local_7);
               _local_8 = (_local_9 <= _local_4 || _local_9 - _local_3 <= _local_4) && (_local_10 >= _local_4 || _local_10 - _local_3 >= _local_4);
               if(isNaN(this._pauseTime) && _local_10 >= _local_4)
               {
                  _local_7.enabled = true;
               }
               if(!_local_6)
               {
                  _local_7.startTime = _local_9;
               }
               if(_local_9 >= _local_4)
               {
                  if(!_local_7.initted)
                  {
                     _local_8 = false;
                  }
                  _local_7.active = false;
               }
               if(_local_8)
               {
                  _local_12[_local_12.length] = _local_7;
               }
               _local_11--;
            }
            _local_11 = _local_12.length - 1;
            while(_local_11 > -1)
            {
               this.renderTween(_local_12[_local_11],_local_4);
               _local_11--;
            }
            this.endTime += _local_3;
            this._startTime += _local_3;
            this._initTime += _local_3;
            if(this.expired && this.endTime > _local_4)
            {
               this.expired = false;
               _unexpired[_unexpired.length] = this;
            }
         }
      }
      
      protected function renderTween(_arg_1:TweenLite, _arg_2:Number) : void
      {
         var _local_4:Boolean = false;
         var _local_5:Boolean = false;
         var _local_3:Number = NaN;
         var _local_6:Number = NaN;
         var _local_7:Number = this.getEndTime(_arg_1);
         if(_arg_1.startTime == 999999999999999)
         {
            _arg_1.startTime = _arg_1.initTime + _arg_1.delay * (1000 / _arg_1.combinedTimeScale);
            _local_4 = true;
         }
         if(!_arg_1.initted)
         {
            _local_5 = _arg_1.active;
            _arg_1.active = false;
            if(_local_4)
            {
               _arg_1.initTweenVals();
               if(_arg_1.vars.onStart != null)
               {
                  _arg_1.vars.onStart.apply(null,_arg_1.vars.onStartParams);
               }
            }
            else
            {
               _arg_1.activate();
            }
            _arg_1.active = _local_5;
         }
         if(_arg_1.startTime > _arg_2)
         {
            _local_3 = _arg_1.startTime;
         }
         else if(_local_7 < _arg_2)
         {
            _local_3 = _local_7;
         }
         else
         {
            _local_3 = _arg_2;
         }
         if(_local_3 < 0)
         {
            _local_6 = _arg_1.startTime;
            _arg_1.startTime -= _local_3;
            _arg_1.render(0);
            _arg_1.startTime = _local_6;
         }
         else
         {
            _arg_1.render(_local_3);
         }
         if(_local_4)
         {
            _arg_1.startTime = 999999999999999;
         }
      }
      
      public function get align() : String
      {
         return this._align;
      }
      
      public function set align(_arg_1:String) : void
      {
         this._align = _arg_1;
         this.realign();
      }
      
      public function set reversed(_arg_1:Boolean) : void
      {
         if(this._reversed != _arg_1)
         {
            this.reverse(true);
         }
      }
      
      public function willTrigger(_arg_1:String) : Boolean
      {
         return this._dispatcher.willTrigger(_arg_1);
      }
      
      override flash_proxy function hasProperty(_arg_1:*) : Boolean
      {
         if(this._tweens.hasOwnProperty(_arg_1))
         {
            return true;
         }
         if(" progress progressWithDelay duration durationWithDelay paused reversed timeScale align stagger tweens ".indexOf(" " + _arg_1 + " ") != -1)
         {
            return true;
         }
         return false;
      }
      
      protected function getEndTime(_arg_1:TweenLite) : Number
      {
         return _arg_1.initTime + (_arg_1.delay + _arg_1.duration) * (1000 / _arg_1.combinedTimeScale);
      }
      
      public function get duration() : Number
      {
         if(this._tweens.length == 0)
         {
            return 0;
         }
         return (this.endTime - this._startTime) / 1000;
      }
      
      public function restart(_arg_1:Boolean = false) : void
      {
         this.setProgress(0,_arg_1);
         this._repeatCount = 0;
         this.resume();
      }
      
      protected function getStartTime(_arg_1:TweenLite) : Number
      {
         return _arg_1.initTime + _arg_1.delay * 1000 / _arg_1.combinedTimeScale;
      }
      
      protected function pauseTween(_arg_1:TweenLite) : void
      {
         if(_arg_1 is _TweenMax)
         {
            (_arg_1 as Object).pauseTime = this._pauseTime;
         }
         _arg_1.startTime = 999999999999999;
         _arg_1.enabled = false;
      }
      
      protected function getRenderOrder(_arg_1:Array, _arg_2:Number) : Array
      {
         var _local_3:int = 0;
         var _local_4:Number = NaN;
         var _local_5:Array = [];
         var _local_6:Array = [];
         var _local_7:Array = [];
         _local_3 = _arg_1.length - 1;
         while(_local_3 > -1)
         {
            _local_4 = this.getStartTime(_arg_1[_local_3]);
            if(_local_4 >= _arg_2)
            {
               _local_5[_local_5.length] = {
                  "start":_local_4,
                  "tween":_arg_1[_local_3]
               };
            }
            else
            {
               _local_6[_local_6.length] = {
                  "end":this.getEndTime(_arg_1[_local_3]),
                  "tween":_arg_1[_local_3]
               };
            }
            _local_3--;
         }
         _local_5.sortOn("start",Array.NUMERIC);
         _local_6.sortOn("end",Array.NUMERIC);
         _local_3 = _local_5.length - 1;
         while(_local_3 > -1)
         {
            _local_7[_local_3] = _local_5[_local_3].tween;
            _local_3--;
         }
         _local_3 = _local_6.length - 1;
         while(_local_3 > -1)
         {
            _local_7[_local_7.length] = _local_6[_local_3].tween;
            _local_3--;
         }
         return _local_7;
      }
      
      protected function getProgress(_arg_1:Boolean = false) : Number
      {
         var _local_2:Number = NaN;
         var _local_3:Number = NaN;
         var _local_4:Number = NaN;
         if(this._tweens.length == 0)
         {
            return 0;
         }
         _local_2 = isNaN(this._pauseTime) ? TweenLite.currentTime : this._pauseTime;
         _local_3 = _arg_1 ? this._initTime : this._startTime;
         _local_4 = (_local_2 - _local_3) / (this.endTime - _local_3);
         if(_local_4 < 0)
         {
            return 0;
         }
         if(_local_4 > 1)
         {
            return 1;
         }
         return _local_4;
      }
      
      protected function setTweenStartTime(_arg_1:TweenLite, _arg_2:Number) : void
      {
         var _local_3:Number = _arg_2 - this.getStartTime(_arg_1);
         _arg_1.initTime += _local_3;
         if(_arg_1.startTime != 999999999999999)
         {
            _arg_1.startTime = _arg_2;
         }
      }
      
      public function mergeGroup(_arg_1:TweenGroup, _arg_2:Number = NaN) : void
      {
         var _local_3:int = 0;
         if(isNaN(_arg_2) || _arg_2 > this._tweens.length)
         {
            _arg_2 = this._tweens.length;
         }
         var _local_4:Array = _arg_1.tweens;
         var _local_5:uint = _local_4.length;
         _local_3 = 0;
         while(_local_3 < _local_5)
         {
            this._tweens.splice(_arg_2 + _local_3,0,_local_4[_local_3]);
            _local_3++;
         }
         this.realign();
      }
      
      public function get durationWithDelay() : Number
      {
         if(this._tweens.length == 0)
         {
            return 0;
         }
         return (this.endTime - this._initTime) / 1000;
      }
      
      public function handleCompletion() : void
      {
         if(!isNaN(this.yoyo) && (this._repeatCount < this.yoyo || this.yoyo == 0))
         {
            ++this._repeatCount;
            this.reverse(true);
         }
         else if(!isNaN(this.loop) && (this._repeatCount < this.loop || this.loop == 0))
         {
            ++this._repeatCount;
            this.setProgress(0,true);
         }
         if(this.onComplete != null)
         {
            this.onComplete.apply(null,this.onCompleteParams);
         }
         this._dispatcher.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function resume() : void
      {
         var _local_1:int = 0;
         var _local_2:Number = NaN;
         var _local_3:Array = [];
         var _local_4:Number = TweenLite.currentTime;
         _local_1 = this._tweens.length - 1;
         while(_local_1 > -1)
         {
            if(this._tweens[_local_1].startTime == 999999999999999)
            {
               this.resumeTween(this._tweens[_local_1]);
               _local_3[_local_3.length] = this._tweens[_local_1];
            }
            if(this._tweens[_local_1].startTime >= _local_4 && !this._tweens[_local_1].enabled)
            {
               this._tweens[_local_1].enabled = true;
               this._tweens[_local_1].active = false;
            }
            _local_1--;
         }
         if(!isNaN(this._pauseTime))
         {
            _local_2 = (TweenLite.currentTime - this._pauseTime) / 1000;
            this._pauseTime = NaN;
            this.offsetTime(_local_3,_local_2);
         }
      }
      
      public function get paused() : Boolean
      {
         return !isNaN(this._pauseTime);
      }
      
      public function updateTimeSpan() : void
      {
         var _local_1:int = 0;
         var _local_5:TweenLite = null;
         var _local_2:Number = NaN;
         var _local_3:Number = NaN;
         var _local_4:Number = NaN;
         if(this._tweens.length == 0)
         {
            this.endTime = this._startTime = this._initTime = 0;
         }
         else
         {
            _local_5 = this._tweens[0];
            this._initTime = _local_5.initTime;
            this._startTime = this._initTime + _local_5.delay * (1000 / _local_5.combinedTimeScale);
            this.endTime = this._startTime + _local_5.duration * (1000 / _local_5.combinedTimeScale);
            _local_1 = this._tweens.length - 1;
            while(_local_1 > 0)
            {
               _local_5 = this._tweens[_local_1];
               _local_3 = _local_5.initTime;
               _local_2 = _local_3 + _local_5.delay * (1000 / _local_5.combinedTimeScale);
               _local_4 = _local_2 + _local_5.duration * (1000 / _local_5.combinedTimeScale);
               if(_local_3 < this._initTime)
               {
                  this._initTime = _local_3;
               }
               if(_local_2 < this._startTime)
               {
                  this._startTime = _local_2;
               }
               if(_local_4 > this.endTime)
               {
                  this.endTime = _local_4;
               }
               _local_1--;
            }
            if(this.expired && this.endTime > TweenLite.currentTime)
            {
               this.expired = false;
               _unexpired[_unexpired.length] = this;
            }
         }
      }
      
      public function get progressWithDelay() : Number
      {
         return this.getProgress(true);
      }
      
      public function realign() : void
      {
         var _local_1:uint = 0;
         var _local_2:int = 0;
         var _local_5:Boolean = false;
         var _local_3:Number = NaN;
         var _local_4:Number = NaN;
         if(this._align != ALIGN_NONE && this._tweens.length > 1)
         {
            _local_1 = this._tweens.length;
            _local_3 = this._stagger * 1000;
            _local_5 = this._reversed;
            if(_local_5)
            {
               _local_4 = this.progressWithDelay;
               this.reverse();
               this.progressWithDelay = 0;
            }
            if(this._align == ALIGN_SEQUENCE)
            {
               this.setTweenInitTime(this._tweens[0],this._initTime);
               _local_2 = 1;
               while(_local_2 < _local_1)
               {
                  this.setTweenInitTime(this._tweens[_local_2],this.getEndTime(this._tweens[_local_2 - 1]) + _local_3);
                  _local_2++;
               }
            }
            else if(this._align == ALIGN_INIT)
            {
               _local_2 = 0;
               while(_local_2 < _local_1)
               {
                  this.setTweenInitTime(this._tweens[_local_2],this._initTime + _local_3 * _local_2);
                  _local_2++;
               }
            }
            else if(this._align == ALIGN_START)
            {
               _local_2 = 0;
               while(_local_2 < _local_1)
               {
                  this.setTweenStartTime(this._tweens[_local_2],this._startTime + _local_3 * _local_2);
                  _local_2++;
               }
            }
            else
            {
               _local_2 = 0;
               while(_local_2 < _local_1)
               {
                  this.setTweenInitTime(this._tweens[_local_2],this.endTime - (this._tweens[_local_2].delay + this._tweens[_local_2].duration) * 1000 / this._tweens[_local_2].combinedTimeScale - _local_3 * _local_2);
                  _local_2++;
               }
            }
            if(_local_5)
            {
               this.reverse();
               this.progressWithDelay = _local_4;
            }
         }
         this.updateTimeSpan();
      }
      
      public function get progress() : Number
      {
         return this.getProgress(false);
      }
      
      protected function setProgress(_arg_1:Number, _arg_2:Boolean = false) : void
      {
         var _local_3:Number = NaN;
         var _local_4:Number = NaN;
         if(this._tweens.length != 0)
         {
            _local_3 = isNaN(this._pauseTime) ? TweenLite.currentTime : this._pauseTime;
            _local_4 = _arg_2 ? this._initTime : this._startTime;
            this.offsetTime(this._tweens,(_local_3 - (_local_4 + (this.endTime - _local_4) * _arg_1)) / 1000);
         }
      }
      
      protected function resumeTween(_arg_1:TweenLite) : void
      {
         if(_arg_1 is _TweenMax)
         {
            (_arg_1 as Object).pauseTime = NaN;
         }
         _arg_1.startTime = _arg_1.initTime + _arg_1.delay * (1000 / _arg_1.combinedTimeScale);
      }
      
      public function dispatchEvent(_arg_1:Event) : Boolean
      {
         return this._dispatcher.dispatchEvent(_arg_1);
      }
      
      public function get stagger() : Number
      {
         return this._stagger;
      }
      
      public function get reversed() : Boolean
      {
         return this._reversed;
      }
      
      override flash_proxy function getProperty(_arg_1:*) : *
      {
         return this._tweens[_arg_1];
      }
      
      public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         this._dispatcher.addEventListener(_arg_1,_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         this._dispatcher.removeEventListener(_arg_1,_arg_2,_arg_3);
      }
      
      override flash_proxy function callProperty(_arg_1:*, ... _args) : *
      {
         var _local_3:* = this._tweens[_arg_1].apply(null,_args);
         this.realign();
         if(!isNaN(this._pauseTime))
         {
            this.pause();
         }
         return _local_3;
      }
      
      protected function setTweenInitTime(_arg_1:TweenLite, _arg_2:Number) : void
      {
         var _local_3:Number = _arg_2 - _arg_1.initTime;
         _arg_1.initTime = _arg_2;
         if(_arg_1.startTime != 999999999999999)
         {
            _arg_1.startTime += _local_3;
         }
      }
      
      public function set progress(_arg_1:Number) : void
      {
         this.setProgress(_arg_1,false);
      }
      
      public function set progressWithDelay(_arg_1:Number) : void
      {
         this.setProgress(_arg_1,true);
      }
      
      public function set stagger(_arg_1:Number) : void
      {
         this._stagger = _arg_1;
         this.realign();
      }
      
      public function reverse(_arg_1:Boolean = true) : void
      {
         var _local_2:int = 0;
         var _local_3:TweenLite = null;
         var _local_4:ReverseProxy = null;
         var _local_10:Boolean = false;
         var _local_5:Number = NaN;
         var _local_6:Number = NaN;
         var _local_7:Number = NaN;
         var _local_8:Number = NaN;
         this._reversed = !this._reversed;
         var _local_9:Number = 0;
         var _local_11:Number = !isNaN(this._pauseTime) ? this._pauseTime : TweenLite.currentTime;
         if(this.endTime <= _local_11)
         {
            _local_9 = int(this.endTime - _local_11) + 1;
            _local_10 = true;
         }
         _local_2 = this._tweens.length - 1;
         while(_local_2 > -1)
         {
            _local_3 = this._tweens[_local_2];
            if(_local_3 is _TweenMax)
            {
               _local_5 = _local_3.startTime;
               _local_6 = _local_3.initTime;
               (_local_3 as Object).reverse(false,false);
               _local_3.startTime = _local_5;
               _local_3.initTime = _local_6;
            }
            else if(_local_3.ease != _local_3.vars.ease)
            {
               _local_3.ease = _local_3.vars.ease;
            }
            else
            {
               _local_4 = new ReverseProxy(_local_3);
               _local_3.ease = _local_4.reverseEase;
            }
            _local_8 = _local_3.combinedTimeScale;
            _local_7 = ((_local_11 - _local_3.initTime) / 1000 - _local_3.delay / _local_8) / _local_3.duration * _local_8;
            _local_5 = int(_local_11 - (1 - _local_7) * _local_3.duration * 1000 / _local_8 + _local_9);
            _local_3.initTime = int(_local_5 - _local_3.delay * (1000 / _local_8));
            if(_local_3.startTime != 999999999999999)
            {
               _local_3.startTime = _local_5;
            }
            if(_local_3.startTime > _local_11)
            {
               _local_3.enabled = true;
               _local_3.active = false;
            }
            _local_2--;
         }
         this.updateTimeSpan();
         if(_arg_1)
         {
            if(_local_10)
            {
               this.setProgress(0,true);
            }
            this.resume();
         }
      }
      
      public function clear(_arg_1:Boolean = true) : void
      {
         var _local_2:int = this._tweens.length - 1;
         while(_local_2 > -1)
         {
            if(_arg_1)
            {
               TweenLite.removeTween(this._tweens[_local_2],true);
            }
            this._tweens[_local_2] = null;
            this._tweens.splice(_local_2,1);
            _local_2--;
         }
         if(!this.expired)
         {
            _local_2 = _unexpired.length - 1;
            while(_local_2 > -1)
            {
               if(_unexpired[_local_2] == this)
               {
                  _unexpired.splice(_local_2,1);
                  break;
               }
               _local_2--;
            }
            this.expired = true;
         }
      }
      
      override flash_proxy function setProperty(_arg_1:*, _arg_2:*) : void
      {
         this.onSetProperty(_arg_1,_arg_2);
      }
      
      public function get tweens() : Array
      {
         return this._tweens.slice();
      }
      
      public function set paused(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            this.pause();
         }
         else
         {
            this.resume();
         }
      }
      
      public function toString() : String
      {
         return "TweenGroup( " + this._tweens.toString() + " )";
      }
      
      public function get length() : uint
      {
         return this._tweens.length;
      }
      
      public function hasEventListener(_arg_1:String) : Boolean
      {
         return this._dispatcher.hasEventListener(_arg_1);
      }
      
      public function pause() : void
      {
         if(isNaN(this._pauseTime))
         {
            this._pauseTime = TweenLite.currentTime;
         }
         var _local_1:int = this._tweens.length - 1;
         while(_local_1 > -1)
         {
            if(this._tweens[_local_1].startTime != 999999999999999)
            {
               this.pauseTween(this._tweens[_local_1]);
            }
            _local_1--;
         }
      }
      
      protected function onSetProperty(_arg_1:*, _arg_2:*) : void
      {
         if(!(!isNaN(_arg_1) && !(_arg_2 is TweenLite)))
         {
            this._tweens[_arg_1] = _arg_2;
            this.realign();
            if(!isNaN(this._pauseTime) && _arg_2 is TweenLite)
            {
               this.pauseTween(_arg_2 as TweenLite);
            }
         }
      }
      
      public function set timeScale(_arg_1:Number) : void
      {
         var _local_2:int = this._tweens.length - 1;
         while(_local_2 > -1)
         {
            if(this._tweens[_local_2] is _TweenMax)
            {
               this._tweens[_local_2].timeScale = _arg_1;
            }
            _local_2--;
         }
         this.updateTimeSpan();
      }
      
      public function getActive() : Array
      {
         var _local_1:int = 0;
         var _local_2:Number = NaN;
         var _local_3:Array = [];
         if(isNaN(this._pauseTime))
         {
            _local_2 = TweenLite.currentTime;
            _local_1 = this._tweens.length - 1;
            while(_local_1 > -1)
            {
               if(this._tweens[_local_1].startTime <= _local_2 && this.getEndTime(this._tweens[_local_1]) >= _local_2)
               {
                  _local_3[_local_3.length] = this._tweens[_local_1];
               }
               _local_1--;
            }
         }
         return _local_3;
      }
      
      public function get timeScale() : Number
      {
         var _local_1:uint = 0;
         while(_local_1 < this._tweens.length)
         {
            if(this._tweens[_local_1] is _TweenMax)
            {
               return this._tweens[_local_1].timeScale;
            }
            _local_1++;
         }
         return 1;
      }
   }
}

class ReverseProxy
{
   
   private var _tween:TweenLite;
   
   public function ReverseProxy(_arg_1:TweenLite)
   {
      super();
      this._tween = _arg_1;
   }
   
   public function reverseEase(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number) : Number
   {
      return this._tween.vars.ease(_arg_4 - _arg_1,_arg_2,_arg_3,_arg_4);
   }
}
