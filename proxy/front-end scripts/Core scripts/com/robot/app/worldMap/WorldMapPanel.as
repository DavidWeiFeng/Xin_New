package com.robot.app.worldMap
{
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.mapTip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.system.ApplicationDomain;
   import flash.text.*;
   import flash.utils.*;
   import gs.*;
   import gs.easing.*;
   import org.taomee.effect.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class WorldMapPanel extends Sprite
   {
      
      private const GALAXY_NAME:String = "galaxy";
      
      private var hotMCArray:Array = [];
      
      private var mapMC:MovieClip;
      
      private var app:ApplicationDomain;
      
      private var perHot:uint = 10;
      
      private var myIcon:MovieClip;
      
      private var txt:TextField;
      
      private var galaxyMC:MovieClip;
      
      private var galaxyArray:Array = [];
      
      private var backBtn:SimpleButton;
      
      private var infoTxt:TextField;
      
      private var intervalId:uint;
      
      private var subPanel:AppModel;
      
      public function WorldMapPanel()
      {
         super();
      }
      
      public function show() : void
      {
         var _local_1:MCLoader = null;
         LevelManager.appLevel.addChild(this);
         if(!this.mapMC)
         {
            _local_1 = new MCLoader("resource/worldMap.swf",LevelManager.appLevel,1,"正在打开星系地图");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,this.onLoad);
            _local_1.addEventListener(MCLoadEvent.CLOSE,this.onCloseLoad);
            _local_1.doLoad();
         }
         else
         {
            setTimeout(this.initMap,200);
         }
      }
      
      private function onCloseLoad(_arg_1:MCLoadEvent) : void
      {
         this.close();
      }
      
      private function onLoad(_arg_1:MCLoadEvent) : void
      {
         var _local_2:Shape = null;
         _local_2 = null;
         this.app = _arg_1.getApplicationDomain();
         this.mapMC = _arg_1.getContent() as MovieClip;
         setTimeout(this.initMap,200);
         _local_2 = new Shape();
         _local_2.graphics.beginFill(0);
         _local_2.graphics.drawRect(0,0,320,30);
         _local_2.graphics.endFill();
         _local_2.x = 508;
         _local_2.y = 398;
         this.mapMC.addChild(_local_2);
         this.txt = new TextField();
         this.mapMC.addChild(this.txt);
         this.txt.height = 30;
         this.txt.autoSize = TextFieldAutoSize.LEFT;
         this.txt.cacheAsBitmap = true;
         this.txt.x = _local_2.x;
         this.txt.y = _local_2.y;
         this.txt.mask = _local_2;
         this.txt.text = UpdateConfig.mapScrollArray.join("        ");
         var _local_3:TextFormat = new TextFormat();
         _local_3.size = 14;
         _local_3.color = 16777215;
         this.txt.setTextFormat(_local_3);
         this.txt.addEventListener(Event.ENTER_FRAME,this.onTxtEnterFrame);
      }
      
      private function onTxtEnterFrame(_arg_1:Event) : void
      {
         this.txt.x -= 1;
         if(this.txt.x < -(this.txt.textWidth + 20))
         {
            this.txt.x = 508 + 322;
         }
      }
      
      private function initMap() : void
      {
         var _local_1:SimpleButton = null;
         var _local_2:String = null;
         var _local_3:uint = 0;
         var _local_7:uint = 0;
         var _local_9:* = undefined;
         addChild(this.mapMC);
         this.backBtn = this.mapMC["backBtn"];
         if(!this.subPanel)
         {
            this.backBtn.visible = false;
         }
         else
         {
            _local_9 = this.subPanel.content;
            _local_9["getHot"]();
         }
         this.backBtn.addEventListener(MouseEvent.CLICK,this.backHandler);
         var _local_4:SimpleButton = this.mapMC["closeBtn"];
         _local_4.addEventListener(MouseEvent.CLICK,this.close);
         this.initGalaxy();
         var _local_5:MovieClip = this.mapMC["shipBtnMC"];
         var _local_6:uint = uint(_local_5.numChildren);
         while(_local_7 < _local_6)
         {
            _local_1 = _local_5.getChildAt(_local_7) as SimpleButton;
            if(Boolean(_local_1))
            {
               _local_1.addEventListener(MouseEvent.CLICK,this.changeMap);
               _local_3 = uint(_local_1.name.split("_")[1]);
               _local_2 = MapConfig.getName(_local_3) + "\r<font color=\'#ff0000\'>" + MapConfig.getDes(_local_3) + "</font>";
               _local_1.addEventListener(MouseEvent.MOUSE_OVER,this.onMosOver);
               _local_1.addEventListener(MouseEvent.MOUSE_OUT,this.onMosOut);
            }
            _local_7++;
         }
         SocketConnection.addCmdListener(CommandID.MAP_HOT,this.onGetMapHot);
         SocketConnection.mainSocket.send(CommandID.MAP_HOT,[]);
         var _local_8:uint = uint(MainManager.serverID);
         this.mapMC["serverNameTxt"].text = _local_8.toString() + ". " + ServerConfig.getNameByID(_local_8);
         if(TasksManager.getTaskStatus(45) == TasksManager.ALR_ACCEPT)
         {
            this.mapMC["shipBtnMC"]["taskIcon_45"].alpha = 1;
         }
         else
         {
            this.mapMC["shipBtnMC"]["taskIcon_45"].alpha = 0;
         }
         this.initMyPostion();
      }
      
      private function backHandler(_arg_1:MouseEvent) : void
      {
         this.backBtn.visible = false;
         if(Boolean(this.subPanel))
         {
            this.subPanel.destroy();
            this.subPanel = null;
         }
         this.galaxyMC.mouseChildren = true;
         TweenLite.to(this.galaxyMC,1,{
            "alpha":1,
            "x":94,
            "y":95
         });
      }
      
      private function onMosOver(evt:MouseEvent) : void
      {
         var id:uint = 0;
         id = 0;
         var btn:SimpleButton = evt.currentTarget as SimpleButton;
         id = uint(btn.name.split("_")[1]);
         this.intervalId = setTimeout(function():void
         {
            MapTip.show(new MapTipInfo(id));
         },500);
      }
      
      private function onMosOut(_arg_1:MouseEvent) : void
      {
         clearInterval(this.intervalId);
         MapTip.hide();
      }
      
      private function onGetMapHot(_arg_1:SocketEvent) : void
      {
         var _local_2:uint = 0;
         var _local_3:MovieClip = null;
         var _local_4:SimpleButton = null;
         var _local_5:uint = 0;
         var _local_7:MovieClip = null;
         var _local_8:MovieClip = null;
         var _local_9:uint = 0;
         var _local_10:uint = 0;
         var _local_6:* = undefined;
         SocketConnection.removeCmdListener(CommandID.MAP_HOT,this.onGetMapHot);
         var _local_11:MapHotInfo = _arg_1.data as MapHotInfo;
         for each(_local_2 in _local_11.infos.getKeys())
         {
            _local_3 = this.mapMC["shipBtnMC"];
            _local_4 = _local_3.getChildByName("btn_" + _local_2) as SimpleButton;
            if(Boolean(_local_4) && _local_2 != 102)
            {
               _local_5 = uint(Math.ceil(uint(_local_11.infos.getValue(_local_2)) / this.perHot));
               if(_local_5 > 5)
               {
                  _local_5 = 5;
               }
               _local_2 = 0;
               while(_local_2 < _local_5)
               {
                  _local_6 = this.app.getDefinition("ShipHotMC");
                  _local_7 = new _local_6() as MovieClip;
                  _local_7.filters = [new DropShadowFilter(2,45,0,1,3,3)];
                  _local_7.mouseEnabled = false;
                  _local_7.x = _local_4.x + 4;
                  _local_7.y = _local_4.y + _local_4.height - 8 - _local_7.height * _local_2;
                  _local_3.addChild(_local_7);
                  this.hotMCArray.push(_local_7);
                  _local_2++;
               }
            }
            if(_local_2 == 102)
            {
               if(Boolean(_local_4))
               {
                  _local_8 = _local_3.getChildByName("hotMC_" + _local_2) as MovieClip;
                  _local_9 = uint(Math.ceil(uint(_local_11.infos.getValue(_local_2)) / this.perHot));
                  if(_local_9 > 5)
                  {
                     _local_9 = 5;
                  }
                  _local_10 = 0;
                  while(_local_10 < 5)
                  {
                     if(_local_10 < _local_9)
                     {
                        _local_8["mc_" + _local_10].gotoAndStop(1);
                     }
                     else
                     {
                        _local_8["mc_" + _local_10].gotoAndStop(2);
                     }
                     _local_10++;
                  }
               }
            }
         }
      }
      
      private function changeMap(_arg_1:MouseEvent) : void
      {
         var _local_2:String = (_arg_1.currentTarget as SimpleButton).name;
         var _local_3:uint = uint(_local_2.split("_")[1]);
         MapManager.changeMap(_local_3);
         this.close();
      }
      
      private function close(_arg_1:MouseEvent = null) : void
      {
         var _local_2:MovieClip = null;
         this.galaxyArray = [];
         DisplayUtil.removeForParent(this,false);
         for each(_local_2 in this.hotMCArray)
         {
            DisplayUtil.removeForParent(_local_2);
         }
         this.hotMCArray = [];
      }
      
      private function initGalaxy() : void
      {
         var _local_1:InteractiveObject = null;
         var _local_2:uint = 0;
         var _local_4:uint = 0;
         this.galaxyMC = this.mapMC["galaxyMC"];
         var _local_3:uint = uint(this.galaxyMC.numChildren);
         while(_local_4 < _local_3)
         {
            _local_1 = this.galaxyMC.getChildAt(_local_4) as InteractiveObject;
            if(Boolean(_local_1))
            {
               if(_local_1.name.substring(0,6) == this.GALAXY_NAME)
               {
                  _local_2 = uint(_local_1.name.split("_")[1]);
                  this.galaxyArray.push(_local_1);
                  _local_1.cacheAsBitmap = true;
                  _local_1.filters = [ColorFilter.setBrightness(-20)];
                  _local_1.addEventListener(MouseEvent.ROLL_OVER,this.onOverGalaxy);
                  _local_1.addEventListener(MouseEvent.ROLL_OUT,this.onOutGalaxy);
                  _local_1.addEventListener(MouseEvent.CLICK,this.onClickGalaxy);
                  ToolTipManager.add(_local_1,GalaxyXMLInfo.getName(_local_2));
               }
            }
            _local_4++;
         }
         if(Boolean(this.subPanel))
         {
            this.subPanel.show();
         }
      }
      
      private function onOverGalaxy(_arg_1:MouseEvent) : void
      {
         var _local_2:InteractiveObject = _arg_1.target as InteractiveObject;
         _local_2.filters = [ColorFilter.setBrightness(30)];
      }
      
      private function onOutGalaxy(_arg_1:MouseEvent) : void
      {
         var _local_2:InteractiveObject = _arg_1.target as InteractiveObject;
         _local_2.filters = [ColorFilter.setBrightness(-20)];
      }
      
      private function onClickGalaxy(event:MouseEvent) : void
      {
         var mc:InteractiveObject = null;
         var i:InteractiveObject = null;
         var p:Point = null;
         mc = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         this.galaxyMC.mouseChildren = false;
         this.backBtn.visible = true;
         mc = event.target as InteractiveObject;
         for each(i in this.galaxyArray)
         {
            i.mouseEnabled = true;
         }
         p = mc.localToGlobal(new Point());
         dx = 498 - p.x;
         dy = 269 - p.y;
         TweenLite.to(this.galaxyMC,1,{
            "x":this.galaxyMC.x + dx,
            "y":this.galaxyMC.y + dy,
            "ease":Cubic.easeOut,
            "onComplete":function():void
            {
               loadGalaxy(uint(mc.name.split("_")[1]));
               TweenLite.to(galaxyMC,1,{"alpha":0.2});
            }
         });
      }
      
      private function loadGalaxy(_arg_1:uint) : void
      {
         this.subPanel = new AppModel(ClientConfig.getAppModule("subMap/Galaxy_" + _arg_1),"正在进入" + GalaxyXMLInfo.getName(_arg_1));
         this.subPanel.init(this.mapMC);
         this.subPanel.setup();
         this.subPanel.show();
      }
      
      private function initMyPostion() : void
      {
         var _local_2:SimpleButton = null;
         var _local_1:* = undefined;
         if(!this.myIcon)
         {
            _local_1 = this.app.getDefinition("my_icon");
            this.myIcon = new _local_1() as MovieClip;
            this.myIcon.mouseChildren = false;
            this.myIcon.mouseEnabled = false;
            DisplayUtil.FillColor(this.myIcon["mc"]["colorMC"],MainManager.actorInfo.color);
         }
         var _local_3:Point = SuperMapXMLInfo.getWorldMapPos(MapConfig.getSuperMapID(MainManager.actorInfo.mapID));
         if(Boolean(_local_3))
         {
            if(_local_3.x == 0 && _local_3.y == 0)
            {
               _local_2 = this.mapMC["shipBtnMC"].getChildByName("btn_" + MainManager.actorInfo.mapID) as SimpleButton;
               if(Boolean(_local_2))
               {
                  this.myIcon.x = _local_2.x;
                  this.myIcon.y = _local_2.y;
                  this.mapMC["shipBtnMC"].addChild(this.myIcon);
               }
               else
               {
                  DisplayUtil.removeForParent(this.myIcon,false);
               }
            }
            else
            {
               DisplayUtil.removeForParent(this.myIcon,false);
            }
         }
         else
         {
            DisplayUtil.removeForParent(this.myIcon,false);
         }
      }
   }
}

