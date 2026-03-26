package gs.utils.tween
{
   public class BevelFilterVars extends FilterVars
   {
      
      protected var _quality:uint;
      
      protected var _blurY:Number;
      
      protected var _distance:Number;
      
      protected var _blurX:Number;
      
      protected var _angle:Number;
      
      protected var _shadowAlpha:Number;
      
      protected var _strength:Number;
      
      protected var _highlightAlpha:Number;
      
      protected var _shadowColor:uint;
      
      protected var _highlightColor:uint;
      
      public function BevelFilterVars(_arg_1:Number = 4, _arg_2:Number = 4, _arg_3:Number = 4, _arg_4:Number = 1, _arg_5:Number = 45, _arg_6:Number = 1, _arg_7:uint = 16777215, _arg_8:Number = 1, _arg_9:uint = 0, _arg_10:uint = 2, _arg_11:Boolean = false, _arg_12:int = -1, _arg_13:Boolean = false)
      {
         super(_arg_11,_arg_12,_arg_13);
         this.distance = _arg_1;
         this.blurX = _arg_2;
         this.blurY = _arg_3;
         this.strength = _arg_4;
         this.angle = _arg_5;
         this.highlightAlpha = _arg_6;
         this.highlightColor = _arg_7;
         this.shadowAlpha = _arg_8;
         this.shadowColor = _arg_9;
         this.quality = _arg_10;
      }
      
      public static function createFromGeneric(_arg_1:Object) : BevelFilterVars
      {
         if(_arg_1 is BevelFilterVars)
         {
            return _arg_1 as BevelFilterVars;
         }
         return new BevelFilterVars(Number(_arg_1.distance) || 0,Number(_arg_1.blurX) || 0,Number(_arg_1.blurY) || 0,_arg_1.strength == null ? 1 : Number(_arg_1.strength),_arg_1.angle == null ? 45 : Number(_arg_1.angle),_arg_1.highlightAlpha == null ? 1 : Number(_arg_1.highlightAlpha),_arg_1.highlightColor == null ? 16777215 : uint(_arg_1.highlightColor),_arg_1.shadowAlpha == null ? 1 : Number(_arg_1.shadowAlpha),_arg_1.shadowColor == null ? 16777215 : uint(_arg_1.shadowColor),uint(_arg_1.quality) || 2,Boolean(_arg_1.remove),_arg_1.index == null ? -1 : int(_arg_1.index),Boolean(_arg_1.addFilter));
      }
      
      public function get strength() : Number
      {
         return this._strength;
      }
      
      public function set strength(_arg_1:Number) : void
      {
         this._strength = this.exposedVars.strength = _arg_1;
      }
      
      public function set shadowAlpha(_arg_1:Number) : void
      {
         this._shadowAlpha = this.exposedVars.shadowAlpha = _arg_1;
      }
      
      public function set quality(_arg_1:uint) : void
      {
         this._quality = this.exposedVars.quality = _arg_1;
      }
      
      public function set shadowColor(_arg_1:uint) : void
      {
         this._shadowColor = this.exposedVars.shadowColor = _arg_1;
      }
      
      public function get highlightAlpha() : Number
      {
         return this._highlightAlpha;
      }
      
      public function get blurX() : Number
      {
         return this._blurX;
      }
      
      public function get highlightColor() : uint
      {
         return this._highlightColor;
      }
      
      public function get angle() : Number
      {
         return this._angle;
      }
      
      public function set highlightColor(_arg_1:uint) : void
      {
         this._highlightColor = this.exposedVars.highlightColor = _arg_1;
      }
      
      public function get blurY() : Number
      {
         return this._blurY;
      }
      
      public function set blurX(_arg_1:Number) : void
      {
         this._blurX = this.exposedVars.blurX = _arg_1;
      }
      
      public function set highlightAlpha(_arg_1:Number) : void
      {
         this._highlightAlpha = this.exposedVars.highlightAlpha = _arg_1;
      }
      
      public function get shadowAlpha() : Number
      {
         return this._shadowAlpha;
      }
      
      public function set distance(_arg_1:Number) : void
      {
         this._distance = this.exposedVars.distance = _arg_1;
      }
      
      public function set angle(_arg_1:Number) : void
      {
         this._angle = this.exposedVars.angle = _arg_1;
      }
      
      public function get shadowColor() : uint
      {
         return this._shadowColor;
      }
      
      public function get distance() : Number
      {
         return this._distance;
      }
      
      public function set blurY(_arg_1:Number) : void
      {
         this._blurY = this.exposedVars.blurY = _arg_1;
      }
      
      public function get quality() : uint
      {
         return this._quality;
      }
   }
}

