package com.robot.app.bag
{
   import com.robot.app.action.*;
   import com.robot.app.team.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.clothInfo.*;
   import com.robot.core.info.team.*;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.skeleton.*;
   import com.robot.core.teamInstallation.*;
   import com.robot.core.ui.itemTip.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.*;
   import org.taomee.effect.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class BagPanel extends Sprite
   {
      
      public static const PREV_PAGE:String = "prevPage";
      
      public static const NEXT_PAGE:String = "nextPage";
      
      public static const SHOW_CLOTH:String = "showCloth";
      
      public static const SHOW_COLLECTION:String = "showCollection";
      
      public static const SHOW_NONO:String = "showNoNo";
      
      public static const SHOW_SOULBEAD:String = "showSoulBead";
      
      public static var suitID:uint = 0;
      
      public static var currTab:uint = BagTabType.CLOTH;
      
      private var UI_PATH:String = "resource/module/bag/bagUI.swf";
      
      private var bagMC:MovieClip;
      
      private var closeBtn:SimpleButton;
      
      private var _dragBtn:SimpleButton;
      
      private var clothBtn:MovieClip;
      
      private var collectionBtn:MovieClip;
      
      private var nonoBtn:MovieClip;
      
      private var _typeBtn:MovieClip;
      
      private var _typeTxt:TextField;
      
      private var _typeJian:MovieClip;
      
      private var soulBeadBtn:MovieClip;
      
      private var _typePanel:BagTypePanel;
      
      public var clothPrev:BagClothPreview;
      
      private var _clickItemID:uint;
      
      private var app:ApplicationDomain;
      
      private var _listCon:Sprite;
      
      public var bChangeClothes:Boolean;
      
      private var _showMc:Sprite;
      
      private var instuctorLogo:MovieClip;
      
      private var logo:Sprite;
      
      private var logoCloth:TeamLogo;
      
      private var clothLight:MovieClip;
      
      private var qqMC:Sprite;
      
      private var changeNick:ChangeNickName;
      
      private var maskMc:Sprite;
      
      private var _arrowMc:MovieClip;
      
      public function BagPanel()
      {
         super();
         this.logo = new Sprite();
         this.logo.x = 27;
         this.logo.y = 95;
         this.logo.filters = [new GlowFilter(3355443,1,3,3,2)];
         this.logo.buttonMode = true;
         ToolTipManager.add(this.logo,"进入战队要塞");
      }
      
      public function show() : void
      {
         var _local_1:MCLoader = null;
         this.bChangeClothes = true;
         LevelManager.appLevel.addChild(this);
         if(!this.bagMC)
         {
            _local_1 = new MCLoader(this.UI_PATH,LevelManager.appLevel,1,"正在打开储存箱");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,this.onLoadBagUI);
            _local_1.doLoad();
         }
         else
         {
            this.bagMC["nonoMc"].visible = false;
            this.init();
         }
      }
      
      public function hide() : void
      {
         DisplayUtil.removeAllChild(this.qqMC);
         currTab = BagTabType.CLOTH;
         this.changeNick.destory();
         this.changeNick = null;
         var _local_1:String = MainManager.actorClothStr;
         var _local_2:Array = this.clothPrev.getClothArray();
         var _local_3:String = this.clothPrev.getClothStr();
         if(_local_3 != _local_1 && !ActorActionManager.isTransforming)
         {
            MainManager.actorModel.changeCloth(_local_2);
            MainManager.actorInfo.clothes = _local_2;
            EventManager.dispatchEvent(new Event(PeopleActionEvent.CLOTH_CHANGE));
         }
         if(Boolean(this._typePanel))
         {
            if(DisplayUtil.hasParent(this._typePanel))
            {
               this.onTypePanelHide();
            }
         }
         DisplayUtil.removeForParent(this,false);
         SocketConnection.removeCmdListener(CommandID.GOLD_ONLINE_CHECK_REMAIN,this.onGetGold);
      }
      
      public function showItem(_arg_1:Array) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_3:BagListItem = null;
         var _local_4:Boolean = false;
         var _local_6:int = 0;
         this.clearItemPanel();
         for(var _local_5:int = int(_arg_1.length); _local_6 < _local_5; _local_6++)
         {
            _local_2 = _arg_1[_local_6];
            _local_3 = this._listCon.getChildAt(_local_6) as BagListItem;
            if(BagShowType.currType == BagShowType.SUIT)
            {
               if(!ItemManager.containsCloth(_local_2.itemID))
               {
                  _local_3.setInfo(_local_2);
                  continue;
               }
            }
            _local_4 = false;
            if(BagShowType.currType == BagShowType.SUIT)
            {
               _local_4 = Boolean(ArrayUtil.arrayContainsValue(this.clothPrev.getClothArray(),_local_2.itemID));
            }
            _local_3.setInfo(_local_2,_local_4);
            if(!_local_4)
            {
               if(_local_2.leftTime != 0)
               {
                  if(_local_2.type == ItemType.CLOTH)
                  {
                     _local_3.buttonMode = true;
                     _local_3.addEventListener(MouseEvent.CLICK,this.onChangeCloth);
                  }
               }
            }
            _local_3.addEventListener(MouseEvent.ROLL_OVER,this.onShowItemInfo);
            _local_3.addEventListener(MouseEvent.ROLL_OUT,this.onHideItemInfo);
         }
      }
      
      private function vipTabGrayscale() : Boolean
      {
         if(!MainManager.actorInfo.vip)
         {
            if(Boolean(this.nonoBtn))
            {
               this.nonoBtn.mouseEnabled = false;
               this.nonoBtn.filters = [ColorFilter.setGrayscale()];
               return true;
            }
         }
         return false;
      }
      
      private function init() : void
      {
         var _local_1:uint = 0;
         this.bagMC.addChild(this.logo);
         DisplayUtil.removeAllChild(this.logo);
         if(TasksManager.getTaskStatus(201) == TasksManager.COMPLETE)
         {
            this.bagMC.addChild(this.instuctorLogo);
            (this.instuctorLogo as MovieClip).gotoAndStop(1);
            if(MainManager.actorInfo.graduationCount >= 5)
            {
               _local_1 = uint(uint(uint(MainManager.actorInfo.graduationCount / 5) + 1));
               if(_local_1 >= 5)
               {
                  (this.instuctorLogo as MovieClip).gotoAndStop(6);
               }
               else
               {
                  (this.instuctorLogo as MovieClip).gotoAndStop(_local_1);
               }
            }
         }
         if(MainManager.actorInfo.teamInfo.id != 0)
         {
            this.getTeamLogo();
         }
         if(Boolean(MainManager.actorInfo.vip))
         {
            this.bagMC["nonoMc"].visible = true;
            ToolTipManager.add(this.bagMC["nonoMc"],MainManager.actorInfo.vipLevel + "级超能NoNo");
            this.bagMC["nonoMc"]["vipStageMC"].gotoAndStop(MainManager.actorInfo.vipLevel);
         }
         this.goToCloth();
         this.clothPrev.changeColor(MainManager.actorInfo.color);
         this.clothPrev.showCloths(MainManager.actorInfo.clothes);
         this.clothPrev.showDoodle(MainManager.actorInfo.texture);
         this.clothBtn.addEventListener(MouseEvent.CLICK,this.showColth);
         this.clothBtn.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.clothBtn.addEventListener(MouseEvent.ROLL_OUT,this.onUp);
         this.collectionBtn.addEventListener(MouseEvent.CLICK,this.showPetThings);
         this.collectionBtn.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.collectionBtn.addEventListener(MouseEvent.ROLL_OUT,this.onUp);
         this.nonoBtn.addEventListener(MouseEvent.CLICK,this.onShowNoNo);
         this.nonoBtn.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.nonoBtn.addEventListener(MouseEvent.ROLL_OUT,this.onUp);
         this.soulBeadBtn.addEventListener(MouseEvent.CLICK,this.onShowSoulBead);
         this.soulBeadBtn.addEventListener(MouseEvent.ROLL_OVER,this.onSBOver);
         this.soulBeadBtn.addEventListener(MouseEvent.ROLL_OUT,this.onSBUp);
         dispatchEvent(new Event(Event.COMPLETE));
         this.changeNick = new ChangeNickName();
         this.changeNick.init(this.bagMC);
         this.bagMC["miId_txt"].text = "(" + MainManager.actorInfo.userID + ")";
         ToolTipManager.add(this.bagMC["goldMC"],"骄阳金豆");
         ToolTipManager.add(this.bagMC["coinMC"],"骄阳豆");
         if(Boolean(this.logoCloth) && Boolean(MainManager.actorInfo.teamInfo.isShow))
         {
            addChild(this.logoCloth);
         }
         this.vipTabGrayscale();
         this.getGoldNum();
         this.showClothLight();
         EventManager.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function showClothLight() : void
      {
         DisplayUtil.removeForParent(this.clothLight);
         var _local_1:uint = uint(MainManager.actorInfo.clothMaxLevel);
         if(_local_1 > 1)
         {
            ResourceManager.getResource(ClientConfig.getClothLightUrl(_local_1),this.onLoadLight);
            ResourceManager.getResource(ClientConfig.getClothCircleUrl(_local_1),this.onLoadQQ);
         }
      }
      
      private function onLoadLight(_arg_1:DisplayObject) : void
      {
         this.clothLight = _arg_1 as MovieClip;
         this.clothLight.scaleY = 3;
         this.clothLight.scaleX = 3;
         var _local_2:Rectangle = this._showMc.getRect(this._showMc);
         this.clothLight.x = _local_2.width / 2 + _local_2.x;
         this.clothLight.y = _local_2.height + _local_2.y;
         this._showMc.addChild(this.clothLight);
      }
      
      private function onLoadQQ(_arg_1:DisplayObject) : void
      {
         DisplayUtil.removeAllChild(this.qqMC);
         this.qqMC.addChild(_arg_1);
      }
      
      private function getGoldNum() : void
      {
         SocketConnection.addCmdListener(CommandID.GOLD_ONLINE_CHECK_REMAIN,this.onGetGold);
         SocketConnection.send(CommandID.GOLD_ONLINE_CHECK_REMAIN);
      }
      
      private function onGetGold(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GOLD_ONLINE_CHECK_REMAIN,this.onGetGold);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:Number = _local_2.readUnsignedInt() / 100;
         this.bagMC["gold_txt"].text = _local_3.toString();
         var coins:Number = _local_2.readUnsignedInt();
         MainManager.actorInfo.coins = coins;
         this.bagMC["money_txt"].text = MainManager.actorInfo.coins;
      }
      
      private function onOver(_arg_1:MouseEvent) : void
      {
         (_arg_1.target as MovieClip).gotoAndStop(2);
      }
      
      private function onUp(_arg_1:MouseEvent) : void
      {
         if((_arg_1.target as MovieClip).currentFrame != 1)
         {
            (_arg_1.target as MovieClip).gotoAndStop(3);
         }
      }
      
      private function onSBOver(_arg_1:MouseEvent) : void
      {
         (_arg_1.target as MovieClip).gotoAndStop(2);
      }
      
      private function onSBUp(_arg_1:MouseEvent) : void
      {
         if((_arg_1.target as MovieClip).currentFrame != 1)
         {
            (_arg_1.target as MovieClip).gotoAndStop(3);
         }
      }
      
      private function showColth(_arg_1:MouseEvent) : void
      {
         this.goToCloth();
         dispatchEvent(new Event(SHOW_CLOTH));
      }
      
      public function goToCloth() : void
      {
         currTab = BagTabType.CLOTH;
         BagShowType.currType = BagShowType.ALL;
         this._typeJian.scaleY = 1;
         this._typeTxt.text = BagShowType.typeNameList[BagShowType.currType];
         this._typeBtn.visible = true;
         this._typeTxt.visible = true;
         this._typeJian.visible = true;
         this.clothBtn.gotoAndStop(1);
         this.clothBtn.mouseEnabled = false;
         this.clothBtn.mouseChildren = false;
         DepthManager.bringToTop(this.clothBtn);
         this.collectionBtn.mouseEnabled = true;
         this.collectionBtn.mouseChildren = true;
         this.collectionBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.collectionBtn);
         this.nonoBtn.mouseEnabled = true;
         this.nonoBtn.mouseChildren = true;
         this.nonoBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.nonoBtn);
         this.soulBeadBtn.mouseEnabled = true;
         this.soulBeadBtn.mouseChildren = true;
         this.soulBeadBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.soulBeadBtn);
      }
      
      private function showPetThings(_arg_1:MouseEvent) : void
      {
         currTab = BagTabType.COLLECTION;
         BagShowType.currType = BagShowType.ALL;
         BagShowType.currSuitID = 0;
         this._typeBtn.visible = false;
         this._typeTxt.visible = false;
         this._typeJian.visible = false;
         this.onTypePanelHide();
         this.collectionBtn.gotoAndStop(1);
         this.collectionBtn.mouseEnabled = false;
         this.collectionBtn.mouseChildren = false;
         DepthManager.bringToTop(this.collectionBtn);
         this.clothBtn.mouseEnabled = true;
         this.clothBtn.mouseChildren = true;
         this.clothBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.clothBtn);
         this.nonoBtn.mouseEnabled = true;
         this.nonoBtn.mouseChildren = true;
         this.nonoBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.nonoBtn);
         this.soulBeadBtn.mouseEnabled = true;
         this.soulBeadBtn.mouseChildren = true;
         this.soulBeadBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.soulBeadBtn);
         dispatchEvent(new Event(SHOW_COLLECTION));
      }
      
      private function onShowNoNo(_arg_1:MouseEvent) : void
      {
         if(this.vipTabGrayscale())
         {
            return;
         }
         currTab = BagTabType.NONO;
         BagShowType.currType = BagShowType.ALL;
         this._typeJian.scaleY = 1;
         this._typeTxt.text = BagShowType.typeNameList[BagShowType.currType];
         this._typeBtn.visible = true;
         this._typeTxt.visible = true;
         this._typeJian.visible = true;
         this.nonoBtn.mouseEnabled = false;
         this.nonoBtn.mouseChildren = false;
         this.nonoBtn.gotoAndStop(1);
         DepthManager.bringToTop(this.nonoBtn);
         this.collectionBtn.gotoAndStop(3);
         this.collectionBtn.mouseEnabled = true;
         this.collectionBtn.mouseChildren = true;
         DepthManager.bringToBottom(this.collectionBtn);
         this.clothBtn.mouseEnabled = true;
         this.clothBtn.mouseChildren = true;
         this.clothBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.clothBtn);
         this.soulBeadBtn.mouseEnabled = true;
         this.soulBeadBtn.mouseChildren = true;
         this.soulBeadBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.soulBeadBtn);
         dispatchEvent(new Event(SHOW_NONO));
      }
      
      private function onShowSoulBead(_arg_1:MouseEvent) : void
      {
         currTab = BagTabType.SOULBEAD;
         BagShowType.currType = BagShowType.ALL;
         this._typeJian.scaleY = 1;
         this._typeTxt.text = BagShowType.typeNameList[BagShowType.currType];
         this._typeBtn.visible = false;
         this._typeTxt.visible = false;
         this._typeJian.visible = false;
         this.soulBeadBtn.mouseEnabled = false;
         this.soulBeadBtn.mouseChildren = false;
         this.soulBeadBtn.gotoAndStop(1);
         DepthManager.bringToTop(this.soulBeadBtn);
         this.nonoBtn.mouseEnabled = true;
         this.nonoBtn.mouseChildren = true;
         this.nonoBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.nonoBtn);
         this.collectionBtn.gotoAndStop(3);
         this.collectionBtn.mouseEnabled = true;
         this.collectionBtn.mouseChildren = true;
         DepthManager.bringToBottom(this.collectionBtn);
         this.clothBtn.mouseEnabled = true;
         this.clothBtn.mouseChildren = true;
         this.clothBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.clothBtn);
         dispatchEvent(new Event(SHOW_SOULBEAD));
      }
      
      private function onTypeClick(_arg_1:MouseEvent) : void
      {
         if(this._typePanel == null)
         {
            this._typePanel = new BagTypePanel(this.app);
            this._typePanel.addEventListener(BagTypeEvent.SELECT,this.onTypeSelect);
            this._typePanel.x = 350;
         }
         if(DisplayUtil.hasParent(this._typePanel))
         {
            this.onTypePanelHide();
         }
         else
         {
            addChild(this._typePanel);
            this._typePanel.setSelect(BagShowType.currType);
            this._typeJian.scaleY = -1;
         }
      }
      
      private function onTypeSelect(_arg_1:BagTypeEvent) : void
      {
         this.onTypePanelHide();
         BagShowType.currType = _arg_1.showType;
         BagShowType.currSuitID = _arg_1.suitID;
         this._typePanel.setSelect(BagShowType.currType);
         this._typeTxt.text = BagShowType.typeNameList[BagShowType.currType];
         dispatchEvent(new BagTypeEvent(BagTypeEvent.SELECT,_arg_1.showType,_arg_1.suitID));
      }
      
      private function onTypePanelHide() : void
      {
         if(Boolean(this._typePanel))
         {
            DisplayUtil.removeForParent(this._typePanel,false);
            this._typeJian.scaleY = 1;
         }
      }
      
      private function prevHandler(_arg_1:MouseEvent) : void
      {
         dispatchEvent(new Event(PREV_PAGE));
      }
      
      private function nextHandler(_arg_1:MouseEvent) : void
      {
         dispatchEvent(new Event(NEXT_PAGE));
      }
      
      private function onLoadBagUI(_arg_1:MCLoadEvent) : void
      {
         this.app = _arg_1.getApplicationDomain();
         this.bagMC = new (this.app.getDefinition("BagPanel") as Class)() as MovieClip;
         this.bagMC["nonoMc"].visible = false;
         addChild(this.bagMC);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         this.instuctorLogo = UIManager.getMovieClip("Teacher_Icon");
         this.instuctorLogo.x = 37;
         this.instuctorLogo.y = 275;
         this._listCon = new Sprite();
         this._listCon.y = 20;
         this._listCon.x = 300;
         this.bagMC.addChild(this._listCon);
         this.closeBtn = this.bagMC["closeBtn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this.createItemPanel();
         this._dragBtn = this.bagMC["dragBtn"];
         this._dragBtn.useHandCursor = false;
         this._dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         this.clothBtn = this.bagMC["clothBtn"];
         this.collectionBtn = this.bagMC["collectionBtn"];
         this.nonoBtn = this.bagMC["nonoBtn"];
         ToolTipManager.add(this.clothBtn,"装备部件");
         ToolTipManager.add(this.collectionBtn,"收藏物品");
         ToolTipManager.add(this.nonoBtn,"超能NoNo");
         this.soulBeadBtn = this.bagMC["soulBeadBtn"];
         ToolTipManager.add(this.soulBeadBtn,"精灵元神珠");
         var _local_2:SimpleButton = this.bagMC["prev_btn"];
         var _local_3:SimpleButton = this.bagMC["next_btn"];
         _local_2.addEventListener(MouseEvent.CLICK,this.prevHandler);
         _local_3.addEventListener(MouseEvent.CLICK,this.nextHandler);
         this._typeBtn = this.bagMC["typeBtn"];
         this._typeTxt = this.bagMC["typeTxt"];
         this._typeJian = this.bagMC["typeJian"];
         this._typeTxt.mouseEnabled = false;
         this._typeJian.mouseEnabled = false;
         this._typeBtn.addEventListener(MouseEvent.CLICK,this.onTypeClick);
         this._showMc = UIManager.getSprite("ComposeMC");
         this._showMc.scaleY = 0.9;
         this._showMc.scaleX = 0.9;
         this._showMc.x = 78;
         this._showMc.y = 122;
         this.bagMC.addChild(this._showMc);
         this.clothPrev = new BagClothPreview(this._showMc,null,ClothPreview.MODEL_SHOW);
         this.qqMC = new Sprite();
         this.qqMC.scaleX = 3.2;
         this.qqMC.scaleY = 1.6;
         var _local_4:Rectangle = this._showMc.getRect(this._showMc);
         this.qqMC.x = _local_4.width / 2 + _local_4.x;
         this.qqMC.y = _local_4.height + _local_4.y;
         this._showMc.addChildAt(this.qqMC,0);
         this.init();
      }
      
      private function createItemPanel() : void
      {
         var _local_1:BagListItem = null;
         var _local_2:int = 0;
         while(_local_2 < 12)
         {
            _local_1 = new BagListItem(new (this.app.getDefinition("itemPanel") as Class)() as Sprite);
            _local_1.x = (_local_1.width + 10) * int(_local_2 % 3);
            _local_1.y = (_local_1.height + 10) * int(_local_2 / 3);
            this._listCon.addChild(_local_1);
            _local_2++;
         }
      }
      
      private function clearItemPanel() : void
      {
         var _local_1:BagListItem = null;
         var _local_3:int = 0;
         var _local_2:int = this._listCon.numChildren;
         while(_local_3 < _local_2)
         {
            _local_1 = this._listCon.getChildAt(_local_3) as BagListItem;
            _local_1.clear();
            _local_1.removeEventListener(MouseEvent.CLICK,this.onChangeCloth);
            _local_1.removeEventListener(MouseEvent.ROLL_OVER,this.onShowItemInfo);
            _local_1.removeEventListener(MouseEvent.ROLL_OUT,this.onHideItemInfo);
            _local_1.buttonMode = false;
            _local_3++;
         }
      }
      
      private function onShowItemInfo(_arg_1:MouseEvent) : void
      {
         var _local_2:BagListItem = _arg_1.currentTarget as BagListItem;
         if(_local_2.info == null)
         {
            return;
         }
         this._clickItemID = _local_2.info.itemID;
         ItemInfoTip.show(_local_2.info);
      }
      
      private function onHideItemInfo(_arg_1:MouseEvent) : void
      {
         ItemInfoTip.hide();
      }
      
      private function onChangeCloth(event:MouseEvent) : void
      {
         var arr:Array = null;
         var array:Array = null;
         var i:uint = 0;
         var item:BagListItem = event.currentTarget as BagListItem;
         if(item.info == null)
         {
            return;
         }
         ItemInfoTip.hide();
         this._clickItemID = item.info.itemID;
         if(BagShowType.currType == BagShowType.SUIT)
         {
            arr = SuitXMLInfo.getCloths(BagShowType.currSuitID).filter(function(_arg_1:uint, _arg_2:int, _arg_3:Array):Boolean
            {
               if(ItemManager.containsCloth(_arg_1))
               {
                  if(ItemManager.getClothInfo(_arg_1).leftTime == 0)
                  {
                     return false;
                  }
                  return true;
               }
               return false;
            });
            array = [];
            for each(i in arr)
            {
               array.push(new PeopleItemInfo(i));
            }
            this.clothPrev.showCloths(array);
         }
         else
         {
            this.clothPrev.showCloth(this._clickItemID,item.info.itemLevel);
         }
      }
      
      private function onClose(_arg_1:MouseEvent) : void
      {
         this.hide();
         this.openEvent();
         dispatchEvent(new Event(Event.CLOSE));
         EventManager.dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function get clickItemID() : uint
      {
         return this._clickItemID;
      }
      
      public function setPageNum(_arg_1:uint, _arg_2:uint) : void
      {
         this.bagMC["page_txt"].text = _arg_1 + "/" + _arg_2;
      }
      
      private function onDragDown(_arg_1:MouseEvent) : void
      {
         if(Boolean(parent))
         {
            parent.addChild(this);
         }
         startDrag();
      }
      
      private function onDragUp(_arg_1:MouseEvent) : void
      {
         stopDrag();
      }
      
      private function getTeamLogo() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_GET_INFO,this.onGetInfo);
         SocketConnection.send(CommandID.TEAM_GET_INFO,MainManager.actorInfo.teamInfo.id);
      }
      
      private function onGetInfo(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_GET_INFO,this.onGetInfo);
         var _local_2:SimpleTeamInfo = _arg_1.data as SimpleTeamInfo;
         var _local_3:TeamLogo = new TeamLogo();
         _local_3.info = _local_2;
         _local_3.scaleY = 0.8;
         _local_3.scaleX = 0.8;
         this.logo.addChild(_local_3);
         _local_3.addEventListener(MouseEvent.CLICK,this.showTeamInfo);
         if(Boolean(this.logoCloth))
         {
            DisplayUtil.removeForParent(this.logoCloth);
            this.logoCloth.removeEventListener(MouseEvent.CLICK,this.removeLogo);
         }
         this.logoCloth = _local_3.clone();
         this.logoCloth.addEventListener(MouseEvent.CLICK,this.removeLogo);
         this.checkLogoCloth();
      }
      
      private function removeLogo(_arg_1:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_SHOW_LOGO,this.onTeamShowLogo);
         SocketConnection.send(CommandID.TEAM_SHOW_LOGO,0);
      }
      
      private function onTeamShowLogo(_arg_1:SocketEvent) : void
      {
         DisplayUtil.removeForParent(this.logoCloth);
      }
      
      private function showTeamInfo(_arg_1:MouseEvent) : void
      {
         var _local_2:TeamLogo = _arg_1.currentTarget as TeamLogo;
         TeamController.show(_local_2.teamID);
      }
      
      private function checkLogoCloth() : void
      {
         if(MainManager.actorInfo.teamInfo.isShow)
         {
            if(Boolean(this.logoCloth))
            {
               this.logoCloth.x = (270 - this.logoCloth.width) / 2;
               this.logoCloth.y = 80;
               addChild(this.logoCloth);
            }
         }
         else
         {
            DisplayUtil.removeForParent(this.logoCloth);
         }
      }
      
      public function closeEvent() : void
      {
         if(Boolean(this._typeBtn))
         {
            this._typeBtn.mouseChildren = false;
            this._typeBtn.mouseEnabled = false;
         }
         this.maskMc = new Sprite();
         this.maskMc.graphics.beginFill(0,1);
         this.maskMc.graphics.lineStyle(1,0);
         this.maskMc.graphics.drawRect(0,0,580,380);
         this.maskMc.graphics.endFill();
         this.maskMc.alpha = 0;
         this.bagMC.addChildAt(this.maskMc,this.bagMC.getChildIndex(this._showMc) + 1);
         this.bagMC.addChild(this.closeBtn);
         this._arrowMc = TaskIconManager.getIcon("Arrows_MC") as MovieClip;
         this.addChild(this._arrowMc);
         this._arrowMc.x = 220;
         this._arrowMc.y = 43;
         MovieClip(this._arrowMc["mc"]).rotation = -180;
         MovieClip(this._arrowMc["mc"]).play();
      }
      
      public function openEvent() : void
      {
         if(Boolean(this._typeBtn))
         {
            this._typeBtn.mouseChildren = true;
            this._typeBtn.mouseEnabled = true;
         }
         if(Boolean(this.maskMc))
         {
            this.maskMc.graphics.clear();
            DisplayUtil.removeForParent(this.maskMc);
            this.maskMc = null;
         }
         if(Boolean(this._arrowMc))
         {
            DisplayUtil.removeForParent(this._arrowMc);
            this._arrowMc = null;
         }
      }
   }
}

