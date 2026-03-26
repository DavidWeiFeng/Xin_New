package com.robot.core.ui.alert2
{
   import com.robot.core.manager.*;
   import com.robot.core.manager.alert.AlertInfo;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class BaseAlert extends EventDispatcher implements IAlert
   {
      
      protected var _info:AlertInfo;
      
      protected var _sprite:Sprite;
      
      protected var _txt:TextField;
      
      protected var _icon:Sprite;
      
      protected var _applyBtn:SimpleButton;
      
      protected var _bgmc:Sprite;
      
      protected var _iconOfftX:Number = 0;
      
      protected var _iconOfftY:Number = 0;
      
      protected var _iconName:String;
      
      public function BaseAlert(_arg_1:AlertInfo, _arg_2:String, _arg_3:String = "item")
      {
         super();
         this._info = _arg_1;
         this._iconName = _arg_3;
         this._sprite = UIManager.getSprite(_arg_2);
         this._bgmc = this._sprite["bgMc"];
         this._applyBtn = this._sprite["applyBtn"];
         this._txt = this._sprite["txt"];
         this._txt.autoSize = TextFormatAlign.CENTER;
         this._txt.width = 265;
         this._txt.htmlText = this._info.str;
         if(this._info.iconURL == "" || this._info.iconURL == null)
         {
            DisplayUtil.align(this._txt,new Rectangle(40,60,265,90),AlignType.MIDDLE_CENTER);
         }
         else
         {
            DisplayUtil.align(this._txt,new Rectangle(40,60,265,90),AlignType.BOTTOM_CENTER);
         }
      }
      
      public function get info() : AlertInfo
      {
         return this._info;
      }
      
      public function get content() : Sprite
      {
         return this._sprite;
      }
      
      public function show() : void
      {
         if(Boolean(this._info.parant))
         {
            this._info.parant.addChild(this._sprite);
         }
         else
         {
            LevelManager.topLevel.addChild(this._sprite);
         }
         DisplayUtil.align(this._sprite,null,AlignType.MIDDLE_CENTER);
         this._bgmc.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._bgmc.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragUp);
         this._applyBtn.addEventListener(MouseEvent.CLICK,this.onApply);
         if(this._info.disMouse)
         {
            LevelManager.closeMouseEvent();
         }
         if(this._info.linkFun != null)
         {
            this._txt.addEventListener(TextEvent.LINK,this.onLink);
         }
         if(this._info.iconURL != "" || this._info.iconURL != null)
         {
            ResourceManager.getResource(this._info.iconURL,this.onLoadIcon,this._iconName);
         }
      }
      
      public function hide() : void
      {
         if(this._info.iconURL != "" || this._info.iconURL != null)
         {
            ResourceManager.cancel(this._info.iconURL,this.onLoadIcon);
         }
         this._bgmc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._bgmc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragUp);
         this._applyBtn.removeEventListener(MouseEvent.CLICK,this.onApply);
         this._txt.removeEventListener(TextEvent.LINK,this.onLink);
         DisplayUtil.removeForParent(this._sprite);
      }
      
      public function destroy() : void
      {
         this.hide();
         this._info = null;
         this._sprite = null;
         this._bgmc = null;
         this._applyBtn = null;
         this._txt = null;
         this._icon = null;
      }
      
      protected function onDragDown(_arg_1:MouseEvent) : void
      {
         this._sprite.startDrag();
      }
      
      protected function onDragUp(_arg_1:MouseEvent) : void
      {
         this._sprite.stopDrag();
      }
      
      protected function onApply(_arg_1:MouseEvent) : void
      {
         LevelManager.openMouseEvent();
         if(this._info.applyFun != null)
         {
            this._info.applyFun();
         }
         this.hide();
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      protected function onCancel(_arg_1:MouseEvent) : void
      {
         LevelManager.openMouseEvent();
         if(this._info.cancelFun != null)
         {
            this._info.cancelFun();
         }
         this.hide();
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      protected function onLink(_arg_1:TextEvent) : void
      {
         _arg_1.stopImmediatePropagation();
         if(this._info.linkFun != null)
         {
            this._info.linkFun(_arg_1);
         }
      }
      
      protected function onLoadIcon(_arg_1:DisplayObject) : void
      {
         this._icon = _arg_1 as Sprite;
         this._icon.mouseChildren = false;
         this._icon.mouseEnabled = false;
         this._sprite.addChild(this._icon);
         DisplayUtil.align(this._icon,new Rectangle(40 + this._iconOfftX,60 + this._iconOfftY,265,90),AlignType.TOP_CENTER);
         if(this._iconName != "item")
         {
            DisplayUtil.stopAllMovieClip(this._icon);
            this._icon.x = 100;
            this._icon.y = 100;
         }
      }
   }
}

