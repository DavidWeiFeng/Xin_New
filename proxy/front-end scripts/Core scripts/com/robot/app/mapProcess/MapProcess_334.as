package com.robot.app.mapProcess
{
   import com.robot.app.buyItem.*;
   import com.robot.core.animate.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.dayGift.*;
   import com.robot.core.info.task.CateInfo;
   import com.robot.core.info.task.DayTalkInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.utils.*;
   
   public class MapProcess_334 extends BaseMapProcess
   {
      
      private static var _count:uint = 0;
      
      private var resultArr:Array = [0,3,1,2];
      
      private var controlArr:Array;
      
      private var lightcontrolArr:Array;
      
      private var _isTurn:Boolean;
      
      private var conveyorMC:MovieClip;
      
      public function MapProcess_334()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _local_1:uint = 0;
         var _local_2:uint = 0;
         topLevel.mouseEnabled = false;
         topLevel.mouseChildren = false;
         conLevel["open_road"].buttonMode = true;
         conLevel["open_road"].addEventListener(MouseEvent.CLICK,this.onOpenRoadHandler);
         conLevel["bbox_mc"].visible = false;
         this.controlArr = [];
         while(_local_1 < 4)
         {
            conLevel["btn_" + _local_1].addEventListener(MouseEvent.CLICK,this.onBtnHandler);
            _local_1++;
         }
         this.lightcontrolArr = [];
         while(_local_2 < 3)
         {
            conLevel["light_" + _local_2].addEventListener(MouseEvent.CLICK,this.onLightHandler);
            conLevel["light_" + _local_2].buttonMode = true;
            _local_2++;
         }
         conLevel["pan_mc"].buttonMode = true;
         conLevel["pan_mc"].addEventListener(MouseEvent.CLICK,this.onPanMCClickHandler);
      }
      
      private function getAward() : Boolean
      {
         var _local_1:Number = 10 * Math.random();
         if(_local_1 < 5)
         {
            return true;
         }
         return false;
      }
      
      private function onBtnHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:DayGiftController = null;
         var _local_3:MovieClip = _arg_1.currentTarget as MovieClip;
         _local_3.removeEventListener(MouseEvent.CLICK,this.onBtnHandler);
         _local_3.enabled = false;
         _local_3.gotoAndStop(2);
         var _local_4:String = _local_3.name;
         var _local_5:uint = uint(_local_4.split("_")[1]);
         this.controlArr.push(_local_5);
         if(this.controlArr.length == 4)
         {
            if(ArrayUtils.eq(this.controlArr,this.resultArr))
            {
               _local_2 = new DayGiftController(22,5);
               _local_2.addEventListener(DayGiftController.COUNT_SUCCESS,this.onCountSuccess);
               _local_2.getCount();
            }
         }
         else if(this.controlArr.length > 4)
         {
            this.controlArr = [];
         }
      }
      
      private function onPanMCClickHandler(param1:MouseEvent) : void
      {
         var t:uint = 0;
         var type:uint = 0;
         var gift:DayGiftController = null;
         t = 0;
         var e:MouseEvent = param1;
         if(!this._isTurn)
         {
            ++_count;
            conLevel["pan_mc"].gotoAndStop(2);
            this._isTurn = true;
         }
         t = setTimeout(function():void
         {
            clearTimeout(t);
            conLevel["pan_mc"].gotoAndStop(1);
            _isTurn = false;
         },500);
         if(_count == 3)
         {
            type = 0;
            if(this.getAward())
            {
               type = 20;
            }
            else
            {
               type = 21;
            }
            gift = new DayGiftController(type,1);
            gift.addEventListener(DayGiftController.COUNT_SUCCESS,this.onCountSuccess);
            gift.getCount();
         }
      }
      
      private function onCountSuccess(param1:Event) : void
      {
         var event:Event = param1;
         var gift:DayGiftController = event.currentTarget as DayGiftController;
         gift.sendToServer(function(_arg_1:DayTalkInfo):void
         {
            var _local_2:CateInfo = null;
            var _local_3:uint = 0;
            var _local_4:uint = 0;
            for each(_local_2 in _arg_1.outList)
            {
               _local_3 = uint(_local_2.id);
               _local_4 = uint(_local_2.count);
               ItemInBagAlert.show(_local_3,_local_4 + "个<font color=\'#ff0000\'>" + ItemXMLInfo.getName(_local_3) + "</font>已经放入你的储存箱中！");
            }
         });
      }
      
      public function onSwitchClick() : void
      {
         var t2:uint = 0;
         t2 = 0;
         AnimateManager.playMcAnimate(animatorLevel["switch_mc"],2,"mc",function():void
         {
            conLevel["bbox_mc"].visible = true;
         });
         animatorLevel["conveyor"].gotoAndStop(2);
         t2 = setTimeout(function():void
         {
            clearTimeout(t2);
            conveyorMC = animatorLevel["conveyor"]["mc"];
         },300);
      }
      
      public function onBoxClick() : void
      {
         AnimateManager.playMcAnimate(conLevel["bbox_mc"],3,"image",function():void
         {
            FitmentAction.buyItem(500824,false);
            conLevel["box_mc"].buttonMode = false;
            conLevel["box_mc"].mouseEnabled = false;
         });
      }
      
      private function onOpenRoadHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(typeLevel["road_mc"]);
         conLevel["open_road"].gotoAndStop(2);
         animatorLevel["road_block"].gotoAndStop(2);
         conLevel["open_road"].buttonMode = false;
         MapManager.currentMap.makeMapArray();
      }
      
      private function onLightHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = _arg_1.currentTarget as MovieClip;
         _local_2.removeEventListener(MouseEvent.CLICK,this.onBtnHandler);
         _local_2.enabled = false;
         _local_2.gotoAndStop(2);
         var _local_3:String = _local_2.name;
         var _local_4:uint = uint(_local_3.split("_")[1]);
         this.lightcontrolArr.push(_local_4);
         if(this.lightcontrolArr.length == 3)
         {
            if(Boolean(this.conveyorMC))
            {
               this.conveyorMC.addEventListener(Event.ENTER_FRAME,this.onFrameEventHandler);
            }
         }
      }
      
      private function onFrameEventHandler(param1:Event) : void
      {
         var e:Event = param1;
         if(this.conveyorMC.currentFrame == this.conveyorMC.totalFrames)
         {
            this.conveyorMC.removeEventListener(Event.ENTER_FRAME,this.onFrameEventHandler);
            this.conveyorMC.gotoAndStop(this.conveyorMC.totalFrames);
            AnimateManager.playMcAnimate(animatorLevel["fireworks_mc"],2,"box",function():void
            {
            });
         }
      }
      
      override public function destroy() : void
      {
         var _local_1:uint = 0;
         var _local_2:uint = 0;
         if(Boolean(this.conveyorMC))
         {
            this.conveyorMC.removeEventListener(Event.ENTER_FRAME,this.onFrameEventHandler);
         }
         while(_local_1 < 4)
         {
            conLevel["btn_" + _local_1].removeEventListener(MouseEvent.CLICK,this.onBtnHandler);
            _local_1++;
         }
         this.lightcontrolArr = [];
         while(_local_2 < 3)
         {
            conLevel["light_" + _local_2].removeEventListener(MouseEvent.CLICK,this.onLightHandler);
            _local_2++;
         }
         this._isTurn = false;
      }
   }
}

