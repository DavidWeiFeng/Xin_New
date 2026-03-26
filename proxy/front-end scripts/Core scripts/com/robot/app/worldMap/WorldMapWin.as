package com.robot.app.worldMap
{
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.system.ApplicationDomain;
   import flash.text.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class WorldMapWin extends Sprite
   {
      
      private var mapMC:MovieClip;
      
      private var app:ApplicationDomain;
      
      private var hotMCArray:Array = [];
      
      private var perHot:uint = 10;
      
      private var txt:TextField;
      
      private var shape:Shape;
      
      private var prevBtn:SimpleButton;
      
      private var nextBtn:SimpleButton;
      
      private var dir:int;
      
      private var myIcon:MovieClip;
      
      private var mapScrollRect:Rectangle;
      
      private var bgScrollRect:Rectangle;
      
      private var target:Number = 0;
      
      private var target2:Number = 0;
      
      private var isHited:Boolean = false;
      
      public function WorldMapWin()
      {
         super();
         this.mapScrollRect = new Rectangle(0,0,763,260);
         this.mapScrollRect.x = 124 + 696;
         this.bgScrollRect = new Rectangle(0,0,783,356);
      }
      
      public function show() : void
      {
         var _local_1:MCLoader = null;
         LevelManager.appLevel.addChild(this);
         if(!this.mapMC)
         {
            _local_1 = new MCLoader("resource/worldMap.swf",LevelManager.appLevel,1,"正在打开星际地图");
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
         this.app = _arg_1.getApplicationDomain();
         this.mapMC = _arg_1.getContent() as MovieClip;
         setTimeout(this.initMap,200);
         this.shape = new Shape();
         this.shape.graphics.beginFill(0);
         this.shape.graphics.drawRect(0,0,322,30);
         this.shape.graphics.endFill();
         this.shape.x = 508;
         this.shape.y = 398;
         this.mapMC.addChild(this.shape);
         this.txt = new TextField();
         this.mapMC.addChild(this.txt);
         this.txt.height = 30;
         this.txt.autoSize = TextFieldAutoSize.LEFT;
         this.txt.cacheAsBitmap = true;
         this.txt.x = this.shape.x;
         this.txt.y = this.shape.y;
         this.txt.mask = this.shape;
         this.txt.text = UpdateConfig.mapScrollArray.join("        ");
         var _local_2:TextFormat = new TextFormat();
         _local_2.size = 14;
         _local_2.color = 16777215;
         this.txt.setTextFormat(_local_2);
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
         var _local_2:uint = 0;
         var _local_3:String = null;
         var _local_8:int = 0;
         addChild(this.mapMC);
         if(TasksManager.getTaskStatus(47) == TasksManager.COMPLETE)
         {
            this.mapMC["plantBtnMC"]["stones_mc"].visible = false;
         }
         if(TasksManager.getTaskStatus(19) == TasksManager.ALR_ACCEPT)
         {
            this.mapMC["plantBtnMC"]["task_19"].alpha = 1;
         }
         else
         {
            this.mapMC["plantBtnMC"]["task_19"].alpha = 0;
         }
         if(TasksManager.getTaskStatus(45) == TasksManager.ALR_ACCEPT)
         {
            this.mapMC["shipBtnMC"]["taskIcon_45"].alpha = 1;
         }
         else
         {
            this.mapMC["shipBtnMC"]["taskIcon_45"].alpha = 0;
         }
         var _local_4:SimpleButton = this.mapMC["closeBtn"];
         _local_4.addEventListener(MouseEvent.CLICK,this.close);
         MovieClip(this.mapMC["plantBtnMC"]).scrollRect = this.mapScrollRect;
         this.mapMC.addEventListener(Event.ENTER_FRAME,this.onMapEnter);
         var _local_5:uint = uint(MainManager.serverID);
         this.mapMC["serverNameTxt"].text = _local_5.toString() + ". " + ServerConfig.getNameByID(_local_5);
         var _local_6:MovieClip = this.mapMC["plantBtnMC"];
         var _local_7:uint = uint(_local_6.numChildren);
         while(_local_8 < _local_7)
         {
            _local_1 = _local_6.getChildAt(_local_8) as SimpleButton;
            if(Boolean(_local_1))
            {
               _local_1.addEventListener(MouseEvent.CLICK,this.changeMap);
               _local_2 = uint(_local_1.name.split("_")[1]);
               _local_3 = MapConfig.getName(_local_2) + "\r<font color=\'#ff0000\'>" + MapConfig.getDes(_local_2) + "</font>";
               ToolTipManager.add(_local_1,_local_3);
            }
            _local_8++;
         }
         _local_6 = this.mapMC["shipBtnMC"];
         _local_7 = uint(_local_6.numChildren);
         _local_8 = 0;
         while(_local_8 < _local_7)
         {
            _local_1 = _local_6.getChildAt(_local_8) as SimpleButton;
            if(Boolean(_local_1))
            {
               _local_1.addEventListener(MouseEvent.CLICK,this.changeMap);
               _local_2 = uint(_local_1.name.split("_")[1]);
               _local_3 = MapConfig.getName(_local_2) + "\r<font color=\'#ff0000\'>" + MapConfig.getDes(_local_2) + "</font>";
               ToolTipManager.add(_local_1,_local_3);
            }
            _local_8++;
         }
         SocketConnection.addCmdListener(CommandID.MAP_HOT,this.onGetMapHot);
         SocketConnection.mainSocket.send(CommandID.MAP_HOT,[]);
         this.initMyPostion();
      }
      
      private function changeMap(_arg_1:MouseEvent) : void
      {
         var _local_2:String = (_arg_1.currentTarget as SimpleButton).name;
         var _local_3:uint = uint(_local_2.split("_")[1]);
         MapManager.changeMap(_local_3);
         this.close();
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
         this.showPlantHot(_local_11);
      }
      
      private function showPlantHot(_arg_1:MapHotInfo) : void
      {
         var _local_2:SimpleButton = null;
         var _local_3:uint = 0;
         var _local_4:MovieClip = null;
         var _local_5:uint = 0;
         var _local_6:uint = 0;
         var _local_9:uint = 0;
         var _local_7:MovieClip = this.mapMC["plantBtnMC"];
         var _local_8:uint = uint(_local_7.numChildren);
         while(_local_9 < _local_8)
         {
            _local_2 = _local_7.getChildAt(_local_9) as SimpleButton;
            if(Boolean(_local_2))
            {
               _local_3 = uint(_local_2.name.split("_")[1]);
               _local_4 = _local_7.getChildByName("hotMC_" + _local_3) as MovieClip;
               _local_5 = uint(Math.ceil(uint(_arg_1.infos.getValue(_local_3)) / this.perHot));
               if(_local_5 > 5)
               {
                  _local_5 = 5;
               }
               _local_6 = 0;
               while(_local_6 < 5)
               {
                  if(_local_6 < _local_5)
                  {
                     _local_4["mc_" + _local_6].gotoAndStop(1);
                  }
                  else
                  {
                     _local_4["mc_" + _local_6].gotoAndStop(2);
                  }
                  _local_6++;
               }
            }
            _local_9++;
         }
      }
      
      private function close(_arg_1:MouseEvent = null) : void
      {
         var _local_2:MovieClip = null;
         this.isHited = false;
         DisplayUtil.removeForParent(this,false);
         for each(_local_2 in this.hotMCArray)
         {
            DisplayUtil.removeForParent(_local_2);
         }
         this.hotMCArray = [];
         if(Boolean(this.prevBtn))
         {
            this.prevBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
            this.nextBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
            this.prevBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.nextBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
         }
         MainManager.getStage().removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
      
      private function onDown(_arg_1:MouseEvent) : void
      {
         var _local_2:SimpleButton = _arg_1.currentTarget as SimpleButton;
         if(_local_2 == this.prevBtn)
         {
            this.dir = 1;
         }
         else
         {
            this.dir = -1;
         }
         var _local_3:MovieClip = this.mapMC["plantBtnMC"];
         _local_3.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      private function onEnter(_arg_1:Event) : void
      {
         var _local_2:MovieClip = this.mapMC["plantBtnMC"];
         _local_2.x += 4 * this.dir;
         this.mapMC["spaceBg"].x += 1.2 * this.dir;
         if(_local_2.x < -182)
         {
            _local_2.x = -182;
            _local_2.removeEventListener(Event.ENTER_FRAME,this.onEnter);
         }
         if(_local_2.x > 136)
         {
            _local_2.x = 136;
            _local_2.removeEventListener(Event.ENTER_FRAME,this.onEnter);
         }
      }
      
      private function onUp(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = this.mapMC["plantBtnMC"];
         _local_2.removeEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      private function onMapEnter(_arg_1:Event) : void
      {
         var _local_2:Number = 124 + 756;
         var _local_3:Number = Number(MainManager.getStage().mouseX);
         var _local_4:Number = (_local_3 - 124) / (825 - 124);
         if(!(!this.mapMC["plantBtnMC"].hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY,true) || _local_3 < 124 || _local_3 > 825))
         {
            if(!this.isHited && Boolean(this.mapMC["plantBtnMC"].hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY,true)))
            {
               this.isHited = true;
            }
            this.target = _local_2 * _local_4;
            this.target2 = _local_2 * _local_4 / 3;
         }
         if(!this.isHited)
         {
            return;
         }
         if(Math.abs(this.target - this.mapScrollRect.x) < 2)
         {
            this.mapScrollRect.x = this.target;
         }
         else
         {
            this.mapScrollRect.x += (this.target - this.mapScrollRect.x) / 12;
         }
         MovieClip(this.mapMC["plantBtnMC"]).scrollRect = this.mapScrollRect;
         if(Math.abs(this.target2 - this.bgScrollRect.x) < 2)
         {
            this.bgScrollRect.x = this.target2;
         }
         else
         {
            this.bgScrollRect.x += (this.target2 - this.bgScrollRect.x) / 12;
         }
         MovieClip(this.mapMC["spaceBg"]).scrollRect = this.bgScrollRect;
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
               return;
            }
            this.myIcon.x = _local_3.x;
            this.myIcon.y = _local_3.y;
            this.mapMC["plantBtnMC"].addChild(this.myIcon);
         }
         else
         {
            DisplayUtil.removeForParent(this.myIcon,false);
         }
      }
   }
}

