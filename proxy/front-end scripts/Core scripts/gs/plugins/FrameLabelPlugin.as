package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class FrameLabelPlugin extends FramePlugin
   {
      
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      public function FrameLabelPlugin()
      {
         super();
         this.propName = "frameLabel";
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         var _local_4:int = 0;
         if(!_arg_3.target is MovieClip)
         {
            return false;
         }
         _target = _arg_1 as MovieClip;
         this.frame = _target.currentFrame;
         var _local_5:Array = _target.currentLabels;
         var _local_6:String = _arg_2;
         var _local_7:int = _target.currentFrame;
         _local_4 = _local_5.length - 1;
         while(_local_4 > -1)
         {
            if(_local_5[_local_4].name == _local_6)
            {
               _local_7 = int(_local_5[_local_4].frame);
               break;
            }
            _local_4--;
         }
         if(this.frame != _local_7)
         {
            addTween(this,"frame",this.frame,_local_7,"frame");
         }
         return true;
      }
   }
}

