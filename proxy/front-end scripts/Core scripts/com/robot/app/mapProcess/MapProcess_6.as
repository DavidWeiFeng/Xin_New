package com.robot.app.mapProcess
{
   import com.robot.app.ItemMixture.*;
   import com.robot.app.exchangeCloth.*;
   import com.robot.app.fightNote.*;
   import com.robot.app.help.*;
   import com.robot.app.task.control.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.animate.*;
   import com.robot.core.config.*;
   import com.robot.core.energyExchange.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.attack.*;
   import com.robot.core.info.task.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.npc.*;
   import com.robot.core.ui.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.events.DynamicEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_6 extends BaseMapProcess
   {
      
      private static var isWin:Boolean = true;
      
      private var btn:Sprite;
      
      private var tt:Timer;
      
      private var exchangeApp:AppModel;
      
      private var _excClothModel:ExchangeClothModel;
      
      private var _isShow:Boolean = false;
      
      private var _count:uint = 0;
      
      private var _tipMc:MovieClip;
      
      private var _app:AppModel;
      
      private var wbMc:MovieClip;
      
      private var mbox:DialogBox;
      
      private var npcModel:NpcModel;
      
      private var gunMC:MovieClip;
      
      private var panel:AppModel;
      
      private var bombGameMc:AppModel;
      
      public function MapProcess_6()
      {
         super();
      }
      
      private function wbmcOverHandler(_arg_1:MouseEvent) : void
      {
         this.mbox = new DialogBox();
         this.mbox.show("有什么需要我帮助您的吗？",0,-30,conLevel["wbNpc"]);
      }
      
      private function wbmcOUTHandler(_arg_1:MouseEvent) : void
      {
         this.mbox.hide();
      }
      
      private function onTipClickHandler(_arg_1:MouseEvent) : void
      {
         this._tipMc["closeBtn"].removeEventListener(MouseEvent.CLICK,this.onTipClickHandler);
         DisplayUtil.removeForParent(this._tipMc);
         this._tipMc = null;
      }
      
      override protected function init() : void
      {
         this.showTask98();
         this._isShow = false;
         this.btn = new Sprite();
         this.btn.graphics.beginFill(65280);
         this.btn.graphics.drawRect(0,0,130,56);
         this.btn.width = 130;
         this.btn.height = 56;
         this.btn.x = 440;
         this.btn.y = 60;
         this.btn.alpha = 0;
         this.btn.buttonMode = true;
         conLevel.addChild(this.btn);
         this.btn.addEventListener(MouseEvent.CLICK,this.showTip);
         ToolTipManager.add(conLevel["exchangeCloth_btn"],"物质转换仪/材料合成");
         ToolTipManager.add(conLevel["Army"],"比比鼠发电装置");
         ToolTipManager.add(conLevel["exchangBtn"],"能源兑换");
         this.wbMc = conLevel["hitWbMC"];
         this.wbMc.addEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.addEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         ToolTipManager.add(conLevel["aeroLiteGameMC"],"突围磁风暴");
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(e:SocketEvent):void
         {
            var oreCountInfo:MiningCountInfo;
            var count:uint;
            SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
            oreCountInfo = e.data as MiningCountInfo;
            count = oreCountInfo.miningCount;
            if(count >= 6 || count < 6 && Math.random() > 0.2)
            {
               EventManager.addEventListener(NpcController.GET_CURNPC,function(_arg_1:Event):void
               {
                  EventManager.removeEventListener(NpcController.GET_CURNPC,arguments.callee);
                  NpcController.curNpc.npc.npc.visible = false;
               });
            }
         });
         SocketConnection.send(CommandID.TALK_COUNT,600012 - 500000);
      }
      
      private function showTaskDialog(_arg_1:uint) : void
      {
      }
      
      public function aeroLiteGame() : void
      {
         var _local_1:MCLoader = new MCLoader("resource/Games/ThruAeroliteGame.swf",LevelManager.appLevel,1,"正在进入磁力光束枪台");
         _local_1.addEventListener(MCLoadEvent.SUCCESS,this.onLoadGameMovie);
         _local_1.doLoad();
      }
      
      private function onLoadGameMovie(event:MCLoadEvent) : void
      {
         var mcloader:MCLoader = null;
         mcloader = null;
         var content:Sprite = event.getContent() as Sprite;
         MainManager.getStage().addChild(content);
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onBeginGame);
         SocketConnection.send(CommandID.JOIN_GAME,1);
         mcloader = event.currentTarget as MCLoader;
         mcloader.sharedEvents.addEventListener("False_ThruAeroGame",function(_arg_1:DynamicEvent):void
         {
            var _local_3:uint = 0;
            mcloader.sharedEvents.removeEventListener("False_ThruAeroGame",arguments.callee);
            switch(uint(_arg_1.paramObject))
            {
               case 1:
                  _local_3 = 40;
                  break;
               case 2:
                  _local_3 = 80;
            }
            SocketConnection.send(CommandID.GAME_OVER,_local_3,_local_3);
         });
         mcloader.sharedEvents.addEventListener("Pass_ThruAeroGame",function(_arg_1:DynamicEvent):void
         {
            mcloader.sharedEvents.removeEventListener("Pass_ThruAeroGame",arguments.callee);
            SocketConnection.send(CommandID.GAME_OVER,100,100);
         });
      }
      
      private function onBeginGame(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onBeginGame);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         SocketConnection.addCmdListener(CommandID.GAME_OVER,this.onGameOver);
      }
      
      private function onGameOver(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GAME_OVER,this.onGameOver);
      }
      
      public function showWbAction() : void
      {
         var _local_1:MovieClip = conLevel["wbNpc"] as MovieClip;
         _local_1.gotoAndPlay(2);
      }
      
      override public function destroy() : void
      {
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         this.wbMc = null;
         this.mbox = null;
         if(Boolean(this._tipMc))
         {
            this.onTipClickHandler(null);
         }
         if(Boolean(this._excClothModel))
         {
            this._excClothModel.destroy();
            this._excClothModel = null;
         }
         if(Boolean(this.exchangeApp))
         {
            this.exchangeApp.sharedEvents.removeEventListener(Event.CLOSE,this.onCloseHandler);
            this.exchangeApp.destroy();
            this.exchangeApp = null;
         }
         this.btn.removeEventListener(MouseEvent.CLICK,this.showTip);
         this.btn = null;
         ToolTipManager.remove(conLevel["exchangeCloth_btn"]);
         ToolTipManager.remove(conLevel["Army"]);
         ToolTipManager.remove(conLevel["exchangBtn"]);
      }
      
      private function showTip(_arg_1:MouseEvent) : void
      {
         NpcTipDialog.show("这里是飞船的能源中心，这里有最先进的矿石检测设备。期望你第一个找到适合地球的能源矿石。当然飞船也是需要能源的，一些普通外星矿石可供给骄阳计划使用。");
      }
      
      public function showExChange() : void
      {
         if(!this._isShow)
         {
            ExchangeOreModel.getData(this.onGetComHandler,"你目前还没有兑换的材料，快打开右下角的<font color=\'#ff0000\'>芯片手册</font>看看吧，可能对你会有所帮助哦！");
         }
      }
      
      public function showWBTask() : void
      {
         HelpManager.show(0);
      }
      
      public function onGetComHandler(_arg_1:Object) : void
      {
         if(Boolean(_arg_1))
         {
            if(!this.exchangeApp)
            {
               this.exchangeApp = new AppModel(ClientConfig.getAppModule("ExchangeOrePanel"),"正在进入能源兑换");
               this.exchangeApp.setup();
               this.exchangeApp.sharedEvents.addEventListener(Event.CLOSE,this.onCloseHandler);
            }
            this.exchangeApp.init(_arg_1);
            this._isShow = true;
         }
      }
      
      private function onCloseHandler(_arg_1:Event) : void
      {
         this._isShow = false;
         this.exchangeApp.sharedEvents.removeEventListener(Event.CLOSE,this.onCloseHandler);
         this.exchangeApp.destroy();
         this.exchangeApp = null;
      }
      
      public function onExchangeClothHandler() : void
      {
         NpcDialog.show(NPC.SHUKE,["合理开采和运用能源才是硬道理！"],["我想使用物质转换仪","我想进行材料合成"],[function():void
         {
            _excClothModel = new ExchangeClothModel();
         },function():void
         {
            ItemMixturePanelController.show();
         }]);
      }
      
      public function gameFun() : void
      {
         var _local_1:String = null;
         var _local_2:ActorModel = null;
         var _local_3:PetModel = null;
         var _local_4:uint = 0;
         if(TasksManager.getTaskStatus(405) == TasksManager.COMPLETE)
         {
            Alarm.show("比比鼠看起来已经很疲劳咯，让小家伙好好休息一下吧。");
            return;
         }
         if(TasksManager.getTaskStatus(405) == TasksManager.UN_ACCEPT)
         {
            _local_1 = "你还没有获取" + TextFormatUtil.getRedTxt("比比鼠发电能源") + "的每日任务呢，" + "快点击右上角的" + TextFormatUtil.getRedTxt("精灵训练营") + "按钮看看吧！";
            Alarm.show(_local_1);
         }
         else
         {
            _local_2 = MainManager.actorModel;
            _local_3 = _local_2.pet;
            if(Boolean(_local_3))
            {
               _local_4 = uint(_local_3.info.petID);
               if(_local_4 == 13 || _local_4 == 14 || _local_4 == 15)
               {
                  this.gameStart();
               }
               else
               {
                  Alarm.show("只有带上你的<font color=\'#ff0000\'>比比鼠</font>才可以来启动发电能源设施哦。");
               }
            }
            else
            {
               Alarm.show("只有带上你的<font color=\'#ff0000\'>比比鼠</font>才可以来启动发电能源设施哦。");
            }
         }
      }
      
      private function addGameInfo() : void
      {
      }
      
      private function gameStart() : void
      {
         if(!this.bombGameMc)
         {
            this.bombGameMc = new AppModel(ClientConfig.getGameModule("ElectricGame"),"正在打开发电游戏");
            this.bombGameMc.setup();
         }
         this.bombGameMc.show();
      }
      
      private function fightWithAllision(e:MouseEvent) : void
      {
         FightInviteManager.fightWithBoss("艾里逊",1);
         EventManager.addEventListener(PetFightEvent.FIGHT_RESULT,function(evt:PetFightEvent):void
         {
            var fightData:FightOverInfo = null;
            EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,arguments.callee);
            fightData = evt.dataObj as FightOverInfo;
            TasksManager.complete(TaskController_98.TASK_ID,3,function(_arg_1:Boolean):void
            {
            });
            if(fightData.winnerID == MainManager.actorInfo.userID)
            {
               MapProcess_6.isWin = true;
            }
            else
            {
               MapProcess_6.isWin = false;
            }
         });
      }
      
      private function zogComeOn() : void
      {
         AnimateManager.playMcAnimate(depthLevel["allison_npc"],2,"effect",function():void
         {
            NpcDialog.show(NPC.ZOG,["我打打打打！！！！那个尼布呢？快交出来！臭小子！竟然敢背叛我！看我不带你回去收拾你！！！"],["我不会让你伤害它的！"],[function():void
            {
               NpcDialog.show(NPC.ALLISON,["大哥！我和你一起收拾这个家伙！！！我看你能神气多久！"],["你们竟然以多欺少！可恶！"],[function():void
               {
                  NpcDialog.show(NPC.JUSTIN,["我不允许你们欺负无辜的精灵！不允许你们欺负我的伙伴！真的想要对决？来找我吧！"],["你们竟然以多欺少！可恶！"],[function():void
                  {
                     AnimateManager.playMcAnimate(depthLevel["allison_npc"],3,"effect",function():void
                     {
                        AnimateManager.playFullScreenAnimate("resource/bounsMovie/fightover.swf",function():void
                        {
                           NpcDialog.show(NPC.ALLISON,["不妙！大哥我们还是先闪吧！君子报仇十年不晚！！！你……你给我们记住！！！！"],["哼！站长快教训他们那群坏蛋！"],[function():void
                           {
                              AnimateManager.playFullScreenAnimate("resource/bounsMovie/spacefight.swf",function():void
                              {
                                 TasksManager.complete(TaskController_98.TASK_ID,4,function():void
                                 {
                                    depthLevel["allison_npc"].visible = false;
                                    conLevel["wbNpc1"].visible = false;
                                    conLevel["wbNpc"].visible = true;
                                    conLevel["hitWbMC"].visible = true;
                                    TaskController_98.showPanel();
                                 });
                              },null,"sound");
                           }]);
                        },null,"sound");
                     });
                  }]);
               }]);
            }]);
         });
      }
      
      private function showTask98() : void
      {
         if(TasksManager.getTaskStatus(TaskController_98.TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(TaskController_98.TASK_ID,function(arr:Array):void
            {
               if(Boolean(arr[2]) && !arr[3])
               {
                  depthLevel["allison_npc"].visible = true;
                  conLevel["wbNpc1"].visible = true;
                  conLevel["hitWbMC"].visible = false;
                  conLevel["wbNpc"].visible = false;
                  NpcDialog.show(NPC.ALLISON,["嘿嘿……我本来只想要抓尼布的！既然你这么多管闲事！那就别怪我手下不留情了！嘿嘿！！！！！"],["我是不会怕你的！"],[function():void
                  {
                     depthLevel["allison_npc"].buttonMode = true;
                     depthLevel["allison_npc"].addEventListener(MouseEvent.CLICK,fightWithAllision);
                     TaskController_98.showPanel();
                  }]);
               }
               else if(Boolean(arr[3]) && !arr[4])
               {
                  conLevel["wbNpc1"].visible = true;
                  conLevel["hitWbMC"].visible = false;
                  conLevel["wbNpc"].visible = false;
                  if(MapProcess_6.isWin)
                  {
                     DisplayUtil.removeForParent(depthLevel["test"]);
                     NpcDialog.show(NPC.ALLISON,["啊……好疼！#5可恶！气死我了！你竟然变得这么强……佐格大哥是你出场的时候了！这个家伙欺负我……"],["就算佐格来我也不怕！"],[function():void
                     {
                        zogComeOn();
                     }]);
                  }
                  else
                  {
                     NpcDialog.show(NPC.ALLISON,["呵呵！手下败将！我就说你不是我的对说了吧！我让你知道什么是宇宙海盗！佐格大哥！该是时候让你出场了！哈哈！"],["我不会让你们带走尼布的！"],[function():void
                     {
                        zogComeOn();
                     }]);
                  }
               }
               else if(Boolean(arr[4]) || !arr[2])
               {
                  depthLevel["allison_npc"].visible = false;
                  conLevel["wbNpc1"].visible = false;
               }
            });
         }
         else
         {
            depthLevel["allison_npc"].visible = false;
            conLevel["wbNpc1"].visible = false;
         }
      }
   }
}

