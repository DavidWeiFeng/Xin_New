package gs.utils.tween
{
   import flash.geom.Point;
   
   public class TransformAroundPointVars extends SubVars
   {
      
      public function TransformAroundPointVars(_arg_1:Point = null, _arg_2:Number = NaN, _arg_3:Number = NaN, _arg_4:Number = NaN, _arg_5:Number = NaN, _arg_6:Number = NaN, _arg_7:Object = null, _arg_8:Number = NaN, _arg_9:Number = NaN)
      {
         super();
         if(_arg_1 != null)
         {
            this.point = _arg_1;
         }
         if(!isNaN(_arg_2))
         {
            this.scaleX = _arg_2;
         }
         if(!isNaN(_arg_3))
         {
            this.scaleY = _arg_3;
         }
         if(!isNaN(_arg_4))
         {
            this.rotation = _arg_4;
         }
         if(!isNaN(_arg_5))
         {
            this.width = _arg_5;
         }
         if(!isNaN(_arg_6))
         {
            this.height = _arg_6;
         }
         if(_arg_7 != null)
         {
            this.shortRotation = _arg_7;
         }
         if(!isNaN(_arg_8))
         {
            this.x = _arg_8;
         }
         if(!isNaN(_arg_9))
         {
            this.y = _arg_9;
         }
      }
      
      public static function createFromGeneric(_arg_1:Object) : TransformAroundPointVars
      {
         if(_arg_1 is TransformAroundPointVars)
         {
            return _arg_1 as TransformAroundPointVars;
         }
         return new TransformAroundPointVars(_arg_1.point,_arg_1.scaleX,_arg_1.scaleY,_arg_1.rotation,_arg_1.width,_arg_1.height,_arg_1.shortRotation,_arg_1.x,_arg_1.y);
      }
      
      public function set point(_arg_1:Point) : void
      {
         this.exposedVars.point = _arg_1;
      }
      
      public function set scaleX(_arg_1:Number) : void
      {
         this.exposedVars.scaleX = _arg_1;
      }
      
      public function set scaleY(_arg_1:Number) : void
      {
         this.exposedVars.scaleY = _arg_1;
      }
      
      public function get width() : Number
      {
         return Number(this.exposedVars.width);
      }
      
      public function get height() : Number
      {
         return Number(this.exposedVars.height);
      }
      
      public function get scale() : Number
      {
         return Number(this.exposedVars.scale);
      }
      
      public function set width(_arg_1:Number) : void
      {
         this.exposedVars.width = _arg_1;
      }
      
      public function get scaleX() : Number
      {
         return Number(this.exposedVars.scaleX);
      }
      
      public function get scaleY() : Number
      {
         return Number(this.exposedVars.scaleY);
      }
      
      public function get point() : Point
      {
         return this.exposedVars.point;
      }
      
      public function set y(_arg_1:Number) : void
      {
         this.exposedVars.y = _arg_1;
      }
      
      public function set scale(_arg_1:Number) : void
      {
         this.exposedVars.scale = _arg_1;
      }
      
      public function set height(_arg_1:Number) : void
      {
         this.exposedVars.height = _arg_1;
      }
      
      public function set x(_arg_1:Number) : void
      {
         this.exposedVars.x = _arg_1;
      }
      
      public function get x() : Number
      {
         return Number(this.exposedVars.x);
      }
      
      public function get y() : Number
      {
         return Number(this.exposedVars.y);
      }
      
      public function get shortRotation() : Object
      {
         return this.exposedVars.shortRotation;
      }
      
      public function set shortRotation(_arg_1:Object) : void
      {
         this.exposedVars.shortRotation = _arg_1;
      }
      
      public function set rotation(_arg_1:Number) : void
      {
         this.exposedVars.rotation = _arg_1;
      }
      
      public function get rotation() : Number
      {
         return Number(this.exposedVars.rotation);
      }
   }
}

