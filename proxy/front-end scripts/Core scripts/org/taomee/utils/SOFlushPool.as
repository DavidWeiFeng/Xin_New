package org.taomee.utils
{
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.utils.Timer;
   
   public class SOFlushPool
   {
      
      private static const TIME:int = 100;
      
      private var _poolList:Array;
      
      private var _time:Timer;
      
      public function SOFlushPool()
      {
         super();
         this._poolList = new Array();
         this._time = new Timer(TIME,0);
         this._time.addEventListener(TimerEvent.TIMER,this.onTime);
      }
      
      private function onTime(e:TimerEvent) : void
      {
         var shareObject:SharedObject = this._poolList.shift();
         if(shareObject != null)
         {
            try
            {
               shareObject.flush();
            }
            catch(e:Error)
            {
            }
         }
         else
         {
            this._time.stop();
         }
      }
      
      public function addFlush(_arg_1:SharedObject) : void
      {
         if(!this.isInPool(_arg_1))
         {
            this._poolList.push(_arg_1);
            if(!this._time.running)
            {
               this._time.reset();
               this._time.start();
            }
         }
      }
      
      private function isInPool(_arg_1:SharedObject) : Boolean
      {
         return this._poolList.indexOf(_arg_1) != -1;
      }
   }
}

