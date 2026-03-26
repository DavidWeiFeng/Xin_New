package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.SoundManager;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.GamePlatformEvent;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.MapEvent;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.events.SocketEvent;
   
   public class GamePlatformManager
   {
      
      private static var currentGame:AppModel;
      
      private static var _name:String;
      
      private static var paramObj:Object;
      
      private static var _instance:EventDispatcher;
      
      private static var currentName:String = "";
      
      private static var _isOnline:Boolean = false;
      
      private static var isConnecting:Boolean = false;
      
      public function GamePlatformManager()
      {
         super();
      }
      
      private static function setup() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onSwitchOpen);
      }
      
      public static function win() : void
      {
         dispatchEvent(new GamePlatformEvent(GamePlatformEvent.GAME_WIN));
      }
      
      public static function lost() : void
      {
         dispatchEvent(new GamePlatformEvent(GamePlatformEvent.GAME_LOST));
      }
      
      private static function onSwitchOpen(_arg_1:MapEvent) : void
      {
         if(Boolean(currentGame))
         {
            currentGame.destroy();
            currentGame = null;
         }
      }
      
      public static function join(_arg_1:String, _arg_2:Boolean = true, _arg_3:uint = 1, _arg_4:Object = null) : void
      {
         if(_isOnline)
         {
            throw new Error("游戏平台中已经有游戏在运行，不能再次加入");
         }
         if(isConnecting)
         {
            Alarm.show("正在连接游戏平台，不能重复发送连接申请");
            return;
         }
         _name = _arg_1;
         paramObj = _arg_4;
         if(_arg_2)
         {
            isConnecting = true;
            SocketConnection.addCmdListener(CommandID.JOIN_GAME,onJoin);
            SocketConnection.send(CommandID.JOIN_GAME,_arg_3);
         }
         else
         {
            _isOnline = false;
            loadGame();
         }
      }
      
      public static function gameOver(_arg_1:uint = 0, _arg_2:uint = 0) : void
      {
         SoundManager.playSound();
         if(_isOnline)
         {
            SocketConnection.addCmdListener(CommandID.GAME_OVER,gameOverHander);
            SocketConnection.send(CommandID.GAME_OVER,_arg_1,_arg_2);
         }
      }
      
      private static function gameOverHander(_arg_1:SocketEvent) : void
      {
         _isOnline = false;
      }
      
      private static function onJoin(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,onJoin);
         _isOnline = true;
         isConnecting = false;
         loadGame();
      }
      
      private static function loadGame() : void
      {
         if(_name == currentName)
         {
            if(!currentGame)
            {
               currentGame = new AppModel(ClientConfig.getGameModule(_name),"正在进入游戏……");
               currentGame.appLoader.addEventListener(MCLoadEvent.CLOSE,onCloseLoading);
               currentGame.setup();
               currentGame.init(paramObj);
            }
            currentGame.show();
            SoundManager.stopSound();
         }
         else
         {
            if(Boolean(currentGame))
            {
               currentGame.appLoader.removeEventListener(MCLoadEvent.CLOSE,onCloseLoading);
               currentGame.destroy();
            }
            currentGame = new AppModel(ClientConfig.getGameModule(_name),"正在进入游戏……");
            currentGame.setup();
            currentGame.init(paramObj);
            currentGame.show();
            SoundManager.stopSound();
         }
         currentName = _name;
      }
      
      private static function onCloseLoading(_arg_1:MCLoadEvent) : void
      {
         if(_isOnline)
         {
            SocketConnection.send(CommandID.GAME_OVER,0,0);
         }
         SoundManager.playSound();
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
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
         getInstance().dispatchEvent(_arg_1);
      }
      
      public static function hasEventListener(_arg_1:String) : Boolean
      {
         return getInstance().hasEventListener(_arg_1);
      }
   }
}

