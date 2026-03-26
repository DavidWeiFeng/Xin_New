package com.robot.core.controller
{
   import com.robot.core.ErrorReport;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.net.SocketConnection;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.utils.ByteArray;
   
   [Event(name="connect",type="flash.events.Event")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="leaveRoom",type="com.robot.core.event.RobotEvent")]
   [Event(name="enterRoom",type="com.robot.core.event.RobotEvent")]
   [Event(name="getRoomAddres",type="com.robot.core.event.RobotEvent")]
   public class RoomController extends EventDispatcher
   {
      
      public static var isClose:Boolean = false;
      
      private var _id:uint;
      
      private var _isConnect:Boolean;
      
      private var _isIlk:Boolean = false;
      
      private var _session:ByteArray;
      
      private var _ip:String;
      
      private var _port:int;
      
      public function RoomController()
      {
         super();
      }
      
      public function get isConnect() : Boolean
      {
         return this._isConnect;
      }
      
      public function get isIlk() : Boolean
      {
         return this._isIlk;
      }
      
      public function getRoomAddres(id:uint) : void
      {
         this._id = id;
         this._isIlk = true;
         dispatchEvent(new RobotEvent(RobotEvent.GET_ROOM_ADDRES));
      }
      
      public function connect() : void
      {
         if(this._isIlk)
         {
            dispatchEvent(new Event(Event.CONNECT));
         }
      }
      
      public function inRoom(_arg_1:uint, _arg_2:uint, _arg_3:uint) : void
      {
         var _local_4:uint = 0;
         if(Boolean(PetManager.showInfo))
         {
            _local_4 = PetManager.showInfo.catchTime;
         }
      }
      
      public function outRoom(mapID:uint) : void
      {
         var catchTime:uint = 0;
         if(Boolean(PetManager.showInfo))
         {
            catchTime = PetManager.showInfo.catchTime;
         }
         this.close();
      }
      
      public function close() : void
      {
         this._isConnect = false;
         isClose = true;
      }
      
      private function onConnect(_arg_1:Event) : void
      {
         SocketConnection.roomSocket.removeEventListener(Event.CONNECT,this.onConnect);
         this._isConnect = true;
         SocketConnection.roomSocket.ip = this._ip;
         SocketConnection.roomSocket.port = this._port;
         dispatchEvent(_arg_1);
      }
      
      private function onClose(_arg_1:Event) : void
      {
         SocketConnection.roomSocket.removeEventListener(Event.CLOSE,this.onClose);
         this._isConnect = false;
         SocketConnection.roomSocket.close();
         isClose = true;
         MapManager.changeMap(MapManager.defaultID);
      }
      
      private function onError(_arg_1:Event) : void
      {
         SocketConnection.roomSocket.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         SocketConnection.roomSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
      
      private function onSecurityError(_arg_1:SecurityErrorEvent) : void
      {
         ErrorReport.sendError(ErrorReport.LOGIN_HOME_ONLINE_ERROR);
         SocketConnection.roomSocket.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         SocketConnection.roomSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
   }
}

