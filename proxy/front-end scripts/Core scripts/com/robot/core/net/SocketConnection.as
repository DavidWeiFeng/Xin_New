package com.robot.core.net
{
   import com.robot.core.manager.*;
   import com.robot.core.net.netHelper.SendQueueItemVo;
   import com.robot.core.net.netHelper.SocketConnectionHelper;
   import flash.events.*;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketErrorEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.net.*;
   
   public class SocketConnection
   {
      
      private static var _mainSocket:SocketImpl;
      
      private static var _roomSocket:SocketImpl;
      
      public function SocketConnection()
      {
         super();
      }
      
      public static function get mainSocket() : SocketImpl
      {
         if(_mainSocket == null)
         {
            _mainSocket = new SocketImpl();
         }
         return _mainSocket;
      }
      
      public static function get roomSocket() : SocketImpl
      {
         if(_mainSocket == null)
         {
            _mainSocket = new SocketImpl();
         }
         return _mainSocket;
      }
      
      public static function addCmdListener(_arg_1:uint, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         SocketDispatcher.getInstance().addEventListener(_arg_1.toString(),_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public static function removeCmdListener(_arg_1:uint, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         SocketDispatcher.getInstance().removeEventListener(_arg_1.toString(),_arg_2,_arg_3);
      }
      
      public static function dispatchCmd(_arg_1:Event) : void
      {
         SocketDispatcher.getInstance().dispatchEvent(_arg_1);
      }
      
      public static function hasCmdListener(_arg_1:uint) : Boolean
      {
         return SocketDispatcher.getInstance().hasEventListener(_arg_1.toString());
      }
      
      public static function willTriggerCmd(_arg_1:uint) : Boolean
      {
         return SocketDispatcher.getInstance().willTrigger(_arg_1.toString());
      }
      
      public static function send(_arg_1:uint, ... _args) : void
      {
         if(!mainSocket.connected)
         {
            mainSocket.dispatchEvent(new Event(Event.CLOSE));
         }
         mainSocket.send(_arg_1,_args);
      }
      
      public static function send_2(_arg_1:uint, _arg_2:Array) : void
      {
         if(!mainSocket.connected)
         {
            mainSocket.dispatchEvent(new Event(Event.CLOSE));
         }
         mainSocket.send(_arg_1,_arg_2);
      }
      
      public static function sendWithCallback(param1:uint, param2:Function, ... rest) : void
      {
         sendWithCallback2(param1,param2,rest);
      }
      
      public static function sendWithCallback2(param1:int, param2:Function, param3:Array = null, param4:Function = null) : void
      {
         var cmdBackFun:Function = null;
         var cmdID:int = 0;
         var callback:Function = null;
         var errorCallback:Function = null;
         cmdBackFun = null;
         var errorFun:Function = null;
         cmdID = param1;
         callback = param2;
         var sendArgs:Array = param3;
         errorCallback = param4;
         sendArgs = null == sendArgs ? [] : sendArgs;
         cmdBackFun = function(param1:SocketEvent):void
         {
            if(param1.data != null && param1.data is ByteArray)
            {
               (param1.data as ByteArray).position = 0;
            }
            SocketConnection.removeCmdListener(cmdID,arguments.callee);
            if(callback != null)
            {
               callback(param1);
            }
         };
         errorFun = function(param1:SocketErrorEvent):void
         {
            SocketConnection.removeCmdListener(cmdID,cmdBackFun);
            if(errorCallback != null)
            {
               errorCallback(param1);
            }
         };
         SocketConnection.addCmdListener(cmdID,cmdBackFun);
         if(!mainSocket.connected)
         {
            mainSocket.dispatchEvent(new Event(Event.CLOSE));
         }
         mainSocket.send(cmdID,sendArgs);
      }
      
      public static function sendByQueue(param1:int, param2:Array, param3:Function = null, param4:Function = null) : void
      {
         var _loc5_:SendQueueItemVo = null;
         _loc5_ = new SendQueueItemVo();
         _loc5_.cmdID = param1;
         _loc5_.args = param2;
         _loc5_.callBackFun = param3;
         _loc5_.errorHandleFun = param4;
         SocketConnectionHelper.sendCommandByQueue(_loc5_);
      }
   }
}

