package com.robot.core.controller
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import org.taomee.utils.*;
   
   public class MouseController
   {
      
      private static var _mouseTxt:TextField;
      
      public static var CanMove:Boolean = true;
      
      public function MouseController()
      {
         super();
      }
      
      public static function addMouseEvent() : void
      {
         MapManager.currentMap.spaceLevel.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      public static function removeMouseEvent() : void
      {
         MapManager.currentMap.spaceLevel.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      private static function showMouseXY() : void
      {
         if(_mouseTxt == null)
         {
            _mouseTxt = new TextField();
            _mouseTxt.autoSize = TextFieldAutoSize.LEFT;
            _mouseTxt.mouseEnabled = false;
            LevelManager.stage.addChild(_mouseTxt);
         }
      }
      
      private static function upDateTxt() : void
      {
         var _local_2:int = 0;
         var _local_1:int = LevelManager.stage.mouseX;
         _local_2 = LevelManager.stage.mouseY;
         _mouseTxt.x = _local_1 + 15;
         _mouseTxt.y = _local_2 + 5;
         _mouseTxt.text = MainManager.actorInfo.mapID.toString() + " / " + _local_1.toString() + "," + _local_2.toString();
      }
      
      private static function onMouseDown(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = null;
         _local_2 = null;
         var _local_3:Point = new Point(_arg_1.currentTarget.mouseX,_arg_1.currentTarget.mouseY);
         MapConfig.delEnterFrame();
         MainManager.actorModel.walkAction(_local_3);
         LevelManager.stage.focus = LevelManager.stage;
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_MOUSE_DOWN,MapManager.currentMap));
         _local_2 = UIManager.getMovieClip("Effect_MouseDown");
         _local_2.mouseEnabled = false;
         _local_2.mouseChildren = false;
         MovieClipUtil.playEndAndRemove(_local_2);
         _local_2.x = _local_3.x;
         _local_2.y = _local_3.y;
         LevelManager.mapLevel.addChild(_local_2);
      }
      
      private static function onMouseMove(_arg_1:MouseEvent) : void
      {
         _arg_1.updateAfterEvent();
      }
   }
}

