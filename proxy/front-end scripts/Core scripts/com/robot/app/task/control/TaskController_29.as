package com.robot.app.task.control
{
   import com.robot.core.config.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   
   public class TaskController_29
   {
      
      private static var _iconMc:MovieClip;
      
      private static var _panel:AppModel;
      
      public function TaskController_29()
      {
         super();
      }
      
      public static function start() : void
      {
         if(TasksManager.getTaskStatus(29) == TasksManager.ALR_ACCEPT)
         {
            createIcon();
         }
      }
      
      public static function createIcon() : void
      {
         _iconMc = TaskIconManager.getIcon("Task29_Icon") as MovieClip;
         _iconMc.buttonMode = true;
         ToolTipManager.add(_iconMc,"健忘的大发明家肖恩");
         _iconMc.addEventListener(MouseEvent.CLICK,onClickHandler);
         TaskIconManager.addIcon(_iconMc);
      }
      
      private static function onClickHandler(_arg_1:MouseEvent) : void
      {
         _iconMc["mc"].gotoAndStop(1);
         showPanel();
      }
      
      public static function delIcon() : void
      {
         ToolTipManager.remove(_iconMc);
         _iconMc.removeEventListener(MouseEvent.CLICK,onClickHandler);
         TaskIconManager.delIcon(_iconMc);
         _iconMc = null;
         if(Boolean(_panel))
         {
            _panel.destroy();
            _panel = null;
         }
      }
      
      public static function showPanel() : void
      {
         if(!_panel)
         {
            _panel = new AppModel(ClientConfig.getTaskModule("ForgetfulShawnPanel"),"正在打开");
            _panel.setup();
         }
         _panel.show();
      }
   }
}

