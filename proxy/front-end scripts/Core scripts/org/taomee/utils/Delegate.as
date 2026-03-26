package org.taomee.utils
{
   public class Delegate
   {
      
      public function Delegate()
      {
         super();
      }
      
      public static function create(_arg_1:Function, ... _args) : Function
      {
         return createWithArgs(_arg_1,_args);
      }
      
      private static function createWithArgs(func:Function, args:Array) : Function
      {
         var f:Function = function():*
         {
            var _local_2:Function = arguments.callee.func;
            var _local_3:Array = arguments.concat(args);
            return _local_2.apply(null,_local_3);
         };
         f["func"] = func;
         return f;
      }
   }
}

