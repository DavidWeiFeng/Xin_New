package com.robot.core.ui.alert2
{
   import com.robot.core.manager.alert.AlertInfo;
   import flash.display.SimpleButton;
   import flash.events.*;
   
   public class Alert extends BaseAlert
   {
      
      private var _cancelBtn:SimpleButton;
      
      public function Alert(_arg_1:AlertInfo)
      {
         super(_arg_1,"AlertMC");
         this._cancelBtn = _sprite["cancelBtn"];
      }
      
      override public function show() : void
      {
         super.show();
         this._cancelBtn.addEventListener(MouseEvent.CLICK,onCancel);
      }
      
      override public function hide() : void
      {
         super.hide();
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,onCancel);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._cancelBtn = null;
      }
   }
}

