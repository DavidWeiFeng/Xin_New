package com.robot.core.mode
{
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.team.ArmInfo;
   import com.robot.core.manager.*;
   import com.robot.core.teamInstallation.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.ui.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ArmModel extends SpriteModel
   {
      
      public var funID:uint;
      
      private var _info:ArmInfo;
      
      protected var _dragEnabled:Boolean;
      
      private var _unit:IFunUnit;
      
      private var _content:Sprite;
      
      private var _resURL:String = "";
      
      private var _markMc:MovieClip;
      
      public function ArmModel()
      {
         super();
      }
      
      public function get info() : ArmInfo
      {
         return this._info;
      }
      
      public function get dragEnabled() : Boolean
      {
         return this._dragEnabled;
      }
      
      public function set dragEnabled(_arg_1:Boolean) : void
      {
         this._dragEnabled = _arg_1;
         if(this._dragEnabled)
         {
            addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            removeEventListener(MouseEvent.CLICK,this.onPanelClick);
         }
         else
         {
            removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            if(!this.funID)
            {
               addEventListener(MouseEvent.CLICK,this.onPanelClick);
            }
         }
      }
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      public function show(_arg_1:ArmInfo, _arg_2:DisplayObjectContainer) : void
      {
         if(this._resURL != "")
         {
            ResourceManager.cancel(ClientConfig.getArmItem(this._resURL),this.onLoadRes);
         }
         this._info = _arg_1;
         if(this._info.form == 0)
         {
            this._resURL = this._info.styleID.toString();
         }
         else
         {
            buttonMode = true;
            if(this._info.form == 1)
            {
               if(this._info.resNum == 0)
               {
                  this._resURL = this._info.styleID.toString() + "_" + this._info.form.toString();
               }
               else
               {
                  this._resURL = this._info.styleID.toString() + "_b";
               }
            }
            else
            {
               this._resURL = this._info.styleID.toString() + "_" + this._info.form.toString();
            }
         }
         _arg_2.addChild(this);
         x = this._info.pos.x;
         y = this._info.pos.y;
         direction = Direction.indexToStr(this._info.dir);
         this.changeUI(this._resURL);
      }
      
      public function checkIsUp() : Boolean
      {
         var _local_1:uint = 0;
         var _local_2:Array = null;
         var _local_3:Array = null;
         var _local_4:uint = 0;
         var _local_5:uint = 0;
         var _local_6:int = 0;
         var _local_7:Boolean = true;
         if(this._info.form >= uint(FortressItemXMLInfo.getMaxLevel(this._info.id)))
         {
            return false;
         }
         if(this._info.id == 3 && this._info.form == 2)
         {
            return false;
         }
         if(this._info.isUsed)
         {
            if(this._info.form == 1)
            {
               _local_1 = uint(this._info.res.getValues()[0]);
               if(_local_1 < 5000)
               {
                  _local_7 = false;
               }
            }
            else
            {
               _local_2 = this._info.res.getValues();
               _local_3 = FortressItemXMLInfo.getResMaxs(this._info.id,this._info.form);
               _local_6 = 0;
               while(_local_6 < 4)
               {
                  _local_4 += _local_2[_local_6];
                  _local_5 += _local_3[_local_6];
                  _local_6++;
               }
               if(_local_4 < _local_5)
               {
                  _local_7 = false;
               }
            }
         }
         else
         {
            _local_7 = false;
         }
         return _local_7;
      }
      
      public function showUpMark() : void
      {
         var _local_1:Rectangle = null;
         if(MapManager.currentMap.id == MainManager.actorInfo.teamInfo.id)
         {
            this._markMc = TaskIconManager.getIcon("EquipUpMarkMc") as MovieClip;
            this._markMc.scaleY = 0.6;
            this._markMc.scaleX = 0.6;
            this._markMc.gotoAndPlay(1);
            _local_1 = this.getRect(this._content);
            this._markMc.y = _local_1.y - this._markMc.height;
            this._markMc.x = -this._markMc.width / 2;
            addChild(this._markMc);
         }
      }
      
      public function hideUpMark() : void
      {
         if(Boolean(this._markMc))
         {
            if(DisplayUtil.hasParent(this._markMc))
            {
               this.removeChild(this._markMc);
               this._markMc = null;
            }
         }
      }
      
      public function hide() : void
      {
         this.dragEnabled = false;
         DisplayUtil.removeForParent(this);
      }
      
      override public function destroy() : void
      {
         this.hide();
         super.destroy();
         if(this._resURL != "")
         {
            ResourceManager.cancel(ClientConfig.getArmItem(this._resURL),this.onLoadRes);
         }
         if(Boolean(this.funID))
         {
            ResourceManager.cancel(ClientConfig.getAppExtSwf(this.funID.toString()),this.onLoadUnit);
         }
         if(Boolean(this._unit))
         {
            this._unit.destroy();
            this._unit = null;
         }
         if(Boolean(this._content))
         {
            this._content.removeEventListener(Event.ADDED_TO_STAGE,this.onADDStage);
            this._content = null;
         }
         TeamInfoController.destroy();
         this._info = null;
      }
      
      public function setSelect(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            filters = [new GlowFilter(16711680)];
         }
         else
         {
            filters = [];
         }
      }
      
      public function setBufForInfo(_arg_1:ArmInfo) : void
      {
         this._info.pos = _arg_1.pos;
         this._info.dir = _arg_1.dir;
         this._info.status = _arg_1.status;
         x = this._info.pos.x;
         y = this._info.pos.y;
         direction = Direction.indexToStr(this._info.dir);
         this.changeDir();
      }
      
      public function setFormUpDate(_arg_1:uint) : void
      {
         if(this._info.form >= _arg_1)
         {
            return;
         }
         this._info.form = _arg_1;
         if(Boolean(this._resURL))
         {
            ResourceManager.cancel(ClientConfig.getArmItem(this._resURL),this.onLoadRes);
         }
         this.changeUI(this._info.styleID.toString() + "_" + this._info.form.toString());
      }
      
      public function setWork(_arg_1:uint, _arg_2:uint) : void
      {
         if(this._info.form != 1)
         {
            return;
         }
         if(this._info.resNum != 0)
         {
            return;
         }
         this._info.workCount = _arg_1;
         this._info.resNum = _arg_2;
         if(Boolean(this._resURL))
         {
            ResourceManager.cancel(ClientConfig.getArmItem(this._resURL),this.onLoadRes);
         }
         this.changeUI(this._info.styleID.toString() + "_b");
      }
      
      public function changeUI(_arg_1:String) : void
      {
         if(Boolean(this._unit))
         {
            this._unit.destroy();
            this._unit = null;
         }
         if(Boolean(this._content))
         {
            this._content.removeEventListener(Event.ADDED_TO_STAGE,this.onADDStage);
            DisplayUtil.removeForParent(this._content);
            this._content = null;
         }
         this._resURL = _arg_1;
         ResourceManager.getResource(ClientConfig.getArmItem(this._resURL),this.onLoadRes);
      }
      
      private function changeDir() : void
      {
         if(this._content is MovieClip)
         {
            if(MovieClip(this._content).totalFrames == 1)
            {
               if(this._info.dir == SolidDir.DIR_LEFT)
               {
                  this._content.scaleX = 1;
               }
               else if(this._info.dir == SolidDir.DIR_RIGHT)
               {
                  this._content.scaleX = -1;
               }
            }
            else if(this._info.dir == SolidDir.DIR_LEFT)
            {
               MovieClip(this._content).gotoAndStop(1);
            }
            else if(this._info.dir == SolidDir.DIR_RIGHT)
            {
               MovieClip(this._content).gotoAndStop(2);
            }
            else if(this._info.dir == SolidDir.DIR_BUTTOM)
            {
               MovieClip(this._content).gotoAndStop(3);
            }
            else if(this._info.dir == SolidDir.DIR_TOP)
            {
               MovieClip(this._content).gotoAndStop(4);
            }
         }
         else if(this._info.dir == SolidDir.DIR_LEFT)
         {
            this._content.scaleX = 1;
         }
         else if(this._info.dir == SolidDir.DIR_RIGHT)
         {
            this._content.scaleX = -1;
         }
      }
      
      private function onLoadRes(_arg_1:DisplayObject) : void
      {
         var _local_2:Boolean = false;
         this._content = _arg_1 as Sprite;
         this._content.addEventListener(Event.ADDED_TO_STAGE,this.onADDStage);
         addChild(this._content);
         if(this.checkIsUp())
         {
            this.showUpMark();
         }
         if(this._info.buyTime == 0)
         {
            this.funID = ItemXMLInfo.getFunID(this._info.id);
         }
         else
         {
            this.funID = FortressItemXMLInfo.getFunID(this._info.id);
         }
         if(this.funID != 0)
         {
            if(this._info.buyTime == 0)
            {
               _local_2 = ItemXMLInfo.getFunIsCom(this._info.id);
            }
            else
            {
               _local_2 = FortressItemXMLInfo.getFunIsCom(this._info.id);
            }
            if(_local_2)
            {
               this._content.buttonMode = true;
               ResourceManager.getResource(ClientConfig.getAppExtSwf(this.funID.toString()),this.onLoadUnit,"");
            }
            else if(MainManager.actorInfo.teamInfo.id == MainManager.actorInfo.mapID)
            {
               this._content.buttonMode = true;
               ResourceManager.getResource(ClientConfig.getAppExtSwf(this.funID.toString()),this.onLoadUnit,"");
            }
            else
            {
               this._content.mouseEnabled = false;
               this._content.mouseChildren = false;
            }
         }
         else
         {
            this._content.mouseEnabled = false;
         }
         this.changeDir();
         if(MainManager.actorInfo.teamInfo.id == MainManager.actorInfo.mapID)
         {
            if(!this.funID)
            {
               addEventListener(MouseEvent.CLICK,this.onPanelClick);
            }
         }
         else
         {
            mouseEnabled = false;
            buttonMode = false;
         }
      }
      
      private function onLoadUnit(_arg_1:DisplayObject) : void
      {
         this._unit = _arg_1 as IFunUnit;
         this._unit.setup(this._content);
         this._unit.init(this._info);
      }
      
      private function onADDStage(_arg_1:Event) : void
      {
         this._content.removeEventListener(Event.ADDED_TO_STAGE,this.onADDStage);
         DepthManager.swapDepth(this,y);
      }
      
      private function onKeyDown(_arg_1:KeyboardEvent) : void
      {
         var _local_2:uint = 0;
         if(Boolean(this._content))
         {
            if(_arg_1.keyCode == Keyboard.LEFT)
            {
               _local_2 = SolidDir.DIR_LEFT;
            }
            else if(_arg_1.keyCode == Keyboard.RIGHT)
            {
               _local_2 = SolidDir.DIR_RIGHT;
            }
            else if(_arg_1.keyCode == Keyboard.DOWN)
            {
               if(this._content is MovieClip)
               {
                  if(MovieClip(this._content).totalFrames >= 3)
                  {
                     _local_2 = SolidDir.DIR_BUTTOM;
                  }
               }
            }
            else if(_arg_1.keyCode == Keyboard.UP)
            {
               if(this._content is MovieClip)
               {
                  if(MovieClip(this._content).totalFrames >= 4)
                  {
                     _local_2 = SolidDir.DIR_TOP;
                  }
               }
            }
            if(_local_2 != this._info.dir)
            {
               this._info.dir = _local_2;
               this.changeDir();
               ArmManager.setIsChange(this._info);
            }
         }
      }
      
      private function onPanelClick(_arg_1:MouseEvent) : void
      {
         TeamInfoController.start(this._info);
      }
   }
}

