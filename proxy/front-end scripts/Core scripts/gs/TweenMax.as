package gs
{
   import flash.events.*;
   import flash.utils.*;
   import gs.events.*;
   import gs.plugins.*;
   import gs.utils.tween.*;
   
   public class TweenMax extends TweenLite implements IEventDispatcher
   {
      
      public static const version:Number = 10.1;
      
      private static var _activatedPlugins:Boolean = TweenPlugin.activate([TintPlugin,RemoveTintPlugin,FramePlugin,AutoAlphaPlugin,VisiblePlugin,VolumePlugin,EndArrayPlugin,HexColorsPlugin,BlurFilterPlugin,ColorMatrixFilterPlugin,BevelFilterPlugin,DropShadowFilterPlugin,GlowFilterPlugin,RoundPropsPlugin,BezierPlugin,BezierThroughPlugin,ShortRotationPlugin]);
      
      private static var _overwriteMode:int = OverwriteManager.enabled ? OverwriteManager.mode : OverwriteManager.init();
      
      public static var killTweensOf:Function = TweenLite.killTweensOf;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      public static var removeTween:Function = TweenLite.removeTween;
      
      protected static var _pausedTweens:Dictionary = new Dictionary(false);
      
      protected static var _globalTimeScale:Number = 1;
      
      protected var _dispatcher:EventDispatcher;
      
      protected var _callbacks:Object;
      
      public var pauseTime:Number;
      
      protected var _repeatCount:Number;
      
      protected var _timeScale:Number;
      
      public function TweenMax(_arg_1:Object, _arg_2:Number, _arg_3:Object)
      {
         super(_arg_1,_arg_2,_arg_3);
         if(TweenLite.version < 10.09)
         {
         }
         if(this.combinedTimeScale != 1 && this.target is TweenMax)
         {
            this._timeScale = 1;
            this.combinedTimeScale = _globalTimeScale;
         }
         else
         {
            this._timeScale = this.combinedTimeScale;
            this.combinedTimeScale *= _globalTimeScale;
         }
         if(this.combinedTimeScale != 1 && this.delay != 0)
         {
            this.startTime = this.initTime + this.delay * (1000 / this.combinedTimeScale);
         }
         if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
         {
            this.initDispatcher();
            if(_arg_2 == 0 && this.delay == 0)
            {
               this.onUpdateDispatcher();
               this.onCompleteDispatcher();
            }
         }
         this._repeatCount = 0;
         if(!isNaN(this.vars.yoyo) || !isNaN(this.vars.loop))
         {
            this.vars.persist = true;
         }
         if(this.delay == 0 && this.exposedVars.startAt != null)
         {
            this.exposedVars.startAt.overwrite = 0;
            new TweenMax(this.target,0,this.exposedVars.startAt);
         }
      }
      
      public static function set globalTimeScale(_arg_1:Number) : void
      {
         setGlobalTimeScale(_arg_1);
      }
      
      public static function pauseAll(_arg_1:Boolean = true, _arg_2:Boolean = false) : void
      {
         changePause(true,_arg_1,_arg_2);
      }
      
      public static function killAllDelayedCalls(_arg_1:Boolean = false) : void
      {
         killAll(_arg_1,false,true);
      }
      
      public static function setGlobalTimeScale(_arg_1:Number) : void
      {
         var _local_2:int = 0;
         var _local_3:Array = null;
         if(_arg_1 < 0.00001)
         {
            _arg_1 = 0.00001;
         }
         var _local_4:Dictionary = masterList;
         _globalTimeScale = _arg_1;
         for each(_local_3 in _local_4)
         {
            _local_2 = _local_3.length - 1;
            while(_local_2 > -1)
            {
               if(_local_3[_local_2] is TweenMax)
               {
                  _local_3[_local_2].timeScale *= 1;
               }
               _local_2--;
            }
         }
      }
      
      public static function get globalTimeScale() : Number
      {
         return _globalTimeScale;
      }
      
      public static function getTweensOf(_arg_1:Object) : Array
      {
         var _local_2:TweenLite = null;
         var _local_3:int = 0;
         var _local_4:Array = masterList[_arg_1];
         var _local_5:Array = [];
         if(_local_4 != null)
         {
            _local_3 = _local_4.length - 1;
            while(_local_3 > -1)
            {
               if(!_local_4[_local_3].gc)
               {
                  _local_5[_local_5.length] = _local_4[_local_3];
               }
               _local_3--;
            }
         }
         for each(_local_2 in _pausedTweens)
         {
            if(_local_2.target == _arg_1)
            {
               _local_5[_local_5.length] = _local_2;
            }
         }
         return _local_5;
      }
      
      public static function delayedCall(_arg_1:Number, _arg_2:Function, _arg_3:Array = null, _arg_4:Boolean = false) : TweenMax
      {
         return new TweenMax(_arg_2,0,{
            "delay":_arg_1,
            "onComplete":_arg_2,
            "onCompleteParams":_arg_3,
            "persist":_arg_4,
            "overwrite":0
         });
      }
      
      public static function isTweening(_arg_1:Object) : Boolean
      {
         var _local_2:Array = getTweensOf(_arg_1);
         var _local_3:int = _local_2.length - 1;
         while(_local_3 > -1)
         {
            if((_local_2[_local_3].active || _local_2[_local_3].startTime == currentTime) && !_local_2[_local_3].gc)
            {
               return true;
            }
            _local_3--;
         }
         return false;
      }
      
      public static function changePause(_arg_1:Boolean, _arg_2:Boolean = true, _arg_3:Boolean = false) : void
      {
         var _local_4:Boolean = false;
         var _local_5:Array = getAllTweens();
         var _local_6:int = _local_5.length - 1;
         while(_local_6 > -1)
         {
            _local_4 = _local_5[_local_6].target == _local_5[_local_6].vars.onComplete;
            if(_local_5[_local_6] is TweenMax && (_local_4 == _arg_3 || _local_4 != _arg_2))
            {
               _local_5[_local_6].paused = _arg_1;
            }
            _local_6--;
         }
      }
      
      public static function killAllTweens(_arg_1:Boolean = false) : void
      {
         killAll(_arg_1,true,false);
      }
      
      public static function from(_arg_1:Object, _arg_2:Number, _arg_3:Object) : TweenMax
      {
         _arg_3.runBackwards = true;
         return new TweenMax(_arg_1,_arg_2,_arg_3);
      }
      
      public static function killAll(_arg_1:Boolean = false, _arg_2:Boolean = true, _arg_3:Boolean = true) : void
      {
         var _local_4:Boolean = false;
         var _local_5:int = 0;
         var _local_6:Array = getAllTweens();
         _local_5 = _local_6.length - 1;
         while(_local_5 > -1)
         {
            _local_4 = _local_6[_local_5].target == _local_6[_local_5].vars.onComplete;
            if(_local_4 == _arg_3 || _local_4 != _arg_2)
            {
               if(_arg_1)
               {
                  _local_6[_local_5].complete(false);
                  _local_6[_local_5].clear();
               }
               else
               {
                  TweenLite.removeTween(_local_6[_local_5],true);
               }
            }
            _local_5--;
         }
      }
      
      public static function getAllTweens() : Array
      {
         var _local_1:Array = null;
         var _local_2:int = 0;
         var _local_3:TweenLite = null;
         var _local_4:Dictionary = masterList;
         var _local_5:Array = [];
         for each(_local_1 in _local_4)
         {
            _local_2 = _local_1.length - 1;
            while(_local_2 > -1)
            {
               if(!_local_1[_local_2].gc)
               {
                  _local_5[_local_5.length] = _local_1[_local_2];
               }
               _local_2--;
            }
         }
         for each(_local_3 in _pausedTweens)
         {
            _local_5[_local_5.length] = _local_3;
         }
         return _local_5;
      }
      
      public static function resumeAll(_arg_1:Boolean = true, _arg_2:Boolean = false) : void
      {
         changePause(false,_arg_1,_arg_2);
      }
      
      public static function to(_arg_1:Object, _arg_2:Number, _arg_3:Object) : TweenMax
      {
         return new TweenMax(_arg_1,_arg_2,_arg_3);
      }
      
      public function dispatchEvent(_arg_1:Event) : Boolean
      {
         if(this._dispatcher == null)
         {
            return false;
         }
         return this._dispatcher.dispatchEvent(_arg_1);
      }
      
      public function get reversed() : Boolean
      {
         return this.ease == this.reverseEase;
      }
      
      public function set reversed(_arg_1:Boolean) : void
      {
         if(this.reversed != _arg_1)
         {
            this.reverse();
         }
      }
      
      public function get progress() : Number
      {
         var _local_1:Number = !isNaN(this.pauseTime) ? this.pauseTime : currentTime;
         var _local_2:Number = ((_local_1 - this.initTime) * 0.001 - this.delay / this.combinedTimeScale) / this.duration * this.combinedTimeScale;
         if(_local_2 > 1)
         {
            return 1;
         }
         if(_local_2 < 0)
         {
            return 0;
         }
         return _local_2;
      }
      
      override public function set enabled(_arg_1:Boolean) : void
      {
         if(!_arg_1)
         {
            _pausedTweens[this] = null;
            delete _pausedTweens[this];
         }
         super.enabled = _arg_1;
         if(_arg_1)
         {
            this.combinedTimeScale = this._timeScale * _globalTimeScale;
         }
      }
      
      protected function onStartDispatcher(... _args) : void
      {
         if(this._callbacks.onStart != null)
         {
            this._callbacks.onStart.apply(null,this.vars.onStartParams);
         }
         this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
      }
      
      public function setDestination(_arg_1:String, _arg_2:*, _arg_3:Boolean = true) : void
      {
         var _local_4:int = 0;
         var _local_5:TweenInfo = null;
         var _local_6:Object = null;
         var _local_7:Object = null;
         var _local_8:Array = null;
         var _local_9:Boolean = false;
         var _local_10:Array = null;
         var _local_11:Object = null;
         var _local_12:Number = this.progress;
         if(this.initted)
         {
            if(!_arg_3)
            {
               _local_4 = this.tweens.length - 1;
               while(_local_4 > -1)
               {
                  _local_5 = this.tweens[_local_4];
                  if(_local_5.name == _arg_1)
                  {
                     _local_5.target[_local_5.property] = _local_5.start;
                  }
                  _local_4--;
               }
            }
            _local_6 = this.vars;
            _local_7 = this.exposedVars;
            _local_8 = this.tweens;
            _local_9 = _hasPlugins;
            this.tweens = [];
            this.vars = this.exposedVars = {};
            this.vars[_arg_1] = _arg_2;
            this.initTweenVals();
            if(this.ease != this.reverseEase && _local_6.ease is Function)
            {
               this.ease = _local_6.ease;
            }
            if(_arg_3 && _local_12 != 0)
            {
               this.adjustStartValues();
            }
            _local_10 = this.tweens;
            this.vars = _local_6;
            this.exposedVars = _local_7;
            this.tweens = _local_8;
            _local_11 = {};
            _local_11[_arg_1] = true;
            _local_4 = this.tweens.length - 1;
            while(_local_4 > -1)
            {
               _local_5 = this.tweens[_local_4];
               if(_local_5.name == _arg_1)
               {
                  this.tweens.splice(_local_4,1);
               }
               else if(_local_5.isPlugin && _local_5.name == "_MULTIPLE_")
               {
                  _local_5.target.killProps(_local_11);
                  if(_local_5.target.overwriteProps.length == 0)
                  {
                     this.tweens.splice(_local_4,1);
                  }
               }
               _local_4--;
            }
            this.tweens = this.tweens.concat(_local_10);
            _hasPlugins = Boolean(_local_9 || _hasPlugins);
         }
         this.vars[_arg_1] = this.exposedVars[_arg_1] = _arg_2;
      }
      
      override public function initTweenVals() : void
      {
         var _local_1:int = 0;
         var _local_2:int = 0;
         var _local_3:String = null;
         var _local_4:String = null;
         var _local_5:Array = null;
         var _local_6:Object = null;
         var _local_7:TweenInfo = null;
         if(this.exposedVars.startAt != null && this.delay != 0)
         {
            this.exposedVars.startAt.overwrite = 0;
            new TweenMax(this.target,0,this.exposedVars.startAt);
         }
         super.initTweenVals();
         if(this.exposedVars.roundProps is Array && TweenLite.plugins.roundProps != null)
         {
            _local_5 = this.exposedVars.roundProps;
            _local_1 = _local_5.length - 1;
            while(_local_1 > -1)
            {
               _local_3 = _local_5[_local_1];
               _local_2 = this.tweens.length - 1;
               while(_local_2 > -1)
               {
                  _local_7 = this.tweens[_local_2];
                  if(_local_7.name == _local_3)
                  {
                     if(_local_7.isPlugin)
                     {
                        _local_7.target.round = true;
                     }
                     else if(_local_6 == null)
                     {
                        _local_6 = new TweenLite.plugins.roundProps();
                        _local_6.add(_local_7.target,_local_3,_local_7.start,_local_7.change);
                        _hasPlugins = true;
                        this.tweens[_local_2] = new TweenInfo(_local_6,"changeFactor",0,1,_local_3,true);
                     }
                     else
                     {
                        _local_6.add(_local_7.target,_local_3,_local_7.start,_local_7.change);
                        this.tweens.splice(_local_2,1);
                     }
                  }
                  else if(_local_7.isPlugin && _local_7.name == "_MULTIPLE_" && !_local_7.target.round)
                  {
                     _local_4 = " " + _local_7.target.overwriteProps.join(" ") + " ";
                     if(_local_4.indexOf(" " + _local_3 + " ") != -1)
                     {
                        _local_7.target.round = true;
                     }
                  }
                  _local_2--;
               }
               _local_1--;
            }
         }
      }
      
      public function restart(_arg_1:Boolean = false) : void
      {
         if(_arg_1)
         {
            this.initTime = currentTime;
            this.startTime = currentTime + this.delay * (1000 / this.combinedTimeScale);
         }
         else
         {
            this.startTime = currentTime;
            this.initTime = currentTime - this.delay * (1000 / this.combinedTimeScale);
         }
         this._repeatCount = 0;
         if(this.target != this.vars.onComplete)
         {
            this.render(this.startTime);
         }
         this.pauseTime = NaN;
         _pausedTweens[this] = null;
         delete _pausedTweens[this];
         this.enabled = true;
      }
      
      public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         if(this._dispatcher != null)
         {
            this._dispatcher.removeEventListener(_arg_1,_arg_2,_arg_3);
         }
      }
      
      public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         if(this._dispatcher == null)
         {
            this.initDispatcher();
         }
         if(_arg_1 == TweenEvent.UPDATE && this.vars.onUpdate != this.onUpdateDispatcher)
         {
            this.vars.onUpdate = this.onUpdateDispatcher;
            _hasUpdate = true;
         }
         this._dispatcher.addEventListener(_arg_1,_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      protected function adjustStartValues() : void
      {
         var _local_4:TweenInfo = null;
         var _local_5:int = 0;
         var _local_1:Number = NaN;
         var _local_2:Number = NaN;
         var _local_3:Number = NaN;
         var _local_6:Number = this.progress;
         if(_local_6 != 0)
         {
            _local_1 = this.ease(_local_6,0,1,1);
            _local_2 = 1 / (1 - _local_1);
            _local_5 = this.tweens.length - 1;
            while(_local_5 > -1)
            {
               _local_4 = this.tweens[_local_5];
               _local_3 = _local_4.start + _local_4.change;
               if(_local_4.isPlugin)
               {
                  _local_4.change = (_local_3 - _local_1) * _local_2;
               }
               else
               {
                  _local_4.change = (_local_3 - _local_4.target[_local_4.property]) * _local_2;
               }
               _local_4.start = _local_3 - _local_4.change;
               _local_5--;
            }
         }
      }
      
      override public function render(_arg_1:uint) : void
      {
         var _local_3:TweenInfo = null;
         var _local_4:int = 0;
         var _local_2:Number = NaN;
         var _local_5:Number = (_arg_1 - this.startTime) * 0.001 * this.combinedTimeScale;
         if(_local_5 >= this.duration)
         {
            _local_5 = this.duration;
            _local_2 = this.ease == this.vars.ease || this.duration == 0.001 ? 1 : 0;
         }
         else
         {
            _local_2 = this.ease(_local_5,0,1,this.duration);
         }
         _local_4 = this.tweens.length - 1;
         while(_local_4 > -1)
         {
            _local_3 = this.tweens[_local_4];
            _local_3.target[_local_3.property] = _local_3.start + _local_2 * _local_3.change;
            _local_4--;
         }
         if(_hasUpdate)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(_local_5 == this.duration)
         {
            this.complete(true);
         }
      }
      
      protected function initDispatcher() : void
      {
         var _local_1:Object = null;
         var _local_2:String = null;
         if(this._dispatcher == null)
         {
            this._dispatcher = new EventDispatcher(this);
            this._callbacks = {
               "onStart":this.vars.onStart,
               "onUpdate":this.vars.onUpdate,
               "onComplete":this.vars.onComplete
            };
            if(this.vars.isTV == true)
            {
               this.vars = this.vars.clone();
            }
            else
            {
               _local_1 = {};
               for(_local_2 in this.vars)
               {
                  _local_1[_local_2] = this.vars[_local_2];
               }
               this.vars = _local_1;
            }
            this.vars.onStart = this.onStartDispatcher;
            this.vars.onComplete = this.onCompleteDispatcher;
            if(this.vars.onStartListener is Function)
            {
               this._dispatcher.addEventListener(TweenEvent.START,this.vars.onStartListener,false,0,true);
            }
            if(this.vars.onUpdateListener is Function)
            {
               this._dispatcher.addEventListener(TweenEvent.UPDATE,this.vars.onUpdateListener,false,0,true);
               this.vars.onUpdate = this.onUpdateDispatcher;
               _hasUpdate = true;
            }
            if(this.vars.onCompleteListener is Function)
            {
               this._dispatcher.addEventListener(TweenEvent.COMPLETE,this.vars.onCompleteListener,false,0,true);
            }
         }
      }
      
      public function willTrigger(_arg_1:String) : Boolean
      {
         if(this._dispatcher == null)
         {
            return false;
         }
         return this._dispatcher.willTrigger(_arg_1);
      }
      
      public function set progress(_arg_1:Number) : void
      {
         this.startTime = currentTime - this.duration * _arg_1 * 1000;
         this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
         if(!this.started)
         {
            activate();
         }
         this.render(currentTime);
         if(!isNaN(this.pauseTime))
         {
            this.pauseTime = currentTime;
            this.startTime = 999999999999999;
            this.active = false;
         }
      }
      
      public function reverse(_arg_1:Boolean = true, _arg_2:Boolean = true) : void
      {
         this.ease = this.vars.ease == this.ease ? this.reverseEase : this.vars.ease;
         var _local_3:Number = this.progress;
         if(_arg_1 && _local_3 > 0)
         {
            this.startTime = currentTime - (1 - _local_3) * this.duration * 1000 / this.combinedTimeScale;
            this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
         }
         if(_arg_2 != false)
         {
            if(_local_3 < 1)
            {
               this.resume();
            }
            else
            {
               this.restart();
            }
         }
      }
      
      protected function onUpdateDispatcher(... _args) : void
      {
         if(this._callbacks.onUpdate != null)
         {
            this._callbacks.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
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
      
      public function resume() : void
      {
         this.enabled = true;
         if(!isNaN(this.pauseTime))
         {
            this.initTime += currentTime - this.pauseTime;
            this.startTime = this.initTime + this.delay * (1000 / this.combinedTimeScale);
            this.pauseTime = NaN;
            if(!this.started && currentTime >= this.startTime)
            {
               activate();
            }
            else
            {
               this.active = this.started;
            }
            _pausedTweens[this] = null;
            delete _pausedTweens[this];
         }
      }
      
      public function get paused() : Boolean
      {
         return !isNaN(this.pauseTime);
      }
      
      public function reverseEase(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number) : Number
      {
         return this.vars.ease(_arg_4 - _arg_1,_arg_2,_arg_3,_arg_4);
      }
      
      public function killProperties(_arg_1:Array) : void
      {
         var _local_2:int = 0;
         var _local_3:Object = {};
         _local_2 = _arg_1.length - 1;
         while(_local_2 > -1)
         {
            _local_3[_arg_1[_local_2]] = true;
            _local_2--;
         }
         killVars(_local_3);
      }
      
      public function hasEventListener(_arg_1:String) : Boolean
      {
         if(this._dispatcher == null)
         {
            return false;
         }
         return this._dispatcher.hasEventListener(_arg_1);
      }
      
      public function pause() : void
      {
         if(isNaN(this.pauseTime))
         {
            this.pauseTime = currentTime;
            this.startTime = 999999999999999;
            this.enabled = false;
            _pausedTweens[this] = this;
         }
      }
      
      override public function complete(_arg_1:Boolean = false) : void
      {
         if(!isNaN(this.vars.yoyo) && (this._repeatCount < this.vars.yoyo || this.vars.yoyo == 0) || !isNaN(this.vars.loop) && (this._repeatCount < this.vars.loop || this.vars.loop == 0))
         {
            ++this._repeatCount;
            if(!isNaN(this.vars.yoyo))
            {
               this.ease = this.vars.ease == this.ease ? this.reverseEase : this.vars.ease;
            }
            this.startTime = _arg_1 ? this.startTime + this.duration * (1000 / this.combinedTimeScale) : currentTime;
            this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
         }
         else if(this.vars.persist == true)
         {
            this.pause();
         }
         super.complete(_arg_1);
      }
      
      public function set timeScale(_arg_1:Number) : void
      {
         if(_arg_1 < 0.00001)
         {
            this._timeScale = 0.00001;
            _arg_1 = 0.00001;
         }
         else
         {
            this._timeScale = _arg_1;
            _arg_1 *= _globalTimeScale;
         }
         this.initTime = currentTime - (currentTime - this.initTime - this.delay * (1000 / this.combinedTimeScale)) * this.combinedTimeScale * (1 / _arg_1) - this.delay * (1000 / _arg_1);
         if(this.startTime != 999999999999999)
         {
            this.startTime = this.initTime + this.delay * (1000 / _arg_1);
         }
         this.combinedTimeScale = _arg_1;
      }
      
      public function invalidate(_arg_1:Boolean = true) : void
      {
         var _local_2:Number = NaN;
         if(this.initted)
         {
            _local_2 = this.progress;
            if(!_arg_1 && _local_2 != 0)
            {
               this.progress = 0;
            }
            this.tweens = [];
            _hasPlugins = false;
            this.exposedVars = this.vars.isTV == true ? this.vars.exposedProps : this.vars;
            this.initTweenVals();
            this._timeScale = Number(this.vars.timeScale) || 1;
            this.combinedTimeScale = this._timeScale * _globalTimeScale;
            this.delay = Number(this.vars.delay) || 0;
            if(isNaN(this.pauseTime))
            {
               this.startTime = this.initTime + this.delay * 1000 / this.combinedTimeScale;
            }
            if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
            {
               if(this._dispatcher != null)
               {
                  this.vars.onStart = this._callbacks.onStart;
                  this.vars.onUpdate = this._callbacks.onUpdate;
                  this.vars.onComplete = this._callbacks.onComplete;
                  this._dispatcher = null;
               }
               this.initDispatcher();
            }
            if(_local_2 != 0)
            {
               if(_arg_1)
               {
                  this.adjustStartValues();
               }
               else
               {
                  this.progress = _local_2;
               }
            }
         }
      }
      
      public function get timeScale() : Number
      {
         return this._timeScale;
      }
      
      protected function onCompleteDispatcher(... _args) : void
      {
         if(this._callbacks.onComplete != null)
         {
            this._callbacks.onComplete.apply(null,this.vars.onCompleteParams);
         }
         this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
      }
   }
}

