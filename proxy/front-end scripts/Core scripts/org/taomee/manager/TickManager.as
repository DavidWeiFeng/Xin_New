package org.taomee.manager
{
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.ds.HashSet;
   
   public class TickManager
   {
      
      private static var _running:Boolean;
      
      private static var _hashSet:HashSet = new HashSet();
      
      private static var _interval:Number = 40;
      
      private static var _id:uint = 0;
      
      public function TickManager()
      {
         super();
      }
      
      private static function onTick() : void
      {
         _hashSet.each2(function(_arg_1:Function):void
         {
            _arg_1();
         });
      }
      
      public static function get interval() : Number
      {
         return _interval;
      }
      
      public static function getFrameForTime(_arg_1:Number) : Number
      {
         return _arg_1 / _interval;
      }
      
      public static function stop() : void
      {
         if(_running)
         {
            clearInterval(_id);
            _running = false;
         }
      }
      
      public static function set interval(_arg_1:Number) : void
      {
         _interval = _arg_1;
         clearInterval(_id);
         _running = false;
         setup();
      }
      
      public static function getTimeForFrame(_arg_1:Number) : Number
      {
         return _arg_1 * _interval;
      }
      
      public static function hasListener(_arg_1:Function) : Boolean
      {
         return _hashSet.contains(_arg_1);
      }
      
      public static function removeListener(_arg_1:Function) : void
      {
         _hashSet.remove(_arg_1);
      }
      
      public static function play() : void
      {
         if(!_running)
         {
            setup();
         }
      }
      
      public static function addListener(_arg_1:Function) : void
      {
         _hashSet.add(_arg_1);
      }
      
      public static function setup() : void
      {
         _id = setInterval(onTick,_interval);
         _running = true;
      }
      
      public static function get running() : Boolean
      {
         return _running;
      }
   }
}

