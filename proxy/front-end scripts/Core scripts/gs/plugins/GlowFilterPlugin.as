package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   
   public class GlowFilterPlugin extends FilterPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      public function GlowFilterPlugin()
      {
         super();
         this.propName = "glowFilter";
         this.overwriteProps = ["glowFilter"];
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         _target = _arg_1;
         _type = GlowFilter;
         initFilter(_arg_2,new GlowFilter(16777215,0,0,0,Number(_arg_2.strength) || 1,int(_arg_2.quality) || 2,_arg_2.inner,_arg_2.knockout));
         return true;
      }
   }
}

