package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   
   public class BevelFilterPlugin extends FilterPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      public function BevelFilterPlugin()
      {
         super();
         this.propName = "bevelFilter";
         this.overwriteProps = ["bevelFilter"];
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         _target = _arg_1;
         _type = BevelFilter;
         initFilter(_arg_2,new BevelFilter(0,0,16777215,0.5,0,0.5,2,2,0,int(_arg_2.quality) || 2));
         return true;
      }
   }
}

