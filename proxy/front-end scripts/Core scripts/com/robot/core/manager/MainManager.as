package com.robot.core.manager
{
   import com.adobe.images.PNGEncoder;
   import com.robot.core.*;
   import com.robot.core.aticon.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.manager.bean.*;
   import com.robot.core.manager.map.config.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class MainManager
   {
      
      public static var WxOs:Dictionary;
      
      public static var isClothHalfDay:Boolean;
      
      public static var isRoomHalfDay:Boolean;
      
      public static var iFortressHalfDay:Boolean;
      
      public static var isHQHalfDay:Boolean;
      
      private static var _isMember:Boolean;
      
      private static var _actorInfo:UserInfo;
      
      private static var _actorModel:ActorModel;
      
      private static var _uiLoader:MCLoader;
      
      public static var actorID:uint;
      
      public static var serverID:uint;
      
      public static const DfSpeed:Number = 4.6;
      
      private static const XML_PATH:String = "config/xmlList.xml";
      
      private static const UI_PATH:String = "resource/ui.swf";
      
      private static const ICON_PATH:String = "resource/taskIcon.swf";
      
      private static const AIMAT_PATH:String = "resource/aimat/aimatUI.swf";
      
      public static var CHANNEL:uint = 0;
      
      public static var _date:Date = null;
      
      public static var count:int = 2700000;
      
      public static var isRecordedInTopLeft:Boolean = false;
      
      public static var isRecordedProcess:Boolean = false;
      
      public static var isRecordedIsRunningInVm:Boolean = false;
      
      public static var isPossiblyMacroControlled:Boolean = false;
      
      public function MainManager()
      {
         super();
      }
      
      public static function setup(_arg_1:Object) : void
      {
         _actorInfo = new UserInfo();
         UserInfo.setForLoginInfo(_actorInfo,_arg_1 as IDataInput);
         SocketConnection.mainSocket.userID = _actorInfo.userID;
         initBean();
         TaomeeManager.initFightSpeed();
      }
      
      public static function creatActor() : void
      {
         _actorModel = new ActorModel(_actorInfo);
         if(_actorInfo.actionType == 1)
         {
            _actorModel.walk = new FlyAction(_actorModel);
         }
         else
         {
            _actorModel.walk = new WalkAction();
         }
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.CREATED_ACTOR));
      }
      
      private static function loadXMLList() : void
      {
         var urlloader:URLLoader = null;
         var xmlCompleteHandler:Function = null;
         var ioERRORHandler:Function = null;
         urlloader = new URLLoader();
         xmlCompleteHandler = null;
         ioERRORHandler = null;
         xmlCompleteHandler = function(_arg_1:Event):void
         {
            urlloader.removeEventListener(Event.COMPLETE,xmlCompleteHandler);
            urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioERRORHandler);
            var _local_2:XML = new XML(_arg_1.target.data);
            XmlConfig.setup(_local_2);
            MapConfig.setup(initPetXML);
         };
         ioERRORHandler = function(_arg_1:IOErrorEvent):void
         {
            urlloader.removeEventListener(Event.COMPLETE,xmlCompleteHandler);
            urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioERRORHandler);
            Alarm.show("xml加载出错！");
         };
         urlloader.addEventListener(Event.COMPLETE,xmlCompleteHandler);
         urlloader.addEventListener(IOErrorEvent.IO_ERROR,ioERRORHandler);
         urlloader.load(new URLRequest(XML_PATH + "?" + Math.random()));
      }
      
      private static function initPetXML() : void
      {
         PetXMLInfo.setup(initPetBookXML);
      }
      
      private static function initPetBookXML() : void
      {
         PetBookXMLInfo.setup(initSkillXML);
      }
      
      private static function initSkillXML() : void
      {
         SkillXMLInfo.parseInfo(initItemXML);
      }
      
      private static function initItemXML() : void
      {
         ItemXMLInfo.parseInfo(initMapIntroXML);
      }
      
      private static function initMapIntroXML() : void
      {
         MapIntroXMLInfo.setup(initAchieveXML);
      }
      
      private static function initAchieveXML() : void
      {
         AchieveXMLInfo.setup(initItemTipXml);
      }
      
      private static function initItemTipXml() : void
      {
         ItemTipXMLInfo.setup(function():void
         {
            EventManager.dispatchEvent(new XMLLoadEvent(XMLLoadEvent.ON_SUCCESS,null));
         });
      }
      
      public static function loaderUILib() : void
      {
         _uiLoader = new MCLoader(UI_PATH,MainManager.getStage(),1,"正在加载星球");
         _uiLoader.setIsShowClose(false);
         _uiLoader.addEventListener(MCLoadEvent.SUCCESS,onLoadUI);
         _uiLoader.addEventListener(MCLoadEvent.ERROR,onFailLoadUI);
         _uiLoader.doLoad();
      }
      
      private static function onLoadUI(event:MCLoadEvent) : void
      {
         var loader:MCLoader = null;
         UIManager.setup(event.getLoader());
         loader = new MCLoader(ICON_PATH,MainManager.getStage(),1,"正在加载任务信息");
         loader.addEventListener(MCLoadEvent.SUCCESS,onLoadIcon);
         loader.setIsShowClose(false);
         loader.addEventListener(MCLoadEvent.ERROR,function(_arg_1:MCLoadEvent):void
         {
            throw new Error("ICON加载出错");
         });
         loader.doLoad();
      }
      
      private static function onLoadIcon(event:MCLoadEvent) : void
      {
         var loader:MCLoader = null;
         TaskIconManager.setup(event.getLoader());
         loader = new MCLoader(AIMAT_PATH,MainManager.getStage(),1,"正在加载任务信息");
         loader.setIsShowClose(false);
         loader.addEventListener(MCLoadEvent.SUCCESS,onLoadAimat);
         loader.addEventListener(MCLoadEvent.ERROR,function(_arg_1:MCLoadEvent):void
         {
            throw new Error("AIMAT加载出错");
         });
         loader.doLoad();
      }
      
      private static function onLoadAimat(_arg_1:MCLoadEvent) : void
      {
         AimatUIManager.setup(_arg_1.getLoader());
         loadXMLList();
      }
      
      private static function initBean() : void
      {
         creatActor();
         EventManager.addEventListener(RobotEvent.BEAN_COMPLETE,onAllBeanComplete);
         BeanManager.start();
      }
      
      private static function onAllBeanComplete(_arg_1:Event) : void
      {
         var _local_2:String = null;
         if(checkIsNovice())
         {
            if(!TasksManager.isComNoviceTask())
            {
               MapManager.changeLocalMap(515);
            }
            else
            {
               MapManager.changeMap(MainManager.actorInfo.mapID);
            }
         }
         else
         {
            MapManager.changeMap(MainManager.actorInfo.mapID);
         }
         NonoManager.getInfo();
         initWxInterface();
      }
      
      public static function initWxInterface() : void
      {
         var WxCallback:*;
         var construct:Function = function(cls:Class, args:Array):*
         {
            switch(args.length)
            {
               case 0:
                  return new cls();
               case 1:
                  return new cls(args[0]);
               case 2:
                  return new cls(args[0],args[1]);
               case 3:
                  return new cls(args[0],args[1],args[2]);
               case 4:
                  return new cls(args[0],args[1],args[2],args[3]);
               case 5:
                  return new cls(args[0],args[1],args[2],args[3],args[4]);
               default:
                  throw new Error("Too many constructor arguments");
            }
         };
         WxOs = new Dictionary();
         if(!ExternalInterface.available)
         {
            return;
         }
         WxCallback = function(result:* = null):void
         {
            ExternalInterface.call("WxSc.Priv.res",result);
         };
         ExternalInterface.addCallback("WxSendWithCallback2",function(commandID:int, parameterArray:Array = null):void
         {
            SocketConnection.sendWithCallback2(commandID,function(event:SocketEvent):void
            {
               var data:ByteArray = event.data as ByteArray;
               var packet:Array = new Array();
               for(var i:int = 0; i < data.length; i++)
               {
                  packet.push(data.readUnsignedByte());
               }
               WxCallback(packet);
            },parameterArray);
         });
         ExternalInterface.addCallback("WxSwf2Jpg",function(url:String, name:String, scaleMain:Number, scaleStage:Number):void
         {
            var WxMcload:* = undefined;
            WxMcload = new Loader();
            var lc:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
            WxMcload.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void
            {
               var swfContent:DisplayObject = null;
               var bounds:Rectangle = null;
               var bmData:BitmapData = null;
               var matrix:Matrix = null;
               var imgBytes:ByteArray = null;
               var byteArray:Array = null;
               var i:int = 0;
               try
               {
                  swfContent = WxMcload.content;
                  if(swfContent is MovieClip)
                  {
                     MovieClip(swfContent).stop();
                  }
                  bounds = swfContent.getBounds(null);
                  bmData = new BitmapData(bounds.width * scaleStage,bounds.height * scaleStage,true,16777215);
                  matrix = new Matrix();
                  matrix.scale(scaleMain,scaleMain);
                  bmData.draw(swfContent,matrix);
                  imgBytes = PNGEncoder.encode(bmData);
                  byteArray = [];
                  imgBytes.position = 0;
                  for(i = 0; i < imgBytes.length; i++)
                  {
                     byteArray.push(imgBytes.readUnsignedByte());
                  }
                  ExternalInterface.call("WxSc.Priv.DownloadJpg",byteArray,name);
               }
               catch(err:Error)
               {
                  ExternalInterface.call("console.log",err.message);
               }
            });
            WxMcload.load(new URLRequest(url),lc);
         });
         ExternalInterface.addCallback("WxSend",function(commandID:int, parameterArray:Array = null):void
         {
            SocketConnection.send_2(commandID,parameterArray);
         });
         ExternalInterface.addCallback("WxAddFunc",function(k1:String, k2:String):void
         {
            WxOs[k1] = function(... rest):void
            {
               WxOs[k2] = rest;
               ExternalInterface.call("WxSc.Priv." + k1);
            };
         });
         ExternalInterface.addCallback("WxDelObj",function(k:String):void
         {
            WxOs[k] = undefined;
         });
         ExternalInterface.addCallback("WxRefl",function(type:uint, name:String, path:String, ... rest):*
         {
            var key:String = null;
            var ps:Array = null;
            var i:int = 0;
            var keys:Array = path.split(".");
            var lastKey:String = keys.pop();
            var current:Object = getDefinitionByName(name);
            for each(key in keys)
            {
               current = current[key];
            }
            switch(type)
            {
               case 1:
                  current[lastKey] = Boolean(rest[0]) ? WxOs[rest[1]] : rest[1];
                  return;
               case 2:
                  return current[lastKey];
               case 3:
               case 4:
                  ps = [];
                  for(i = type - 3; i < rest.length; )
                  {
                     ps.push(Boolean(rest[i]) ? WxOs[rest[i + 1]] : rest[i + 1]);
                     i += 2;
                  }
                  if(type == 3)
                  {
                     return current[lastKey].apply(null,ps);
                  }
                  WxOs[rest[0]] = current[lastKey].apply(null,ps);
            }
         });
         ExternalInterface.addCallback("WxTmpAttrib",function(k1:String, attrib:String, k2:String):void
         {
            WxOs[k2] = WxOs[k1][attrib];
         });
         ExternalInterface.addCallback("WxAutoAlarmOk",function(n:Number):void
         {
            getDefinitionByName("flash.utils.setInterval").apply(null,[function():void
            {
               var child:* = undefined;
               var name:* = undefined;
               var childi:* = undefined;
               var namei:* = undefined;
               var stage:* = LevelManager.stage;
               for(var i:* = 0; i < stage.numChildren; i++)
               {
                  child = stage.getChildAt(i);
                  name = getQualifiedClassName(child);
                  if(name == "AlarmMC")
                  {
                     child["applyBtn"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     break;
                  }
                  if(name == "CountExpPanel_UI")
                  {
                     child["okBtn"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     break;
                  }
               }
               stage = LevelManager.tipLevel;
               for(var ii:* = 0; i < stage.numChildren; i++)
               {
                  childi = stage.getChildAt(ii);
                  namei = getQualifiedClassName(childi);
                  if(namei == "Alarm_Special" || namei == "Alarm_New")
                  {
                     child["applyBtn"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     break;
                  }
                  if(namei == "UI_PetSwitchAlert" || namei == "UI_PetInStorageAlert")
                  {
                     child["applyBtn"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     break;
                  }
               }
            },n]);
         });
         ExternalInterface.addCallback("WxAddObj",function(key:String, name:String, ... rest):void
         {
            var c:Class = getDefinitionByName(name) as Class;
            var args:Array = [];
            for(var i:int = 0; i < rest.length; i += 2)
            {
               args.push(Boolean(rest[i]) ? WxOs[rest[i + 1]] : rest[i + 1]);
            }
            WxOs[key] = construct(c,args);
         });
      }
      
      public static function checkIsRunningInVm() : void
      {
         var result:Boolean = false;
         var processList:String = null;
         var machineInfo:String = null;
         if(ExternalInterface.available)
         {
            result = ExternalInterface.call("getIsRunningInVm");
            if(result && !isRecordedIsRunningInVm)
            {
               isRecordedIsRunningInVm = true;
               processList = ExternalInterface.call("getProceessList");
               machineInfo = ExternalInterface.call("getMachineInfo");
            }
         }
         setInterval(function():void
         {
            var _local_1:Boolean = false;
            var _local_2:String = null;
            var _local_3:String = null;
            if(ExternalInterface.available)
            {
               _local_1 = ExternalInterface.call("getIsRunningInVm");
               if(_local_1 && !isRecordedIsRunningInVm)
               {
                  isRecordedIsRunningInVm = true;
                  _local_2 = ExternalInterface.call("getProceessList");
                  _local_3 = ExternalInterface.call("getMachineInfo");
               }
            }
         },60000);
      }
      
      public static function checkSpeed() : void
      {
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,function(_arg_1:SocketEvent):void
         {
            var _local_3:int = 0;
            var _local_2:SystemTimeInfo = _arg_1.data as SystemTimeInfo;
            if(_local_2.num == 0)
            {
               return;
            }
            if(_date != null)
            {
               _local_3 = int(count / (_local_2.date.time - _date.time));
               if(_local_3 >= 2)
               {
                  TaomeeManager.xinCheck(2,String(_local_3));
               }
            }
            _date = _local_2.date;
         });
         setInterval(function():void
         {
            SocketConnection.send(CommandID.SYSTEM_TIME,int(Math.random() * 1000),int(Math.random() * 1000));
         },count);
      }
      
      public static function checkUA() : void
      {
         var userAgent:String = null;
         userAgent = "*unknown";
         if(ExternalInterface.available)
         {
            try
            {
               userAgent = ExternalInterface.call("function() { return navigator.userAgent; }");
               if(userAgent.indexOf("seer-game") == -1)
               {
                  TaomeeManager.xinCheck(3,userAgent);
               }
            }
            catch(error:Error)
            {
               TaomeeManager.xinCheck(3,userAgent);
            }
         }
         else
         {
            TaomeeManager.xinCheck(3,userAgent);
         }
      }
      
      public static function checkIsInTopLeft() : Boolean
      {
         var result:Boolean = false;
         var processList:String = null;
         var machineInfo:String = null;
         if(ExternalInterface.available)
         {
            result = ExternalInterface.call("getIsInTopLeftCorner");
            if(result && !isRecordedInTopLeft)
            {
               isRecordedInTopLeft = true;
               processList = ExternalInterface.call("getProceessList");
               machineInfo = ExternalInterface.call("getMachineInfo");
               TaomeeManager.xinCheck(5,"isInTopLeftCorner,machineInfo:" + machineInfo + ",processList:" + processList);
            }
         }
         setInterval(function():void
         {
            var _local_1:Boolean = false;
            var _local_2:String = null;
            var _local_3:String = null;
            if(ExternalInterface.available)
            {
               _local_1 = ExternalInterface.call("getIsInTopLeftCorner");
               if(_local_1 && !isRecordedInTopLeft)
               {
                  isRecordedInTopLeft = true;
                  _local_2 = ExternalInterface.call("getProceessList");
                  _local_3 = ExternalInterface.call("getMachineInfo");
                  TaomeeManager.xinCheck(5,"isInTopLeftCorner,machineInfo:" + _local_3 + ",processList:" + _local_2);
               }
            }
         },60000);
         return result;
      }
      
      public static function checkIsPossiblyMacroControlled() : Boolean
      {
         var result:Boolean = false;
         var processList:String = null;
         var machineInfo:String = null;
         if(ExternalInterface.available)
         {
            result = ExternalInterface.call("getIsPossiblyMacroControlled");
            if(result && !isPossiblyMacroControlled)
            {
               isPossiblyMacroControlled = true;
               processList = ExternalInterface.call("getProceessList");
               machineInfo = ExternalInterface.call("getMachineInfo");
               TaomeeManager.xinCheck(5,"isPossiblyMacroControlled,machineInfo:" + machineInfo + "processList:" + processList);
            }
         }
         setInterval(function():void
         {
            var _local_1:Boolean = false;
            var _local_2:String = null;
            var _local_3:String = null;
            if(ExternalInterface.available)
            {
               _local_1 = ExternalInterface.call("getIsPossiblyMacroControlled");
               if(_local_1 && !isPossiblyMacroControlled)
               {
                  isPossiblyMacroControlled = true;
                  _local_2 = ExternalInterface.call("getProceessList");
                  _local_3 = ExternalInterface.call("getMachineInfo");
                  TaomeeManager.xinCheck(5,"isPossiblyMacroControlled,machineInfo:" + _local_3 + "processList:" + _local_2);
               }
            }
         },60000);
         return result;
      }
      
      public static function checkIsNovice() : Boolean
      {
         var _local_1:Number = MainManager.actorInfo.regTime * 1000;
         var _local_2:Boolean = true;
         var _local_3:Date = new Date(_local_1);
         var _local_4:String = _local_3.getFullYear().toString();
         var _local_5:String = (_local_3.getMonth() + 1).toString();
         if(_local_5.length == 1)
         {
            _local_5 = "0" + _local_5;
         }
         var _local_6:String = _local_3.getDate().toString();
         if(_local_6.length == 1)
         {
            _local_6 = "0" + _local_6;
         }
         var _local_7:String = _local_3.getHours().toString();
         if(_local_7.length == 1)
         {
            _local_7 = "0" + _local_7;
         }
         var _local_8:String = _local_3.getMinutes().toString();
         if(_local_8.length == 1)
         {
            _local_8 = "0" + _local_8;
         }
         var _local_9:Number = Number(_local_4 + _local_5 + _local_6 + _local_7 + _local_8);
         if(_local_9 < 201003112359)
         {
            _local_2 = false;
         }
         return _local_2;
      }
      
      public static function get isMember() : Boolean
      {
         return _isMember;
      }
      
      public static function get actorInfo() : UserInfo
      {
         return _actorInfo;
      }
      
      public static function get actorClothStr() : String
      {
         var _local_1:PeopleItemInfo = null;
         var _local_2:Array = actorInfo.clothes;
         var _local_3:Array = [];
         for each(_local_1 in _local_2)
         {
            _local_3.push(_local_1.id);
         }
         return _local_3.sort().join(",");
      }
      
      public static function get actorModel() : ActorModel
      {
         return _actorModel;
      }
      
      public static function upDateForPeoleInfo(_arg_1:UserInfo) : void
      {
         _actorInfo.userID = _arg_1.userID;
         _actorInfo.nick = _arg_1.nick;
         _actorInfo.curTitle = _arg_1.curTitle;
         _actorInfo.color = _arg_1.color;
         _actorInfo.texture = _arg_1.texture;
         _actorInfo.vip = _arg_1.vip;
         _actorInfo.action = _arg_1.action;
         _actorInfo.direction = _arg_1.direction;
         _actorInfo.spiritID = _arg_1.spiritID;
         _actorInfo.fightFlag = _arg_1.fightFlag;
         _actorInfo.teacherID = _arg_1.teacherID;
         _actorInfo.studentID = _arg_1.studentID;
         _actorInfo.nonoState = _arg_1.nonoState.slice();
         _actorInfo.nonoColor = _arg_1.nonoColor;
         _actorInfo.nonoNick = _arg_1.nonoNick;
         _actorInfo.superNono = _arg_1.superNono;
         _actorInfo.clothes = _arg_1.clothes.slice();
      }
      
      public static function getRoot() : Sprite
      {
         return LevelManager.root;
      }
      
      public static function getStage() : Stage
      {
         return LevelManager.stage;
      }
      
      public static function getStageWidth() : int
      {
         return TaomeeManager.stageWidth;
      }
      
      public static function getStageHeight() : int
      {
         return TaomeeManager.stageHeight;
      }
      
      public static function getStageCenterPoint() : Point
      {
         return new Point(TaomeeManager.stageWidth / 2,TaomeeManager.stageHeight / 2);
      }
      
      public static function getStageMousePoint() : Point
      {
         return new Point(getStage().mouseX,getStage().mouseY);
      }
      
      private static function onFailLoadUI(_arg_1:MCLoadEvent) : void
      {
         throw new Error("UI/Icon资源加载错误");
      }
   }
}

