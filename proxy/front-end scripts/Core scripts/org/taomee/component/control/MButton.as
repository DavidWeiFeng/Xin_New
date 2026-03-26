package org.taomee.component.control
{
   import com.robot.core.manager.CoreAssetsManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextFormatAlign;
   import org.taomee.component.UIComponent;
   import org.taomee.component.event.ButtonEvent;
   import org.taomee.component.manager.MComponentManager;
   
   [Event(name="onRollOut",type="org.taomee.component.event.ButtonEvent")]
   [Event(name="onRollOver",type="org.taomee.component.event.ButtonEvent")]
   [Event(name="press",type="org.taomee.component.event.ButtonEvent")]
   [Event(name="release",type="org.taomee.component.event.ButtonEvent")]
   [Event(name="releaseOutside",type="org.taomee.component.event.ButtonEvent")]
   public class MButton extends UIComponent
   {
      
      protected var bg:MovieClip;
      
      protected var offSetY:uint = 1;
      
      private var defaultFilterColor:uint = 676248;
      
      private var oldY:Number;
      
      protected var isDown:Boolean = false;
      
      private var bgClass:Class = CoreAssetsManager.getClass("MButton_bgClass");
      
      protected var _label:MLabel;
      
      private var defaultTxtColor:uint = 16777215;
      
      public function MButton(_arg_1:String = "Button")
      {
         super();
         this.mouseChildren = false;
         this._label = new MLabel(_arg_1);
         this._label.mouseChildren = false;
         this._label.mouseEnabled = false;
         this.initUI();
         this.initHandler();
      }
      
      protected function press() : void
      {
         this._label.y = this.oldY;
         this.bg.gotoAndStop(3);
         dispatchEvent(new ButtonEvent(ButtonEvent.PRESS));
      }
      
      protected function release() : void
      {
         this._label.y = this.oldY - this.offSetY;
         this.bg.gotoAndStop(2);
         dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE));
      }
      
      private function downHandler(_arg_1:MouseEvent) : void
      {
         this.isDown = true;
         this.press();
      }
      
      override public function set width(_arg_1:Number) : void
      {
         super.width = _arg_1;
         this.label.width = _arg_1;
         this.bg.width = _arg_1;
      }
      
      override public function set height(_arg_1:Number) : void
      {
         super.height = _arg_1;
         this.label.y = (height - this.label.height) / 2;
         this.bg.height = _arg_1;
         this.oldY = this.label.y;
      }
      
      private function overHandler(_arg_1:MouseEvent) : void
      {
         if(this.isDown)
         {
            this.press();
         }
         else
         {
            this.mouseOver();
         }
      }
      
      protected function mouseOver() : void
      {
         this._label.y = this.oldY - this.offSetY;
         this.bg.gotoAndStop(2);
         dispatchEvent(new ButtonEvent(ButtonEvent.ON_ROLL_OVER));
      }
      
      public function set text(_arg_1:String) : void
      {
         this._label.text = _arg_1;
      }
      
      private function outHandler(_arg_1:MouseEvent) : void
      {
         if(this.isDown)
         {
            this.mouseOver();
         }
         else
         {
            this.mouseOut();
         }
      }
      
      protected function releaseOutside() : void
      {
         this._label.y = this.oldY;
         this.bg.gotoAndStop(1);
         dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE_OUTSIDE));
      }
      
      private function stageUpHandler(_arg_1:MouseEvent) : void
      {
         if(this.isDown)
         {
            this.releaseOutside();
         }
         this.isDown = false;
      }
      
      private function initHandler() : void
      {
         this.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
         this.addEventListener(MouseEvent.MOUSE_UP,this.upHandler);
         MComponentManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.stageUpHandler);
      }
      
      protected function mouseOut() : void
      {
         this._label.y = this.oldY;
         this.bg.gotoAndStop(1);
         dispatchEvent(new ButtonEvent(ButtonEvent.ON_ROLL_OUT));
      }
      
      protected function initUI() : void
      {
         this.bg = new this.bgClass();
         this.bg.gotoAndStop(1);
         addChild(this.bg);
         this._label.blod = true;
         this._label.align = TextFormatAlign.CENTER;
         this.label.textField.filters = [new GlowFilter(this.defaultFilterColor,0.8,4,4,10)];
         addChild(this._label);
         this.width = 65;
         this.height = 30;
         if(this._label.width > 65 - 20)
         {
            this.width = this._label.width + 20;
         }
         if(this._label.height > 30 - 4)
         {
            this.height = this._label.height + 4;
         }
         this.label.textColor = this.defaultTxtColor;
      }
      
      private function upHandler(_arg_1:MouseEvent) : void
      {
         if(this.isDown)
         {
            this.release();
         }
         this.isDown = false;
      }
      
      public function get label() : MLabel
      {
         return this._label;
      }
   }
}

