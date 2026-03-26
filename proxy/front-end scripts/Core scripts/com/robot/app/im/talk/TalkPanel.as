package com.robot.app.im.talk
{
   import com.robot.app.bag.*;
   import com.robot.app.cutBmp.*;
   import com.robot.app.fightNote.*;
   import com.robot.app.imgPanel.*;
   import com.robot.app.user.*;
   import com.robot.core.event.*;
   import com.robot.core.info.ChatInfo;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.relation.OnLineInfo;
   import com.robot.core.manager.*;
   import com.robot.core.skeleton.*;
   import com.robot.core.uic.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import org.taomee.effect.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class TalkPanel extends UIPanel
   {
      
      private static const EXP_MAX_TIME:int = 2000;
      
      public static const IMG_LINK:String = "http://";
      
      private var _info:UserInfo;
      
      private var _userID:uint;
      
      private var _titleTxt:TextField;
      
      private var _sendBtn:SimpleButton;
      
      private var _inputTxt:TextField;
      
      private var _wordTxt:TextField;
      
      private var _emotionBtn:SimpleButton;
      
      private var _fightInviteBtn:SimpleButton;
      
      private var _composeYou:BagClothPreview;
      
      private var _composeMe:BagClothPreview;
      
      private var _showYou:Sprite;
      
      private var _showMe:Sprite;
      
      private var _meBtn:SimpleButton;
      
      private var _youBtn:SimpleButton;
      
      private var _cutBmpBtn:SimpleButton;
      
      private var _nonoYou:Sprite;
      
      private var _nonoMe:Sprite;
      
      private var _txtBar:TextScrollBar;
      
      private var _emotionPanel:TEmotionPanel;
      
      private var _expMe:MovieClip;
      
      private var _expYou:MovieClip;
      
      private var _outTimeMe:uint;
      
      private var _outTimeYou:uint;
      
      private var _alertMc:Sprite;
      
      private var _alertTxt:TextField;
      
      private var _isSend:Boolean = false;
      
      public function TalkPanel()
      {
         super(UIManager.getSprite("ChatPanel"));
         this._sendBtn = _mainUI["sendBtn"];
         this._inputTxt = _mainUI["writeTxt"];
         this._titleTxt = _mainUI["titleTxt"];
         this._wordTxt = _mainUI["readTxt"];
         this._wordTxt.height -= 20;
         this._wordTxt.y += 20;
         this._emotionBtn = _mainUI["emotionBtn"];
         this._fightInviteBtn = _mainUI["fightInviteBtn"];
         this._meBtn = _mainUI["meBtn"];
         this._youBtn = _mainUI["youBtn"];
         this._cutBmpBtn = _mainUI["cutBmpBtn"];
         this._nonoYou = _mainUI["nonoYou"];
         this._nonoMe = _mainUI["nonoMe"];
         addChild(_mainUI);
         this._alertMc = TaskIconManager.getIcon("ChatAlert_Icon") as Sprite;
         _mainUI.addChild(this._alertMc);
         this._alertMc.x = 30;
         this._alertMc.y = 60;
         this._alertTxt = new TextField();
         this._alertTxt.width = 200;
         this._alertTxt.text = "请不要向任何人透露你的密码哦！";
         this._alertTxt.selectable = false;
         var _local_1:TextFormat = new TextFormat();
         _local_1.color = 16711680;
         _local_1.size = 12;
         _local_1.bold = true;
         this._alertTxt.setTextFormat(_local_1);
         this._alertMc.addChild(this._alertTxt);
         this._alertTxt.x = 20;
         this._nonoYou.visible = false;
         if(Boolean(MainManager.actorInfo.vip))
         {
            this._nonoMe.visible = true;
            this._nonoMe["vipStageMC"].gotoAndStop(MainManager.actorInfo.vipLevel);
            ToolTipManager.add(this._nonoMe,MainManager.actorInfo.vipLevel + "级超能NoNo");
         }
         else
         {
            this._nonoMe.visible = false;
         }
         this._inputTxt.maxChars = 130;
         this._inputTxt.restrict = "^妈";
         this._txtBar = new TextScrollBar(_mainUI,this._wordTxt,_mainUI["upBtn"],_mainUI["downBtn"]);
         this._showYou = UIManager.getSprite("ComposeMC");
         this._showMe = UIManager.getSprite("ComposeMC");
         this._showYou.mouseEnabled = false;
         this._showYou.mouseChildren = false;
         this._showMe.mouseEnabled = false;
         this._showMe.mouseChildren = false;
         this._showYou.x = 329;
         this._showYou.y = 98;
         this._showMe.x = 329;
         this._showMe.y = 260;
         this._showYou.scaleX = 0.4;
         this._showYou.scaleY = 0.4;
         this._showMe.scaleX = 0.4;
         this._showMe.scaleY = 0.4;
         addChild(this._showYou);
         addChild(this._showMe);
         this._composeYou = new BagClothPreview(this._showYou,null,ClothPreview.MODEL_SHOW);
         this._composeMe = new BagClothPreview(this._showMe,null,ClothPreview.MODEL_SHOW);
      }
      
      public function show(_arg_1:uint) : void
      {
         this._userID = _arg_1;
         this._composeMe.changeColor(MainManager.actorInfo.color);
         this._composeMe.showCloths(MainManager.actorInfo.clothes);
         this._composeMe.showDoodle(MainManager.actorInfo.texture);
         _show();
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         this.removeEvent();
         UserInfoManager.getInfo(this._userID,this.onInfo);
      }
      
      override public function hide() : void
      {
         super.hide();
         EventManager.removeEventListener(CutBmpEvent.CUT_BMP_COMPLETE,this.onCutBmpHandler);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         ToolTipManager.remove(this._nonoYou);
         ToolTipManager.remove(this._nonoMe);
         this.removeExpMe();
         this.removeExpYou();
         if(Boolean(this._alertMc))
         {
            DisplayUtil.removeForParent(this._alertMc);
            this._alertMc = null;
         }
         this._info = null;
         this._sendBtn = null;
         this._inputTxt = null;
         this._titleTxt = null;
         this._wordTxt = null;
         this._composeYou = null;
         this._composeMe = null;
         this._showMe = null;
         this._showYou = null;
         this._cutBmpBtn = null;
         this._nonoYou = null;
         this._nonoMe = null;
      }
      
      private function onInfo(_arg_1:UserInfo) : void
      {
         this._info = _arg_1;
         UserInfoManager.seeOnLine([this._userID],this.onInitOnLine);
         this._composeYou.changeColor(this._info.color);
         this._composeYou.showCloths(this._info.clothes);
         this._composeYou.showDoodle(this._info.texture);
         if(Boolean(this._info.vip))
         {
            this._nonoYou.visible = true;
            this._nonoYou["vipStageMC"].gotoAndStop(this._info.vipLevel);
            ToolTipManager.add(this._nonoYou,this._info.vipLevel + "级超能NoNo");
         }
         else
         {
            this._nonoYou.visible = false;
         }
         this.addEvent();
         this.initMsg();
      }
      
      private function onInitOnLine(_arg_1:Array) : void
      {
         var _local_2:OnLineInfo = null;
         var _local_3:Boolean = false;
         var _local_4:int = int(_arg_1.length);
         if(_local_4 > 0)
         {
            _local_2 = _arg_1[0];
            if(_local_2.serverID == MainManager.actorInfo.serverID)
            {
               _local_3 = true;
            }
            this._showYou.filters = [];
         }
         else
         {
            _local_3 = true;
            this._showYou.filters = [ColorFilter.setGrayscale(),ColorFilter.setBrightness(50)];
         }
         if(_local_3)
         {
            this._titleTxt.htmlText = "<a href=\'event:\'>与好友" + this._info.nick + "(" + this._info.userID + ")通话中</a>";
         }
         else
         {
            this._titleTxt.htmlText = "<a href=\'event:\'>与" + _local_2.serverID + ".服务器的" + this._info.nick + "(" + this._info.userID + ")通话中</a>";
         }
      }
      
      private function initMsg() : void
      {
         var _local_1:ChatInfo = null;
         var _local_2:Array = MessageManager.getChatInfo(this._userID);
         if(_local_2 != null)
         {
            this._wordTxt.text = "";
            for each(_local_1 in _local_2)
            {
               this.wordChange(_local_1);
            }
            this._txtBar.checkScroll();
         }
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.onSendMsg);
         this._inputTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._inputTxt.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this._emotionBtn.addEventListener(MouseEvent.CLICK,this.onEmotion);
         this._meBtn.addEventListener(MouseEvent.CLICK,this.onMeShow);
         this._youBtn.addEventListener(MouseEvent.CLICK,this.onYouShow);
         this._titleTxt.addEventListener(TextEvent.LINK,this.onYouShow);
         this._fightInviteBtn.addEventListener(MouseEvent.CLICK,this.onFight);
         this._wordTxt.addEventListener(TextEvent.LINK,this.onTextLink);
         this._cutBmpBtn.addEventListener(MouseEvent.CLICK,this.onCutMap);
         ToolTipManager.add(this._emotionBtn,"发送表情");
         ToolTipManager.add(this._fightInviteBtn,"发起对战");
         ToolTipManager.add(this._cutBmpBtn,"截图");
         MessageManager.addEventListener(ChatEvent.TALK + this._userID.toString(),this.onData);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._sendBtn.removeEventListener(MouseEvent.CLICK,this.onSendMsg);
         this._inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._inputTxt.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this._emotionBtn.removeEventListener(MouseEvent.CLICK,this.onEmotion);
         this._meBtn.removeEventListener(MouseEvent.CLICK,this.onMeShow);
         this._youBtn.removeEventListener(MouseEvent.CLICK,this.onYouShow);
         this._titleTxt.removeEventListener(TextEvent.LINK,this.onYouShow);
         this._fightInviteBtn.removeEventListener(MouseEvent.CLICK,this.onFight);
         this._wordTxt.removeEventListener(TextEvent.LINK,this.onTextLink);
         this._cutBmpBtn.removeEventListener(MouseEvent.CLICK,this.onCutMap);
         ToolTipManager.remove(this._emotionBtn);
         ToolTipManager.remove(this._fightInviteBtn);
         ToolTipManager.remove(this._cutBmpBtn);
         MessageManager.removeEventListener(ChatEvent.TALK + this._userID.toString(),this.onData);
      }
      
      private function wordChange(_arg_1:ChatInfo) : void
      {
         var _local_2:MovieClip = null;
         if(_arg_1.msg.substr(0,1) == "#")
         {
            if(_arg_1.isRead)
            {
               return;
            }
            _arg_1.isRead = true;
            _local_2 = UIManager.getMovieClip("e" + _arg_1.msg.substring(1,_arg_1.msg.length));
            if(Boolean(_local_2))
            {
               _local_2.mouseChildren = false;
               _local_2.mouseEnabled = false;
               if(_arg_1.senderID == MainManager.actorID)
               {
                  this.removeExpMe();
                  this.addExpMe(_local_2);
               }
               else
               {
                  this.removeExpYou();
                  this.addExpYou(_local_2);
               }
               return;
            }
         }
         if(_arg_1.senderID == MainManager.actorID)
         {
            TextFormatUtil.appSenderFormatText(this._wordTxt,MainManager.actorInfo.nick + ": ",true);
         }
         else
         {
            TextFormatUtil.appSenderFormatText(this._wordTxt,this._info.nick + ": ",false);
         }
         if(_arg_1.msg.substr(0,1) == "$")
         {
            _arg_1.isRead = true;
            if(_arg_1.msg.substring(1,IMG_LINK.length + 1) == IMG_LINK)
            {
               this._wordTxt.htmlText += "<font color=\'#ff9900\'><b><u><a href=\'event:" + _arg_1.msg + "\'>赛尔截图</a></u></b></font>\n";
               return;
            }
         }
         TextFormatUtil.appDefaultFormatText(this._wordTxt,_arg_1.msg + "\n",0);
         _arg_1.isRead = true;
      }
      
      private function addExpMe(mc:MovieClip) : void
      {
         this._showMe.visible = false;
         this._expMe = mc;
         if(Boolean(this._expMe))
         {
            this._expMe.x = 355;
            this._expMe.y = 295;
            this._expMe.scaleY = 3;
            this._expMe.scaleX = 3;
            addChild(this._expMe);
            this._outTimeMe = setTimeout(function():void
            {
               _showMe.visible = true;
               DisplayUtil.removeForParent(_expMe);
               _expMe = null;
            },EXP_MAX_TIME);
         }
      }
      
      private function removeExpMe() : void
      {
         clearTimeout(this._outTimeMe);
         if(Boolean(this._expMe))
         {
            this._showMe.visible = true;
            DisplayUtil.removeForParent(this._expMe);
            this._expMe = null;
         }
      }
      
      private function addExpYou(mc:MovieClip) : void
      {
         this._showYou.visible = false;
         this._expYou = mc;
         if(Boolean(this._expYou))
         {
            this._expYou.x = 355;
            this._expYou.y = 125;
            this._expYou.scaleY = 3;
            this._expYou.scaleX = 3;
            addChild(this._expYou);
            this._outTimeYou = setTimeout(function():void
            {
               _showYou.visible = true;
               DisplayUtil.removeForParent(_expYou);
               _expYou = null;
            },EXP_MAX_TIME);
         }
      }
      
      private function removeExpYou() : void
      {
         clearTimeout(this._outTimeYou);
         if(Boolean(this._expYou))
         {
            this._showYou.visible = true;
            DisplayUtil.removeForParent(this._expYou);
            this._expYou = null;
         }
      }
      
      private function onMeShow(_arg_1:MouseEvent) : void
      {
         AllUserInfoController.show(MainManager.actorInfo,LevelManager.appLevel);
      }
      
      private function onYouShow(_arg_1:Event) : void
      {
         UserInfoController.show(this._info.userID);
      }
      
      private function onSendMsg(_arg_1:Event) : void
      {
         MainManager.actorModel.chatAction(this._inputTxt.text,this._userID);
         this._inputTxt.text = "";
      }
      
      override protected function onClose(_arg_1:MouseEvent) : void
      {
         TalkPanelManager.closeTalkPanel(this._userID);
      }
      
      private function onKeyDown(_arg_1:KeyboardEvent) : void
      {
         if(_arg_1.keyCode == Keyboard.ENTER)
         {
            this._isSend = true;
            this._inputTxt.multiline = false;
            this._inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
      }
      
      private function onKeyUp(_arg_1:KeyboardEvent) : void
      {
         if(_arg_1.keyCode == Keyboard.ENTER)
         {
            this._inputTxt.multiline = true;
            this._inputTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            if(!this._isSend)
            {
               return;
            }
            this._isSend = false;
            if(this._inputTxt.text != "")
            {
               this.onSendMsg(null);
            }
         }
      }
      
      private function onData(_arg_1:ChatEvent) : void
      {
         this.wordChange(_arg_1.info);
         this._txtBar.checkScroll();
      }
      
      private function onEmotion(_arg_1:MouseEvent) : void
      {
         if(this._emotionPanel == null)
         {
            this._emotionPanel = new TEmotionPanel(this._info.userID);
         }
         if(DisplayUtil.hasParent(this._emotionPanel))
         {
            this._emotionPanel.hide();
         }
         else
         {
            this._emotionPanel.show(this._emotionBtn);
         }
      }
      
      private function onFight(_arg_1:MouseEvent) : void
      {
         FightInviteManager.fightWithPlayer(this._info);
      }
      
      private function onTextLink(_arg_1:TextEvent) : void
      {
         var _local_2:String = _arg_1.text;
         ImagePanel.show(_local_2.substring(1,_local_2.length));
      }
      
      private function onCutMap(_arg_1:MouseEvent) : void
      {
         CutBmpController.show(this._info.userID);
         EventManager.addEventListener(CutBmpEvent.CUT_BMP_COMPLETE,this.onCutBmpHandler);
      }
      
      private function onCutBmpHandler(_arg_1:CutBmpEvent) : void
      {
         EventManager.removeEventListener(CutBmpEvent.CUT_BMP_COMPLETE,this.onCutBmpHandler);
         MainManager.actorModel.chatAction("$" + _arg_1.imgURL,_arg_1.toID);
      }
   }
}

