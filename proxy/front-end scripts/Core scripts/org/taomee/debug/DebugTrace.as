package org.taomee.debug
{
   public class DebugTrace
   {
      
      public function DebugTrace()
      {
         super();
      }
      
      public static function show(... _args) : void
      {
         trace(_args);
      }
   }
}

