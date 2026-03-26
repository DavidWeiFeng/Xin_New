package gs.utils.tween
{
   public class TransformAroundCenterVars extends TransformAroundPointVars
   {
      
      public function TransformAroundCenterVars(_arg_1:Number = NaN, _arg_2:Number = NaN, _arg_3:Number = NaN, _arg_4:Number = NaN, _arg_5:Number = NaN, _arg_6:Object = null, _arg_7:Number = NaN, _arg_8:Number = NaN)
      {
         super(null,_arg_1,_arg_2,_arg_3,_arg_4,_arg_5,_arg_6,_arg_7,_arg_8);
      }
      
      public static function createFromGeneric(_arg_1:Object) : TransformAroundCenterVars
      {
         if(_arg_1 is TransformAroundCenterVars)
         {
            return _arg_1 as TransformAroundCenterVars;
         }
         return new TransformAroundCenterVars(_arg_1.scaleX,_arg_1.scaleY,_arg_1.rotation,_arg_1.width,_arg_1.height,_arg_1.shortRotation,_arg_1.x,_arg_1.y);
      }
   }
}

