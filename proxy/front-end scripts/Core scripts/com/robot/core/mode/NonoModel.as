package com.robot.core.mode
{
   import com.robot.core.aticon.FlyAction;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.nono.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.utils.*;
   import org.taomee.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class NonoModel extends BobyModel implements INonoModel
   {
      
      public static const MAX:int = 30;
      
      private static const ClaName:Array = ["pet","sou"];
      
      private static const SCALE:Number = 0.8;
      
      private var _people:ActionSpriteModel;
      
      private var _info:NonoInfo;
      
      private var _actionID:uint;
      
      private var _expID:uint;
      
      private var _expList:Array;
      
      private var _linesList:Array;
      
      private var _expTimeID:uint;
      
      private var _bodyMC:Sprite;
      
      private var _bodyUpColorMC:MovieClip;
      
      private var _bodyDownColorMC:MovieClip;
      
      private var _bodyChildMC:MovieClip;
      
      private var _bodyFootMC:MovieClip;
      
      private var _bodyFootMC2:MovieClip;
      
      private var _expMC:MovieClip;
      
      private var _actionMC:MovieClip;
      
      private var _sound:Sound;
      
      private var _sc:SoundChannel;
      
      private var _dirPos:Point = new Point();
      
      private var _dirSpeed:Point = new Point();
      
      private var _followTimeID:uint;
      
      private var _resPath:String = "";
      
      private var _fly:FlyAction;
      
      private var _enterCount:int;
      
      private var _nullPos:Point = new Point();
      
      private var _bodyRect:Rectangle;
      
      private var _matriix:Matrix = new Matrix();
      
      private var _bmd:BitmapData;
      
      private var _bmp:Bitmap;
      
      public function NonoModel(_arg_1:NonoInfo, _arg_2:ActionSpriteModel = null)
      {
         super();
         _speed = 3;
         this._info = _arg_1;
         this.buttonMode = true;
         if(this._info.superNono)
         {
            this._resPath = "super/";
         }
         if(Boolean(_arg_2))
         {
            this._people = _arg_2;
            this._people.addChild(this);
            this.moveForPeople(false);
         }
         this._expList = MachXMLInfo.getExpID();
         if(this._info.superNono)
         {
            ResourceManager.getResource(ClientConfig.getNonoPath(this._resPath + "nono" + "_" + this._info.superStage),this.onResLoad,"pet");
         }
         else
         {
            ResourceManager.getResource(ClientConfig.getNonoPath(this._resPath + "nono"),this.onResLoad,"pet");
         }
         this.addEvent();
      }
      
      override public function destroy() : void
      {
         this.removeEvent();
         clearTimeout(this._expTimeID);
         clearTimeout(this._followTimeID);
         super.destroy();
         this.clearActionMC();
         this._dirPos = null;
         this._dirSpeed = null;
         this._bodyUpColorMC = null;
         this._bodyDownColorMC = null;
         this._bodyChildMC = null;
         this._bodyFootMC = null;
         this._bodyMC = null;
         DisplayUtil.removeForParent(this);
      }
      
      override public function set visible(_arg_1:Boolean) : void
      {
         this.visible = _arg_1;
      }
      
      public function set people(_arg_1:ActionSpriteModel) : void
      {
         this._people = _arg_1;
         if(Boolean(this._people))
         {
            this.stopAutoTime();
            this.setGear();
            y = -22;
            this._people.addChild(this);
            this.moveForPeople(false);
         }
         else
         {
            this.startAutoTime();
         }
      }
      
      public function get people() : ActionSpriteModel
      {
         return this._people;
      }
      
      public function get info() : NonoInfo
      {
         return this._info;
      }
      
      override public function set direction(_arg_1:String) : void
      {
         if(_arg_1 == null || _arg_1 == "")
         {
            return;
         }
         _direction = _arg_1;
         this.changedir();
      }
      
      override public function get centerPoint() : Point
      {
         _centerPoint.x = x;
         _centerPoint.y = y - 22;
         return _centerPoint;
      }
      
      override public function get hitRect() : Rectangle
      {
         _hitRect.x = x - width / 2;
         _hitRect.y = y - height;
         _hitRect.width = width;
         _hitRect.height = height;
         return _hitRect;
      }
      
      private function addEvent() : void
      {
         if(this._info.userID == MainManager.actorID)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.onOver);
         }
         EventManager.addEventListener(RobotEvent.NONO_SHORTCUT_HIDE,this.onShortcutHide);
         NonoManager.addActionListener(this._info.userID,this.onNonoEvent);
         if(Boolean(this._people))
         {
            this._people.addEventListener(RobotEvent.CHANGE_DIRECTION,this.onPeopleDir);
            this._people.addEventListener(RobotEvent.WALK_START,this.onPeopleWalkStart);
            this._people.addEventListener(RobotEvent.WALK_END,this.onPeopleWalkEnd);
            if(this._info.superNono)
            {
               this._people.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
            }
         }
         else
         {
            addEventListener(RobotEvent.WALK_START,this.onWalkStart);
            addEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onMoveDir);
         removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         removeEventListener(MouseEvent.CLICK,this.onClick);
         EventManager.removeEventListener(RobotEvent.NONO_SHORTCUT_HIDE,this.onShortcutHide);
         NonoManager.removeActionListener(this._info.userID,this.onNonoEvent);
         if(Boolean(this._people))
         {
            this._people.removeEventListener(RobotEvent.CHANGE_DIRECTION,this.onPeopleDir);
            this._people.removeEventListener(RobotEvent.WALK_START,this.onPeopleWalkStart);
            this._people.removeEventListener(RobotEvent.WALK_END,this.onPeopleWalkEnd);
            if(this._info.superNono)
            {
               this._people.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
            }
         }
         else
         {
            removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
            removeEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         }
      }
      
      private function initCheck() : void
      {
         if(this._info.chargeTime != 0)
         {
            this._actionID = 1;
            this.getActionRes();
            return;
         }
         if(!this._info.state[0] || this._info.power == 0)
         {
            this.setClose();
            return;
         }
         this.startAutoTime();
      }
      
      private function onResLoad(o:DisplayObject) : void
      {
         this._bodyMC = o as Sprite;
         this._bodyMC.scaleX = SCALE;
         this._bodyMC.scaleY = SCALE;
         this._bodyMC.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function():void
         {
            _bodyMC.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
            _bodyUpColorMC = _bodyMC.getChildByName("color_1") as MovieClip;
            if(Boolean(_bodyUpColorMC))
            {
               DisplayUtil.FillColor(_bodyUpColorMC,_info.color);
               _bodyUpColorMC.gotoAndStop(direction);
            }
            _bodyDownColorMC = _bodyMC.getChildByName("color_2") as MovieClip;
            if(Boolean(_bodyDownColorMC))
            {
               DisplayUtil.FillColor(_bodyDownColorMC,_info.color);
               _bodyDownColorMC.gotoAndStop(direction);
            }
            _bodyChildMC = _bodyMC.getChildByName("body") as MovieClip;
            _bodyChildMC.gotoAndStop(direction);
            _bodyFootMC = _bodyMC.getChildByName("foot") as MovieClip;
            if(Boolean(_bodyFootMC))
            {
               _bodyFootMC.gotoAndStop(direction);
            }
            _bodyFootMC2 = _bodyMC.getChildByName("foot_2") as MovieClip;
            if(Boolean(_bodyFootMC2))
            {
               _bodyFootMC2.gotoAndStop(direction);
            }
         });
         addChild(this._bodyMC);
         if(this._people == null)
         {
            this.initCheck();
         }
         else
         {
            this.onPeopleWalkEnd();
         }
      }
      
      private function startAutoTime() : void
      {
         if(this._actionID == 0)
         {
            if(this._info.power > 0 && Boolean(this._info.state[0]))
            {
               this._expTimeID = setTimeout(this.onExpTime,MathUtil.randomHalve(20000));
               starAutoWalk(3000);
            }
         }
      }
      
      private function stopAutoTime() : void
      {
         clearTimeout(this._expTimeID);
         stopAutoWalk();
         this.changedir();
      }
      
      private function clearActionMC() : void
      {
         if(Boolean(this._actionMC))
         {
            this._actionMC.addFrameScript(this._actionMC.totalFrames - 1,null);
            DisplayUtil.removeForParent(this._actionMC);
            this._actionMC = null;
         }
         if(Boolean(this._expMC))
         {
            this._expMC.addFrameScript(this._expMC.totalFrames - 1,null);
            DisplayUtil.removeForParent(this._expMC);
            this._expMC = null;
         }
         if(Boolean(this._sound))
         {
            this._sound = null;
         }
         if(Boolean(this._sc))
         {
            this._sc.stop();
            this._sc = null;
         }
      }
      
      private function fillColor(mc:MovieClip) : void
      {
         mc.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(_arg_1:Event):void
         {
            var _local_3:MovieClip = null;
            var _local_5:uint = 0;
            mc.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
            var _local_4:uint = uint(mc.numChildren);
            while(_local_5 < _local_4)
            {
               _local_3 = mc.getChildAt(_local_5) as MovieClip;
               if(Boolean(_local_3))
               {
                  if(_local_3.name.substr(0,6) == "color_")
                  {
                     DisplayUtil.FillColor(_local_3,_info.color);
                  }
               }
               _local_5++;
            }
         });
      }
      
      private function setGear() : void
      {
         this.clearActionMC();
         this._actionID = 0;
         if(Boolean(this._bodyMC))
         {
            addChild(this._bodyMC);
         }
      }
      
      private function setClose() : void
      {
         this._info.state[0] = false;
         this._actionID = 3;
         this.getActionRes();
      }
      
      private function setOpen() : Boolean
      {
         if(this._info.power != 0)
         {
            this._info.state[0] = true;
            this._info.chargeTime = 0;
            this._actionID = 2;
            this.getActionRes();
            return true;
         }
         return false;
      }
      
      private function onResAction(_arg_1:Array) : void
      {
         var _local_2:int = 0;
         this.clearActionMC();
         if(_arg_1.length == 0)
         {
            return;
         }
         this._actionMC = _arg_1[0] as MovieClip;
         if(Boolean(this._actionMC))
         {
            this._actionMC.scaleX = SCALE;
            this._actionMC.scaleY = SCALE;
            this.fillColor(this._actionMC);
            addChild(this._actionMC);
            this.stopAutoTime();
            this._actionMC.addFrameScript(this._actionMC.totalFrames - 1,this.onActionScript);
            this._actionMC.gotoAndPlay(1);
            if(Boolean(this._bodyMC))
            {
               DisplayUtil.removeForParent(this._bodyMC,false);
            }
            if(_arg_1.length >= 2)
            {
               _local_2 = MachXMLInfo.getActionSouLoops(this._actionID);
               if(_local_2 > 0)
               {
                  this._sound = _arg_1[1] as Sound;
                  if(Boolean(this._sound))
                  {
                     this._sc = this._sound.play(0,_local_2);
                  }
               }
            }
            DepthManager.bringToTop(this);
         }
      }
      
      private function onActionScript() : void
      {
         this._actionMC.addFrameScript(this._actionMC.totalFrames - 1,null);
         if(!MachXMLInfo.getActionIsAutoEnd(this._actionID))
         {
            return;
         }
         NonoManager.dispatchEvent(new DynamicEvent(NonoEvent.PLAY_COMPLETE,this._actionID));
         this._actionID = 0;
         if(Boolean(this._bodyMC))
         {
            addChild(this._bodyMC);
         }
         this.clearActionMC();
         this.initCheck();
      }
      
      private function onResExp(_arg_1:Array) : void
      {
         var _local_2:uint = 0;
         this.clearActionMC();
         if(_arg_1.length == 0)
         {
            return;
         }
         this._expMC = _arg_1[0] as MovieClip;
         if(Boolean(this._expMC))
         {
            this._expMC.scaleX = SCALE;
            this._expMC.scaleY = SCALE;
            this.fillColor(this._expMC);
            addChild(this._expMC);
            this.stopAutoTime();
            this.direction = Direction.DOWN;
            this._expMC.addFrameScript(this._expMC.totalFrames - 1,this.onExpScript);
            this._expMC.gotoAndPlay(1);
            if(Boolean(this._bodyMC))
            {
               DisplayUtil.removeForParent(this._bodyMC,false);
            }
            if(this._linesList.length != 0)
            {
               _local_2 = uint(this._linesList[int(this._linesList.length * Math.random())]);
               showBox(MachXMLInfo.getLinesName(_local_2),12);
            }
         }
         if(_arg_1.length >= 2)
         {
            this._sound = _arg_1[1] as Sound;
            if(Boolean(this._sound))
            {
               this._sc = this._sound.play(0,1);
            }
         }
      }
      
      private function onExpTime() : void
      {
         this._expID = this._expList[int(this._expList.length * Math.random())];
         this._linesList = MachXMLInfo.getLinesIDForExp(this._expID,this._info.getPowerLevel(),this._info.getMateLevel());
         this.getExpRes();
      }
      
      private function onExpScript() : void
      {
         this.clearActionMC();
         if(this._actionID != 0)
         {
            return;
         }
         if(Boolean(this._bodyMC))
         {
            addChild(this._bodyMC);
         }
         this.startAutoTime();
      }
      
      private function changedir() : void
      {
         var num:uint = 0;
         var i:uint = 0;
         var c:MovieClip = null;
         if(Boolean(this._bodyMC))
         {
            num = uint(this._bodyMC.numChildren);
            i = 0;
            while(i < num)
            {
               c = this._bodyMC.getChildAt(i) as MovieClip;
               if(c != this._bodyDownColorMC && c != this._bodyUpColorMC && c != this._bodyFootMC && c != this._bodyChildMC)
               {
                  c.gotoAndStop(_direction);
               }
               i++;
            }
            if(Boolean(this._bodyUpColorMC))
            {
               this._bodyUpColorMC.gotoAndStop(_direction);
               this._bodyUpColorMC.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(_arg_1:Event):void
               {
                  var _local_3:MovieClip = null;
                  _bodyUpColorMC.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
                  if(_bodyUpColorMC.numChildren > 0)
                  {
                     _local_3 = _bodyUpColorMC.getChildAt(0) as MovieClip;
                     if(Boolean(_local_3))
                     {
                     }
                  }
               });
            }
            if(Boolean(this._bodyDownColorMC))
            {
               this._bodyDownColorMC.gotoAndStop(_direction);
               this._bodyDownColorMC.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(_arg_1:Event):void
               {
                  var _local_3:MovieClip = null;
                  _bodyDownColorMC.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
                  if(_bodyDownColorMC.numChildren > 0)
                  {
                     _local_3 = _bodyDownColorMC.getChildAt(0) as MovieClip;
                     if(Boolean(_local_3))
                     {
                     }
                  }
               });
            }
            if(Boolean(this._bodyChildMC))
            {
               this._bodyChildMC.gotoAndStop(_direction);
               this._bodyChildMC.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(_arg_1:Event):void
               {
                  var _local_3:MovieClip = null;
                  _bodyChildMC.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
                  if(_bodyChildMC.numChildren > 0)
                  {
                     _local_3 = _bodyChildMC.getChildAt(0) as MovieClip;
                     if(Boolean(_local_3))
                     {
                     }
                  }
               });
            }
            if(Boolean(this._bodyFootMC))
            {
               this._bodyFootMC.gotoAndStop(_direction);
               this._bodyFootMC.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(_arg_1:Event):void
               {
                  var _local_3:MovieClip = null;
                  _bodyFootMC.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
                  if(_bodyFootMC.numChildren > 0)
                  {
                     _local_3 = _bodyFootMC.getChildAt(0) as MovieClip;
                     if(Boolean(_local_3))
                     {
                     }
                  }
               });
            }
            if(Boolean(this._bodyFootMC2))
            {
               this._bodyFootMC2.gotoAndStop(_direction);
               this._bodyFootMC2.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(_arg_1:Event):void
               {
                  var _local_3:MovieClip = null;
                  _bodyFootMC2.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
                  if(_bodyFootMC2.numChildren > 0)
                  {
                     _local_3 = _bodyFootMC2.getChildAt(0) as MovieClip;
                     if(Boolean(_local_3))
                     {
                     }
                  }
               });
            }
         }
      }
      
      private function onPeopleWalkEnter(_arg_1:Event) : void
      {
         var _local_2:Point = null;
         var _local_3:Number = NaN;
         var _local_4:Number = NaN;
         if(Boolean(this._bodyMC))
         {
            if(this._enterCount % 3 == 0)
            {
               this._bodyRect = this._bodyMC.transform.pixelBounds;
               _local_2 = this._bodyMC.localToGlobal(this._nullPos);
               _local_3 = _local_2.x - this._bodyRect.x;
               _local_4 = _local_2.y - this._bodyRect.y;
               this._matriix.createBox(SCALE,SCALE,0,-this._bodyMC.x + _local_3,-this._bodyMC.y + _local_4);
               this._bmd = new BitmapData(this._bodyRect.width,this._bodyRect.height - 13,true,0);
               this._bmd.draw(this._bodyMC,this._matriix);
               this._bmp = new Bitmap(this._bmd);
               this._bmp.x = -LevelManager.mapLevel.x + this._bodyRect.x;
               this._bmp.y = -LevelManager.mapLevel.y + this._bodyRect.y;
               this._bmp.alpha = 0.5;
               MapManager.currentMap.depthLevel.addChildAt(this._bmp,0);
               this._bmp.addEventListener(Event.ENTER_FRAME,this.onBMPEnter);
            }
            ++this._enterCount;
         }
      }
      
      private function onBMPEnter(_arg_1:Event) : void
      {
         var _local_2:Bitmap = _arg_1.target as Bitmap;
         if(_local_2.alpha <= 0)
         {
            _local_2.bitmapData.dispose();
            _local_2.removeEventListener(Event.ENTER_FRAME,this.onBMPEnter);
            DisplayUtil.removeForParent(_local_2);
            _local_2 = null;
         }
         else
         {
            _local_2.alpha -= 0.05;
         }
      }
      
      private function onPeopleWalkStart(_arg_1:Event = null) : void
      {
         clearTimeout(this._followTimeID);
         this.clearActionMC();
         if(Boolean(this._bodyMC))
         {
            addChild(this._bodyMC);
         }
         if(Boolean(this._expID))
         {
            if(this._info.superNono)
            {
               ResourceManager.cancel(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString() + "_" + this._info.superStage),this.onResFollowExp);
            }
            else
            {
               ResourceManager.cancel(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString()),this.onResFollowExp);
            }
            this._expID = 0;
         }
      }
      
      private function onPeopleWalkEnd(_arg_1:Event = null) : void
      {
         this._followTimeID = setTimeout(this.onFollowTime,MathUtil.randomHalve(20000));
         if(NonoManager.isBeckon)
         {
            NonoManager.isBeckon = false;
            ResourceManager.getResourceList(ClientConfig.getNonoPath(this._resPath + "action/6" + "_" + this._info.superStage),this.onResFollowAction,ClaName);
         }
      }
      
      private function onFollowTime() : void
      {
         this._expID = this._expList[int(this._expList.length * Math.random())];
         if(this._info.superNono)
         {
            ResourceManager.getResource(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString() + "_" + this._info.superStage),this.onResFollowExp,"pet");
         }
         else
         {
            ResourceManager.getResource(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString()),this.onResFollowExp,"pet");
         }
      }
      
      private function onResFollowExp(_arg_1:DisplayObject) : void
      {
         this.clearActionMC();
         this._expMC = _arg_1 as MovieClip;
         this._expMC.scaleX = SCALE;
         this._expMC.scaleY = SCALE;
         this.fillColor(this._expMC);
         addChild(this._expMC);
         clearTimeout(this._followTimeID);
         this.direction = Direction.DOWN;
         this._expMC.addFrameScript(this._expMC.totalFrames - 1,this.onFollowExpScript);
         this._expMC.gotoAndPlay(1);
         if(Boolean(this._bodyMC))
         {
            DisplayUtil.removeForParent(this._bodyMC,false);
         }
      }
      
      private function onFollowExpScript() : void
      {
         this.clearActionMC();
         if(Boolean(this._bodyMC))
         {
            addChild(this._bodyMC);
         }
         this.onPeopleWalkEnd();
      }
      
      private function onResFollowAction(_arg_1:Array) : void
      {
         this.clearActionMC();
         if(_arg_1.length == 0)
         {
            return;
         }
         this._expMC = _arg_1[0] as MovieClip;
         if(Boolean(this._expMC))
         {
            this._expMC.scaleX = SCALE;
            this._expMC.scaleY = SCALE;
            this.fillColor(this._expMC);
            addChild(this._expMC);
            clearTimeout(this._followTimeID);
            this.direction = Direction.DOWN;
            this._expMC.addFrameScript(this._expMC.totalFrames - 1,this.onFollowExpScript);
            this._expMC.gotoAndPlay(1);
            if(Boolean(this._bodyMC))
            {
               DisplayUtil.removeForParent(this._bodyMC,false);
            }
         }
         if(_arg_1.length >= 2)
         {
            this._sound = _arg_1[1] as Sound;
            if(Boolean(this._sound))
            {
               this._sc = this._sound.play(0,1);
            }
         }
      }
      
      private function onPeopleDir(_arg_1:DynamicEvent) : void
      {
         this.direction = _arg_1.paramObject as String;
         this.moveForPeople();
      }
      
      private function moveForPeople(_arg_1:Boolean = true) : void
      {
         if(Boolean(this._people))
         {
            switch(this._people.direction)
            {
               case Direction.LEFT_DOWN:
               case Direction.DOWN:
               case Direction.RIGHT_DOWN:
                  this._dirPos.y = -MAX;
                  DepthManager.bringToBottom(this);
                  break;
               case Direction.UP:
               case Direction.RIGHT_UP:
               case Direction.LEFT_UP:
                  this._dirPos.y = 10;
                  DepthManager.bringToTop(this);
                  break;
               case Direction.LEFT:
               case Direction.RIGHT:
                  this._dirPos.y = 0;
                  DepthManager.bringToBottom(this);
            }
            switch(this._people.direction)
            {
               case Direction.LEFT:
               case Direction.DOWN:
               case Direction.LEFT_DOWN:
               case Direction.LEFT_UP:
                  this._dirPos.x = MAX;
                  break;
               case Direction.UP:
               case Direction.RIGHT:
               case Direction.RIGHT_DOWN:
               case Direction.RIGHT_UP:
                  this._dirPos.x = -MAX;
            }
            if(_arg_1)
            {
               if(Math.abs(Point.distance(pos,this._dirPos)) > 4)
               {
                  this._dirSpeed = GeomUtil.angleSpeed(pos,this._dirPos);
                  this._dirSpeed.x *= 4;
                  this._dirSpeed.y *= 4;
                  addEventListener(Event.ENTER_FRAME,this.onMoveDir);
               }
            }
            else
            {
               pos = this._dirPos.clone();
            }
         }
      }
      
      private function onMoveDir(_arg_1:Event) : void
      {
         if(Math.abs(Point.distance(pos,this._dirPos)) < 4)
         {
            removeEventListener(Event.ENTER_FRAME,this.onMoveDir);
         }
         pos = pos.subtract(this._dirSpeed);
      }
      
      private function onNonoEvent(_arg_1:NonoActionEvent) : void
      {
         var _local_2:Boolean = false;
         var _local_3:Boolean = false;
         switch(_arg_1.actionType)
         {
            case NonoActionEvent.COLOR_CHANGE:
               this._info.color = _arg_1.data as uint;
               trace("nono事件",this._info.color);
               if(Boolean(this._bodyUpColorMC))
               {
                  DisplayUtil.FillColor(this._bodyUpColorMC,this._info.color);
               }
               if(Boolean(this._bodyDownColorMC))
               {
                  DisplayUtil.FillColor(this._bodyDownColorMC,this._info.color);
               }
               return;
            case NonoActionEvent.NAME_CHANGE:
               this._info.nick = _arg_1.data as String;
               return;
            case NonoActionEvent.CLOSE_OPEN:
               _local_2 = _arg_1.data as Boolean;
               if(_local_2)
               {
                  this.setOpen();
               }
               else
               {
                  this.setClose();
               }
               return;
            case NonoActionEvent.NONO_PLAY:
               this._actionID = _arg_1.data as uint;
               if(this._actionID == 0)
               {
                  return;
               }
               this.getActionRes();
               return;
               break;
            case NonoActionEvent.CHARGEING:
               _local_3 = _arg_1.data as Boolean;
               if(_local_3)
               {
                  this._info.chargeTime = 1;
                  this._actionID = 1;
                  this._info.state[0] = false;
                  this.getActionRes();
                  break;
               }
               this._info.chargeTime = 0;
               this._actionID = 0;
               if(!this._info.state[0] || this._info.power == 0)
               {
                  this.setClose();
                  break;
               }
               this.setGear();
               this.startAutoTime();
         }
      }
      
      private function onWalkStart(_arg_1:Event) : void
      {
         var _local_2:MovieClip = null;
         var _local_3:MovieClip = null;
         var _local_4:MovieClip = null;
         var _local_5:MovieClip = null;
         if(Boolean(this._bodyMC))
         {
            if(Boolean(this._bodyUpColorMC))
            {
               if(this._bodyUpColorMC.numChildren > 0)
               {
                  _local_2 = this._bodyUpColorMC.getChildAt(0) as MovieClip;
                  if(Boolean(_local_2))
                  {
                     if(_local_2.currentFrame == 1)
                     {
                        _local_2.gotoAndStop(2);
                     }
                  }
               }
            }
            if(Boolean(this._bodyDownColorMC))
            {
               if(this._bodyDownColorMC.numChildren > 0)
               {
                  _local_3 = this._bodyDownColorMC.getChildAt(0) as MovieClip;
                  if(Boolean(_local_3))
                  {
                     if(_local_3.currentFrame == 1)
                     {
                        _local_3.gotoAndStop(2);
                     }
                  }
               }
            }
            if(Boolean(this._bodyChildMC))
            {
               if(this._bodyChildMC.numChildren > 0)
               {
                  _local_4 = this._bodyChildMC.getChildAt(0) as MovieClip;
                  if(Boolean(_local_4))
                  {
                     if(_local_4.currentFrame == 1)
                     {
                        _local_4.gotoAndStop(2);
                     }
                  }
               }
            }
            if(Boolean(this._bodyFootMC))
            {
               if(this._bodyFootMC.numChildren > 0)
               {
                  _local_5 = this._bodyFootMC.getChildAt(0) as MovieClip;
                  if(Boolean(_local_5))
                  {
                     if(_local_5.currentFrame == 1)
                     {
                        _local_5.gotoAndStop(2);
                     }
                  }
               }
            }
         }
      }
      
      private function onWalkEnd(_arg_1:Event) : void
      {
         var _local_2:MovieClip = null;
         var _local_3:MovieClip = null;
         var _local_4:MovieClip = null;
         var _local_5:MovieClip = null;
         if(Boolean(this._bodyMC))
         {
            if(Boolean(this._bodyUpColorMC))
            {
               if(this._bodyUpColorMC.numChildren > 0)
               {
                  _local_2 = this._bodyUpColorMC.getChildAt(0) as MovieClip;
                  if(Boolean(_local_2))
                  {
                     if(_local_2.currentFrame == 2)
                     {
                        _local_2.gotoAndStop(1);
                     }
                  }
               }
            }
            if(Boolean(this._bodyDownColorMC))
            {
               if(this._bodyDownColorMC.numChildren > 0)
               {
                  _local_3 = this._bodyDownColorMC.getChildAt(0) as MovieClip;
                  if(Boolean(_local_3))
                  {
                     if(_local_3.currentFrame == 2)
                     {
                        _local_3.gotoAndStop(1);
                     }
                  }
               }
            }
            if(Boolean(this._bodyChildMC))
            {
               if(this._bodyChildMC.numChildren > 0)
               {
                  _local_4 = this._bodyChildMC.getChildAt(0) as MovieClip;
                  if(Boolean(_local_4))
                  {
                     if(_local_4.currentFrame == 2)
                     {
                        _local_4.gotoAndStop(1);
                     }
                  }
               }
            }
            if(Boolean(this._bodyFootMC))
            {
               if(this._bodyFootMC.numChildren > 0)
               {
                  _local_5 = this._bodyFootMC.getChildAt(0) as MovieClip;
                  if(Boolean(_local_5))
                  {
                     if(_local_5.currentFrame == 2)
                     {
                        _local_5.gotoAndStop(1);
                     }
                  }
               }
            }
         }
      }
      
      private function getActionRes() : void
      {
         if(this._info.superNono)
         {
            ResourceManager.getResourceList(ClientConfig.getNonoPath(this._resPath + "action/" + this._actionID.toString() + "_" + this._info.superStage),this.onResAction,ClaName);
         }
         else
         {
            ResourceManager.getResourceList(ClientConfig.getNonoPath(this._resPath + "action/" + this._actionID.toString()),this.onResAction,ClaName);
         }
      }
      
      private function getExpRes() : void
      {
         if(this._info.superNono)
         {
            ResourceManager.getResourceList(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString() + "_" + this._info.superStage),this.onResExp,ClaName);
         }
         else
         {
            ResourceManager.getResourceList(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString()),this.onResExp,ClaName);
         }
      }
      
      private function onOver(_arg_1:MouseEvent) : void
      {
         var _local_2:Boolean = false;
         if(this._people == null)
         {
            _local_2 = false;
         }
         else
         {
            _local_2 = true;
            if(this._people.walk.isPlaying)
            {
               return;
            }
         }
         var _local_3:Point = localToGlobal(new Point(0,-30));
         NonoShortcut.show(_local_3,this._info,_local_2);
         this.stopAutoTime();
      }
      
      private function onShortcutHide(_arg_1:Event) : void
      {
         if(this._people == null)
         {
            this.startAutoTime();
         }
      }
      
      public function startPlay() : void
      {
      }
      
      public function stopPlay() : void
      {
      }
      
      private function onClick(_arg_1:MouseEvent) : void
      {
         NonoInfoPanelController.show(this._info);
      }
   }
}

