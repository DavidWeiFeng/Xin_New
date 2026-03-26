package gs.utils.tween
{
   import gs.plugins.*;
   
   public class ColorMatrixFilterVars extends FilterVars
   {
      
      protected static var _ID_MATRIX:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
      
      protected static var _lumR:Number = 0.212671;
      
      protected static var _lumG:Number = 0.71516;
      
      protected static var _lumB:Number = 0.072169;
      
      public var matrix:Array;
      
      public function ColorMatrixFilterVars(_arg_1:uint = 16777215, _arg_2:Number = 1, _arg_3:Number = 1, _arg_4:Number = 1, _arg_5:Number = 1, _arg_6:Number = 0, _arg_7:Number = -1, _arg_8:Boolean = false, _arg_9:int = -1, _arg_10:Boolean = false)
      {
         super(_arg_8,_arg_9,_arg_10);
         this.matrix = _ID_MATRIX.slice();
         if(_arg_5 != 1)
         {
            this.setBrightness(_arg_5);
         }
         if(_arg_4 != 1)
         {
            this.setContrast(_arg_4);
         }
         if(_arg_6 != 0)
         {
            this.setHue(_arg_6);
         }
         if(_arg_3 != 1)
         {
            this.setSaturation(_arg_3);
         }
         if(_arg_7 != -1)
         {
            this.setThreshold(_arg_7);
         }
         if(_arg_1 != 16777215)
         {
            this.setColorize(_arg_1,_arg_2);
         }
      }
      
      public static function createFromGeneric(_arg_1:Object) : ColorMatrixFilterVars
      {
         var _local_2:ColorMatrixFilterVars = null;
         if(_arg_1 is ColorMatrixFilterVars)
         {
            _local_2 = _arg_1 as ColorMatrixFilterVars;
         }
         else if(_arg_1.matrix != null)
         {
            _local_2 = new ColorMatrixFilterVars();
            _local_2.matrix = _arg_1.matrix;
         }
         else
         {
            _local_2 = new ColorMatrixFilterVars(uint(_arg_1.colorize) || 16777215,_arg_1.amount == null ? 1 : Number(_arg_1.amount),_arg_1.saturation == null ? 1 : Number(_arg_1.saturation),_arg_1.contrast == null ? 1 : Number(_arg_1.contrast),_arg_1.brightness == null ? 1 : Number(_arg_1.brightness),Number(_arg_1.hue) || 0,_arg_1.threshold == null ? -1 : Number(_arg_1.threshold),Boolean(_arg_1.remove),_arg_1.index == null ? -1 : int(_arg_1.index),Boolean(_arg_1.addFilter));
         }
         return _local_2;
      }
      
      public function setContrast(_arg_1:Number) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.setContrast(this.matrix,_arg_1);
      }
      
      public function setColorize(_arg_1:uint, _arg_2:Number = 1) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.colorize(this.matrix,_arg_1,_arg_2);
      }
      
      public function setHue(_arg_1:Number) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.setHue(this.matrix,_arg_1);
      }
      
      public function setThreshold(_arg_1:Number) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.setThreshold(this.matrix,_arg_1);
      }
      
      public function setBrightness(_arg_1:Number) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.setBrightness(this.matrix,_arg_1);
      }
      
      public function setSaturation(_arg_1:Number) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.setSaturation(this.matrix,_arg_1);
      }
   }
}

