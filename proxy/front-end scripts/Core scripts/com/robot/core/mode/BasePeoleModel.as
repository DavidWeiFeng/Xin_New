package com.robot.core.mode
{
   import com.robot.core.*;
   import com.robot.core.aticon.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.info.item.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.info.team.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.additiveInfo.*;
   import com.robot.core.mode.spriteInteractive.*;
   import com.robot.core.net.*;
   import com.robot.core.skeleton.*;
   import com.robot.core.teamInstallation.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import org.taomee.debug.DebugTrace;
   import org.taomee.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   [Event(name="changeDirection",type="com.robot.core.event.RobotEvent")]
   [Event(name="walkStart",type="com.robot.core.event.RobotEvent")]
   [Event(name="walkEnd",type="com.robot.core.event.RobotEvent")]
   [Event(name="walkEnterFrame",type="com.robot.core.event.RobotEvent")]
   public class BasePeoleModel extends BobyModel implements ISkeletonSprite
   {
      
      public static var SPECIAL_ACTION:String = "action";
      
      public static const defaultY:int = 14;
      
      public static const defaultTopIconY:int = -70;
      
      public static const titlIconX:int = -42;
      
      private var iconId:int;
      
      private var _url:String;
      
      private var _bodyWidth:Number;
      
      protected var _annualFeeSprite:Sprite;
      
      private var isWrap:Boolean;
      
      private var _icon:Sprite;
      
      private var titleCon:Sprite;
      
      private var _selfTf:TextFormat;
      
      private var titleTxt:TextField;
      
      protected var _nameContainer:DisplayObjectContainer;
      
      public var isShield:Boolean = false;
      
      protected var _info:UserInfo;
      
      protected var tf:TextFormat;
      
      protected var _nameTxt:TextField;
      
      protected var _isProtected:Boolean = false;
      
      protected var _protectMC:MovieClip;
      
      protected var _skeletonSys:ISkeleton;
      
      protected var _oldSkeleton:ISkeleton;
      
      protected var _teamLogo:TeamLogo;
      
      protected var _interactiveAction:ISpriteInteractiveAction;
      
      private var _nono:INonoModel;
      
      private var _pet:PetModel;
      
      private var _tranMC:MovieClip;
      
      protected var clickBtn:Sprite;
      
      private var shieldMC:MovieClip;
      
      private var shieldTimer:Timer;
      
      private var _additiveInfo:ISpriteAdditiveInfo;
      
      private var clothLight:MovieClip;
      
      protected var _yearVipforverId:int = 125078;
      
      public function BasePeoleModel(_arg_1:UserInfo)
      {
         var _local_2:PetShowInfo = null;
         var _loc3_:MovieClip = null;
         super();
         this._info = _arg_1;
         _loc3_ = UIManager.getMovieClip("show_mc");
         _loc3_.name = "show_mc";
         _loc3_.cacheAsBitmap = true;
         mouseEnabled = false;
         name = "BasePeoleModel_" + this._info.userID.toString();
         this.tf = new TextFormat();
         this.tf.font = "simsun";
         this.tf.letterSpacing = 0.5;
         this.tf.size = 12;
         this.tf.align = TextFormatAlign.CENTER;
         this._nameTxt = new TextField();
         this._nameTxt.mouseEnabled = false;
         this._nameTxt.autoSize = TextFieldAutoSize.CENTER;
         this._nameTxt.width = 100;
         this._nameTxt.height = 30;
         this._nameTxt.x = this._nameTxt.width / 2 - 4;
         this._nameTxt.y = 34;
         this._nameTxt.text = this._info.nick;
         this._nameTxt.setTextFormat(this.tf);
         this._nameTxt.cacheAsBitmap = true;
         addChild(_loc3_);
         addChild(this._nameTxt);
         this.skeleton = new EmptySkeletonStrategy();
         this._nameContainer = new Sprite();
         this._nameContainer.name = "nameContainer";
         this._nameContainer.y = defaultY;
         this._nameContainer.cacheAsBitmap = true;
         this._nameContainer.mouseChildren = this._nameContainer.mouseEnabled = false;
         addChild(this._nameContainer);
         if(_arg_1.changeShape != 0)
         {
            this.skeleton = new TransformSkeleton();
         }
         pos = this._info.pos;
         this.direction = Direction.indexToStr(this._info.direction);
         if(this._info.action > 10000)
         {
            this.peculiarAction(direction,false);
         }
         this.refreshTitle(this._info.curTitle);
         if(this._info.spiritID != 0)
         {
            _local_2 = new PetShowInfo();
            _local_2.catchTime = this._info.spiritTime;
            _local_2.petID = this._info.spiritID;
            _local_2.userID = this._info.userID;
            _local_2.dv = this._info.petDV;
            _local_2.shiny = this._info.petShiny;
            _local_2.skinID = this._info.petSkin;
            this.showPet(_local_2);
         }
         this.clickBtn = new Sprite();
         this.clickBtn.graphics.beginFill(0,0);
         this.clickBtn.graphics.drawRect(0,0,40,50);
         this.clickBtn.graphics.endFill();
         this.clickBtn.buttonMode = true;
         this.clickBtn.x = -20;
         this.clickBtn.y = -50;
         addChild(this.clickBtn);
         this._additiveInfo = new TeamPkPlayerSideInfo(this);
         this.interactiveAction = new ClothLightInteractive(this);
         this.addEvent();
      }
      
      public function set topIconY(param1:int) : void
      {
      }
      
      private function initAnnualFeeName() : void
      {
         this._annualFeeSprite = UIManager.getSprite("AnnualVipName");
         this.annualChangeName(this.info.nick);
         this._nameContainer.cacheAsBitmap = true;
      }
      
      private function annualChangeName(param1:String) : void
      {
         var _loc2_:TextField = this._annualFeeSprite["txt"]["txt"];
         _loc2_.text = param1;
         _loc2_.width = _loc2_.textWidth + 4;
         _loc2_.x = _loc2_.width / 2 * -1;
         if(this._annualFeeSprite["txt"].width > 40)
         {
            this._bodyWidth = this._annualFeeSprite["txt"].width + 10;
         }
         else
         {
            this._bodyWidth = 40;
         }
         this._annualFeeSprite["mc"].width = this._bodyWidth;
         this._annualFeeSprite["leftMc"].x = this._bodyWidth / 2 * -1 + 1;
         this._annualFeeSprite["rightMc"].x = this._bodyWidth / 2 - 1;
         this._annualFeeSprite["mc"].x = 0;
         this._annualFeeSprite.x = 0;
      }
      
      public function get nameContainer() : DisplayObjectContainer
      {
         return this._nameContainer;
      }
      
      public function setNick(param1:String) : void
      {
         this._info.nick = param1;
         this._nameTxt.text = param1;
         this._nameTxt.setTextFormat(this.tf);
         this.annualChangeName(param1);
      }
      
      public function switchNameDO() : void
      {
         var cls:* = undefined;
         cls = undefined;
         if(Boolean(this._nameContainer))
         {
            DisplayUtil.removeAllChild(this._nameContainer);
            cls = getDefinitionByName("com.robot.app.task.petstory.util.KTool");
            cls.getOnlineUsersForeverOrDailyVal([this._info.userID,this._yearVipforverId],function(param1:uint):void
            {
               var _loc2_:MovieClip = null;
               if(cls.getBit(param1,9) > 0)
               {
                  DisplayUtil.removeForParent(_nameTxt);
                  _nameContainer.addChild(_annualFeeSprite);
                  _nameContainer.x = 0;
               }
               else
               {
                  _nameContainer.addChild(_nameTxt);
                  _nameContainer.x = 5;
               }
            });
         }
      }
      
      public function showClothLight(_arg_1:Boolean = false) : void
      {
         if(_arg_1)
         {
            DisplayUtil.removeForParent(this.clothLight);
            return;
         }
         DisplayUtil.removeForParent(this.clothLight);
         var _local_2:uint = this.info.clothMaxLevel;
         if(_local_2 > 1)
         {
            ResourceManager.getResource(ClientConfig.getClothLightUrl(_local_2),this.onLoadLight);
         }
      }
      
      private function onLoadLight(_arg_1:DisplayObject) : void
      {
         this.clothLight = _arg_1 as MovieClip;
         this.addChild(this.clothLight);
      }
      
      public function addProtectMC() : void
      {
         if(!this._protectMC)
         {
            this._protectMC = this.getProtectMC();
         }
         if(!DisplayUtil.hasParent(this._protectMC))
         {
            this._protectMC.gotoAndStop(1);
            addChild(this._protectMC);
         }
         this._isProtected = true;
      }
      
      public function aimatAction(_arg_1:uint, _arg_2:uint, _arg_3:Point, _arg_4:Boolean = true) : void
      {
         if(_arg_4)
         {
            SocketConnection.send(CommandID.AIMAT,_arg_1,_arg_2,_arg_3.x,_arg_3.y);
         }
         else
         {
            this.stop();
            AimatAction.execute(_arg_1,_arg_2,this._info.userID,this,_arg_3);
         }
      }
      
      override public function aimatState(_arg_1:AimatInfo) : void
      {
         if(this._isProtected)
         {
            this._protectMC.gotoAndPlay(2);
            return;
         }
         super.aimatState(_arg_1);
      }
      
      override public function get centerPoint() : Point
      {
         _centerPoint.x = x;
         _centerPoint.y = y - 20;
         return _centerPoint;
      }
      
      public function set interactiveAction(_arg_1:ISpriteInteractiveAction) : void
      {
         if(Boolean(this._interactiveAction))
         {
            this._interactiveAction.destroy();
         }
         if(_arg_1 == null)
         {
            this._interactiveAction = new ClothLightInteractive(this);
         }
         else
         {
            this._interactiveAction = _arg_1;
         }
      }
      
      public function changeCloth(_arg_1:Array, _arg_2:Boolean = true) : void
      {
         new FigureAction().changeCloth(this,_arg_1,_arg_2);
      }
      
      public function changeColor(_arg_1:uint, _arg_2:Boolean = true) : void
      {
         new FigureAction().changeColor(this,_arg_1,_arg_2);
      }
      
      public function changeDoodle(_arg_1:DoodleInfo, _arg_2:Boolean = true) : void
      {
         new FigureAction().changeDoodle(this,_arg_1,_arg_2);
      }
      
      public function changeNickName(_arg_1:String, _arg_2:Boolean = true) : void
      {
         new FigureAction().changeNickName(this,_arg_1,_arg_2);
         if(!_arg_2)
         {
            this._nameTxt.text = _arg_1;
            this._nameTxt.setTextFormat(this.tf);
         }
      }
      
      public function chatAction(_arg_1:String, _arg_2:uint = 0, _arg_3:Boolean = true) : void
      {
         new ChatAction().execute(this,_arg_1,_arg_2,_arg_3);
      }
      
      public function delProtectMC() : void
      {
         DisplayUtil.removeForParent(this._protectMC,false);
         this._isProtected = false;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeEvent();
         this.hidePet();
         this.hideNono();
         this._pet = null;
         DisplayUtil.removeForParent(this);
         this._info = null;
         this._skeletonSys = null;
         DisplayUtil.removeForParent(this._protectMC);
         this._protectMC = null;
         if(Boolean(this._teamLogo))
         {
            this._teamLogo.destroy();
         }
         this._teamLogo = null;
         if(Boolean(this._interactiveAction))
         {
            this._interactiveAction.destroy();
            this._interactiveAction = null;
         }
         DisplayUtil.removeForParent(this.clothLight);
         this.clothLight = null;
      }
      
      override public function set direction(_arg_1:String) : void
      {
         if(_arg_1 == null || _arg_1 == "")
         {
            return;
         }
         _direction = _arg_1;
         this._skeletonSys.changeDirection(_arg_1);
         dispatchEvent(new DynamicEvent(RobotEvent.CHANGE_DIRECTION,_arg_1));
      }
      
      public function get skeleton() : ISkeleton
      {
         return this._skeletonSys;
      }
      
      override public function get height() : Number
      {
         return this._skeletonSys.getBodyMC().height;
      }
      
      public function hideNono() : void
      {
         if(Boolean(this._nono))
         {
            this._nono.destroy();
            this._nono = null;
         }
      }
      
      public function hidePet() : void
      {
         if(Boolean(this._pet))
         {
            this._pet.destroy();
            this._pet = null;
         }
      }
      
      override public function get hitRect() : Rectangle
      {
         _hitRect.x = x + this.clickBtn.x;
         _hitRect.y = y + this.clickBtn.y;
         _hitRect.width = 35;
         _hitRect.height = 40;
         return _hitRect;
      }
      
      public function get nameTxt() : TextField
      {
         return this._nameTxt;
      }
      
      public function setClickSpriteToTop() : void
      {
         this.setChildIndex(this.clickBtn,this.numChildren - 1);
      }
      
      public function get info() : UserInfo
      {
         return this._info;
      }
      
      public function get additiveInfo() : ISpriteAdditiveInfo
      {
         return this._additiveInfo;
      }
      
      public function get isTransform() : Boolean
      {
         return this._skeletonSys is TransformSkeleton;
      }
      
      public function get isProtected() : Boolean
      {
         return this._isProtected;
      }
      
      public function get nono() : INonoModel
      {
         return this._nono;
      }
      
      public function peculiarAction(_arg_1:String = "", _arg_2:Boolean = true) : void
      {
         new PeculiarAction().execute(this,_arg_1,_arg_2);
      }
      
      public function get pet() : PetModel
      {
         return this._pet;
      }
      
      public function removeTeamLogo() : void
      {
         DisplayUtil.removeForParent(this._teamLogo,false);
      }
      
      public function set skeleton(_arg_1:ISkeleton) : void
      {
         if(Boolean(this._skeletonSys))
         {
            this._oldSkeleton = this._skeletonSys;
         }
         this._skeletonSys = _arg_1;
         this._skeletonSys.people = this;
         this._skeletonSys.info = this._info;
      }
      
      public function clearOldSkeleton() : void
      {
         if(Boolean(this._oldSkeleton))
         {
            this._oldSkeleton.destroy();
            this._oldSkeleton = null;
         }
      }
      
      public function showNono(_arg_1:NonoInfo, _arg_2:uint = 0) : void
      {
         if(Boolean(this._nono))
         {
            this._nono.destroy();
            this._nono = null;
         }
         if(_arg_1.superStage == 0)
         {
            _arg_1.superStage = 1;
         }
         if(_arg_2 == 0)
         {
            this._nono = new NonoModel(_arg_1,this);
         }
         else
         {
            this._nono = new NonoFlyModel(_arg_1,this);
         }
      }
      
      public function showNonoShield(_arg_1:uint) : void
      {
         if(!this.shieldTimer)
         {
            this.shieldTimer = new Timer(_arg_1 * 1000,1);
            this.shieldTimer.addEventListener(TimerEvent.TIMER,this.onShieldTimer);
         }
         this.shieldTimer.reset();
         this.shieldTimer.start();
         this.isShield = true;
         if(!this.shieldMC)
         {
            this.shieldMC = ShotBehaviorManager.getMovieClip("pk_nono_shield");
         }
         this.shieldMC.gotoAndStop(1);
         addChild(this.shieldMC);
      }
      
      public function showPet(_arg_1:PetShowInfo) : void
      {
         if(this._pet == null)
         {
            this._pet = new PetModel(this);
         }
         this._pet.show(_arg_1);
      }
      
      public function showShieldMovie() : void
      {
         this.shieldMC.gotoAndPlay(2);
      }
      
      public function showTeamLogo(_arg_1:ITeamLogoInfo) : void
      {
         if(_arg_1 is SimpleTeamInfo)
         {
            if(SimpleTeamInfo(_arg_1).superCoreNum < 10)
            {
               return;
            }
         }
         if(!this._teamLogo)
         {
            this._teamLogo = new TeamLogo();
         }
         this._teamLogo.info = _arg_1;
         this._teamLogo.scaleY = 0.6;
         this._teamLogo.scaleX = 0.6;
         this._teamLogo.x = -this._teamLogo.width / 2;
         this._teamLogo.y = -60 - this._teamLogo.height * this._teamLogo.scaleX - 5;
         addChild(this._teamLogo);
      }
      
      public function specialAction(_arg_1:uint) : void
      {
         this._skeletonSys.specialAction(this,_arg_1);
      }
      
      override public function stop() : void
      {
         super.stop();
         if(Boolean(this._pet))
         {
            this._pet.stop();
         }
      }
      
      public function stopSpecialAct() : void
      {
         this.direction = Direction.DOWN;
      }
      
      public function takeOffCloth() : void
      {
         this._skeletonSys.takeOffCloth();
      }
      
      public function walkAction(_arg_1:Object, _arg_2:Boolean = true) : void
      {
         _walk.execute(this,_arg_1,_arg_2);
      }
      
      override public function get width() : Number
      {
         return this._skeletonSys.getBodyMC().width;
      }
      
      protected function addEvent() : void
      {
         addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         addEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         this.clickBtn.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.clickBtn.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.clickBtn.addEventListener(MouseEvent.CLICK,this.onClick);
         UserManager.addActionListener(this._info.userID,this.onAction);
         addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnterFrame);
      }
      
      protected function onWalkEnd(_arg_1:Event) : void
      {
         this._skeletonSys.stop();
      }
      
      private function getProtectMC() : MovieClip
      {
         var _local_1:MovieClip = UIManager.getMovieClip("ui_TandS_Protecte_MC");
         _local_1.mouseChildren = false;
         _local_1.mouseEnabled = false;
         return _local_1;
      }
      
      private function hideShield() : void
      {
         this.isShield = false;
         DisplayUtil.removeForParent(this.shieldMC,false);
      }
      
      private function onAction(_arg_1:PeopleActionEvent) : void
      {
         var _local_2:uint = 0;
         var _local_3:NonoInfo = null;
         switch(_arg_1.actionType)
         {
            case PeopleActionEvent.WALK:
               this.walkAction(_arg_1.data,false);
               return;
            case PeopleActionEvent.CHAT:
               this.chatAction(_arg_1.data as String,0,false);
               return;
            case PeopleActionEvent.COLOR_CHANGE:
               this._info.coins = _arg_1.data.coins as uint;
               this.changeColor(_arg_1.data.color,false);
               return;
            case PeopleActionEvent.CLOTH_CHANGE:
               this.changeCloth(_arg_1.data as Array,false);
               return;
            case PeopleActionEvent.DOODLE_CHANGE:
               this.changeDoodle(_arg_1.data as DoodleInfo,false);
               return;
            case PeopleActionEvent.PET_SHOW:
               this.showPet(_arg_1.data as PetShowInfo);
               return;
            case PeopleActionEvent.PET_HIDE:
               this.hidePet();
               return;
            case PeopleActionEvent.NAME_CHANGE:
               trace("changeName");
               this.changeNickName(_arg_1.data.nickName,false);
               return;
            case PeopleActionEvent.AIMAT:
               _local_2 = _arg_1.data.type as uint;
               if(_local_2 > 10000)
               {
                  if(AimatXMLInfo.getType(this._info.clothIDs) == 0)
                  {
                     return;
                  }
               }
               this.aimatAction(_arg_1.data.itemID,_local_2,_arg_1.data.pos as Point,false);
               return;
            case PeopleActionEvent.SPECIAL:
               this.peculiarAction(_arg_1.data as String,false);
               return;
            case PeopleActionEvent.NONO_FOLLOW:
               _local_3 = _arg_1.data as NonoInfo;
               this.showNono(_local_3);
               return;
            case PeopleActionEvent.NONO_HOOM:
               this.hideNono();
               break;
            case PeopleActionEvent.SET_TITLE:
               break;
            default:
               return;
         }
         trace("changetitle");
         this.refreshTitle(_arg_1.data as uint);
      }
      
      private function onShieldTimer(_arg_1:TimerEvent) : void
      {
         this.hideShield();
      }
      
      private function onWalkEnterFrame(_arg_1:Event) : void
      {
      }
      
      private function onWalkStart(_arg_1:Event) : void
      {
         this._skeletonSys.play();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         removeEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         this.clickBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         UserManager.removeActionListener(this._info.userID,this.onAction);
         removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnterFrame);
      }
      
      private function onRollOver(_arg_1:MouseEvent) : void
      {
         this._interactiveAction.rollOver();
      }
      
      private function onRollOut(_arg_1:MouseEvent) : void
      {
         this._interactiveAction.rollOut();
      }
      
      private function onClick(_arg_1:MouseEvent) : void
      {
         this._interactiveAction.click();
      }
      
      public function refreshTitle(param1:uint) : void
      {
         DisplayUtil.removeForParent(this._icon);
         DisplayUtil.removeForParent(this.titleCon);
         this._icon = null;
         this.titleCon = null;
         this._info.curTitle = param1;
         if(this._info.curTitle > 0)
         {
            this._nameTxt.y = 34;
            this.getOldMedal();
         }
         else
         {
            this._nameTxt.y = 14;
            this._nameContainer.y = defaultY;
         }
      }
      
      private function getOldMedal() : void
      {
         var _url:String = null;
         var _p:BasePeoleModel = null;
         _p = null;
         DisplayUtil.removeForParent(this._icon);
         this._icon = null;
         _p = this;
         _url = ClientConfig.getResPath("achieve/title/" + this._info.curTitle + ".swf");
         ResourceManager.getResource(_url,function(param1:DisplayObject):void
         {
            var _loc2_:TextField = null;
            var _loc3_:Rectangle = null;
            var _loc4_:TextFormat = null;
            var _loc5_:MovieClip = null;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            if(Boolean(param1))
            {
               _icon = param1 as Sprite;
               addChild(_icon);
               _loc2_ = _icon.getChildByName("txt") as TextField;
               _loc3_ = null;
               if(Boolean(_loc2_))
               {
                  _loc2_.autoSize = TextFieldAutoSize.LEFT;
                  if(_loc2_.defaultTextFormat.size != 12)
                  {
                     _loc4_ = new TextFormat();
                     _loc4_.size = 12;
                     _loc2_.setTextFormat(_loc4_);
                  }
                  if(Boolean(_icon["icon"]))
                  {
                     _loc5_ = _icon["icon"];
                     _loc6_ = 25;
                     if(_loc5_.width > _loc6_ || _loc5_.height > _loc6_)
                     {
                        _loc5_.scaleX = _loc5_.scaleY = 1;
                        _loc8_ = _loc5_.width;
                        if(_loc5_.height > _loc8_)
                        {
                           _loc8_ = _loc5_.height;
                        }
                        _loc9_ = _loc6_ / _loc8_;
                        _loc5_.scaleX = _loc5_.scaleY = _loc9_;
                     }
                     _loc3_ = _loc5_.getBounds(_icon);
                     _loc7_ = _loc5_.y;
                     _loc5_.y = _loc2_.height + _loc2_.y - _loc5_.height + (_loc3_.y - _loc7_) - 2;
                     _loc5_.x = 0;
                     _loc3_ = _icon.getBounds(_p);
                     _icon.x = -(_loc3_.x + _loc3_.width / 2) + 3;
                     _icon.y = 15 - _loc2_.y;
                  }
               }
               else
               {
                  _loc3_ = _icon.getBounds(_p);
                  _icon.x = -(_loc3_.x + _loc3_.width / 2) + 3;
                  _icon.y = 16;
               }
               _nameContainer.y = 34;
            }
         },"title");
      }
      
      private function showTitleTxt(param1:String, param2:uint = 16777011) : void
      {
         if(this.titleTxt == null)
         {
            this.titleTxt = new TextField();
            this.titleTxt.mouseEnabled = false;
            this.titleTxt.autoSize = TextFieldAutoSize.CENTER;
            this.titleTxt.multiline = true;
            this.titleTxt.cacheAsBitmap = true;
            this.titleTxt.width = 65;
            this.titleTxt.filters = [new GlowFilter(1182489,1,3,3,10,1,false,false)];
         }
         if(this._selfTf == null)
         {
            this._selfTf = new TextFormat();
            this._selfTf.font = "宋体";
            this._selfTf.letterSpacing = 0.5;
            this._selfTf.size = 12;
            this._selfTf.leading = 2;
            this._selfTf.align = TextFormatAlign.CENTER;
         }
         this.titleTxt.text = param1;
         this._selfTf.color = param2;
         this.titleTxt.setTextFormat(this._selfTf);
      }
      
      private function getSptIcon(param1:* = null) : void
      {
         var e:* = param1;
         EventManager.removeEventListener(ResourceManager.RESOUCE_ERROR,this.getSptIcon);
         this._url = ClientConfig.getResPath("achieve/spt/" + this.iconId + ".swf");
         ResourceManager.getResource(this._url,function(param1:DisplayObject):void
         {
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Bitmap = null;
            DisplayUtil.removeAllChild(titleCon);
            if(Boolean(param1))
            {
               _loc2_ = 20;
               param1.scaleX = param1.scaleY = 1;
               _loc3_ = param1.height > param1.width ? param1.height : param1.width;
               _loc4_ = _loc2_ / _loc3_;
               param1.scaleX = param1.scaleY = _loc4_;
               _loc5_ = DisplayUtil.copyDisplayAsBmp(param1);
               _loc5_.x = _loc5_.y = 0;
               titleCon.addChild(_loc5_);
               titleCon.addChild(titleTxt);
               titleTxt.x = param1.width + (65 - titleTxt.width) / 2;
               titleTxt.y = 4;
               titleCon.x = titlIconX;
               titleCon.y = defaultY;
               _nameContainer.y = isWrap ? 46 : 34;
            }
            else
            {
               DebugTrace("achieve/spt/" + iconId + ".swf素材不对");
               _nameContainer.y = defaultTopIconY;
            }
         },"spt");
      }
      
      private function getMedal() : void
      {
         var titleName:String = null;
         var _p:BasePeoleModel = null;
         var arr:Array = null;
         var color:uint = uint(AchieveXMLInfo.getTitleColor(this._info.curTitle));
         if(color == 16777215)
         {
            this.getOldMedal();
            return;
         }
         this.iconId = AchieveXMLInfo.getTitleIconId(this._info.curTitle);
         titleName = AchieveXMLInfo.getOriginalTitle(this._info.curTitle);
         this._url = ClientConfig.getResPath("achieve/icon/" + this.iconId + ".swf");
         this.isWrap = titleName.split("|").length > 1 || titleName.length > 5;
         if(this.isWrap && titleName.split("|").length == 1)
         {
            arr = titleName.split("");
            arr.splice(5,0,"|");
            titleName = arr.join("");
         }
         if(titleName.lastIndexOf("|") == titleName.length - 1)
         {
            titleName = titleName.replace("|","");
            this.isWrap = false;
         }
         else
         {
            titleName = titleName.replace("|","\r");
         }
         _p = this;
         if(color == 0)
         {
            color = 16777011;
         }
         this.showTitleTxt(titleName,color);
         if(null == this.titleCon)
         {
            this.titleCon = new Sprite();
            this.titleCon.y = defaultY;
            this.titleCon.cacheAsBitmap = true;
            addChild(this.titleCon);
            this.titleCon.mouseChildren = this.titleCon.mouseEnabled = false;
         }
         DisplayUtil.removeAllChild(this.titleCon);
         EventManager.addEventListener(ResourceManager.RESOUCE_ERROR,this.getSptIcon);
         ResourceManager.getResource(this._url,function(param1:DisplayObject):void
         {
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Bitmap = null;
            EventManager.removeEventListener(ResourceManager.RESOUCE_ERROR,getSptIcon);
            DisplayUtil.removeAllChild(titleCon);
            if(Boolean(param1))
            {
               _loc2_ = 20;
               param1.scaleX = param1.scaleY = 1;
               _loc3_ = param1.height > param1.width ? param1.height : param1.width;
               _loc4_ = _loc2_ / _loc3_;
               param1.scaleX = param1.scaleY = _loc4_;
               _loc5_ = DisplayUtil.copyDisplayAsBmp(param1);
               _loc5_.x = _loc5_.y = 0;
               titleCon.addChild(_loc5_);
               titleCon.addChild(titleTxt);
               titleTxt.x = param1.width + (65 - titleTxt.width) / 2;
               titleTxt.y = 4;
               titleCon.x = titlIconX;
               titleCon.y = defaultY;
               _nameContainer.y = isWrap ? 46 : 34;
            }
            else
            {
               DebugTrace("achieve/icon/" + iconId + ".swf素材不对");
               _nameContainer.y = defaultTopIconY;
            }
         },"icon");
      }
   }
}

