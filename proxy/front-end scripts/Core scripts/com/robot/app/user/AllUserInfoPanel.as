package com.robot.app.user
{
   import com.robot.app.bag.*;
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.*;
   import com.robot.core.skeleton.*;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.text.*;
   import gs.*;
   import gs.events.*;
   import org.taomee.utils.*;
   
   public class AllUserInfoPanel extends Sprite
   {
      
      private const allBossNum_uint:uint = 12;
      
      private const move:Number = 270.6;
      
      private var _allBossIdA:Array = [301,302,303,304,305,306,307,308,309,310,311,312];
      
      private var page:uint;
      
      private var curIndex:uint = 1;
      
      private var bossContainer:Sprite;
      
      private var bossMask:Sprite;
      
      private var _containerWidth2:Number;
      
      private var _containerX:Number;
      
      private var panel:MovieClip;
      
      private var userInfo:UserInfo;
      
      private var changeNick:ChangeNickName;
      
      private var tt1:TweenMax;
      
      private var tt2:TweenMax;
      
      private var extendTween:TweenMax;
      
      private var retractTween:TweenMax;
      
      private var oTherClothPrev:BagClothPreview;
      
      private var otherFaceShow:Sprite;
      
      public function AllUserInfoPanel()
      {
         super();
         this.setup();
      }
      
      public function setup() : void
      {
         this.panel = this.getPanel();
         this.otherFaceShow = this.getFaceBg();
         this.oTherClothPrev = new BagClothPreview(this.otherFaceShow,null,ClothPreview.MODEL_SHOW);
         this.panel["achievement_txt"].autoSize = TextFieldAutoSize.LEFT;
         this.panel["achievement_txt"].selectable = false;
         this.panel["stageTxt"].autoSize = TextFieldAutoSize.LEFT;
         this.panel["stageTxt"].selectable = false;
         this.panel["arenaTxt"].selectable = false;
         this.panel["noBtn"].visible = false;
      }
      
      public function init(_arg_1:UserInfo) : void
      {
         this.curIndex = 1;
         this.userInfo = _arg_1;
         UserInfoManager.upDateMoreInfo(this.userInfo,this.onUserInfoUpdataHandler);
      }
      
      public function hide() : void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this.panel);
         DisplayUtil.removeForParent(this);
         if(this.userInfo.userID != MainManager.actorInfo.userID)
         {
            AllUserInfoController.setStatus = false;
         }
      }
      
      public function show(_arg_1:UserInfo, _arg_2:DisplayObjectContainer) : void
      {
         this.curIndex = 1;
         this.userInfo = _arg_1;
         if(this.allBossNum_uint % 3 == 0)
         {
            this.page = uint(this.allBossNum_uint / 3);
         }
         else
         {
            this.page = uint(this.allBossNum_uint / 3) + 1;
         }
         this.addChild(this.panel);
         if(this.userInfo.userID == MainManager.actorInfo.userID)
         {
            LevelManager.appLevel.addChild(this);
            DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER,null);
         }
         else
         {
            _arg_2.addChildAt(this,0);
            this.x = 0;
         }
         this.panel["prevMC"].addChild(this.otherFaceShow);
         if(this.userInfo.userID == MainManager.actorInfo.userID)
         {
            this.panel["flex_mc"].visible = false;
         }
         else
         {
            this.panel["close_btn"].visible = false;
            this.panel["chNickTagBtn"].visible = false;
            this.panel["chNickBtn"].visible = false;
            this.extendTween = new TweenMax(this,0.3,{"x":this.move});
            this.extendTween.addEventListener(TweenEvent.COMPLETE,this.onExtendTweenCompleteHandler);
         }
         this.addEvent();
         this.init(this.userInfo);
      }
      
      private function onExtendTweenCompleteHandler(_arg_1:TweenEvent) : void
      {
         this.extendTween.removeEventListener(TweenEvent.COMPLETE,this.onExtendTweenCompleteHandler);
         this.extendTween = null;
         this.panel["flex_mc"].mouseChildren = true;
         this.panel["flex_mc"].addEventListener(MouseEvent.CLICK,this.onOtherPanelFlexMcHandler);
      }
      
      private function onUserInfoUpdataHandler() : void
      {
         if(this.userInfo.userID == MainManager.actorInfo.userID)
         {
            if(!this.changeNick)
            {
               this.changeNick = new ChangeNickName();
               this.changeNick.init(this.panel);
            }
         }
         if(Boolean(this.userInfo.vip))
         {
            this.panel["noBtn"].visible = true;
         }
         this.panel["name_txt"].text = this.userInfo.nick;
         this.panel["mimi_txt"].text = String(this.userInfo.userID);
         this.panel["arg_txt"].text = String(this.userInfo.graduationCount) + "人";
         var _local_1:Date = new Date(this.userInfo.regTime * 1000);
         this.panel["time_txt"].text = _local_1.getFullYear().toString() + "年" + (_local_1.getMonth() + 1).toString() + "月" + _local_1.getDate().toString() + "日";
         this.panel["mum_txt"].text = String(this.userInfo.petAllNum);
         this.panel["le_txt"].text = String(this.userInfo.petMaxLev);
         this.panel["title"].text = "右侧更换称号";
         this.panel["achievement_txt"].text = String(this.userInfo.monKingWin) + "分";
         this.panel["petTxt"].text = String(this.userInfo.messWin) + "胜";
         this.panel["stageTxt"].text = String(this.userInfo.maxStage) + "层";
         this.panel["arenaTxt"].text = String(this.userInfo.maxArenaWins) + "胜";
         this.oTherClothPrev.changeColor(this.userInfo.color);
         this.oTherClothPrev.showCloths(this.userInfo.clothes);
         this.oTherClothPrev.showDoodle(this.userInfo.texture);
         this.addBossIcon();
      }
      
      private function addEvent() : void
      {
         this.panel["leftBtn"].addEventListener(MouseEvent.CLICK,this.onOtherLeftHandler);
         this.panel["rightBtn"].addEventListener(MouseEvent.CLICK,this.onOtherRightHandler);
         if(this.userInfo.userID == MainManager.actorInfo.userID)
         {
            this.panel["titleBtn"].addEventListener(MouseEvent.CLICK,this.onchoiceTitle);
            this.panel["close_btn"].addEventListener(MouseEvent.CLICK,this.onCloseHandler);
            this.panel["drag_mc"].buttonMode = true;
            this.panel["drag_mc"].addEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
         }
      }
      
      private function onchoiceTitle(_arg_1:MouseEvent) : void
      {
         trace("choiceTitle");
         if(ExternalInterface.available)
         {
            ExternalInterface.call("settitle",this.userInfo.curTitle);
         }
      }
      
      private function removeEvent() : void
      {
         this.panel["leftBtn"].removeEventListener(MouseEvent.CLICK,this.onOtherLeftHandler);
         this.panel["rightBtn"].removeEventListener(MouseEvent.CLICK,this.onOtherRightHandler);
         if(this.userInfo.userID == MainManager.actorInfo.userID)
         {
            this.panel["close_btn"].removeEventListener(MouseEvent.CLICK,this.onCloseHandler);
            this.panel["drag_mc"].removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
         }
      }
      
      private function onCloseHandler(_arg_1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function onDownHandler(_arg_1:MouseEvent) : void
      {
         this.startDrag();
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
      }
      
      private function onUpHandler(_arg_1:MouseEvent) : void
      {
         this.stopDrag();
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
      }
      
      public function destroy() : void
      {
         if(Boolean(this.extendTween))
         {
            this.extendTween.pause();
            this.extendTween.removeEventListener(TweenEvent.COMPLETE,this.onExtendTweenCompleteHandler);
            this.extendTween = null;
         }
         if(Boolean(this.retractTween))
         {
            this.retractTween.pause();
            this.retractTween.removeEventListener(TweenEvent.COMPLETE,this.onReTractCompleteHandler);
            this.retractTween = null;
         }
         if(Boolean(this.tt1))
         {
            this.tt1.pause();
            this.tt1.removeEventListener(TweenEvent.COMPLETE,this.onTT1Handler);
            this.tt1 = null;
         }
         if(Boolean(this.tt2))
         {
            this.tt2.pause();
            this.tt2.removeEventListener(TweenEvent.COMPLETE,this.onTT2Handler);
            this.tt2 = null;
         }
         if(Boolean(this.changeNick))
         {
            this.changeNick.destory();
         }
         if(this.userInfo.userID != MainManager.actorInfo.userID)
         {
            AllUserInfoController.setStatus = false;
         }
         this.removeEvent();
         DisplayUtil.removeForParent(this.panel);
         DisplayUtil.removeForParent(this);
         this.panel = null;
         this.otherFaceShow = null;
         this.oTherClothPrev = null;
         this.bossContainer = null;
         this.bossMask = null;
         this.userInfo = null;
      }
      
      public function returnFelx() : void
      {
         this.retractTween = new TweenMax(this,0.3,{"x":0});
         this.retractTween.addEventListener(TweenEvent.COMPLETE,this.onReTractCompleteHandler);
      }
      
      private function onOtherPanelFlexMcHandler(_arg_1:MouseEvent) : void
      {
         this.returnFelx();
      }
      
      private function onReTractCompleteHandler(_arg_1:TweenEvent) : void
      {
         this.retractTween.removeEventListener(TweenEvent.COMPLETE,this.onReTractCompleteHandler);
         this.retractTween = null;
         this.panel["flex_mc"].mouseEnabled = false;
         this.panel["flex_mc"].removeEventListener(MouseEvent.CLICK,this.onOtherPanelFlexMcHandler);
         this.hide();
      }
      
      private function onOtherLeftHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:Number = NaN;
         if(this.curIndex > 1)
         {
            _local_2 = this.bossContainer.x + 150;
            --this.curIndex;
            this.panel["leftBtn"].removeEventListener(MouseEvent.CLICK,this.onOtherLeftHandler);
            this.tt1 = new TweenMax(this.bossContainer,0.5,{"x":_local_2});
            this.tt1.addEventListener(TweenEvent.COMPLETE,this.onTT1Handler);
         }
      }
      
      private function onTT1Handler(_arg_1:TweenEvent) : void
      {
         this.tt1.removeEventListener(TweenEvent.COMPLETE,this.onTT1Handler);
         this.panel["leftBtn"].addEventListener(MouseEvent.CLICK,this.onOtherLeftHandler);
      }
      
      private function onOtherRightHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:Number = NaN;
         if(this.curIndex < this.page)
         {
            _local_2 = this.bossContainer.x - 150;
            ++this.curIndex;
            this.panel["rightBtn"].removeEventListener(MouseEvent.CLICK,this.onOtherRightHandler);
            this.tt2 = new TweenMax(this.bossContainer,0.5,{"x":_local_2});
            this.tt2.addEventListener(TweenEvent.COMPLETE,this.onTT2Handler);
         }
      }
      
      private function onTT2Handler(_arg_1:TweenEvent) : void
      {
         this.tt2.removeEventListener(TweenEvent.COMPLETE,this.onTT2Handler);
         this.panel["rightBtn"].addEventListener(MouseEvent.CLICK,this.onOtherRightHandler);
      }
      
      private function addBossIcon() : void
      {
         var _local_1:Sprite = null;
         var _local_2:int = 0;
         if(Boolean(this.bossContainer))
         {
            if(DisplayUtil.hasParent(this.bossContainer))
            {
               DisplayUtil.removeAllChild(this.bossContainer);
               DisplayUtil.removeForParent(this.bossContainer);
               this.bossContainer = null;
            }
         }
         this.bossContainer = new Sprite();
         this.panel.addChild(this.bossContainer);
         this.bossContainer.x = 62;
         this.bossContainer.y = 187;
         if(Boolean(this.bossMask))
         {
            if(DisplayUtil.hasParent(this.bossMask))
            {
               DisplayUtil.removeForParent(this.bossMask);
               this.bossMask.graphics.clear();
               this.bossMask = null;
            }
         }
         this.bossMask = new Sprite();
         this.bossMask.graphics.lineStyle(1,0,1);
         this.bossMask.graphics.beginFill(0,1);
         this.bossMask.graphics.drawRect(0,0,145,40);
         this.bossMask.graphics.endFill();
         this.panel.addChild(this.bossMask);
         this.bossMask.x = 62;
         this.bossMask.y = 175;
         this.bossContainer.mask = this.bossMask;
         this.bossContainer.y -= 12;
         while(_local_2 < this.allBossNum_uint)
         {
            _local_1 = UIManager.getSprite("Boss" + this._allBossIdA[_local_2] + "_MC");
            this.bossContainer.addChild(_local_1);
            _local_1.x = (_local_1.width + 15) * _local_2;
            _local_1.y = 2;
            if(this.userInfo.userID == MainManager.actorInfo.userID)
            {
               if(TasksManager.taskList[this._allBossIdA[_local_2] - 1] == 3)
               {
                  _local_1["mc1"].visible = false;
               }
            }
            else if(this.userInfo.bossAchievement[_local_2] == true)
            {
               _local_1["mc1"].visible = false;
            }
            _local_1["win_mc"].visible = false;
            _local_2++;
         }
      }
      
      private function getPanel() : MovieClip
      {
         return UIManager.getMovieClip("AllUserInfoPanel_MC");
      }
      
      private function getFaceBg() : Sprite
      {
         var _local_1:Sprite = UIManager.getSprite("ComposeMC");
         _local_1.mouseEnabled = false;
         _local_1.mouseChildren = false;
         _local_1.scaleY = 0.5;
         _local_1.scaleX = 0.5;
         _local_1.x = (71 - _local_1.width) / 2;
         return _local_1;
      }
   }
}

