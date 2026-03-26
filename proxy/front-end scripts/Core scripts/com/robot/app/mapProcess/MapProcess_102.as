package com.robot.app.mapProcess
{
   import com.robot.app.buyPetProps.BuyPetPropsController;
   import com.robot.app.fightNote.petKing.*;
   import com.robot.app.sceneInteraction.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.app.temp.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.*;
   import com.robot.core.npc.*;
   import com.robot.core.ui.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.*;
   import org.taomee.effect.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_102 extends BaseMapProcess
   {
      
      private var justin:MovieClip;
      
      private var confirm:SimpleButton;
      
      private var justinTxt:TextField;
      
      private var closeBt:SimpleButton;
      
      private var waitPanel:MovieClip;
      
      private var closeButton:SimpleButton;
      
      private var grassMC:SimpleButton;
      
      private var fireMC:SimpleButton;
      
      private var waterMC:SimpleButton;
      
      private var mcPet:String;
      
      private var j_npc:MovieClip;
      
      private var pet_mc:MovieClip;
      
      private var timer:Timer;
      
      private var dialogNum:uint = 0;
      
      public function MapProcess_102()
      {
         super();
      }
      
      override protected function init() : void
      {
         ToolTipManager.add(conLevel["enterFight"],"加入精灵王对战");
         ToolTipManager.add(conLevel["buyMC"],"精灵道具购买");
         ToolTipManager.add(conLevel["arenaTouchBtn_1"],"挑战擂台");
         ToolTipManager.add(conLevel["arenaTouchBtn_2"],"挑战擂台");
         ToolTipManager.add(conLevel["arenaTouchBtn_3"],"挑战擂台");
         ToolTipManager.add(conLevel["dou_mc"],"精灵大乱斗");
         ToolTipManager.add(conLevel["door_2"],"暗黑武斗场");
         ArenaController.getInstance().setup(conLevel.getChildByName("arenaMc") as MovieClip);
         this.j_npc = conLevel["npc"];
         this.j_npc.visible = false;
         this.pet_mc = conLevel["pet_mc"];
         this.pet_mc.visible = false;
         this.timer = new Timer(9000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      private function onTimer(_arg_1:TimerEvent) : void
      {
         var _local_2:DialogBox = new DialogBox();
         _local_2.show("使自己的训练精灵的技术更上一个境界吧。",0,-85,conLevel["npc"]);
      }
      
      public function hitNpc() : void
      {
         NpcDialog.show(NPC.JUSTIN,["骄阳计划上的每一个小赛尔都由我来守护。"],["我们会让自己变得更强！"],[]);
      }
      
      override public function destroy() : void
      {
         ToolTipManager.remove(conLevel["enterFight"]);
         ToolTipManager.remove(conLevel["buyMC"]);
         ToolTipManager.remove(conLevel["arenaTouchBtn_1"]);
         ToolTipManager.remove(conLevel["arenaTouchBtn_2"]);
         ToolTipManager.remove(conLevel["arenaTouchBtn_3"]);
         ToolTipManager.remove(conLevel["door_2"]);
         ArenaController.getInstance().figth();
         if(Boolean(this.closeBt))
         {
            this.closeBt.removeEventListener(MouseEvent.CLICK,this.closeMC);
            this.closeBt = null;
         }
         if(Boolean(this.confirm))
         {
            this.confirm.removeEventListener(MouseEvent.CLICK,this.closeMC);
            this.confirm.removeEventListener(MouseEvent.CLICK,this.givePetScr);
            this.confirm = null;
         }
         this.justin = null;
         this.justinTxt = null;
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.stop();
         this.timer = null;
      }
      
      public function onPetWarHandler() : void
      {
         PetKingWaitPanel.showPetWar();
      }
      
      private function onPetList(e:PetEvent) : void
      {
         var i:int = 0;
         var cheak:Function = function(_arg_1:int):void
         {
            if(_arg_1 == 1 || _arg_1 == 2 || _arg_1 == 3)
            {
               grassMC.filters = [ColorFilter.setGrayscale()];
               grassMC.mouseEnabled = false;
            }
            else if(_arg_1 == 7 || _arg_1 == 8 || _arg_1 == 9)
            {
               fireMC.filters = [ColorFilter.setGrayscale()];
               fireMC.mouseEnabled = false;
            }
            else if(_arg_1 == 4 || _arg_1 == 5 || _arg_1 == 6)
            {
               waterMC.filters = [ColorFilter.setGrayscale()];
               waterMC.mouseEnabled = false;
            }
         };
         PetManager.removeEventListener(PetEvent.STORAGE_LIST,this.onPetList);
         this.waitPanel = MapLibManager.getMovieClip("GetPet");
         LevelManager.appLevel.addChild(this.waitPanel);
         DisplayUtil.align(this.waitPanel,null,AlignType.MIDDLE_CENTER);
         this.closeButton = this.waitPanel["closeBtn"];
         this.closeButton.addEventListener(MouseEvent.CLICK,this.closeMC);
         this.grassMC = this.waitPanel["grassMC"];
         this.waterMC = this.waitPanel["waterMC"];
         this.fireMC = this.waitPanel["fireMC"];
         this.grassMC.addEventListener(MouseEvent.CLICK,this.onGivePet);
         this.waterMC.addEventListener(MouseEvent.CLICK,this.onGivePet);
         this.fireMC.addEventListener(MouseEvent.CLICK,this.onGivePet);
         i = 1;
         while(i <= 9)
         {
            if(PetManager.containsBagForID(i))
            {
               cheak(i);
            }
            else if(PetManager.containsStorageForID(i))
            {
               cheak(i);
            }
            i += 1;
         }
      }
      
      public function enterFight() : void
      {
         PetKingWaitPanel.show();
      }
      
      public function HitJustin() : void
      {
         this.justin = MapLibManager.getMovieClip("JustinGivePet3");
         DisplayUtil.align(this.justin,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         this.confirm = this.justin["ConfirmBtn"];
         this.closeBt = this.justin["closeBtn"];
         this.justinTxt = this.justin["TxtTip"];
         this.closeBt.addEventListener(MouseEvent.CLICK,this.closeMC);
         if(MainManager.actorInfo.monKingWin >= 10)
         {
            SocketConnection.addCmdListener(CommandID.IS_COLLECT,function(_arg_1:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.IS_COLLECT,arguments.callee);
               var _local_3:ByteArray = _arg_1.data as ByteArray;
               var _local_4:uint = _local_3.readUnsignedInt();
               var _local_5:Boolean = Boolean(_local_3.readUnsignedInt());
               LevelManager.topLevel.addChild(justin);
               if(_local_5)
               {
                  justinTxt.text = "   精灵王之战考验的是你的战斗技巧，通过自己不懈的努力成为真正的精灵王吧。";
                  confirm.addEventListener(MouseEvent.CLICK,closeMC);
               }
               else
               {
                  justinTxt.htmlText = "    你在精灵王之战中的表现非常出色，请接收我的礼物！";
                  confirm.addEventListener(MouseEvent.CLICK,givePetScr);
               }
            });
            SocketConnection.send(CommandID.IS_COLLECT,301);
         }
         else
         {
            LevelManager.topLevel.addChild(this.justin);
            this.justinTxt.text = "    贾斯汀站长委托我为每个在精灵王之战中获得10场胜利的高手送上一份礼物。";
            this.confirm.addEventListener(MouseEvent.CLICK,this.closeMC);
         }
      }
      
      private function givePetScr(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.justin,false);
         LevelManager.openMouseEvent();
         PetManager.addEventListener(PetEvent.STORAGE_LIST,this.onPetList);
         PetManager.getStorageList();
      }
      
      private function closeMC(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.waitPanel,false);
         DisplayUtil.removeForParent(this.justin,false);
         LevelManager.openMouseEvent();
      }
      
      private function onGivePet(_arg_1:MouseEvent) : void
      {
         var _local_2:uint = 0;
         if(_arg_1.currentTarget == this.grassMC)
         {
            _local_2 = 1;
            this.mcPet = "布布种子精灵";
         }
         else if(_arg_1.currentTarget == this.fireMC)
         {
            _local_2 = 7;
            this.mcPet = "小火猴精灵";
         }
         else if(_arg_1.currentTarget == this.waterMC)
         {
            _local_2 = 4;
            this.mcPet = "伊优精灵";
         }
         SocketConnection.addCmdListener(CommandID.PRIZE_OF_PETKING,this.onPrize);
         SocketConnection.send(CommandID.PRIZE_OF_PETKING,301,_local_2);
         var _local_3:SimpleButton = _arg_1.target as SimpleButton;
         DisplayUtil.removeForParent(this.waitPanel,false);
      }
      
      private function onPrize(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PRIZE_OF_PETKING,this.onPrize);
         var _local_2:PetKingPrizeInfo = _arg_1.data as PetKingPrizeInfo;
         var _local_3:String = PetXMLInfo.getName(_local_2.petID);
         if(PetManager.length < 6)
         {
            SocketConnection.send(CommandID.PET_RELEASE,_local_2.catchTime,1);
            SocketConnection.send(CommandID.GET_PET_INFO,_local_2.catchTime);
            PetInBagAlert.show(_local_2.petID,_local_3 + "已经放入了你的精灵背包！");
         }
         else
         {
            PetManager.addStorage(_local_2.petID,_local_2.catchTime);
            PetInStorageAlert.show(_local_2.petID,_local_3 + "已经放入了你的精灵仓库！");
         }
      }
      
      public function buyHandler() : void
      {
         BuyPetPropsController.show();
      }
      
      public function onArenaHit() : void
      {
         ArenaController.getInstance().strat();
      }
      
      public function onEnterHandler() : void
      {
         if(MainManager.actorInfo.superNono)
         {
            if(Boolean(MainManager.actorModel.nono))
            {
               MapManager.changeMap(110);
            }
            else
            {
               NpcTipDialog.show("你必须带上超能NoNo才能进入暗黑武斗场哦！",null,NpcTipDialog.NONO);
            }
         }
         else if(Boolean(NonoManager.info.func[12]))
         {
            if(Boolean(MainManager.actorModel.nono))
            {
               MapManager.changeMap(110);
            }
            else
            {
               NpcTipDialog.show("你必须带上NoNo才能进入暗黑武斗场哦！",null,NpcTipDialog.NONO_2);
            }
         }
         else
         {
            NpcTipDialog.show("你必须给NoNo装载上反物质芯片才能进入暗黑武斗场哦！",null,NpcTipDialog.NONO_2);
         }
      }
   }
}

