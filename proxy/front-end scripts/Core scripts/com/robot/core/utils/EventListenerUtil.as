package com.robot.core.utils
{
   import flash.events.IEventDispatcher;
   
   public class EventListenerUtil
   {
      
      private var mListenerList:Vector.<EventModel> = new Vector.<EventModel>();
      
      public function EventListenerUtil()
      {
         super();
      }
      
      public function addEventListener(param1:IEventDispatcher, param2:String, param3:Function) : void
      {
         var _loc4_:EventModel = null;
         if(param1 && param3 && param2 && param2.length > 0)
         {
            _loc4_ = new EventModel(param1,param2,param3);
            param1.addEventListener(param2,param3);
            this.mListenerList.push(_loc4_);
         }
      }
      
      public function removeEventListener(param1:IEventDispatcher, param2:String, param3:Function) : void
      {
         var _loc4_:EventModel = null;
         var _loc5_:int = int(this.mListenerList.length - 1);
         while(_loc5_ >= 0)
         {
            _loc4_ = this.mListenerList[_loc5_];
            if(Boolean(_loc4_))
            {
               if(_loc4_.target == param1 && _loc4_.eventType == param2 && _loc4_.listener == param3)
               {
                  if(Boolean(_loc4_.target))
                  {
                     _loc4_.target.removeEventListener(_loc4_.eventType,_loc4_.listener);
                     this.mListenerList.splice(_loc5_,1);
                  }
               }
            }
            _loc5_--;
         }
      }
      
      public function removeTargetAllEventListener(param1:IEventDispatcher) : void
      {
         var _loc2_:EventModel = null;
         var _loc3_:int = int(this.mListenerList.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = this.mListenerList[_loc3_];
            if(Boolean(_loc2_))
            {
               if(_loc2_.target == param1)
               {
                  if(Boolean(_loc2_.target))
                  {
                     _loc2_.target.removeEventListener(_loc2_.eventType,_loc2_.listener);
                  }
                  this.mListenerList.splice(_loc3_,1);
               }
            }
            _loc3_--;
         }
      }
      
      public function removeAllEventListener() : void
      {
         var _loc1_:EventModel = null;
         var _loc2_:IEventDispatcher = null;
         var _loc3_:String = null;
         var _loc4_:Function = null;
         if(this.mListenerList == null)
         {
            return;
         }
         while(this.mListenerList.length > 0)
         {
            _loc1_ = this.mListenerList.shift();
            if(Boolean(_loc1_))
            {
               _loc2_ = _loc1_.target;
               _loc3_ = _loc1_.eventType;
               _loc4_ = _loc1_.listener;
               _loc2_.removeEventListener(_loc3_,_loc4_);
               _loc1_.dispose();
               _loc1_ = null;
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeAllEventListener();
         this.mListenerList = null;
      }
   }
}

import flash.events.IEventDispatcher;

class EventModel
{
   
   public var target:IEventDispatcher;
   
   public var eventType:String;
   
   public var listener:Function;
   
   public function EventModel(param1:IEventDispatcher, param2:String, param3:Function)
   {
      super();
      this.target = param1;
      this.eventType = param2;
      this.listener = param3;
   }
   
   public function dispose() : void
   {
      this.target = null;
      this.eventType = null;
      this.listener = null;
   }
}
