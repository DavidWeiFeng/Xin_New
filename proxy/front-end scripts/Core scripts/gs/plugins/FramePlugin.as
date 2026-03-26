package gs.plugins
{
   import flash.display.MovieClip;
   import gs.TweenLite;
   
   public class FramePlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      protected var _target:MovieClip;
      
      public var frame:int;
      
      public function FramePlugin()
      {
         super();
         this.propName = "frame";
         this.overwriteProps = ["frame"];
         this.round = true;
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         if(!(_arg_1 is MovieClip) || isNaN(_arg_2))
         {
            return false;
         }
         this._target = _arg_1 as MovieClip;
         this.frame = this._target.currentFrame;
         addTween(this,"frame",this.frame,_arg_2,"frame");
         return true;
      }
      
      override public function set changeFactor(_arg_1:Number) : void
      {
         updateTweens(_arg_1);
         this._target.gotoAndStop(this.frame);
      }
   }
}

