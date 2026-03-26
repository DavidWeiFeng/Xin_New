package com.robot.app.mapProcess
{
   import com.robot.app.sceneInteraction.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.*;
   import com.robot.core.temp.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class MapProcess_304 extends BaseMapProcess
   {
      
      private var btn_0:MovieClip;
      
      private var btn_1:MovieClip;
      
      private var arrowheadMC:MovieClip;
      
      private var chestsMC:MovieClip;
      
      private var direction:uint = 1;
      
      private var count:uint = 1;
      
      public function MapProcess_304()
      {
         super();
      }
      
      override protected function init() : void
      {
         MazeController.setup();
         var _local_1:uint = Math.floor(Math.random() * 5);
         this.arrowheadMC = conLevel["arrowheadMC"];
         this.arrowheadMC.gotoAndStop(_local_1);
         this.direction = _local_1;
         this.btn_0 = conLevel["btn_0"];
         this.btn_1 = conLevel["btn_1"];
         this.btn_0.buttonMode = true;
         this.btn_1.buttonMode = true;
         var _local_2:uint = Math.floor(Math.random() * 5);
         var _local_3:uint = Math.floor(Math.random() * 5);
         this.btn_0.gotoAndStop(_local_2);
         this.btn_1.gotoAndStop(_local_3);
         this.btn_0.addEventListener(MouseEvent.CLICK,this.onClickBox);
         this.btn_1.addEventListener(MouseEvent.CLICK,this.onClickBox);
         this.chestsMC = conLevel["chestsMC"];
         this.chestsMC.gotoAndStop(1);
         SocketConnection.addCmdListener(CommandID.PRIZE_OF_ATRESIASPACE,this.getPirze);
      }
      
      override public function destroy() : void
      {
         MazeController.destroy();
      }
      
      private function onClickBox(evt:MouseEvent) : void
      {
         var mc:MovieClip = evt.currentTarget as MovieClip;
         this.count = mc.currentFrame;
         if(this.count == mc.totalFrames)
         {
            mc.gotoAndStop(1);
         }
         else
         {
            ++this.count;
            mc.gotoAndStop(this.count);
         }
         if(this.chestsMC == null)
         {
            return;
         }
         if(this.btn_0.currentFrame == this.direction && this.btn_1.currentFrame == this.direction)
         {
            this.chestsMC.gotoAndPlay(2);
            this.chestsMC.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
            {
               if(chestsMC.currentFrame == chestsMC.totalFrames)
               {
                  chestsMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  chestsMC.buttonMode = true;
                  chestsMC.addEventListener(MouseEvent.CLICK,onClickChests);
               }
            });
         }
      }
      
      private function onClickChests(_arg_1:MouseEvent) : void
      {
         this.chestsMC.removeEventListener(MouseEvent.CLICK,this.onClickChests);
         DisplayUtil.removeForParent(this.chestsMC);
         this.chestsMC = null;
         SocketConnection.send(CommandID.PRIZE_OF_ATRESIASPACE,1);
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
   }
}

