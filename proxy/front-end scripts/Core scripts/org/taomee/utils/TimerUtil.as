package org.taomee.utils
{
   import flash.events.*;
   import flash.utils.*;
   
   public class TimerUtil
   {
      
      public function TimerUtil()
      {
         super();
      }
      
      public static function clearAllTimer() : void
      {
         clearAllTimeout();
         clearAllInterval();
      }
      
      private static function getTimerInstance(closure:Function, delay:Number, num:uint, vars:*) : Timer
      {
         var tempTimer:Timer = null;
         tempTimer = null;
         tempTimer = new Timer(delay,num);
         tempTimer.addEventListener(TimerEvent.TIMER,function(_arg_1:TimerEvent):void
         {
            if(_arg_1.currentTarget.currentCount == _arg_1.currentTarget.repeatCount)
            {
               tempTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,arguments.callee);
               clearGTimeout(tempTimer);
            }
            if(vars.length > 0)
            {
               closure.apply(this,vars);
            }
            else
            {
               closure();
            }
         });
         tempTimer.start();
         return tempTimer;
      }
      
      public static function clearGTimeout(_arg_1:Timer) : void
      {
         if(Boolean(_arg_1))
         {
            _arg_1.stop();
            _arg_1 = null;
         }
      }
      
      public static function clearAllInterval() : void
      {
         var timeoutNum:uint = 0;
         timeoutNum = 0;
         timeoutNum = setInterval(function():void
         {
            var i:* = undefined;
            timeoutNum = setInterval(function():void
            {
            },0);
            i = 1;
            while(i <= timeoutNum)
            {
               clearInterval(i);
               i++;
            }
         },0);
      }
      
      public static function setGInterval(_arg_1:Function, _arg_2:*, ... _args) : Timer
      {
         var _local_4:uint = 0;
         var _local_5:Array = null;
         if(Boolean(_arg_2 as String) && _arg_2.indexOf(":") > -1)
         {
            _local_5 = _arg_2.split(":");
            _local_4 = uint(int(_local_5[1]));
            _arg_2 = int(_local_5[0]);
         }
         else
         {
            _local_4 = 0;
         }
         return getTimerInstance(_arg_1,_arg_2,_local_4,_args);
      }
      
      public static function setGTimeout(_arg_1:Function, _arg_2:Number, ... _args) : Timer
      {
         return getTimerInstance(_arg_1,_arg_2,1,_args);
      }
      
      public static function clearAllTimeout() : void
      {
         var timeoutNum:uint = 0;
         timeoutNum = 0;
         timeoutNum = setTimeout(function():void
         {
            var i:* = undefined;
            timeoutNum = setTimeout(function():void
            {
            },0);
            i = 1;
            while(i <= timeoutNum)
            {
               clearTimeout(i);
               i++;
            }
         },0);
      }
      
      public static function clearGInterval(_arg_1:Timer) : void
      {
         if(Boolean(_arg_1))
         {
            _arg_1.stop();
            _arg_1 = null;
         }
      }
   }
}

