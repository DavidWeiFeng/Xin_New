package com.robot.core
{
   import com.robot.core.config.*;
   import com.robot.core.manager.*;
   import flash.events.Event;
   import flash.net.*;
   import flash.system.*;
   import org.taomee.manager.*;
   
   public class ErrorReport
   {
      
      public static const PATH:String = "http://114.80.98.38/cgi-bin/stat/seer-err-report.cgi";
      
      public static const MIMI_LOGIN_ERROR:uint = 1;
      
      public static const EMAIL_LOGIN_ERROR:uint = 2;
      
      public static const GET_SERVER_LIST_ERROR:uint = 3;
      
      public static const LOGIN_ONLINE_ERROR:uint = 4;
      
      public static const REGISTE_ERROR:uint = 5;
      
      public static const CREATE_SEER_ERROR:uint = 6;
      
      public static const LOGIN_HOME_ONLINE_ERROR:uint = 7;
      
      public static const SOCKET_CLOSE_ERROR:uint = 8;
      
      public static const RESOURCE_MANAGER_ERROR:uint = 9;
      
      public static const RESOURCE_REFLECT_ERROR:uint = 10;
      
      setup();
      
      public function ErrorReport()
      {
         super();
      }
      
      private static function setup() : void
      {
         EventManager.addEventListener(ResourceManager.RESOUCE_REFLECT_ERROR,function(_arg_1:Event):void
         {
            sendError(RESOURCE_REFLECT_ERROR);
         });
         EventManager.addEventListener(ResourceManager.RESOUCE_ERROR,function(_arg_1:Event):void
         {
            sendError(RESOURCE_MANAGER_ERROR);
         });
      }
      
      public static function sendError(_arg_1:uint) : void
      {
         var _local_2:URLLoader = new URLLoader();
         var _local_3:URLVariables = new URLVariables();
         var _local_4:Date = new Date();
         _local_3.date = _local_4.getFullYear() + "/" + (_local_4.getMonth() + 1) + "/" + _local_4.getDate() + "/" + _local_4.getHours() + ":" + _local_4.getMinutes();
         _local_3.serverIP = getIP(_arg_1);
         _local_3.serverPort = getPort(_arg_1);
         _local_3.version = ClientConfig.uiVersion;
         _local_3.id = MainManager.actorID;
         if(Boolean(MainManager.actorModel))
         {
            _local_3.x = MainManager.actorModel.x;
            _local_3.y = MainManager.actorModel.y;
         }
         else
         {
            _local_3.x = 0;
            _local_3.y = 0;
         }
         if(Boolean(MainManager.actorInfo))
         {
            _local_3.mapID = MainManager.actorInfo.mapID;
         }
         else
         {
            _local_3.mapID = 0;
         }
         _local_3.serverID = MainManager.serverID;
         _local_3.playerType = Capabilities.playerType;
         _local_3.playerVersion = Capabilities.version;
         _local_3.isDebugger = Capabilities.isDebugger;
         _local_3.os = Capabilities.os;
         _local_3.language = Capabilities.language;
         var _local_5:URLRequest = new URLRequest(PATH + "?folder=" + _arg_1);
         _local_5.method = URLRequestMethod.POST;
         _local_5.data = _local_3;
         _local_2.load(_local_5);
      }
      
      private static function getIP(_arg_1:uint) : String
      {
         var _local_2:String = null;
         if(_arg_1 == MIMI_LOGIN_ERROR || _arg_1 == EMAIL_LOGIN_ERROR)
         {
            _local_2 = ClientConfig.ID_IP;
         }
         else if(_arg_1 == GET_SERVER_LIST_ERROR || _arg_1 == CREATE_SEER_ERROR)
         {
            _local_2 = ClientConfig.SUB_SERVER_IP;
         }
         return _local_2;
      }
      
      private static function getPort(_arg_1:uint) : uint
      {
         var _local_2:int = 0;
         if(_arg_1 == MIMI_LOGIN_ERROR || _arg_1 == EMAIL_LOGIN_ERROR)
         {
            _local_2 = int(ClientConfig.ID_PORT);
         }
         else if(_arg_1 == GET_SERVER_LIST_ERROR || _arg_1 == CREATE_SEER_ERROR)
         {
            _local_2 = int(ClientConfig.SUB_SERVER_PORT);
         }
         return _local_2;
      }
   }
}

