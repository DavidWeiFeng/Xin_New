package gs.utils.tween
{
   public class FilterVars extends SubVars
   {
      
      public var index:int;
      
      public var addFilter:Boolean;
      
      public var remove:Boolean;
      
      public function FilterVars(_arg_1:Boolean = false, _arg_2:int = -1, _arg_3:Boolean = false)
      {
         super();
         this.remove = _arg_1;
         if(_arg_2 > -1)
         {
            this.index = _arg_2;
         }
         this.addFilter = _arg_3;
      }
   }
}

