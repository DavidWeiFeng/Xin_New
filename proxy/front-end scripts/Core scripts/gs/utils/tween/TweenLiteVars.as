package gs.utils.tween
{
   import gs.*;
   
   public dynamic class TweenLiteVars
   {
      
      public static const version:Number = 2.03;
      
      public const isTV:Boolean = true;
      
      protected var _glowFilter:GlowFilterVars;
      
      protected var _transformAroundCenter:TransformAroundCenterVars;
      
      public var easeParams:Array;
      
      protected var _shortRotation:Object;
      
      protected var _colorMatrixFilter:ColorMatrixFilterVars;
      
      protected var _frameLabel:String;
      
      public var onStartParams:Array;
      
      public var onUpdateParams:Array;
      
      protected var _visible:Boolean = true;
      
      public var startAt:TweenLiteVars;
      
      public var onComplete:Function;
      
      protected var _volume:Number;
      
      protected var _setSize:Object;
      
      protected var _removeTint:Boolean;
      
      public var renderOnStart:Boolean = false;
      
      protected var _quaternions:Object;
      
      protected var _blurFilter:BlurFilterVars;
      
      protected var _colorTransform:ColorTransformVars;
      
      protected var _frame:int;
      
      protected var _autoAlpha:Number;
      
      public var delay:Number = 0;
      
      public var onUpdate:Function;
      
      public var overwrite:int = 2;
      
      protected var _transformAroundPoint:TransformAroundPointVars;
      
      protected var _endArray:Array;
      
      public var runBackwards:Boolean = false;
      
      protected var _exposedVars:Object;
      
      protected var _dropShadowFilter:DropShadowFilterVars;
      
      protected var _orientToBezier:Array;
      
      public var onStart:Function;
      
      protected var _bevelFilter:BevelFilterVars;
      
      public var persist:Boolean = false;
      
      protected var _tint:uint;
      
      public var onCompleteParams:Array;
      
      protected var _bezierThrough:Array;
      
      protected var _hexColors:Object;
      
      public var ease:Function;
      
      protected var _bezier:Array;
      
      public function TweenLiteVars(_arg_1:Object = null)
      {
         var _local_2:String = null;
         var _local_3:Object = null;
         super();
         this._exposedVars = {};
         if(_arg_1 != null)
         {
            for(_local_2 in _arg_1)
            {
               if(!(_local_2 == "blurFilter" || _local_2 == "glowFilter" || _local_2 == "colorMatrixFilter" || _local_2 == "bevelFilter" || _local_2 == "dropShadowFilter" || _local_2 == "transformAroundPoint" || _local_2 == "transformAroundCenter" || _local_2 == "colorTransform"))
               {
                  if(_local_2 != "protectedVars")
                  {
                     this[_local_2] = _arg_1[_local_2];
                  }
               }
            }
            if(_arg_1.blurFilter != null)
            {
               this.blurFilter = BlurFilterVars.createFromGeneric(_arg_1.blurFilter);
            }
            if(_arg_1.bevelFilter != null)
            {
               this.bevelFilter = BevelFilterVars.createFromGeneric(_arg_1.bevelFilter);
            }
            if(_arg_1.colorMatrixFilter != null)
            {
               this.colorMatrixFilter = ColorMatrixFilterVars.createFromGeneric(_arg_1.colorMatrixFilter);
            }
            if(_arg_1.dropShadowFilter != null)
            {
               this.dropShadowFilter = DropShadowFilterVars.createFromGeneric(_arg_1.dropShadowFilter);
            }
            if(_arg_1.glowFilter != null)
            {
               this.glowFilter = GlowFilterVars.createFromGeneric(_arg_1.glowFilter);
            }
            if(_arg_1.transformAroundPoint != null)
            {
               this.transformAroundPoint = TransformAroundPointVars.createFromGeneric(_arg_1.transformAroundPoint);
            }
            if(_arg_1.transformAroundCenter != null)
            {
               this.transformAroundCenter = TransformAroundCenterVars.createFromGeneric(_arg_1.transformAroundCenter);
            }
            if(_arg_1.colorTransform != null)
            {
               this.colorTransform = ColorTransformVars.createFromGeneric(_arg_1.colorTransform);
            }
            if(_arg_1.protectedVars != null)
            {
               _local_3 = _arg_1.protectedVars;
               for(_local_2 in _local_3)
               {
                  this[_local_2] = _local_3[_local_2];
               }
            }
         }
         if(TweenLite.version < 10.05)
         {
         }
      }
      
      public function set setSize(_arg_1:Object) : void
      {
         this._setSize = this._exposedVars.setSize = _arg_1;
      }
      
      public function set frameLabel(_arg_1:String) : void
      {
         this._frameLabel = this._exposedVars.frameLabel = _arg_1;
      }
      
      public function get quaternions() : Object
      {
         return this._quaternions;
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set transformAroundCenter(_arg_1:TransformAroundCenterVars) : void
      {
         this._transformAroundCenter = this._exposedVars.transformAroundCenter = _arg_1;
      }
      
      public function get shortRotation() : Object
      {
         return this._shortRotation;
      }
      
      public function set bevelFilter(_arg_1:BevelFilterVars) : void
      {
         this._bevelFilter = this._exposedVars.bevelFilter = _arg_1;
      }
      
      public function set quaternions(_arg_1:Object) : void
      {
         this._quaternions = this._exposedVars.quaternions = _arg_1;
      }
      
      protected function appendCloneVars(_arg_1:Object, _arg_2:Object) : void
      {
         var _local_3:Array = null;
         var _local_4:Array = null;
         var _local_5:int = 0;
         var _local_6:String = null;
         _local_3 = ["delay","ease","easeParams","onStart","onStartParams","onUpdate","onUpdateParams","onComplete","onCompleteParams","overwrite","persist","renderOnStart","runBackwards","startAt"];
         _local_5 = _local_3.length - 1;
         while(_local_5 > -1)
         {
            _arg_1[_local_3[_local_5]] = this[_local_3[_local_5]];
            _local_5--;
         }
         _local_4 = ["_autoAlpha","_bevelFilter","_bezier","_bezierThrough","_blurFilter","_colorMatrixFilter","_colorTransform","_dropShadowFilter","_endArray","_frame","_frameLabel","_glowFilter","_hexColors","_orientToBezier","_quaternions","_removeTint","_setSize","_shortRotation","_tint","_transformAroundCenter","_transformAroundPoint","_visible","_volume","_exposedVars"];
         _local_5 = _local_4.length - 1;
         while(_local_5 > -1)
         {
            _arg_2[_local_4[_local_5]] = this[_local_4[_local_5]];
            _local_5--;
         }
         for(_local_6 in this)
         {
            _arg_1[_local_6] = this[_local_6];
         }
      }
      
      public function get transformAroundCenter() : TransformAroundCenterVars
      {
         return this._transformAroundCenter;
      }
      
      public function set volume(_arg_1:Number) : void
      {
         this._volume = this._exposedVars.volume = _arg_1;
      }
      
      public function get endArray() : Array
      {
         return this._endArray;
      }
      
      public function set colorMatrixFilter(_arg_1:ColorMatrixFilterVars) : void
      {
         this._colorMatrixFilter = this._exposedVars.colorMatrixFilter = _arg_1;
      }
      
      public function set shortRotation(_arg_1:Object) : void
      {
         this._shortRotation = this._exposedVars.shortRotation = _arg_1;
      }
      
      public function set removeTint(_arg_1:Boolean) : void
      {
         this._removeTint = this._exposedVars.removeTint = _arg_1;
      }
      
      public function get dropShadowFilter() : DropShadowFilterVars
      {
         return this._dropShadowFilter;
      }
      
      public function get colorTransform() : ColorTransformVars
      {
         return this._colorTransform;
      }
      
      public function addProps(_arg_1:String, _arg_2:Number, _arg_3:Boolean = false, _arg_4:String = null, _arg_5:Number = 0, _arg_6:Boolean = false, _arg_7:String = null, _arg_8:Number = 0, _arg_9:Boolean = false, _arg_10:String = null, _arg_11:Number = 0, _arg_12:Boolean = false, _arg_13:String = null, _arg_14:Number = 0, _arg_15:Boolean = false, _arg_16:String = null, _arg_17:Number = 0, _arg_18:Boolean = false, _arg_19:String = null, _arg_20:Number = 0, _arg_21:Boolean = false, _arg_22:String = null, _arg_23:Number = 0, _arg_24:Boolean = false, _arg_25:String = null, _arg_26:Number = 0, _arg_27:Boolean = false, _arg_28:String = null, _arg_29:Number = 0, _arg_30:Boolean = false, _arg_31:String = null, _arg_32:Number = 0, _arg_33:Boolean = false, _arg_34:String = null, _arg_35:Number = 0, _arg_36:Boolean = false, _arg_37:String = null, _arg_38:Number = 0, _arg_39:Boolean = false, _arg_40:String = null, _arg_41:Number = 0, _arg_42:Boolean = false, _arg_43:String = null, _arg_44:Number = 0, _arg_45:Boolean = false) : void
      {
         this.addProp(_arg_1,_arg_2,_arg_3);
         if(_arg_4 != null)
         {
            this.addProp(_arg_4,_arg_5,_arg_6);
         }
         if(_arg_7 != null)
         {
            this.addProp(_arg_7,_arg_8,_arg_9);
         }
         if(_arg_10 != null)
         {
            this.addProp(_arg_10,_arg_11,_arg_12);
         }
         if(_arg_13 != null)
         {
            this.addProp(_arg_13,_arg_14,_arg_15);
         }
         if(_arg_16 != null)
         {
            this.addProp(_arg_16,_arg_17,_arg_18);
         }
         if(_arg_19 != null)
         {
            this.addProp(_arg_19,_arg_20,_arg_21);
         }
         if(_arg_22 != null)
         {
            this.addProp(_arg_22,_arg_23,_arg_24);
         }
         if(_arg_25 != null)
         {
            this.addProp(_arg_25,_arg_26,_arg_27);
         }
         if(_arg_28 != null)
         {
            this.addProp(_arg_28,_arg_29,_arg_30);
         }
         if(_arg_31 != null)
         {
            this.addProp(_arg_31,_arg_32,_arg_33);
         }
         if(_arg_34 != null)
         {
            this.addProp(_arg_34,_arg_35,_arg_36);
         }
         if(_arg_37 != null)
         {
            this.addProp(_arg_37,_arg_38,_arg_39);
         }
         if(_arg_40 != null)
         {
            this.addProp(_arg_40,_arg_41,_arg_42);
         }
         if(_arg_43 != null)
         {
            this.addProp(_arg_43,_arg_44,_arg_45);
         }
      }
      
      public function clone() : TweenLiteVars
      {
         var _local_1:Object = {"protectedVars":{}};
         this.appendCloneVars(_local_1,_local_1.protectedVars);
         return new TweenLiteVars(_local_1);
      }
      
      public function set orientToBezier(_arg_1:*) : void
      {
         if(_arg_1 is Array)
         {
            this._orientToBezier = this._exposedVars.orientToBezier = _arg_1;
         }
         else if(_arg_1 == true)
         {
            this._orientToBezier = this._exposedVars.orientToBezier = [["x","y","rotation",0]];
         }
         else
         {
            this._orientToBezier = null;
            delete this._exposedVars.orientToBezier;
         }
      }
      
      public function get glowFilter() : GlowFilterVars
      {
         return this._glowFilter;
      }
      
      public function get hexColors() : Object
      {
         return this._hexColors;
      }
      
      public function get exposedVars() : Object
      {
         var _local_1:String = null;
         var _local_2:Object = {};
         for(_local_1 in this._exposedVars)
         {
            _local_2[_local_1] = this._exposedVars[_local_1];
         }
         for(_local_1 in this)
         {
            _local_2[_local_1] = this[_local_1];
         }
         return _local_2;
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      public function set transformAroundPoint(_arg_1:TransformAroundPointVars) : void
      {
         this._transformAroundPoint = this._exposedVars.transformAroundPoint = _arg_1;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set endArray(_arg_1:Array) : void
      {
         this._endArray = this._exposedVars.endArray = _arg_1;
      }
      
      public function set blurFilter(_arg_1:BlurFilterVars) : void
      {
         this._blurFilter = this._exposedVars.blurFilter = _arg_1;
      }
      
      public function get frameLabel() : String
      {
         return this._frameLabel;
      }
      
      public function get setSize() : Object
      {
         return this._setSize;
      }
      
      public function set dropShadowFilter(_arg_1:DropShadowFilterVars) : void
      {
         this._dropShadowFilter = this._exposedVars.dropShadowFilter = _arg_1;
      }
      
      public function get bevelFilter() : BevelFilterVars
      {
         return this._bevelFilter;
      }
      
      public function set colorTransform(_arg_1:ColorTransformVars) : void
      {
         this._colorTransform = this._exposedVars.colorTransform = _arg_1;
      }
      
      public function get colorMatrixFilter() : ColorMatrixFilterVars
      {
         return this._colorMatrixFilter;
      }
      
      public function get removeTint() : Boolean
      {
         return this._removeTint;
      }
      
      public function addProp(_arg_1:String, _arg_2:Number, _arg_3:Boolean = false) : void
      {
         if(_arg_3)
         {
            this[_arg_1] = String(_arg_2);
         }
         else
         {
            this[_arg_1] = _arg_2;
         }
      }
      
      public function get orientToBezier() : *
      {
         return this._orientToBezier;
      }
      
      public function get transformAroundPoint() : TransformAroundPointVars
      {
         return this._transformAroundPoint;
      }
      
      public function get blurFilter() : BlurFilterVars
      {
         return this._blurFilter;
      }
      
      public function set bezier(_arg_1:Array) : void
      {
         this._bezier = this._exposedVars.bezier = _arg_1;
      }
      
      public function set glowFilter(_arg_1:GlowFilterVars) : void
      {
         this._glowFilter = this._exposedVars.glowFilter = _arg_1;
      }
      
      public function set bezierThrough(_arg_1:Array) : void
      {
         this._bezierThrough = this._exposedVars.bezierThrough = _arg_1;
      }
      
      public function set hexColors(_arg_1:Object) : void
      {
         this._hexColors = this._exposedVars.hexColors = _arg_1;
      }
      
      public function get bezier() : Array
      {
         return this._bezier;
      }
      
      public function set frame(_arg_1:int) : void
      {
         this._frame = this._exposedVars.frame = _arg_1;
      }
      
      public function set visible(_arg_1:Boolean) : void
      {
         this._visible = this._exposedVars.visible = _arg_1;
      }
      
      public function set autoAlpha(_arg_1:Number) : void
      {
         this._autoAlpha = this._exposedVars.autoAlpha = _arg_1;
      }
      
      public function get bezierThrough() : Array
      {
         return this._bezierThrough;
      }
      
      public function get autoAlpha() : Number
      {
         return this._autoAlpha;
      }
      
      public function set tint(_arg_1:uint) : void
      {
         this._tint = this._exposedVars.tint = _arg_1;
      }
      
      public function get tint() : uint
      {
         return this._tint;
      }
   }
}

