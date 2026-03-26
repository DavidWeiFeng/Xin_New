package com.robot.core.effect
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   
   public class GlowTween
   {
      
      private var _target:InteractiveObject;
      
      private var _color:uint;
      
      private var _toggle:Boolean;
      
      private var _blur:Number;
      
      public function GlowTween(_arg_1:InteractiveObject, _arg_2:uint = 16777215, _arg_3:Boolean = false)
      {
         super();
         this._target = _arg_1;
         this._color = _arg_2;
         this._toggle = true;
         this._blur = 2;
         if(_arg_3)
         {
            this.startGlowHandler();
         }
         else
         {
            _arg_1.addEventListener(MouseEvent.ROLL_OVER,this.startGlowHandler);
            _arg_1.addEventListener(MouseEvent.ROLL_OUT,this.stopGlowHandler);
         }
      }
      
      public function remove() : void
      {
         this._target.removeEventListener(MouseEvent.ROLL_OVER,this.startGlowHandler);
         this._target.removeEventListener(MouseEvent.ROLL_OUT,this.stopGlowHandler);
         this._target.removeEventListener(Event.ENTER_FRAME,this.blinkHandler);
         this._target.filters = null;
         this._target = null;
      }
      
      public function startGlowHandler(_arg_1:MouseEvent = null) : void
      {
         this._target.addEventListener(Event.ENTER_FRAME,this.blinkHandler,false,0,true);
      }
      
      public function stopGlowHandler(_arg_1:MouseEvent = null) : void
      {
         this._target.removeEventListener(Event.ENTER_FRAME,this.blinkHandler);
         this._target.filters = null;
      }
      
      private function blinkHandler(_arg_1:Event) : void
      {
         if(this._blur >= 30)
         {
            this._toggle = false;
         }
         else if(this._blur <= 2)
         {
            this._toggle = true;
         }
         if(this._toggle)
         {
            ++this._blur;
         }
         else
         {
            --this._blur;
         }
         var _local_2:GlowFilter = new GlowFilter(this._color,1,this._blur,this._blur,2,2);
         this._target.filters = [_local_2];
      }
   }
}

