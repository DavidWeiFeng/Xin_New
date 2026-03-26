package gs.utils.tween
{
   public class DropShadowFilterVars extends FilterVars
   {
      
      protected var _blurX:Number;
      
      protected var _blurY:Number;
      
      protected var _distance:Number;
      
      protected var _inner:Boolean;
      
      protected var _quality:uint;
      
      protected var _knockout:Boolean;
      
      protected var _angle:Number;
      
      protected var _alpha:Number;
      
      protected var _strength:Number;
      
      protected var _hideObject:Boolean;
      
      protected var _color:uint;
      
      public function DropShadowFilterVars(_arg_1:Number = 4, _arg_2:Number = 4, _arg_3:Number = 4, _arg_4:Number = 1, _arg_5:Number = 45, _arg_6:uint = 0, _arg_7:Number = 2, _arg_8:Boolean = false, _arg_9:Boolean = false, _arg_10:Boolean = false, _arg_11:uint = 2, _arg_12:Boolean = false, _arg_13:int = -1, _arg_14:Boolean = false)
      {
         super(_arg_12,_arg_13,_arg_14);
         this.distance = _arg_1;
         this.blurX = _arg_2;
         this.blurY = _arg_3;
         this.alpha = _arg_4;
         this.angle = _arg_5;
         this.color = _arg_6;
         this.strength = _arg_7;
         this.inner = _arg_8;
         this.knockout = _arg_9;
         this.hideObject = _arg_10;
         this.quality = _arg_11;
      }
      
      public static function createFromGeneric(_arg_1:Object) : DropShadowFilterVars
      {
         if(_arg_1 is DropShadowFilterVars)
         {
            return _arg_1 as DropShadowFilterVars;
         }
         return new DropShadowFilterVars(Number(_arg_1.distance) || 0,Number(_arg_1.blurX) || 0,Number(_arg_1.blurY) || 0,Number(_arg_1.alpha) || 0,_arg_1.angle == null ? 45 : Number(_arg_1.angle),_arg_1.color == null ? 0 : uint(_arg_1.color),_arg_1.strength == null ? 2 : Number(_arg_1.strength),Boolean(_arg_1.inner),Boolean(_arg_1.knockout),Boolean(_arg_1.hideObject),uint(_arg_1.quality) || 2,Boolean(_arg_1.remove),_arg_1.index == null ? -1 : int(_arg_1.index),_arg_1.addFilter);
      }
      
      public function get strength() : Number
      {
         return this._strength;
      }
      
      public function set strength(_arg_1:Number) : void
      {
         this._strength = this.exposedVars.strength = _arg_1;
      }
      
      public function set alpha(_arg_1:Number) : void
      {
         this._alpha = this.exposedVars.alpha = _arg_1;
      }
      
      public function set quality(_arg_1:uint) : void
      {
         this._quality = this.exposedVars.quality = _arg_1;
      }
      
      public function set color(_arg_1:uint) : void
      {
         this._color = this.exposedVars.color = _arg_1;
      }
      
      public function set hideObject(_arg_1:Boolean) : void
      {
         this._hideObject = this.exposedVars.hideObject = _arg_1;
      }
      
      public function get blurX() : Number
      {
         return this._blurX;
      }
      
      public function get inner() : Boolean
      {
         return this._inner;
      }
      
      public function get angle() : Number
      {
         return this._angle;
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function get blurY() : Number
      {
         return this._blurY;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set blurX(_arg_1:Number) : void
      {
         this._blurX = this.exposedVars.blurX = _arg_1;
      }
      
      public function set distance(_arg_1:Number) : void
      {
         this._distance = this.exposedVars.distance = _arg_1;
      }
      
      public function set inner(_arg_1:Boolean) : void
      {
         this._inner = this.exposedVars.inner = _arg_1;
      }
      
      public function set angle(_arg_1:Number) : void
      {
         this._angle = this.exposedVars.angle = _arg_1;
      }
      
      public function get hideObject() : Boolean
      {
         return this._hideObject;
      }
      
      public function set knockout(_arg_1:Boolean) : void
      {
         this._knockout = this.exposedVars.knockout = _arg_1;
      }
      
      public function get distance() : Number
      {
         return this._distance;
      }
      
      public function get knockout() : Boolean
      {
         return this._knockout;
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

