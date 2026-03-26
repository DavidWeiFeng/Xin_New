package gs.utils.tween
{
   public class ArrayTweenInfo
   {
      
      public var change:Number;
      
      public var start:Number;
      
      public var index:uint;
      
      public function ArrayTweenInfo(_arg_1:uint, _arg_2:Number, _arg_3:Number)
      {
         super();
         this.index = _arg_1;
         this.start = _arg_2;
         this.change = _arg_3;
      }
   }
}

