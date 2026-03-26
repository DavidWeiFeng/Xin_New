package gs.utils.tween
{
   public class GlowFilterVars extends FilterVars
   {
      
      protected var _quality:uint;
      
      protected var _blurY:Number;
      
      protected var _inner:Boolean;
      
      protected var _blurX:Number;
      
      protected var _alpha:Number;
      
      protected var _strength:Number;
      
      protected var _color:uint;
      
      protected var _knockout:Boolean;
      
      public function GlowFilterVars(_arg_1:Number = 10, _arg_2:Number = 10, _arg_3:uint = 16777215, _arg_4:Number = 1, _arg_5:Number = 2, _arg_6:Boolean = false, _arg_7:Boolean = false, _arg_8:uint = 2, _arg_9:Boolean = false, _arg_10:int = -1, _arg_11:Boolean = false)
      {
         super(_arg_9,_arg_10,_arg_11);
         this.blurX = _arg_1;
         this.blurY = _arg_2;
         this.color = _arg_3;
         this.alpha = _arg_4;
         this.strength = _arg_5;
         this.inner = _arg_6;
         this.knockout = _arg_7;
         this.quality = _arg_8;
      }
      
      public static function createFromGeneric(_arg_1:Object) : GlowFilterVars
      {
         if(_arg_1 is GlowFilterVars)
         {
            return _arg_1 as GlowFilterVars;
         }
         return new GlowFilterVars(Number(_arg_1.blurX) || 0,Number(_arg_1.blurY) || 0,_arg_1.color == null ? 0 : uint(_arg_1.color),Number(_arg_1.alpha) || 0,_arg_1.strength == null ? 2 : Number(_arg_1.strength),Boolean(_arg_1.inner),Boolean(_arg_1.knockout),uint(_arg_1.quality) || 2,Boolean(_arg_1.remove),_arg_1.index == null ? -1 : int(_arg_1.index),Boolean(_arg_1.addFilter));
      }
      
      public function get strength() : Number
      {
         return this._strength;
      }
      
      public function set strength(_arg_1:Number) : void
      {
         this._strength = this.exposedVars.strength = _arg_1;
      }
      
      public function set quality(_arg_1:uint) : void
      {
         this._quality = this.exposedVars.quality = _arg_1;
      }
      
      public function set color(_arg_1:uint) : void
      {
         this._color = this.exposedVars.color = _arg_1;
      }
      
      public function get blurX() : Number
      {
         return this._blurX;
      }
      
      public function get blurY() : Number
      {
         return this._blurY;
      }
      
      public function get inner() : Boolean
      {
         return this._inner;
      }
      
      public function set blurY(_arg_1:Number) : void
      {
         this._blurY = this.exposedVars.blurY = _arg_1;
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set blurX(_arg_1:Number) : void
      {
         this._blurX = this.exposedVars.blurX = _arg_1;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set inner(_arg_1:Boolean) : void
      {
         this._inner = this.exposedVars.inner = _arg_1;
      }
      
      public function set knockout(_arg_1:Boolean) : void
      {
         this._knockout = this.exposedVars.knockout = _arg_1;
      }
      
      public function get knockout() : Boolean
      {
         return this._knockout;
      }
      
      public function set alpha(_arg_1:Number) : void
      {
         this._alpha = this.exposedVars.alpha = _arg_1;
      }
      
      public function get quality() : uint
      {
         return this._quality;
      }
   }
}

