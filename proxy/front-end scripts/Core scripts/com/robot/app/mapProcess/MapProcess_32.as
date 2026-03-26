package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.*;
   import com.robot.app.leiyiTrain.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_32 extends BaseMapProcess
   {
      
      private var _rockMc:MovieClip;
      
      private var _rockBtn:MovieClip;
      
      private var _leiyiGameBtn:SimpleButton;
      
      public function MapProcess_32()
      {
         super();
      }
      
      override protected function init() : void
      {
         try
         {
            EventManager.addEventListener("LY_OUT",this.onLYShow);
            this._rockMc = conLevel.getChildByName("rockMc") as MovieClip;
            this._rockMc.gotoAndStop(1);
            this._rockMc.buttonMode = true;
            this._rockMc.mouseEnabled = false;
            this._rockMc.visible = false;
            this._rockBtn = conLevel.getChildByName("rockBtn") as MovieClip;
            this._rockBtn.mouseEnabled = false;
            this._rockBtn.visible = false;
            this._rockBtn.buttonMode = true;
            conLevel["bossBtn"].mouseEnabled = false;
            this.check();
         }
         catch(error:Error)
         {
         }
         try
         {
            conLevel["kaku_leiyi"].visible = false;
            conLevel["findItemMc"].visible = false;
            conLevel["jiaLeiyi"].visible = false;
            conLevel["task_122"].visible = false;
            btnLevel["cloud_mc"].visible = false;
            animatorLevel["leyi_effect"].visible = false;
            animatorLevel["leiyi_mc"].visible = false;
            animatorLevel["kaku32_mc"].visible = false;
            this._leiyiGameBtn = btnLevel["game_btn"] as SimpleButton;
            ToolTipManager.add(this._leiyiGameBtn,"雷伊特训");
            this._leiyiGameBtn.addEventListener(MouseEvent.CLICK,function():void
            {
               LeiyiTrainPanelController.show();
            });
         }
         catch(error:Error)
         {
         }
      }
      
      private function onLYShow(_arg_1:Event) : void
      {
         this.showLY();
      }
      
      private function showLY() : void
      {
         conLevel["bossMc"]["mc"].gotoAndPlay(2);
         conLevel["bossBtn"].mouseEnabled = true;
      }
      
      public function hitLY() : void
      {
         FightInviteManager.fightWithBoss("雷伊");
      }
      
      private function check() : void
      {
         if(TasksManager.getTaskStatus(401) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatus(401,1,function(_arg_1:Boolean):void
            {
               if(!_arg_1)
               {
                  _rockMc.mouseEnabled = true;
                  _rockMc.visible = true;
                  _rockBtn.mouseEnabled = true;
                  _rockBtn.visible = true;
               }
            });
         }
      }
      
      override public function destroy() : void
      {
         EventManager.removeEventListener("LY_OUT",this.onLYShow);
         this._rockMc.removeEventListener(MouseEvent.CLICK,this.onMusicClick);
         this._rockMc = null;
         this._rockBtn = null;
      }
      
      private function onMusicClick(e:MouseEvent) : void
      {
         if(!MainManager.actorModel.getIsPetFollw(22) && !MainManager.actorModel.getIsPetFollw(23) && !MainManager.actorModel.getIsPetFollw(24))
         {
            Alarm.show("只有带上你的<font color=\'#ff0000\'>毛毛</font>，这些音符才会起到作用呢。");
            return;
         }
         TasksManager.complete(401,1,function(_arg_1:Boolean):void
         {
            _rockMc.removeEventListener(MouseEvent.CLICK,onMusicClick);
            if(_arg_1)
            {
               DisplayUtil.removeForParent(_rockMc);
               Alarm.show("你帮助毛毛找到了一个音符！");
            }
         });
      }
      
      public function clearWaste() : void
      {
      }
      
      public function onRockHit() : void
      {
         DisplayUtil.removeForParent(this._rockBtn);
         this._rockMc.gotoAndStop(2);
         this._rockMc.addEventListener(MouseEvent.CLICK,this.onMusicClick);
      }
      
      public function onbossHit() : void
      {
         FightInviteManager.fightWithBoss("雷伊");
      }
   }
}

