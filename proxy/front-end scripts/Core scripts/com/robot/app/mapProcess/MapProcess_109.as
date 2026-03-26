package com.robot.app.mapProcess
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.ColorTransform;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class MapProcess_109 extends BaseMapProcess
   {
      
      private var superStone:MovieClip;
      
      private var weightLessHouse:MovieClip;
      
      private var oreGather:MovieClip;
      
      private var suitAlarm:MovieClip;
      
      private var nonoSuit:MovieClip;
      
      private var sinNum:Number = 0;
      
      private var stoneNum:uint = 0;
      
      private var stoneList:Array = [];
      
      private var oldSpeed:Number;
      
      public function MapProcess_109()
      {
         super();
      }
      
      private function createStone() : void
      {
         var _local_4:Stone = null;
         var _local_5:uint = 0;
         var _local_1:Number = NaN;
         var _local_2:Number = NaN;
         var _local_3:Number = NaN;
         _local_4 = null;
         while(this.stoneNum > 20 || this.stoneNum < 15)
         {
            this.stoneNum = Math.floor(Math.random() * 20);
         }
         while(_local_5 < this.stoneNum)
         {
            _local_1 = this.getGaussian(40 * (_local_5 + 1),50);
            _local_2 = this.getGaussian(20 * (_local_5 + 1),100);
            _local_3 = Math.random();
            while(_local_3 < 0.7)
            {
               _local_3 = Math.random();
            }
            _local_4 = new Stone(Math.ceil(Math.random() * 5));
            _local_4.x = _local_1;
            _local_4.y = _local_2;
            _local_4.scaleX = _local_3;
            _local_4.scaleY = _local_3;
            conLevel.addChild(_local_4);
            _local_4.addEventListener(Stone.CLEAR,this.onClear);
            this.stoneList.push(_local_4);
            _local_5++;
         }
      }
      
      private function onClear(_arg_1:Event) : void
      {
         var _local_2:Stone = _arg_1.currentTarget as Stone;
         _local_2.removeEventListener(Stone.CLEAR,this.onClear);
         var _local_3:int = int(this.stoneList.indexOf(_local_2));
         if(_local_3 != -1)
         {
            this.stoneList.splice(_local_3,1);
         }
      }
      
      override protected function init() : void
      {
         var array:Array = null;
         this.oldSpeed = MainManager.actorModel.speed;
         MainManager.actorModel.speed = this.oldSpeed / 2;
         this.createStone();
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
         this.suitAlarm = MapLibManager.getMovieClip("suitAlarm");
         this.superStone = this.conLevel["superStone"];
         this.weightLessHouse = this.conLevel["weightLessHouse"];
         this.oreGather = this.conLevel["oreGather"];
         array = MainManager.actorInfo.clothIDs;
         if(!ArrayUtil.arrayContainsValue(array,100054) && !ArrayUtil.arrayContainsValue(array,100110) && !ArrayUtil.arrayContainsValue(array,100158) && !ArrayUtil.arrayContainsValue(array,100167))
         {
            LevelManager.appLevel.addChild(this.suitAlarm);
            DisplayUtil.align(this.suitAlarm,null,AlignType.MIDDLE_CENTER);
            this.suitAlarm["closeBtn"].addEventListener(MouseEvent.CLICK,function():void
            {
               MapManager.changeMap(107);
            });
            return;
         }
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MainManager.actorModel.addEventListener(RobotEvent.WALK_END,this.onWalkEnd);
      }
      
      override public function destroy() : void
      {
         var _local_1:Stone = null;
         MainManager.actorModel.speed = this.oldSpeed;
         LevelManager.openMouseEvent();
         if(!MainManager.actorModel.nono)
         {
            MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
         }
         for each(_local_1 in this.stoneList)
         {
            _local_1.removeEventListener(Stone.CLEAR,this.onClear);
         }
         if(Boolean(this.suitAlarm))
         {
            DisplayUtil.removeForParent(this.suitAlarm);
         }
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         SocketConnection.removeCmdListener(CommandID.NO_GRAVITY_SHIP,this.onSocketSuccessHandler);
         this.stoneList = [];
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         if(Boolean(this.nonoSuit))
         {
            if(this.nonoSuit.hasEventListener(Event.ENTER_FRAME))
            {
               this.nonoSuit.removeEventListener(Event.ENTER_FRAME,this.onNonoSuitFrameHandler);
            }
         }
         if(this.weightLessHouse.hasEventListener(Event.ENTER_FRAME))
         {
            this.weightLessHouse.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler("*"));
         }
      }
      
      private function onAimat(_arg_1:AimatEvent) : void
      {
         var _local_2:Stone = null;
         var _local_3:AimatInfo = _arg_1.info;
         if(_local_3.userID != MainManager.actorID)
         {
            return;
         }
         for each(_local_2 in this.stoneList)
         {
            if(_local_2.hitTestPoint(_local_3.endPos.x,_local_3.endPos.y,true))
            {
               _local_2.play();
               break;
            }
         }
      }
      
      public function onSuperStoneClickHandler() : void
      {
         if(!MainManager.actorInfo.superNono)
         {
            Alarm.show("你必须要带上超能NoNo哦！");
            return;
         }
         if(!MainManager.actorModel.nono)
         {
            Alarm.show("你必须要带上超能NoNo哦！");
            return;
         }
         MainManager.actorModel.hideNono();
         LevelManager.closeMouseEvent();
         this.superStone.gotoAndStop(2);
         setTimeout(this.superStonePlay,300);
      }
      
      private function superStonePlay() : void
      {
         var _local_1:MovieClip = null;
         var _local_3:uint = 0;
         var _local_2:uint = uint(this.superStone.numChildren);
         while(_local_3 < _local_2)
         {
            _local_1 = this.superStone.getChildAt(_local_3) as MovieClip;
            if(Boolean(_local_1))
            {
               if(_local_1.name == "colorMC")
               {
                  DisplayUtil.FillColor(_local_1,MainManager.actorInfo.nonoColor);
               }
               if(_local_1.name == "stoneMC")
               {
                  _local_1.addEventListener(Event.ENTER_FRAME,this.sendToServer);
               }
            }
            _local_3++;
         }
      }
      
      private function sendToServer(_arg_1:Event) : void
      {
         var _local_2:MovieClip = _arg_1.currentTarget as MovieClip;
         if(_local_2.totalFrames == _local_2.currentFrame)
         {
            _local_2.removeEventListener(Event.ENTER_FRAME,this.sendToServer);
            DisplayUtil.removeForParent(this.superStone);
            MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
            Stone.send(1);
            LevelManager.openMouseEvent();
         }
      }
      
      public function onWeightLessHouseClickHandler() : void
      {
         SocketConnection.addCmdListener(CommandID.NO_GRAVITY_SHIP,this.onSocketSuccessHandler);
         SocketConnection.send(CommandID.NO_GRAVITY_SHIP);
      }
      
      private function onWalk(_arg_1:RobotEvent) : void
      {
         this.sinNum += 0.1;
         MainManager.actorModel.y += Math.sin(this.sinNum) * 20;
         MainManager.actorModel.x += Math.sin(this.sinNum) * 20;
      }
      
      private function onWalkEnd(_arg_1:RobotEvent) : void
      {
         this.sinNum = 0;
      }
      
      private function onSocketSuccessHandler(_arg_1:SocketEvent) : void
      {
         MainManager.actorModel.hideNono();
         LevelManager.closeMouseEvent();
         if(MainManager.actorInfo.superNono)
         {
            this.weightLessHouse.gotoAndPlay(3);
            this.weightLessHouse.addEventListener(Event.ENTER_FRAME,this.onFrameHandler("superNono"));
         }
         else
         {
            this.weightLessHouse.gotoAndPlay(2);
            this.weightLessHouse.addEventListener(Event.ENTER_FRAME,this.onFrameHandler("normalNono"));
         }
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         NonoManager.info.power = _local_3 / 1000;
         NonoManager.info.mate = _local_4 / 1000;
      }
      
      private function onFrameHandler(mcName:String) : Function
      {
         var func:Function = function(_arg_1:Event):void
         {
            var _local_2:ColorTransform = null;
            if(Boolean(weightLessHouse.getChildByName(mcName)))
            {
               nonoSuit = (weightLessHouse.getChildByName(mcName) as MovieClip).getChildByName("nonoSuit") as MovieClip;
               _local_2 = nonoSuit.transform.colorTransform;
               _local_2.color = MainManager.actorInfo.nonoColor;
               nonoSuit.transform.colorTransform = _local_2;
               nonoSuit.addEventListener(Event.ENTER_FRAME,onNonoSuitFrameHandler);
            }
         };
         return func;
      }
      
      private function onNonoSuitFrameHandler(_arg_1:Event) : void
      {
         if(this.nonoSuit.currentFrame == this.nonoSuit.totalFrames)
         {
            this.nonoSuit.removeEventListener(Event.ENTER_FRAME,this.onNonoSuitFrameHandler);
            this.weightLessHouse.gotoAndStop(1);
            this.weightLessHouse.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler("*"));
            MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
            if(this.nonoSuit.parent.name == "superNono")
            {
               NpcTipDialog.show("O(∩_∩)O  NoNo精神满满，主人，你也要加油哦！！！",null,NpcTipDialog.NONO);
            }
            else
            {
               NpcTipDialog.show("O(∩_∩)O  NoNo精神满满，主人，你也要加油哦！！！",null,NpcTipDialog.NONO_2);
            }
            LevelManager.openMouseEvent();
         }
      }
      
      public function getGaussian(_arg_1:Number = 0, _arg_2:Number = 1) : Number
      {
         var _local_3:Number = Math.random();
         var _local_4:Number = Math.random();
         return Math.sqrt(-2 * Math.log(_local_3)) * Math.cos(2 * Math.PI * _local_4) * _arg_2 + _arg_1;
      }
   }
}

