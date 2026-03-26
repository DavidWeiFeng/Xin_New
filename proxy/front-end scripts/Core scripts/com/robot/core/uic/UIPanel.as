package com.robot.core.uic
{
   import com.robot.core.manager.*;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class UIPanel extends Sprite
   {
      
      private var _dragBtn:SimpleButton;
      
      private var _closeBtn:SimpleButton;
      
      protected var _mainUI:Sprite;
      
      public function UIPanel(_arg_1:Sprite)
      {
         super();
         this._mainUI = _arg_1;
         this._dragBtn = this._mainUI["dragBtn"];
         this._closeBtn = this._mainUI["closeBtn"];
         addChild(this._mainUI);
      }
      
      protected function _show() : void
      {
         LevelManager.appLevel.addChild(this);
         this.addEvent();
      }
      
      public function hide() : void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this,false);
      }
      
      public function destroy() : void
      {
         this.hide();
         this._dragBtn = null;
         this._closeBtn = null;
         this._mainUI = null;
      }
      
      protected function addEvent() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
      }
      
      protected function removeEvent() : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         this._dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
      }
      
      private function onDragDown(_arg_1:MouseEvent) : void
      {
         DepthManager.bringToTop(this);
         startDrag();
      }
      
      private function onDragUp(_arg_1:MouseEvent) : void
      {
         stopDrag();
      }
      
      protected function onClose(_arg_1:MouseEvent) : void
      {
         this.hide();
         EventManager.dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function get closeBtn() : SimpleButton
      {
         return this._closeBtn;
      }
   }
}

