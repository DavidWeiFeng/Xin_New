package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   
   public class BlurFilterPlugin extends FilterPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      public function BlurFilterPlugin()
      {
         super();
         this.propName = "blurFilter";
         this.overwriteProps = ["blurFilter"];
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         _target = _arg_1;
         _type = BlurFilter;
         initFilter(_arg_2,new BlurFilter(0,0,int(_arg_2.quality) || 2));
         return true;
      }
   }
}

