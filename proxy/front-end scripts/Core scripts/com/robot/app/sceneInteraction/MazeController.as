package com.robot.app.sceneInteraction
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.temp.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.effect.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class MazeController
   {
      
      private static var _instance:MazeController;
      
      private const mapList:Array = [302,303,304,305,306,307,308,309,310,311,312,313];
      
      private var _bailuen:BailuenModel;
      
      private var _allowArr:Array;
      
      private var _allowLen:int = 0;
      
      private var _time:Timer;
      
      public function MazeController()
      {
         super();
         this._allowArr = MapManager.currentMap.allowData;
         this._allowLen = this._allowArr.length;
      }
      
      public static function setup() : void
      {
         if(_instance == null)
         {
            _instance = new MazeController();
         }
      }
      
      public static function destroy() : void
      {
         if(Boolean(_instance))
         {
            _instance._destroy();
            _instance = null;
         }
      }
      
      private function _destroy() : void
      {
         if(Boolean(this._bailuen))
         {
            this._bailuen.removeEventListener(BailuenModel.FIG,this.onBailuenFig);
            this._bailuen.destroy();
            this._bailuen = null;
         }
         if(Boolean(this._time))
         {
            if(this._time.running)
            {
               this._time.stop();
            }
            this._time.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._time.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this._time = null;
         }
      }
      
      private function onBailuenInfo(_arg_1:SocketEvent) : void
      {
         var _local_2:MovieClip = null;
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         var _local_5:uint = _local_3.readUnsignedInt();
         var _local_6:uint = _local_3.readUnsignedInt();
         if(_local_4 == 1 || _local_4 == 3)
         {
            if(_local_5 == MapManager.getMapController().newMapID)
            {
               if(_local_6 > 0)
               {
                  if(this._bailuen == null)
                  {
                     this._bailuen = new BailuenModel();
                     this._bailuen.show(this._allowArr[int(Math.random() * this._allowLen)],Boolean(_local_4 == 1));
                     MapManager.currentMap.depthLevel.addChild(this._bailuen);
                     this._bailuen.addEventListener(BailuenModel.FIG,this.onBailuenFig);
                  }
               }
            }
         }
         else if(_local_4 == 2)
         {
            if(_local_5 == MapManager.getMapController().newMapID)
            {
               if(Boolean(this._bailuen))
               {
                  this._bailuen.destroy();
                  this._bailuen = null;
               }
            }
         }
         else if(_local_4 == 4)
         {
            if(Boolean(this._bailuen))
            {
               this._bailuen.fight();
            }
         }
         if(Boolean(this._bailuen))
         {
            this._bailuen.hp = _local_6;
            if(_local_6 == 0)
            {
               _local_2 = TaskIconManager.getIcon("Chests") as MovieClip;
               MapManager.currentMap.controlLevel.addChild(_local_2);
               _local_2.x = 450;
               _local_2.y = 200;
               _local_2.addEventListener(MouseEvent.CLICK,this.getChests);
               SocketConnection.addCmdListener(CommandID.PRIZE_OF_ATRESIASPACE,this.getPirze);
            }
         }
      }
      
      private function getChests(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = _arg_1.currentTarget as MovieClip;
         SocketConnection.send(CommandID.PRIZE_OF_ATRESIASPACE,2);
         _local_2.removeEventListener(MouseEvent.CLICK,this.getChests);
         DisplayUtil.removeForParent(_local_2);
      }
      
      private function getPirze(_arg_1:SocketEvent) : void
      {
         var _local_2:Object = null;
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_5:String = null;
         var _local_6:String = null;
         SocketConnection.removeCmdListener(CommandID.PRIZE_OF_ATRESIASPACE,this.getPirze);
         var _local_7:AresiaSpacePrize = _arg_1.data as AresiaSpacePrize;
         var _local_8:Array = _local_7.monBallList;
         for each(_local_2 in _local_8)
         {
            _local_3 = uint(_local_2.itemID);
            _local_4 = uint(_local_2.itemCnt);
            _local_5 = ItemXMLInfo.getName(_local_3);
            _local_6 = _local_4 + "个<font color=\'#FF0000\'>" + _local_5 + "</font>已经放入了你的储存箱！";
            if(_local_4 != 0)
            {
               LevelManager.tipLevel.addChild(ItemInBagAlert.show(_local_3,_local_6));
            }
         }
      }
      
      private function onBailuenFig(_arg_1:Event) : void
      {
         if(this._time == null)
         {
            this._time = new Timer(100,6);
            this._time.addEventListener(TimerEvent.TIMER,this.onTimer);
            this._time.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         }
         this._time.reset();
         this._time.start();
      }
      
      private function onTimer(_arg_1:TimerEvent) : void
      {
         if(this._time.currentCount % 2 == 0)
         {
            MapManager.currentMap.root.filters = [ColorFilter.setBrightness(30)];
         }
         else
         {
            MapManager.currentMap.root.filters = [ColorFilter.setInvert(),ColorFilter.setBrightness(30)];
         }
         MapManager.currentMap.root.x = 10 - Math.random() * 5;
         MapManager.currentMap.root.y = 10 - Math.random() * 5;
      }
      
      private function onTimerComplete(_arg_1:TimerEvent) : void
      {
         var _local_2:Array = null;
         var _local_3:int = 0;
         MapManager.currentMap.root.filters = [];
         MapManager.currentMap.root.x = 0;
         MapManager.currentMap.root.y = 0;
         if(Math.random() > 0.85)
         {
            LevelManager.topLevel.addChild(NpcTipDialog.show("你受伤过重，现在已经整备完毕，你可以重新开始你的历险了！",null,NpcTipDialog.CICI));
            MapManager.changeMap(MainManager.actorID);
         }
         else
         {
            _local_2 = this.mapList.concat();
            _local_3 = int(_local_2.indexOf(MapManager.currentMap.id));
            if(_local_3 != -1)
            {
               _local_2.splice(_local_3,1);
            }
            MapManager.changeMap(_local_2[int(Math.random() * _local_2.length)]);
         }
      }
   }
}

