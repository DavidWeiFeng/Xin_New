package
{
   import com.common.util.LoaderUtil;
   import com.taomee.pandaVersion.IPVM_Loader;
   import com.taomee.pandaVersion.PVM;
   import com.taomee.pandaVersion.PVM_Event;
   import com.taomee.pandaVersion.PVM_Loader;
   import com.taomee.utils.VLU;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.external.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLStream;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class Client extends Sprite
   {
      
      public static const LOGIN_SUCCESS:String = "loginSuccess";
      
      public static const SERVER_XML:String = "config/ServerR.xml";
      
      private static var RESOURCE_PATH:String = "resource/main_resource.swf";
      
      private static var LOGIN_PATH:String = "login/Login.swf";
      
      private var bgMC:MovieClip;
      
      private var loader:Loader;
      
      private var dllLoader:DLLLoader;
      
      private var xmlloader:URLStream;
      
      private var loadingMC:MovieClip;
      
      private const DOOR_XML:String = "config/doorConfig.xml";
      
      private const CHECK_URL:String = "http://10.1.1.240:1500/time";
      
      private var urlLoader:URLLoader;
      
      private var tineOut:uint;
      
      private var loadTime:int;
      
      private var size:uint;
      
      private var configXML:XML;
      
      private var updateXML:XML;
      
      private var timer:Timer;
      
      public var BC_List:Object;
      
      private var fileLoader:PVM_Loader;
      
      public function Client()
      {
         super();
         var _loc1_:MovieClip = new mainBG();
         _loc1_.cacheAsBitmap = true;
         addChildAt(_loc1_,0);
         this.loadingMC = new firstLoading();
         this.timer = new Timer(2000);
         this.timer.addEventListener(TimerEvent.TIMER,this.changeTip);
         stage.stageFocusRect = false;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         this.loadDorrXml();
      }
      
      private function loadDorrXml() : void
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.onDoorXmlHandler);
         _loc1_.load(new URLRequest(this.DOOR_XML + "?" + Math.random()));
      }
      
      private function onDoorXmlHandler(param1:Event) : void
      {
         var xml:XML = null;
         var xmlL:XML = null;
         var e:Event = param1;
         var urlRe:URLRequest = null;
         var loader:URLLoader = e.target as URLLoader;
         loader.removeEventListener(Event.COMPLETE,this.onDoorXmlHandler);
         xml = new XML(loader.data);
         xmlL = xml.elements("time")[0] as XML;
         if(Boolean(uint(xmlL.@isOpen)))
         {
            this.start();
         }
         else
         {
            urlRe = new URLRequest(this.CHECK_URL);
            this.urlLoader = new URLLoader();
            this.urlLoader.addEventListener(Event.COMPLETE,this.onComHandler);
            this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIoHandler);
            this.urlLoader.load(urlRe);
            this.tineOut = setTimeout(function():void
            {
               clearTimeout(tineOut);
               urlLoader.removeEventListener(Event.COMPLETE,onComHandler);
               urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onIoHandler);
               urlLoader = null;
               urlRe = null;
               start();
            },5000);
         }
      }
      
      private function onIoHandler(param1:IOErrorEvent) : void
      {
         clearTimeout(this.tineOut);
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onComHandler);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoHandler);
         this.urlLoader = null;
         this.start();
      }
      
      private function onComHandler(param1:Event) : void
      {
         clearTimeout(this.tineOut);
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onComHandler);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoHandler);
         var _loc2_:int = int(this.urlLoader.data);
         var _loc3_:Date = new Date(_loc2_ * 1000);
         if(_loc3_.getHours() >= 0 && _loc3_.getHours() <= 5)
         {
            navigateToURL(new URLRequest("http://www.51seer.com/index_close.html"),"_self");
         }
         else
         {
            this.start();
         }
         this.urlLoader = null;
      }
      
      private function start() : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadResource);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.failResource);
         this.loader.load(new URLRequest(RESOURCE_PATH));
      }
      
      private function changeTip(param1:TimerEvent) : void
      {
         var _loc2_:uint = Math.floor(Math.random() * DLLLoader.array.length);
         this.loadingMC["tip_txt"].text = DLLLoader.array[_loc2_];
      }
      
      private function onLoadResource(param1:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadResource);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.failResource);
         this.loadXMLResource();
      }
      
      private function init() : void
      {
         this.dllLoader = new DLLLoader();
         this.stage.addChild(this.dllLoader.loadingMC);
         this.dllLoader.addEventListener(DLLLoader.DLL_OVER,this.onDLLComplete);
         this.dllLoader.doLoad();
      }
      
      private function onDLLComplete(param1:Event) : void
      {
         this.dllLoader.removeEventListener(DLLLoader.DLL_OVER,this.onDLLComplete);
         this.dllLoader = null;
         var _loc2_:* = getDefinitionByName("com.robot.core.config.ClientConfig");
         _loc2_.setup(this.configXML);
         var _loc3_:* = getDefinitionByName("com.robot.core.config.UpdateConfig");
         _loc3_.setup(this.updateXML);
         var _loc4_:* = getDefinitionByName("com.robot.core.manager.LoadingManager");
         _loc4_.setup(this.loader);
         this.loadReg();
         var _loc5_:Object = this.loaderInfo.parameters;
         var _loc6_:* = getDefinitionByName("com.robot.core.manager.MainManager");
         _loc6_.CHANNEL = uint(_loc5_["channel"]);
      }
      
      private function loadReg() : void
      {
         var _loc1_:* = getDefinitionByName("com.robot.core.config.ClientConfig");
         this.stage.addChild(this.loadingMC);
         this.loadingMC["content_txt"].text = "正在加载登陆界面";
         var _loc2_:Loader = new Loader();
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadReg);
         _loc2_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.regProgress);
         _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.failResource);
         _loc2_.load(VLU.getURLRequest(LOGIN_PATH));
      }
      
      private function loadXMLResource() : void
      {
         this.xmlloader = new URLStream();
         this.xmlloader.addEventListener(Event.COMPLETE,this.onServerComplete);
         this.xmlloader.addEventListener(IOErrorEvent.IO_ERROR,this.onServerError);
         this.xmlloader.load(new URLRequest(SERVER_XML + "?" + Math.random()));
      }
      
      private function onServerComplete(param1:Event) : void
      {
         this.xmlloader.removeEventListener(Event.COMPLETE,this.onServerComplete);
         this.xmlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onServerError);
         var _loc2_:ByteArray = new ByteArray();
         this.xmlloader.readBytes(_loc2_);
         if(SERVER_XML == "config/Server.xml")
         {
            _loc2_.uncompress();
         }
         var _loc3_:Array = _loc2_.readUTFBytes(_loc2_.bytesAvailable).split("****");
         this.configXML = XML(_loc3_[0]);
         this.updateXML = XML(_loc3_[1]);
         DLLLoader.parseStr(_loc3_[1]);
         this.timer.start();
         var _loc4_:uint = Math.floor(Math.random() * DLLLoader.array.length);
         this.loadingMC["tip_txt"].text = DLLLoader.array[_loc4_];
         this.init();
         this.loadTime = getTimer();
      }
      
      private function onLoadReg(param1:Event) : void
      {
         var urllloader:URLLoader = null;
         var e:Event = param1;
         var loaderInfo:LoaderInfo = e.target as LoaderInfo;
         loaderInfo.removeEventListener(Event.COMPLETE,this.onLoadResource);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.failResource);
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.regProgress);
         loaderInfo.content.addEventListener(LOGIN_SUCCESS,this.onLoginSuccess);
         addChild(loaderInfo.content);
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.changeTip);
         this.timer = null;
         this.loadingMC.parent.removeChild(this.loadingMC);
         this.loadingMC = null;
         this.loadTime = getTimer() - this.loadTime;
         urllloader = new URLLoader();
         urllloader.addEventListener(Event.COMPLETE,this.onGetIP);
         urllloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function():void
         {
         });
         urllloader.addEventListener(IOErrorEvent.IO_ERROR,this.onIPError);
         urllloader.load(new URLRequest("http://www.51seer.com/ip"));
      }
      
      private function regProgress(param1:ProgressEvent) : void
      {
         var _loc2_:Number = param1.bytesTotal;
         var _loc3_:Number = param1.bytesLoaded;
         this.size = _loc2_;
         var _loc4_:Number = Math.floor(_loc3_ / _loc2_ * 100);
         this.loadingMC["perNum"].text = _loc4_ + "%";
         this.loadingMC["loadingBar"].gotoAndStop(_loc4_);
      }
      
      private function onLoginSuccess(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         _loc2_.removeEventListener(LOGIN_SUCCESS,this.onLoginSuccess);
         var _loc3_:String = String(_loc2_.svrObj.ip);
         var _loc4_:uint = uint(_loc2_.svrObj.port);
         var _loc5_:uint = uint(_loc2_.svrObj.userID);
         var _loc6_:ByteArray = _loc2_.svrObj.session;
         var _loc7_:IDataInput = _loc2_.svrObj.friendData;
         var _loc8_:Boolean = Boolean(_loc2_.svrObj.bSavaMi);
         var _loc9_:String = String(_loc2_.svrObj.pwd);
         var _loc10_:Class = getDefinitionByName("com.robot.app.MainEntry") as Class;
         var _loc11_:* = new _loc10_();
         _loc11_.setup(this,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
         _loc2_.parent.removeChild(_loc2_);
      }
      
      private function failResource(param1:IOErrorEvent) : void
      {
         var event:IOErrorEvent = param1;
         var urllloader:URLLoader = new URLLoader();
         urllloader.addEventListener(Event.COMPLETE,this.onGetIPByError);
         urllloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function():void
         {
         });
         urllloader.addEventListener(IOErrorEvent.IO_ERROR,this.onIPError);
         urllloader.load(new URLRequest("http://www.51seer.com/ip"));
         throw new Error("文件加载错误！");
      }
      
      private function onServerError(param1:Event) : void
      {
         throw new Error("xml资源加载错误，请检查XML资源！");
      }
      
      public function removeBG() : void
      {
         removeChild(this.bgMC);
         this.bgMC = null;
      }
      
      private function onGetIP(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.currentTarget as URLLoader;
         var _loc3_:String = _loc2_.data;
         var _loc4_:URLLoader = new URLLoader();
         var _loc5_:URLVariables = new URLVariables();
         _loc5_["ip"] = _loc3_;
         _loc5_["size"] = this.size;
         _loc5_["time"] = this.loadTime;
         _loc5_["game"] = "seer";
         var _loc6_:URLRequest = new URLRequest("http://114.80.98.38/stat/ip_speed_stat.php");
         _loc6_.method = URLRequestMethod.POST;
         _loc6_.data = _loc5_;
      }
      
      private function onGetIPByError(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.currentTarget as URLLoader;
         var _loc3_:String = _loc2_.data;
         var _loc4_:URLLoader = new URLLoader();
         var _loc5_:URLVariables = new URLVariables();
         _loc5_["ip"] = _loc3_;
         _loc5_["size"] = 0;
         _loc5_["time"] = 0;
         _loc5_["game"] = "seer";
         var _loc6_:URLRequest = new URLRequest("http://114.80.98.38/stat/ip_speed_stat.php");
         _loc6_.method = URLRequestMethod.POST;
         _loc6_.data = _loc5_;
      }
      
      private function onIPError(param1:IOErrorEvent) : void
      {
      }
      
      private function initPVM() : void
      {
         PVM.getInstance(PVM.ALL_VERSION).checkIsOnline(this.stage);
         this.fileLoader = new PVM_Loader(PVM.ALL_VERSION);
         this.fileLoader.addEventListener(PVM_Event.ON_HEADER_LOADED,this.onHeaderLoaded);
         this.fileLoader.load("version.swf");
      }
      
      private function onHeaderLoaded(param1:PVM_Event) : void
      {
         this.fileLoader.removeEventListener(PVM_Event.ON_HEADER_LOADED,this.onHeaderLoaded);
         this.onHeaderFilesListLoaded_And_LoadBody();
      }
      
      private function onHeaderFilesListLoaded_And_LoadBody() : void
      {
         IPVM_Loader(this.fileLoader).loadBody();
         this.fileLoader.addEventListener(PVM_Event.ON_LOADED,this.onBodyLoaded);
         LoaderUtil.addLoaderEvents(this,this.fileLoader.byteLoader,null,null,null,this.progressHandler);
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
         var _loc2_:Number = param1.bytesTotal;
         var _loc3_:Number = param1.bytesLoaded;
         var _loc4_:Number = Math.floor(_loc3_ / _loc2_ * 100);
         this.loadingMC["perNum"].text = _loc4_ + "%";
         this.loadingMC["tip_txt"].text = "初始化环境";
         this.loadingMC["loadingBar"].gotoAndStop(_loc4_);
      }
      
      private function onBodyLoaded(param1:PVM_Event) : void
      {
         this.fileLoader.removeEventListener(PVM_Event.ON_LOADED,this.onBodyLoaded);
         this.init();
      }
   }
}

