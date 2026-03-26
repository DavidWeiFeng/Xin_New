package com.robot.app
{
   import com.robot.app.cmd.OfflineExpCmdListener;
   import com.robot.app.cmd.SetTitleCmdListener;
   import com.robot.app.cmd.SysMsgCmdListener;
   import com.robot.core.CommandID;
   import com.robot.core.ErrorReport;
   import com.robot.core.cmd.ChatCmdListener;
   import com.robot.core.cmd.InformCmdListener;
   import com.robot.core.cmd.SysTimeCmdListener;
   import com.robot.core.cmd.team.TeamInformCmdListener;
   import com.robot.core.controller.SaveUserInfo;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.event.XMLLoadEvent;
   import com.robot.core.manager.CoreAssetsManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.RelationManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import org.taomee.component.manager.MComponentManager;
   import org.taomee.events.SocketErrorEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.manager.TickManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.net.SocketDispatcher;
   
   public class MainEntry
   {
      
      public static var coreAssets_PATH:String = "resource/coreAssets.swf";
      
      private static const POLL_INTERVAL:int = 100;
      
      private static const POLL_TIMEOUT:int = 30000;
      
      private var logindata:Object;
      
      private var isLoginSuccess:Boolean = false;
      
      private var isUILoaded:Boolean = false;
      
      private var xmlLoadCallback:Function;
      
      private var pollTimer:Timer;
      
      public function MainEntry()
      {
         super();
      }
      
      private static function onFailLoadUI(_arg_1:MCLoadEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("alert","资源包内缺少coreAssets.swf文件！");
         }
      }
      
      public function setup(sprite:Sprite, ip:String, port:uint, userID:uint, session:ByteArray, relData:ByteArray, isSave:Boolean, pass:String) : void
      {
         var coreAssetsLoader:MCLoader;
         MComponentManager.setup(sprite,14,"Tahoma");
         TaomeeManager.setup(sprite,sprite.stage);
         TaomeeManager.stageWidth = 960;
         TaomeeManager.stageHeight = 560;
         MainManager.actorID = userID;
         LevelManager.setup(sprite);
         ClassRegister.setup();
         TickManager.setup();
         RelationManager.init(relData);
         new OfflineExpCmdListener().start();
         new ChatCmdListener().start();
         new InformCmdListener().start();
         SysMsgCmdListener.getInstance().start();
         new TeamInformCmdListener().start();
         new SetTitleCmdListener().start();
         coreAssetsLoader = new MCLoader(coreAssets_PATH,sprite,1,"正在加载核心资源");
         coreAssetsLoader.setIsShowClose(false);
         coreAssetsLoader.addEventListener(MCLoadEvent.SUCCESS,function(event:MCLoadEvent):void
         {
            CoreAssetsManager.setup(event.getLoader());
            SocketConnection.mainSocket.userID = userID;
            SocketConnection.mainSocket.session = session;
            SocketConnection.mainSocket.ip = ip;
            SocketConnection.mainSocket.port = port;
            SocketConnection.mainSocket.addEventListener(Event.CONNECT,onConnect);
            SocketConnection.mainSocket.addEventListener(IOErrorEvent.IO_ERROR,onSocketConnectError);
            SocketConnection.mainSocket.connect(ip,port);
            xmlLoadCallback = function():void
            {
               isUILoaded = true;
               EventManager.removeEventListener(XMLLoadEvent.ON_SUCCESS,xmlLoadCallback);
               checkAndDoPostLoginLogic(isSave,pass);
            };
            EventManager.addEventListener(XMLLoadEvent.ON_SUCCESS,xmlLoadCallback);
            MainManager.loaderUILib();
         });
         coreAssetsLoader.addEventListener(MCLoadEvent.ERROR,onFailLoadUI);
         coreAssetsLoader.doLoad();
      }
      
      private function onSocketConnectError(e:IOErrorEvent) : void
      {
         var connectErrSprite:Sprite;
         SocketConnection.mainSocket.removeEventListener(Event.CONNECT,this.onConnect);
         SocketConnection.mainSocket.removeEventListener(IOErrorEvent.IO_ERROR,this.onSocketConnectError);
         connectErrSprite = Alarm.show("Socket连接失败，请检查网络或重新登录",function():void
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("location.reload");
            }
         },false,true);
         LevelManager.iconLevel.addChild(connectErrSprite);
      }
      
      private function onConnect(_arg_1:Event) : void
      {
         SocketConnection.mainSocket.removeEventListener(Event.CONNECT,this.onConnect);
         SocketConnection.mainSocket.removeEventListener(IOErrorEvent.IO_ERROR,this.onSocketConnectError);
         SocketConnection.mainSocket.addEventListener(Event.CLOSE,this.socketClose);
         SocketConnection.addCmdListener(CommandID.LOGIN_IN,this.onLogin);
         try
         {
            SocketConnection.send(CommandID.LOGIN_IN,SocketConnection.mainSocket.session);
         }
         catch(e:Error)
         {
            socketClose(null);
         }
      }
      
      private function socketClose(event:Event) : void
      {
         var closeSprite:Sprite = null;
         this.stopPollTimer();
         SocketConnection.mainSocket.removeEventListener(Event.CLOSE,this.socketClose);
         ErrorReport.sendError(ErrorReport.SOCKET_CLOSE_ERROR);
         try
         {
            closeSprite = Alarm.show("此次连接已经断开，请重新登陆",function():void
            {
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("location.reload");
               }
            },false,true);
            LevelManager.iconLevel.addChild(closeSprite);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onLogin(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.LOGIN_IN,this.onLogin);
         SocketDispatcher.getInstance().addEventListener(SocketErrorEvent.ERROR,this.onError);
         EventManager.addEventListener(RobotEvent.CREATED_ACTOR,this.onCreatedActor);
         if(!_arg_1 || !_arg_1.data)
         {
            this.socketClose(null);
            return;
         }
         this.logindata = _arg_1.data;
         this.isLoginSuccess = true;
         this.checkAndDoPostLoginLogic(SaveUserInfo.isSave,SaveUserInfo.pass);
      }
      
      private function checkAndDoPostLoginLogic(isSave:Boolean, pass:String) : void
      {
         this.stopPollTimer();
         if(this.isLoginSuccess && this.isUILoaded && this.logindata != null)
         {
            this.executePostLoginLogic(isSave,pass);
         }
         else
         {
            trace("[轮询] 条件未满足，启动等待：登录成功=" + this.isLoginSuccess + "，UI加载完成=" + this.isUILoaded + "，logindata非空=" + (this.logindata != null));
            this.pollTimer = new Timer(POLL_INTERVAL,0);
            this.pollTimer.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void
            {
               if(isLoginSuccess && isUILoaded && logindata != null)
               {
                  stopPollTimer();
                  executePostLoginLogic(isSave,pass);
               }
               else
               {
                  trace("[轮询] 等待中...");
               }
            });
            this.pollTimer.start();
            setTimeout(function():void
            {
               if(Boolean(pollTimer) && pollTimer.running)
               {
                  stopPollTimer();
                  socketClose(null);
               }
            },POLL_TIMEOUT);
         }
      }
      
      private function executePostLoginLogic(isSave:Boolean, pass:String) : void
      {
         try
         {
            SaveUserInfo.isSave = isSave;
            SaveUserInfo.pass = pass;
            MainManager.setup(this.logindata);
            new SysTimeCmdListener().start();
            trace("[业务逻辑] 所有条件满足，执行登录后初始化");
         }
         catch(e:Error)
         {
            stopPollTimer();
         }
      }
      
      private function stopPollTimer() : void
      {
         if(Boolean(this.pollTimer))
         {
            this.pollTimer.stop();
            this.pollTimer = null;
         }
      }
      
      private function onCreatedActor(_arg_1:RobotEvent) : void
      {
         EventManager.removeEventListener(RobotEvent.CREATED_ACTOR,this.onCreatedActor);
         try
         {
            ToolTipManager.setup(UIManager.getSprite("Tooltip_Background"));
            RelationManager.setup();
            SaveUserInfo.saveSo();
         }
         catch(e:Error)
         {
         }
      }
      
      private function onError(_arg_1:SocketErrorEvent) : void
      {
         try
         {
            if(!_arg_1.headInfo)
            {
               ParseSocketError.parse(1,0);
            }
            else
            {
               ParseSocketError.parse(_arg_1.headInfo.result,_arg_1.headInfo.cmdID);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function destroy() : void
      {
         this.stopPollTimer();
         if(this.xmlLoadCallback != null)
         {
            EventManager.removeEventListener(XMLLoadEvent.ON_SUCCESS,this.xmlLoadCallback);
            this.xmlLoadCallback = null;
         }
         if(SocketConnection.mainSocket != null)
         {
            SocketConnection.mainSocket.removeEventListener(Event.CONNECT,this.onConnect);
            SocketConnection.mainSocket.removeEventListener(Event.CLOSE,this.socketClose);
            SocketConnection.mainSocket.removeEventListener(IOErrorEvent.IO_ERROR,this.onSocketConnectError);
            SocketConnection.removeCmdListener(CommandID.LOGIN_IN,this.onLogin);
         }
         SocketDispatcher.getInstance().removeEventListener(SocketErrorEvent.ERROR,this.onError);
         EventManager.removeEventListener(RobotEvent.CREATED_ACTOR,this.onCreatedActor);
         this.logindata = null;
         this.isLoginSuccess = false;
         this.isUILoaded = false;
      }
   }
}

