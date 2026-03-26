package gs.plugins
{
   import gs.TweenLite;
   
   public class BezierThroughPlugin extends BezierPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      public function BezierThroughPlugin()
      {
         super();
         this.propName = "bezierThrough";
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         if(!(_arg_2 is Array))
         {
            return false;
         }
         init(_arg_3,_arg_2 as Array,true);
         return true;
      }
   }
}

