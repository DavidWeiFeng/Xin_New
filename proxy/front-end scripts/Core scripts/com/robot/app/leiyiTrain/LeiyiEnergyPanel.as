package com.robot.app.leiyiTrain
{
   import com.robot.app.fightNote.*;
   import com.robot.app.petbag.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class LeiyiEnergyPanel extends Sprite
   {
      
      private var _closeBtn:SimpleButton;
      
      private var _cureBtn:SimpleButton;
      
      private var _bagBtn:SimpleButton;
      
      private var _mainMc:Sprite;
      
      private var _loader:MCLoader;
      
      private var PATH:String = "resource/appRes/2016/0122/LeiYiGamePanel.swf";
      
      private var _current:Array = [];
      
      private var _total:Array = [];
      
      private var _desList:Array = ["体力","防御","特防","攻击","特攻","速度","极光刃","闪电斗气","元气电光球","雷神觉醒"];
      
      public function LeiyiEnergyPanel()
      {
         super();
      }
      
      public function hide() : void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this._mainMc);
      }
      
      public function show() : void
      {
         this._loader = null;
         if(!this._mainMc)
         {
            this._loader = new MCLoader(this.PATH,this,1,"正在打开雷伊体能特训面板");
            this._loader.addEventListener(MCLoadEvent.SUCCESS,this.setup);
            this._loader.doLoad();
         }
      }
      
      public function init(_arg_1:Object = null) : void
      {
      }
      
      private function onEnergyHandler(_arg_1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function removeEvent() : void
      {
         var _local_1:uint = 0;
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseHandler);
         this._bagBtn.removeEventListener(MouseEvent.CLICK,this.onBagClick);
         this._cureBtn.removeEventListener(MouseEvent.CLICK,this.onCureClick);
         while(_local_1 < 10)
         {
            this._mainMc["btn_" + _local_1].removeEventListener(MouseEvent.CLICK,this.clickHandle);
            _local_1++;
         }
      }
      
      private function onCloseHandler(_arg_1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function onBagClick(_arg_1:MouseEvent) : void
      {
         PetBagController.show();
      }
      
      private function onCureClick(_arg_1:MouseEvent) : void
      {
         PetManager.cureAll();
      }
      
      private function addEvent() : void
      {
         var _local_1:uint = 0;
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseHandler);
         this._bagBtn.addEventListener(MouseEvent.CLICK,this.onBagClick);
         this._cureBtn.addEventListener(MouseEvent.CLICK,this.onCureClick);
         while(_local_1 < 10)
         {
            this._mainMc["btn_" + _local_1].addEventListener(MouseEvent.CLICK,this.clickHandle);
            _local_1++;
         }
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainMc = null;
         this._closeBtn = null;
         this._bagBtn = null;
         this._cureBtn = null;
      }
      
      public function setup(event:MCLoadEvent) : void
      {
         this._mainMc = this._loader.loader.content as Sprite;
         LevelManager.appLevel.addChild(this._mainMc);
         this._closeBtn = this._mainMc["close"];
         this._bagBtn = this._mainMc["bag"];
         this._cureBtn = this._mainMc["cure"];
         SocketConnection.addCmdListener(CommandID.LEIYI_TRAIN_GET_STATUS,function(_arg_1:SocketEvent):void
         {
            var _local_4:uint = 0;
            SocketConnection.removeCmdListener(CommandID.LEIYI_TRAIN_GET_STATUS,arguments.callee);
            var _local_3:IDataInput = _arg_1.data as IDataInput;
            while(_local_4 < 10)
            {
               _current.push(_local_3.readUnsignedInt());
               _total.push(_local_3.readUnsignedInt());
               if(_local_4 < 6)
               {
                  setNum(_mainMc["num_" + _local_4],_current[_local_4],_total[_local_4]);
               }
               _local_4++;
            }
            addEvent();
         });
         SocketConnection.send(CommandID.LEIYI_TRAIN_GET_STATUS);
      }
      
      private function setNum(_arg_1:TextField, _arg_2:uint, _arg_3:uint) : void
      {
         if(_arg_1 == null)
         {
            return;
         }
         _arg_1.text = _arg_2.toString() + "/" + _arg_3.toString();
      }
      
      private function clickHandle(e:MouseEvent) : void
      {
         var index:int = 0;
         var catchTime:uint = 0;
         var petinfo:PetInfo = null;
         index = 0;
         var ename:String = e.target.name;
         index = int(uint(ename.split("_")[1]));
         if(index > 0)
         {
            Alarm.show(this._desList[index] + "特训即将开放");
            return;
         }
         if(this._current[index] >= this._total[index])
         {
            Alarm.show("你已经完成了该项特训！");
            return;
         }
         catchTime = uint(PetManager.defaultTime);
         petinfo = PetManager.getPetInfo(catchTime);
         if(Boolean(petinfo) && petinfo.id == 70)
         {
            this.hide();
            EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,function(_arg_1:PetFightEvent):void
            {
               var _local_4:FightOverInfo = null;
               var _local_3:Array = null;
               EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,arguments.callee);
               _local_4 = _arg_1.dataObj["data"];
               LeiyiEnergyPanelController.show();
               if(_local_4.winnerID == MainManager.actorInfo.userID && index > 5)
               {
                  Alarm.show("恭喜你成功学会了新技能：" + _desList[index]);
               }
            });
            FightInviteManager.fightWithBoss("雷伊特训",index + 1);
         }
         else
         {
            Alarm.show("哎呀！快把雷伊设为对战的首选精灵，再来进行雷伊极限修行哦！");
         }
      }
   }
}

