package gs.utils.tween
{
   public class ColorTransformVars extends SubVars
   {
      
      public function ColorTransformVars(_arg_1:Number = NaN, _arg_2:Number = NaN, _arg_3:Number = NaN, _arg_4:Number = NaN, _arg_5:Number = NaN, _arg_6:Number = NaN, _arg_7:Number = NaN, _arg_8:Number = NaN, _arg_9:Number = NaN, _arg_10:Number = NaN, _arg_11:Number = NaN, _arg_12:Number = NaN)
      {
         super();
         if(!isNaN(_arg_1))
         {
            this.tint = uint(_arg_1);
         }
         if(!isNaN(_arg_2))
         {
            this.tintAmount = _arg_2;
         }
         if(!isNaN(_arg_3))
         {
            this.exposure = _arg_3;
         }
         if(!isNaN(_arg_4))
         {
            this.brightness = _arg_4;
         }
         if(!isNaN(_arg_5))
         {
            this.redMultiplier = _arg_5;
         }
         if(!isNaN(_arg_6))
         {
            this.greenMultiplier = _arg_6;
         }
         if(!isNaN(_arg_7))
         {
            this.blueMultiplier = _arg_7;
         }
         if(!isNaN(_arg_8))
         {
            this.alphaMultiplier = _arg_8;
         }
         if(!isNaN(_arg_9))
         {
            this.redOffset = _arg_9;
         }
         if(!isNaN(_arg_10))
         {
            this.greenOffset = _arg_10;
         }
         if(!isNaN(_arg_11))
         {
            this.blueOffset = _arg_11;
         }
         if(!isNaN(_arg_12))
         {
            this.alphaOffset = _arg_12;
         }
      }
      
      public static function createFromGeneric(_arg_1:Object) : ColorTransformVars
      {
         if(_arg_1 is ColorTransformVars)
         {
            return _arg_1 as ColorTransformVars;
         }
         return new ColorTransformVars(_arg_1.tint,_arg_1.tintAmount,_arg_1.exposure,_arg_1.brightness,_arg_1.redMultiplier,_arg_1.greenMultiplier,_arg_1.blueMultiplier,_arg_1.alphaMultiplier,_arg_1.redOffset,_arg_1.greenOffset,_arg_1.blueOffset,_arg_1.alphaOffset);
      }
      
      public function get tint() : Number
      {
         return Number(this.exposedVars.tint);
      }
      
      public function get redOffset() : Number
      {
         return Number(this.exposedVars.redOffset);
      }
      
      public function set blueMultiplier(_arg_1:Number) : void
      {
         this.exposedVars.blueMultiplier = _arg_1;
      }
      
      public function get exposure() : Number
      {
         return Number(this.exposedVars.exposure);
      }
      
      public function set greenMultiplier(_arg_1:Number) : void
      {
         this.exposedVars.greenMultiplier = _arg_1;
      }
      
      public function get blueOffset() : Number
      {
         return Number(this.exposedVars.blueOffset);
      }
      
      public function set exposure(_arg_1:Number) : void
      {
         this.exposedVars.exposure = _arg_1;
      }
      
      public function set redOffset(_arg_1:Number) : void
      {
         this.exposedVars.redOffset = _arg_1;
      }
      
      public function get brightness() : Number
      {
         return Number(this.exposedVars.brightness);
      }
      
      public function get alphaOffset() : Number
      {
         return Number(this.exposedVars.alphaOffset);
      }
      
      public function set blueOffset(_arg_1:Number) : void
      {
         this.exposedVars.blueOffset = _arg_1;
      }
      
      public function set brightness(_arg_1:Number) : void
      {
         this.exposedVars.brightness = _arg_1;
      }
      
      public function set redMultiplier(_arg_1:Number) : void
      {
         this.exposedVars.redMultiplier = _arg_1;
      }
      
      public function set tintAmount(_arg_1:Number) : void
      {
         this.exposedVars.tintAmount = _arg_1;
      }
      
      public function set alphaOffset(_arg_1:Number) : void
      {
         this.exposedVars.alphaOffset = _arg_1;
      }
      
      public function get greenMultiplier() : Number
      {
         return Number(this.exposedVars.greenMultiplier);
      }
      
      public function set greenOffset(_arg_1:Number) : void
      {
         this.exposedVars.greenOffset = _arg_1;
      }
      
      public function get redMultiplier() : Number
      {
         return Number(this.exposedVars.redMultiplier);
      }
      
      public function get tintAmount() : Number
      {
         return Number(this.exposedVars.tintAmount);
      }
      
      public function get greenOffset() : Number
      {
         return Number(this.exposedVars.greenOffset);
      }
      
      public function get blueMultiplier() : Number
      {
         return Number(this.exposedVars.blueMultiplier);
      }
      
      public function set tint(_arg_1:Number) : void
      {
         this.exposedVars.tint = _arg_1;
      }
      
      public function set alphaMultiplier(_arg_1:Number) : void
      {
         this.exposedVars.alphaMultiplier = _arg_1;
      }
      
      public function get alphaMultiplier() : Number
      {
         return Number(this.exposedVars.alphaMultiplier);
      }
   }
}

