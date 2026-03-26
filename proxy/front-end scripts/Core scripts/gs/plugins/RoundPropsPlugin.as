package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class RoundPropsPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      public function RoundPropsPlugin()
      {
         super();
         this.propName = "roundProps";
         this.overwriteProps = [];
         this.round = true;
      }
      
      public function add(_arg_1:Object, _arg_2:String, _arg_3:Number, _arg_4:Number) : void
      {
         addTween(_arg_1,_arg_2,_arg_3,_arg_3 + _arg_4,_arg_2);
         this.overwriteProps[this.overwriteProps.length] = _arg_2;
      }
   }
}

