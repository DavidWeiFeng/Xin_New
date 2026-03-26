package com.robot.core.manager
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class NpcTaskManager
   {
      
      private static var instance:EventDispatcher;
      
      private static var isSingle:Boolean = false;
      
      public function NpcTaskManager()
      {
         super();
         if(!isSingle)
         {
            throw new Error("NpcTaskManager为单例模式，不能直接创建");
         }
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            isSingle = true;
            instance = new EventDispatcher();
         }
         isSingle = false;
         return instance;
      }
      
      public static function addTaskListener(_arg_1:uint, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         getInstance().addEventListener(_arg_1.toString(),_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public static function removeTaskListener(_arg_1:uint, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         getInstance().removeEventListener(_arg_1.toString(),_arg_2,_arg_3);
      }
      
      public static function dispatchEvent(_arg_1:Event) : void
      {
         if(hasEventListener(_arg_1.type))
         {
            getInstance().dispatchEvent(_arg_1);
         }
      }
      
      public static function hasEventListener(_arg_1:String) : Boolean
      {
         return getInstance().hasEventListener(_arg_1);
      }
      
      public static function willTrigger(_arg_1:String) : Boolean
      {
         return getInstance().willTrigger(_arg_1);
      }
   }
}

