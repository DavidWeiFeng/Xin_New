package com.robot.core.manager
{
   import com.robot.core.*;
   import com.robot.core.controller.*;
   import com.robot.core.event.*;
   import com.robot.core.mode.MapModel;
   import com.robot.core.net.*;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.manager.*;
   
   [Event(name="mapMouseDown",type="com.robot.core.event.MapEvent")]
   [Event(name="mapSwitchOpen",type="com.robot.core.event.MapEvent")]
   [Event(name="mapSwitchComplete",type="com.robot.core.event.MapEvent")]
   [Event(name="mapLoaderOpen",type="com.robot.core.event.MapEvent")]
   [Event(name="mapLoaderClose",type="com.robot.core.event.MapEvent")]
   [Event(name="mapLoaderComplete",type="com.robot.core.event.MapEvent")]
   [Event(name="mapInit",type="com.robot.core.event.MapEvent")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   public class MapManager
   {
      
      public static var currentMap:MapModel;
      
      public static var styleID:uint;
      
      public static var initPos:Point;
      
      public static var prevMapID:uint;
      
      public static var isInMap:Boolean;
      
      private static var _mapType:uint;
      
      private static var _mapController:MapController;
      
      private static var instance:EventDispatcher;
      
      public static const FRESH_TRIALS:uint = 600;
      
      public static const TOWER_MAP:uint = 500;
      
      public static const ID_MAX:uint = 10000;
      
      public static const TYPE_MAX:uint = 200;
      
      public static const defaultID:uint = 1;
      
      public static const defaultRoomStyleID:uint = 500001;
      
      public static const defaultArmStyleID:uint = 800001;
      
      public static var type:int = ConnectionType.MAIN;
      
      public static var DESTROY_SWITCH:Boolean = true;
      
      setup();
      
      public function MapManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         getMapController();
         EventManager.addEventListener(PetFightEvent.ALARM_CLICK,onFightClose);
      }
      
      private static function onFightClose(_arg_1:PetFightEvent) : void
      {
         if(!DESTROY_SWITCH)
         {
            SocketConnection.send(CommandID.LIST_MAP_PLAYER);
         }
      }
      
      public static function getMapController() : MapController
      {
         if(_mapController == null)
         {
            _mapController = new MapController();
         }
         return _mapController;
      }
      
      public static function getResMapID(_arg_1:uint) : uint
      {
         if(_arg_1 > MapManager.ID_MAX)
         {
            return styleID;
         }
         return _arg_1;
      }
      
      public static function changeMap(_arg_1:int, _arg_2:int = 0, _arg_3:uint = 0) : void
      {
         var _local_4:* = getDefinitionByName("com.robot.app.task.noviceGuide.CheckGuideTaskStatus");
         if(Boolean(_local_4.check(_arg_1)))
         {
            _mapType = _arg_3;
            getMapController().changeMap(_arg_1,_arg_2,_arg_3);
         }
      }
      
      public static function changeLocalMap(_arg_1:uint) : void
      {
         getMapController().changeLocalMap(_arg_1);
      }
      
      public static function refMap(_arg_1:Boolean = true) : void
      {
         if(DESTROY_SWITCH)
         {
            getMapController().refMap(_arg_1);
         }
      }
      
      public static function destroy() : void
      {
         if(DESTROY_SWITCH)
         {
            getMapController().destroy();
         }
      }
      
      public static function getObjectsPointRect(_arg_1:Point, _arg_2:Number = 10, _arg_3:Array = null) : Array
      {
         var _local_4:Array = null;
         var _local_5:DisplayObject = null;
         var _local_6:Class = null;
         var _local_9:int = 0;
         if(!isInMap)
         {
            return _local_4;
         }
         var _local_7:DisplayObjectContainer = currentMap.depthLevel;
         var _local_8:int = _local_7.numChildren;
         _local_4 = [];
         while(_local_9 < _local_8)
         {
            _local_5 = _local_7.getChildAt(_local_9);
            if(_arg_3 == null)
            {
               if(Point.distance(new Point(_local_5.x,_local_5.y),_arg_1) < _arg_2)
               {
                  _local_4.push(_local_5);
               }
            }
            else
            {
               for each(_local_6 in _arg_3)
               {
                  if(_local_5 is _local_6)
                  {
                     if(Point.distance(new Point(_local_5.x,_local_5.y),_arg_1) < _arg_2)
                     {
                        _local_4.push(_local_5);
                     }
                     break;
                  }
               }
            }
            _local_9++;
         }
         return _local_4;
      }
      
      public static function getObjectPoint(_arg_1:Point, _arg_2:Array = null) : DisplayObject
      {
         var _local_3:DisplayObject = null;
         var _local_4:Class = null;
         if(!isInMap)
         {
            return null;
         }
         var _local_5:DisplayObjectContainer = currentMap.depthLevel;
         var _local_6:int = _local_5.numChildren - 1;
         var _local_7:int = _local_6;
         while(_local_7 >= 0)
         {
            _local_3 = _local_5.getChildAt(_local_7);
            if(_arg_2 == null)
            {
               if(_local_3.hitTestPoint(_arg_1.x,_arg_1.y))
               {
                  return _local_3;
               }
            }
            else
            {
               for each(_local_4 in _arg_2)
               {
                  if(_local_3 is _local_4)
                  {
                     if(_local_3.hitTestPoint(_arg_1.x,_arg_1.y))
                     {
                        return _local_3;
                     }
                     break;
                  }
               }
            }
            _local_7--;
         }
         return null;
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            instance = new EventDispatcher();
         }
         return instance;
      }
      
      public static function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         getInstance().addEventListener(_arg_1,_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public static function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         getInstance().removeEventListener(_arg_1,_arg_2,_arg_3);
      }
      
      public static function dispatchEvent(_arg_1:Event) : void
      {
         if(hasEventListener(_arg_1.type))
         {
            getInstance().dispatchEvent(_arg_1);
         }
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

