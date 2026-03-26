package com.robot.app.RegisterCode
{
   import com.robot.core.manager.*;
   import flash.display.SimpleButton;
   import flash.events.*;
   
   public class RegisterCodeIcon
   {
      
      private static var _regCodeIcon:SimpleButton;
      
      public function RegisterCodeIcon()
      {
         super();
      }
      
      public static function show() : void
      {
         if(TasksManager.taskList[0] == 3)
         {
            _regCodeIcon = UIManager.getButton("regCode_Icon");
            TaskIconManager.addIcon(_regCodeIcon);
            _regCodeIcon.addEventListener(MouseEvent.CLICK,onShowCodePanel);
         }
      }
      
      private static function onShowCodePanel(_arg_1:MouseEvent) : void
      {
         CopyRegisterCodePanel.loadPanel();
      }
   }
}

