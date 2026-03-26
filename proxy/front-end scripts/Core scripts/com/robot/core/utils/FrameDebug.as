package com.robot.core.utils
{
   import flash.display.MovieClip;
   
   public class FrameDebug
   {
      
      private static var _frame:int;
      
      private static var _mc:MovieClip;
      
      public function FrameDebug()
      {
         super();
      }
      
      public static function debug(param1:MovieClip) : void
      {
         if(_mc != param1)
         {
            _mc = param1;
            _frame = param1.currentFrame;
         }
         else if(_frame == param1.currentFrame && param1.currentFrame != param1.totalFrames)
         {
            param1.gotoAndPlay(param1.currentFrame + 1);
         }
         else
         {
            _frame = param1.currentFrame;
         }
      }
      
      public static function destroy() : void
      {
         _mc = null;
      }
   }
}

