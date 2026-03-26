package gs.utils.tween
{
   public class BlurFilterVars extends FilterVars
   {
      
      protected var _quality:uint;
      
      protected var _blurX:Number;
      
      protected var _blurY:Number;
      
      public function BlurFilterVars(_arg_1:Number = 10, _arg_2:Number = 10, _arg_3:uint = 2, _arg_4:Boolean = false, _arg_5:int = -1, _arg_6:Boolean = false)
      {
         super(_arg_4,_arg_5,_arg_6);
         this.blurX = _arg_1;
         this.blurY = _arg_2;
         this.quality = _arg_3;
      }
      
      public static function createFromGeneric(_arg_1:Object) : BlurFilterVars
      {
         if(_arg_1 is BlurFilterVars)
         {
            return _arg_1 as BlurFilterVars;
         }
         return new BlurFilterVars(Number(_arg_1.blurX) || 0,Number(_arg_1.blurY) || 0,uint(_arg_1.quality) || 2,Boolean(_arg_1.remove),_arg_1.index == null ? -1 : int(_arg_1.index),Boolean(_arg_1.addFilter));
      }
      
      public function set blurX(_arg_1:Number) : void
      {
         this._blurX = this.exposedVars.blurX = _arg_1;
      }
      
      public function set blurY(_arg_1:Number) : void
      {
         this._blurY = this.exposedVars.blurY = _arg_1;
      }
      
      public function get blurX() : Number
      {
         return this._blurX;
      }
      
      public function get blurY() : Number
      {
         return this._blurY;
      }
      
      public function set quality(_arg_1:uint) : void
      {
         this._quality = this.exposedVars.quality = _arg_1;
      }
      
      public function get quality() : uint
      {
         return this._quality;
      }
   }
}

