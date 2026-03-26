package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.event.NonoEvent;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import org.taomee.events.SocketEvent;
   
   public class NonoManager
   {
      
      public static var info:NonoInfo;
      
      private static var _time:int;
      
      private static var instance:EventDispatcher;
      
      public static var isBeckon:Boolean = false;
      
      public function NonoManager()
      {
         super();
      }
      
      public static function getInfo(_arg_1:Boolean = false) : void
      {
         if(_arg_1)
         {
            SocketConnection.addCmdListener(CommandID.NONO_INFO,onSocketInfo);
            SocketConnection.send(CommandID.NONO_INFO,MainManager.actorID);
            return;
         }
         var _local_2:int = getTimer() - _time;
         if(_time == 0 || _local_2 > 200000)
         {
            SocketConnection.addCmdListener(CommandID.NONO_INFO,onSocketInfo);
            SocketConnection.send(CommandID.NONO_INFO,MainManager.actorID);
         }
         else
         {
            dispatchEvent(new NonoEvent(NonoEvent.GET_INFO,info));
         }
      }
      
      private static function onSocketInfo(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.NONO_INFO,onSocketInfo);
         _time = getTimer();
         info = new NonoInfo(_arg_1.data as ByteArray);
         dispatchEvent(new NonoEvent(NonoEvent.GET_INFO,info));
         SocketConnection.send(9019,1);
      }
      
      public static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            instance = new EventDispatcher();
         }
         return instance;
      }
      
      public static function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         getInstance().addEventListener(_arg_1,_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public static function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         getInstance().removeEventListener(_arg_1,_arg_2,_arg_3);
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
      
      public static function addActionListener(_arg_1:uint, _arg_2:Function) : void
      {
         getInstance().addEventListener(_arg_1.toString(),_arg_2,false,0,false);
      }
      
      public static function removeActionListener(_arg_1:uint, _arg_2:Function) : void
      {
         getInstance().removeEventListener(_arg_1.toString(),_arg_2,false);
      }
      
      public static function dispatchAction(_arg_1:uint, _arg_2:String, _arg_3:Object) : void
      {
         getInstance().dispatchEvent(new NonoActionEvent(_arg_1.toString(),_arg_2,_arg_3));
      }
      
      public static function hasActionListener(_arg_1:uint) : Boolean
      {
         return getInstance().hasEventListener(_arg_1.toString());
      }
   }
}

