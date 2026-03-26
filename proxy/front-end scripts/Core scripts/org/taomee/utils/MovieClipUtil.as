package org.taomee.utils
{
   import flash.display.*;
   import flash.events.*;
   
   public class MovieClipUtil
   {
      
      public function MovieClipUtil()
      {
         super();
      }
      
      public static function childPlay(obj:DisplayObjectContainer, frame:Object, level:uint = 0) : void
      {
         var count:int = 0;
         count = 0;
         count = 0;
         var num:int = obj.numChildren;
         if(num == 0)
         {
            return;
         }
         if(level >= num)
         {
            level = uint(num - 1);
         }
         obj.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
         {
            var _local_3:MovieClip = obj.getChildAt(level) as MovieClip;
            if(Boolean(_local_3))
            {
               obj.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               _local_3.gotoAndPlay(frame);
            }
            else if(count > 2)
            {
               obj.removeEventListener(Event.ENTER_FRAME,arguments.callee);
            }
            ++count;
         });
      }
      
      public static function playEndAndRemove(mc:MovieClip) : void
      {
         mc.addFrameScript(mc.totalFrames - 1,function():void
         {
            mc.addFrameScript(mc.totalFrames - 1,null);
            DisplayUtil.removeForParent(mc);
            mc = null;
         });
      }
      
      public static function childStop(obj:DisplayObjectContainer, frame:Object, level:uint = 0) : void
      {
         var count:int = 0;
         count = 0;
         count = 0;
         var num:int = obj.numChildren;
         if(num == 0)
         {
            return;
         }
         if(level >= num)
         {
            level = uint(num - 1);
         }
         obj.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
         {
            var _local_3:MovieClip = obj.getChildAt(level) as MovieClip;
            if(Boolean(_local_3))
            {
               obj.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               _local_3.gotoAndStop(frame);
            }
            else if(count > 2)
            {
               obj.removeEventListener(Event.ENTER_FRAME,arguments.callee);
            }
            ++count;
         });
      }
   }
}

