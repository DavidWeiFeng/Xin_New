package com.robot.app.control
{
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.mode.AppModel;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import org.taomee.manager.ToolTipManager;
   
   public class GuoqingsignupController
   {
      
      private static var iconMc:MovieClip;
      
      private static var _so:SharedObject;
      
      private static var _panel:AppModel;
      
      public function GuoqingsignupController()
      {
         super();
      }
      
      public static function createIcon() : void
      {
         iconMc = UIManager.getMovieClip("icondianfeng");
         iconMc.scaleX = iconMc.scaleY = 0.7;
         iconMc.x = iconMc.y = 25;
         ToolTipManager.add(iconMc,"巅峰之战");
         TaskIconManager.addIcon(iconMc);
         iconMc.mouseEnabled = true;
         iconMc.addEventListener(MouseEvent.CLICK,onClickHandler);
      }
      
      private static function onClickHandler(_arg_1:MouseEvent) : void
      {
         MapManager.changeMap(402);
      }
      
      public static function delIcon() : void
      {
         TaskIconManager.delIcon(iconMc);
      }
   }
}

