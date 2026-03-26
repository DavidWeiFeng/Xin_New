package com.robot.core.mode
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.manager.FitmentManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.utils.Direction;
   import com.robot.core.utils.SolidDir;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.ui.Keyboard;
   import org.taomee.manager.DepthManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.MovieClipUtil;
   
   public class FitmentModel extends SpriteModel
   {
      
      public var funID:uint;
      
      private var _info:FitmentInfo;
      
      protected var _dragEnabled:Boolean;
      
      private var _unit:IFunUnit;
      
      private var _content:Sprite;
      
      private var _enabledDir:Boolean = true;
      
      private var _enabedStatus:Boolean = true;
      
      public function FitmentModel()
      {
         super();
      }
      
      public function get info() : FitmentInfo
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
            if(this._enabledDir)
            {
               addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            }
         }
         else
         {
            removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
      }
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      public function show(_arg_1:FitmentInfo, _arg_2:DisplayObjectContainer) : void
      {
         if(Boolean(this._info))
         {
            ResourceManager.cancel(ClientConfig.getFitmentItem(this._info.id),this.onLoadRes);
         }
         this._info = _arg_1;
         this._enabedStatus = !ItemXMLInfo.getDisabledStatus(this._info.id);
         this._enabledDir = !ItemXMLInfo.getDisabledDir(this._info.id);
         _arg_2.addChild(this);
         x = this._info.pos.x;
         y = this._info.pos.y;
         direction = Direction.indexToStr(this._info.dir);
         if(Boolean(this._unit))
         {
            this._unit.destroy();
            this._unit = null;
         }
         if(Boolean(this._content))
         {
            this._content.removeEventListener(Event.ADDED_TO_STAGE,this.onADDStage);
            this._content.removeEventListener(MouseEvent.CLICK,this.onStatusClick);
            DisplayUtil.removeForParent(this._content);
            this._content = null;
         }
         ResourceManager.getResource(ClientConfig.getFitmentItem(this._info.id),this.onLoadRes);
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
         if(Boolean(this._info))
         {
            ResourceManager.cancel(ClientConfig.getFitmentItem(this._info.id),this.onLoadRes);
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
            this._content.removeEventListener(MouseEvent.CLICK,this.onStatusClick);
            this._content = null;
         }
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
      
      private function changeDir() : void
      {
         if(this._content is MovieClip)
         {
            if(MovieClip(this._content).totalFrames == 1)
            {
               if(this._info.dir == SolidDir.DIR_LEFT)
               {
                  this._content.scaleX = -1;
               }
               else if(this._info.dir == SolidDir.DIR_RIGHT)
               {
                  this._content.scaleX = 1;
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
            this._content.scaleX = -1;
         }
         else if(this._info.dir == SolidDir.DIR_RIGHT)
         {
            this._content.scaleX = 1;
         }
         MovieClipUtil.childStop(this._content,this._info.status + 1);
      }
      
      private function onLoadRes(_arg_1:DisplayObject) : void
      {
         var _local_2:Boolean = false;
         this._content = _arg_1 as Sprite;
         this._content.addEventListener(Event.ADDED_TO_STAGE,this.onADDStage);
         addChild(this._content);
         this.funID = ItemXMLInfo.getFunID(this._info.id);
         if(this.funID != 0)
         {
            _local_2 = ItemXMLInfo.getFunIsCom(this._info.id);
            if(_local_2)
            {
               this._content.buttonMode = true;
               ResourceManager.getResource(ClientConfig.getAppExtSwf(this.funID.toString()),this.onLoadUnit,"");
            }
            else if(MainManager.actorID == MainManager.actorInfo.mapID)
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
         if(this._enabedStatus)
         {
            this._content.addEventListener(MouseEvent.CLICK,this.onStatusClick);
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
               FitmentManager.isChange = true;
            }
         }
      }
      
      private function onStatusClick(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = null;
         var _local_3:Sprite = _arg_1.currentTarget as Sprite;
         if(Boolean(_local_3))
         {
            _local_2 = _local_3.getChildAt(0) as MovieClip;
            if(Boolean(_local_2))
            {
               if(_local_2.totalFrames < 2)
               {
                  return;
               }
               if(_local_2.currentFrame == 1)
               {
                  this._info.status = 1;
                  _local_2.gotoAndStop(2);
               }
               else
               {
                  this._info.status = 0;
                  _local_2.gotoAndStop(1);
               }
               if(MainManager.actorID == MainManager.actorInfo.mapID)
               {
                  FitmentManager.isChange = true;
                  FitmentManager.saveInfo();
               }
            }
         }
      }
   }
}

