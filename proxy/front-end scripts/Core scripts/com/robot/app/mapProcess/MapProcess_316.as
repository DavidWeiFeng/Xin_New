package com.robot.app.mapProcess
{
   import com.robot.app.control.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.PetModel;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.temp.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.events.DynamicEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_316 extends BaseMapProcess
   {
      
      private var lineBeltMC:MovieClip;
      
      private var spriteTransferMC:MovieClip;
      
      private var spriteContainerMC:MovieClip;
      
      private var petType:String;
      
      private var comdType:uint = 3;
      
      private var trainingMC_0:MovieClip;
      
      private var trainingMC_1:MovieClip;
      
      private var trainingMC_2:MovieClip;
      
      private var trainingMC_3:MovieClip;
      
      private var trainingMcArr:Array = [];
      
      private var pao_mc:SimpleButton;
      
      private var petShowInfo:PetShowInfo;
      
      private var _showMc:MovieClip;
      
      private var _showMc1:MovieClip;
      
      private var _leiyi:SimpleButton;
      
      private var _panel:MovieClip;
      
      private var petT:String;
      
      private var loader:MCLoader;
      
      private var curDisplayObj:DisplayObject;
      
      public function MapProcess_316()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _local_1:MovieClip = null;
         this.lineBeltMC = conLevel["lineBeltMC"];
         this.lineBeltMC.buttonMode = true;
         this._leiyi = conLevel["leiyi_mc"];
         this._panel = btnLevel["panel_mc"];
         this._panel.visible = false;
         this._leiyi.addEventListener(MouseEvent.CLICK,this.leiyiClickHandler);
         ToolTipManager.add(this._leiyi,"拜伦号精灵舱");
         ToolTipManager.add(this.lineBeltMC,"精灵养成装置");
         this.spriteTransferMC = conLevel["spriteTransferMC"];
         this.spriteContainerMC = this.spriteTransferMC["spriteContainerMC"];
         this.spriteTransferMC.gotoAndStop(1);
         this.trainingMC_0 = conLevel["trainingMC_0"];
         this.trainingMC_1 = conLevel["trainingMC_1"];
         this.trainingMC_2 = conLevel["trainingMC_2"];
         this.trainingMC_3 = conLevel["trainingMC_3"];
         this.pao_mc = conLevel["paopao_mc"];
         ToolTipManager.add(this.pao_mc,"精灵泡泡机");
         this.pao_mc.addEventListener(MouseEvent.CLICK,this.paoclickHandler);
         this.trainingMcArr = [this.trainingMC_0,this.trainingMC_1,this.trainingMC_2,this.trainingMC_3];
         for each(_local_1 in this.trainingMcArr)
         {
            _local_1.gotoAndStop(1);
         }
      }
      
      public function onLeaveHandler() : void
      {
         Alert.show("你确定要离开这里吗?",function():void
         {
            MapManager.changeMap(315);
         });
      }
      
      private function leiyiClickHandler(e:MouseEvent) : void
      {
         var clickokBtn:Function = null;
         clickokBtn = null;
         clickokBtn = function(_arg_1:MouseEvent):void
         {
            _panel.visible = false;
            _panel["ok_btn"].removeEventListener(MouseEvent.CLICK,clickokBtn);
         };
         this._panel.visible = true;
         this._panel["ok_btn"].addEventListener(MouseEvent.CLICK,clickokBtn);
      }
      
      private function paoclickHandler(_arg_1:MouseEvent) : void
      {
         if(!MainManager.actorModel.nono)
         {
            Alarm.show("精灵泡泡机能量不足，只有带上超能NoNo，用的超级能量才能维持它的运转。");
         }
         else if(Boolean(MainManager.actorModel.pet))
         {
            this.petT = PetXMLInfo.getTypeCN(MainManager.actorModel.pet.info.petID);
            this.showGame();
         }
         else
         {
            Alarm.show("精灵泡泡机是先进的精灵学习机，你要带着精灵来哦！");
         }
      }
      
      private function onShowComplete(_arg_1:DisplayObject) : void
      {
         this._showMc1 = _arg_1 as MovieClip;
         if(Boolean(this._showMc1))
         {
            this._showMc1.gotoAndStop(Direction.UP);
            this.showGame();
         }
      }
      
      override public function destroy() : void
      {
         this.lineBeltMC = null;
         this.spriteTransferMC = null;
         this.spriteContainerMC = null;
         this.trainingMC_0 = null;
         this.trainingMC_1 = null;
         this.trainingMC_2 = null;
         this.trainingMC_3 = null;
         this.trainingMcArr = null;
         this.pao_mc = null;
         this.petShowInfo = null;
         this._showMc = null;
         this._showMc1 = null;
         this._leiyi = null;
         this._panel = null;
         EventManager.removeEventListener("Training_Pet_Sucess",this.petTrainingSucess);
         EventManager.removeEventListener("Training_Pet_False",this.petTrainingFalse);
      }
      
      private function addEvent() : void
      {
         EventManager.addEventListener("Training_Pet_Sucess",this.petTrainingSucess);
         EventManager.addEventListener("Training_Pet_False",this.petTrainingFalse);
         SocketConnection.addCmdListener(CommandID.PRIZE_OF_ATRESIASPACE,this.getPirze);
      }
      
      private function removeEvent() : void
      {
         EventManager.removeEventListener("Training_Pet_Sucess",this.petTrainingSucess);
         EventManager.removeEventListener("Training_Pet_False",this.petTrainingFalse);
      }
      
      public function clickLineBelt() : void
      {
         var _local_1:PetShowInfo = null;
         if(MainManager.actorModel.nono == null)
         {
            NpcTipDialog.show("带上你的NoNo才能给精灵进行训练噢!",null,NpcTipDialog.SHAWN);
            return;
         }
         var _local_2:PetModel = MainManager.actorModel.pet;
         if(Boolean(_local_2))
         {
            _local_1 = MainManager.actorModel.pet.info;
            this.petShowInfo = _local_1;
            this.petType = PetXMLInfo.getType(_local_1.petID);
            MainManager.actorModel.pet.visible = false;
            ResourceManager.getResource(ClientConfig.getPetSwfPath(_local_2.info.petID),this.onShowComplete1,"pet");
         }
         else
         {
            NpcTipDialog.show("带上你的精灵才能给它进行训练噢!",null,NpcTipDialog.DOCTOR);
         }
      }
      
      private function onShowComplete1(_arg_1:DisplayObject) : void
      {
         this._showMc = _arg_1 as MovieClip;
         if(Boolean(this._showMc))
         {
            this._showMc.gotoAndStop(Direction.LEFT_DOWN);
            this.spriteContainerMC.addChild(this._showMc);
            this._showMc.x = this._showMc.width / 2 + 5;
            this._showMc.y = this._showMc.height;
            this.spriteTransferMC.gotoAndPlay(2);
            this.spriteTransferMC.addEventListener(Event.ENTER_FRAME,this.chosFoodTra);
            this.lineBeltMC.mouseEnabled = false;
            this.addEvent();
         }
      }
      
      public function showGame() : void
      {
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoinGame);
         SocketConnection.send(CommandID.JOIN_GAME,1);
      }
      
      private function onJoinGame(_arg_1:SocketEvent) : void
      {
         MapManager.destroy();
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoinGame);
         this.loader = new MCLoader("resource/Games/PaoPaoGame.swf",LevelManager.topLevel,1,"正在加载游戏");
         this.loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadDLL);
         this.loader.doLoad();
      }
      
      private function onLoadDLL(_arg_1:MCLoadEvent) : void
      {
         MainManager.getStage().frameRate = 40;
         this.loader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadDLL);
         this.loader = null;
         LevelManager.topLevel.addChild(_arg_1.getContent());
         _arg_1.getContent().addEventListener("gamelost",this.onGameOver);
         _arg_1.getContent().addEventListener("gameclose",this.onGameOver);
         _arg_1.getContent().addEventListener("gamewin",this.onGameOver);
         this.curDisplayObj = _arg_1.getContent();
         var _local_2:* = this.curDisplayObj as Sprite;
         _local_2.addMc(this.petT);
      }
      
      private function onGameOver(_arg_1:Event) : void
      {
         var _local_2:Number = NaN;
         MainManager.getStage().frameRate = 24;
         var _local_3:* = _arg_1.target as Sprite;
         if(_local_3._bili < 1)
         {
            _local_2 = 1;
         }
         else
         {
            _local_2 = Number(_local_3._bili);
         }
         var _local_4:int = int(int((_local_2 - 1) / 2 * 10) * 10);
         var _local_5:int = int(_local_4 * 10);
         MapManager.refMap();
         this.curDisplayObj.removeEventListener("gamelost",this.onGameOver);
         this.curDisplayObj.removeEventListener("gameclose",this.onGameOver);
         this.curDisplayObj.removeEventListener("gamewin",this.onGameOver);
         this.curDisplayObj = null;
         SocketConnection.send(CommandID.GAME_OVER,_local_4,_local_4);
      }
      
      private function chosFoodTra(evt:Event) : void
      {
         var timer_0:Timer = null;
         timer_0 = null;
         if(this.spriteTransferMC.currentLabel == "one")
         {
            this.spriteTransferMC.removeEventListener(Event.ENTER_FRAME,this.chosFoodTra);
            this.spriteTransferMC.gotoAndStop("one");
            this.trainingMC_0.gotoAndStop(2);
            timer_0 = new Timer(2000,1);
            timer_0.addEventListener(TimerEvent.TIMER,function(_arg_1:TimerEvent):void
            {
               timer_0.removeEventListener(TimerEvent.TIMER,arguments.callee);
               timer_0.stop();
               timer_0 = null;
               ChosSpriteFoodController.showPanel();
            });
            timer_0.start();
         }
      }
      
      private function spritePhyTra(evt:Event) : void
      {
         var timer_1:Timer = null;
         timer_1 = null;
         if(this.spriteTransferMC.currentLabel == "two")
         {
            this.spriteTransferMC.removeEventListener(Event.ENTER_FRAME,this.spritePhyTra);
            this.spriteTransferMC.gotoAndStop("two");
            this.trainingMC_1.gotoAndStop(2);
            this.trainingMC_0.gotoAndStop(1);
            timer_1 = new Timer(2000,1);
            timer_1.addEventListener(TimerEvent.TIMER,function(_arg_1:TimerEvent):void
            {
               timer_1.removeEventListener(TimerEvent.TIMER,arguments.callee);
               timer_1.stop();
               timer_1 = null;
               SpritePhyTraController.showPanel();
            });
            timer_1.start();
         }
      }
      
      private function spriteRaceTra(evt:Event) : void
      {
         var timer_2:Timer = null;
         timer_2 = null;
         if(this.spriteTransferMC.currentLabel == "three")
         {
            this.spriteTransferMC.removeEventListener(Event.ENTER_FRAME,this.spriteRaceTra);
            this.spriteTransferMC.gotoAndStop("three");
            this.trainingMC_2.gotoAndStop(2);
            this.trainingMC_1.gotoAndStop(1);
            timer_2 = new Timer(2000,1);
            timer_2.addEventListener(TimerEvent.TIMER,function(_arg_1:TimerEvent):void
            {
               timer_2.removeEventListener(TimerEvent.TIMER,arguments.callee);
               timer_2.stop();
               timer_2 = null;
               SpriteRaceTraController.showPanel();
            });
            timer_2.start();
         }
      }
      
      private function spriteElecTra(evt:Event) : void
      {
         var timer_3:Timer = null;
         timer_3 = null;
         if(this.spriteTransferMC.currentLabel == "four")
         {
            this.spriteTransferMC.removeEventListener(Event.ENTER_FRAME,this.spriteElecTra);
            this.spriteTransferMC.gotoAndStop("four");
            this.trainingMC_3.gotoAndStop(2);
            this.trainingMC_2.gotoAndStop(1);
            timer_3 = new Timer(2000,1);
            timer_3.addEventListener(TimerEvent.TIMER,function(_arg_1:TimerEvent):void
            {
               timer_3.removeEventListener(TimerEvent.TIMER,arguments.callee);
               timer_3.stop();
               timer_3 = null;
               SpriteElecTraController.showPanel();
            });
            timer_3.start();
         }
      }
      
      private function petTrainingSucess(_arg_1:DynamicEvent) : void
      {
         var _local_2:String = null;
         this.spriteTransferMC.gotoAndPlay(this.spriteTransferMC.currentFrame + 1);
         var _local_3:String = _arg_1.paramObject as String;
         var _local_4:String = NpcTipDialog.NONO_2;
         if(MainManager.actorInfo.superNono)
         {
            _local_4 = NpcTipDialog.NONO;
         }
         switch(_local_3)
         {
            case "game_0":
               this.spriteTransferMC.addEventListener(Event.ENTER_FRAME,this.spritePhyTra);
               return;
            case "game_1":
               if(!MainManager.actorInfo.superNono)
               {
                  _local_2 = "精灵养成机能量不足，需要超能NoNo的超级能量才能维持它的后续运转。";
                  this.comdType = 4;
                  NpcTipDialog.show(_local_2,this.returnPetStatus,NpcTipDialog.NONO_2,0,this.returnPetStatus);
                  return;
               }
               this.spriteTransferMC.addEventListener(Event.ENTER_FRAME,this.spriteRaceTra);
               return;
               break;
            case "game_2":
               this.spriteTransferMC.addEventListener(Event.ENTER_FRAME,this.spriteElecTra);
               return;
            case "game_3":
               this.comdType = 6;
               this.returnPetStatus();
         }
      }
      
      private function petTrainingFalse(_arg_1:DynamicEvent) : void
      {
         var _local_2:MovieClip = null;
         var _local_3:String = null;
         var _local_4:String = null;
         var _local_5:String = null;
         var _local_6:String = null;
         var _local_7:String = null;
         var _local_8:String = _arg_1.paramObject as String;
         var _local_9:String = NpcTipDialog.NONO_2;
         if(MainManager.actorInfo.superNono)
         {
            _local_9 = NpcTipDialog.NONO;
         }
         for each(_local_2 in this.trainingMcArr)
         {
            _local_2.gotoAndStop(1);
         }
         switch(_local_8)
         {
            case "game_0":
               _local_3 = "主人主人，你需要对精灵有更多的了解哦！每种不同属性的精灵喜欢不同的食物呢！";
               this.comdType = 0;
               NpcTipDialog.show(_local_3,this.returnPetStatus,_local_9,0,this.returnPetStatus);
               return;
            case "game_1":
               _local_4 = "精灵们还需要更多的锻炼啊，继续努力吧！";
               this.comdType = 3;
               NpcTipDialog.show(_local_4,this.returnPetStatus,_local_9,0,this.returnPetStatus);
               return;
            case "game_2":
               _local_5 = "精灵们还需要更多的锻炼啊，继续努力吧！";
               this.comdType = 4;
               NpcTipDialog.show(_local_5,this.returnPetStatus,_local_9,0,this.returnPetStatus);
               return;
            case "game_3":
               SocketConnection.send(CommandID.PRIZE_OF_ATRESIASPACE,5);
               return;
            case "small":
               _local_6 = "这样不能激发精灵的最佳体能哦，再试试看吧！";
               this.comdType = 5;
               NpcTipDialog.show(_local_6,this.returnPetStatus,_local_9,0,this.returnPetStatus);
               return;
            case "big":
               _local_7 = "那么强的电力会让精灵们受伤呢，要疼爱精灵们哦！";
               this.comdType = 5;
               NpcTipDialog.show(_local_7,this.returnPetStatus,_local_9,0,this.returnPetStatus);
         }
      }
      
      private function returnPetStatus() : void
      {
         this.lineBeltMC.mouseEnabled = true;
         MainManager.actorModel.pet.visible = true;
         this.spriteTransferMC.gotoAndStop(1);
         DisplayUtil.removeForParent(this._showMc);
         this._showMc = null;
         if(this.comdType != 0)
         {
            SocketConnection.send(CommandID.PRIZE_OF_ATRESIASPACE,this.comdType);
         }
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

