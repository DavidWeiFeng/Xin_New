package com.robot.core.animate
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MCStopPlayManager
   {
      
      public function MCStopPlayManager()
      {
         super();
      }
      
      public static function stopChildMC(param1:MovieClip, param2:Object = null) : void
      {
         var mc:MovieClip = null;
         mc = param1;
         var frame:Object = param2;
         if(Boolean(frame))
         {
            mc.gotoAndStop(frame);
         }
         mc.addEventListener(Event.ENTER_FRAME,function(param1:Event):void
         {
            var _loc3_:MovieClip = mc.getChildAt(0) as MovieClip;
            if(Boolean(_loc3_))
            {
               _loc3_.gotoAndStop(1);
               mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
            }
         });
      }
      
      public static function playChildMC(param1:MovieClip, param2:Object = null) : void
      {
         var mc:MovieClip = null;
         mc = param1;
         var frame:Object = param2;
         if(Boolean(frame))
         {
            mc.gotoAndStop(frame);
         }
         mc.addEventListener(Event.ENTER_FRAME,function(param1:Event):void
         {
            var _loc3_:MovieClip = mc.getChildAt(0) as MovieClip;
            if(Boolean(_loc3_))
            {
               _loc3_.gotoAndPlay(2);
               mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
            }
         });
      }
   }
}

