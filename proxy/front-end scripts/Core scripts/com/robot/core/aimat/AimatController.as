package com.robot.core.aimat
{
   import com.robot.core.config.xml.AimatXMLInfo;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.AimatUIManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.utils.Direction;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashSet;
   import org.taomee.manager.CursorManager;
   
   public class AimatController
   {
      
      public static var type:uint;
      
      private static var itemID:uint;
      
      private static var _instance:EventDispatcher;
      
      private static var _isAllow:Boolean = true;
      
      private static var _list:HashSet = new HashSet();
      
      public function AimatController()
      {
         super();
      }
      
      public static function addAimat(_arg_1:IAimat) : void
      {
         _list.add(_arg_1);
      }
      
      public static function removeAimat(_arg_1:IAimat) : void
      {
         _list.remove(_arg_1);
      }
      
      public static function destroy() : void
      {
         _list.each2(function(_arg_1:IAimat):void
         {
            _arg_1.destroy();
            _arg_1 = null;
         });
         _list.clear();
      }
      
      public static function start(_itemID:uint) : void
      {
         if(!_isAllow)
         {
            return;
         }
         _isAllow = false;
         itemID = _itemID;
         setTimeout(function():void
         {
            _isAllow = true;
         },1000);
         dispatchEvent(AimatEvent.OPEN,new AimatInfo(type,MainManager.actorID));
         CursorManager.setCursor(UIManager.getSprite("Cursor_AimatSkin"));
         LevelManager.mapLevel.mouseChildren = false;
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
         LevelManager.mapLevel.addEventListener(MouseEvent.CLICK,onClick);
      }
      
      public static function close() : void
      {
         CursorManager.removeCursor();
         LevelManager.mapLevel.mouseChildren = true;
         LevelManager.mapLevel.removeEventListener(MouseEvent.CLICK,onClick);
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
         dispatchEvent(AimatEvent.CLOSE,new AimatInfo(type,MainManager.actorID));
      }
      
      public static function setClothType(_arg_1:Array) : void
      {
         type = AimatXMLInfo.getType(_arg_1);
      }
      
      public static function getResEffect(_arg_1:uint, _arg_2:String = "") : MovieClip
      {
         return AimatUIManager.getMovieClip("Aimat_Effect_" + _arg_1.toString() + _arg_2);
      }
      
      public static function getResSound(_arg_1:uint, _arg_2:String = "") : Sound
      {
         return AimatUIManager.getSound("Aimat_Sound_" + _arg_1.toString() + _arg_2);
      }
      
      public static function getResState(_arg_1:uint, _arg_2:String = "") : MovieClip
      {
         return AimatUIManager.getMovieClip("Aimat_State_" + _arg_1.toString() + _arg_2);
      }
      
      private static function onMove(_arg_1:MouseEvent) : void
      {
         MainManager.actorModel.direction = Direction.getStr(MainManager.actorModel.pos,new Point(LevelManager.stage.mouseX,LevelManager.stage.mouseY));
      }
      
      private static function onClick(_arg_1:MouseEvent) : void
      {
         close();
         MainManager.actorModel.aimatAction(itemID,type,new Point(LevelManager.mapLevel.mouseX,LevelManager.mapLevel.mouseY));
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
      }
      
      public static function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         getInstance().addEventListener(_arg_1,_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public static function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         getInstance().removeEventListener(_arg_1,_arg_2,_arg_3);
      }
      
      public static function dispatchEvent(_arg_1:String, _arg_2:AimatInfo) : void
      {
         getInstance().dispatchEvent(new AimatEvent(_arg_1,_arg_2));
      }
      
      public static function hasEventListener(_arg_1:String) : Boolean
      {
         return getInstance().hasEventListener(_arg_1);
      }
      
      public static function willTrigger(_arg_1:String) : Boolean
      {
         return getInstance().willTrigger(_arg_1);
      }
   }
}