import com.robot.core.*;
import com.robot.core.config.xml.*;
import com.robot.core.info.task.*;
import com.robot.core.manager.*;
import com.robot.core.manager.map.*;
import com.robot.core.net.*;
import com.robot.core.ui.alert.*;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.*;
import org.taomee.events.SocketEvent;
import org.taomee.utils.*;

class Stone extends Sprite
{
   
   public static const CLEAR:String = "clear";
   
   private var mc:MovieClip;
   
   private var isHited:Boolean = false;
   
   private var sub:MovieClip;
   
   public function Stone(_arg_1:uint)
   {
      super();
      this.mc = MapLibManager.getMovieClip("stone" + _arg_1);
      this.mc["mc"].gotoAndStop(1);
      this.mc.cacheAsBitmap = true;
      addChild(this.mc);
      this.mc["light"].gotoAndStop(1);
      this.sub = this.mc["mc"];
      this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
      this.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
   }
   
   public static function send(type:uint) : void
   {
      SocketConnection.addCmdListener(CommandID.HIT_STONE,function(_arg_1:SocketEvent):void
      {
         var _local_3:Object = null;
         var _local_4:uint = 0;
         var _local_5:uint = 0;
         var _local_6:String = null;
         var _local_7:String = null;
         SocketConnection.removeCmdListener(CommandID.HIT_STONE,arguments.callee);
         var _local_8:BossMonsterInfo = _arg_1.data as BossMonsterInfo;
         for each(_local_3 in _local_8.monBallList)
         {
            _local_4 = uint(_local_3["itemCnt"]);
            _local_5 = uint(_local_3["itemID"]);
            _local_6 = ItemXMLInfo.getName(_local_5);
            if(_local_5 < 10)
            {
               _local_7 = "恭喜你得到了" + _local_4 + "个<font color=\'#FF0000\'>" + _local_6 + "</font>";
               LevelManager.tipLevel.addChild(Alarm.show(_local_7));
            }
            else
            {
               _local_7 = _local_4 + "个<font color=\'#FF0000\'>" + _local_6 + "</font>已经放入了你的储存箱！";
               LevelManager.tipLevel.addChild(ItemInBagAlert.show(_local_5,_local_7));
            }
         }
      });
      SocketConnection.send(CommandID.HIT_STONE,type);
   }
   
   private function onOver(_arg_1:MouseEvent) : void
   {
      this.mc["light"].gotoAndPlay(2);
   }
   
   private function onOut(_arg_1:MouseEvent) : void
   {
      this.mc["light"].gotoAndStop(1);
   }
   
   public function play() : void
   {
      if(!this.isHited)
      {
         this.isHited = true;
         this.sub.gotoAndPlay(2);
         this.mc["light"].visible = false;
         this.sub.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
   }
   
   private function onEnter(_arg_1:Event) : void
   {
      if(this.sub.currentFrame == this.sub.totalFrames)
      {
         this.sub.removeEventListener(Event.ENTER_FRAME,this.onEnter);
         DisplayUtil.removeForParent(this);
         dispatchEvent(new Event(CLEAR));
         send(0);
      }
   }
}
