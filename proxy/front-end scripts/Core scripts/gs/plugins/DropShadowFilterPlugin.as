package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   
   public class DropShadowFilterPlugin extends FilterPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      public function DropShadowFilterPlugin()
      {
         super();
         this.propName = "dropShadowFilter";
         this.overwriteProps = ["dropShadowFilter"];
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         _target = _arg_1;
         _type = DropShadowFilter;
         initFilter(_arg_2,new DropShadowFilter(0,45,0,0,0,0,1,int(_arg_2.quality) || 2,_arg_2.inner,_arg_2.knockout,_arg_2.hideObject));
         return true;
      }
   }
}

