package com.robot.app.ogre
{
   import com.robot.app.fightNote.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.ui.alert.*;
   import flash.events.Event;
   import flash.geom.*;
   import org.taomee.ds.*;
   
   public class SpecialController
   {
      
      private static var _list:HashMap;
      
      private static var _pList:Array;
      
      private static var _currObj:OgreModel;
      
      private static var D_MAX:int = 40;
      
      private static var _isSwitching:Boolean = false;
      
      private static var b:Boolean = false;
      
      public function SpecialController()
      {
         super();
      }
      
      public static function add(_arg_1:int, _arg_2:uint) : void
      {
         var _local_3:OgreModel = null;
         if(_isSwitching)
         {
            return;
         }
         if(_list == null)
         {
            _pList = OgreXMLInfo.getSpecialList(MainManager.actorInfo.mapID);
            _list = new HashMap();
            MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitchOpen);
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
            MapManager.addEventListener(MapEvent.MAP_DESTROY,onMapSwitchOpen);
            MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,onMapDown);
         }
         if(_list.length > 3)
         {
            return;
         }
         if(_list.containsKey(_arg_1))
         {
            return;
         }
         if(Boolean(_pList))
         {
            _local_3 = _list.getValue(_arg_1) as OgreModel;
            if(Boolean(_local_3))
            {
               _local_3.removeEventListener(RobotEvent.OGRE_CLICK,onClick);
               _local_3.destroy();
               _local_3 = null;
            }
            _local_3 = new OgreModel(_arg_1);
            _local_3.addEventListener(RobotEvent.OGRE_CLICK,onClick);
            _list.add(_arg_1,_local_3);
            _local_3.show(_arg_2,_pList[_arg_1],null);
         }
      }
      
      public static function remove(_arg_1:int) : void
      {
         if(_list == null)
         {
            return;
         }
         var _local_2:OgreModel = _list.remove(_arg_1) as OgreModel;
         if(Boolean(_local_2))
         {
            _local_2.removeEventListener(RobotEvent.OGRE_CLICK,onClick);
            _local_2.destroy();
            _local_2 = null;
         }
      }
      
      public static function destroy() : void
      {
         var _local_1:OgreModel = null;
         MapManager.removeEventListener(MapEvent.MAP_MOUSE_DOWN,onMapDown);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,onEnter);
         var _local_2:Array = _list.getValues();
         for each(_local_1 in _local_2)
         {
            _local_1.removeEventListener(RobotEvent.OGRE_CLICK,onClick);
            _local_1.destroy();
            _local_1 = null;
         }
         _list = null;
         _pList = null;
      }
      
      private static function startFight(_arg_1:OgreModel) : Boolean
      {
         var _local_2:Array = null;
         var _local_3:PetInfo = null;
         var _local_4:uint = 0;
         var _local_5:PetSkillInfo = null;
         if(Point.distance(_arg_1.pos,MainManager.actorModel.pos) < D_MAX)
         {
            if(PetManager.length == 0)
            {
               Alarm.show("你的背包里还没有一只赛尔精灵哦！");
               return true;
            }
            _local_2 = PetManager.infos;
            for each(_local_3 in _local_2)
            {
               _local_4 = 0;
               for each(_local_5 in _local_3.skillArray)
               {
                  _local_4 += _local_5.pp;
               }
               if(_local_3.hp > 0 && _local_4 > 0)
               {
                  MainManager.actorModel.stop();
                  LevelManager.closeMouseEvent();
                  FightInviteManager.fightWithSpecial();
                  return true;
               }
            }
            if(!b)
            {
               b = true;
               Alarm.show("你的赛尔精灵没有体力或不能使用技能了，不能出战哦！");
            }
         }
         return false;
      }
      
      private static function onClick(_arg_1:RobotEvent) : void
      {
         b = false;
         _currObj = _arg_1.currentTarget as OgreModel;
         if(startFight(_currObj))
         {
            _currObj = null;
            return;
         }
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,onEnter);
         MainManager.actorModel.walkAction(_currObj.pos);
      }
      
      private static function onEnter(_arg_1:Event) : void
      {
         if(Boolean(_currObj))
         {
            if(startFight(_currObj))
            {
               _currObj = null;
               onMapDown(null);
               return;
            }
         }
      }
      
      private static function onMapDown(_arg_1:MapEvent) : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,onEnter);
      }
      
      private static function onMapSwitchOpen(_arg_1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitchOpen);
         MapManager.removeEventListener(MapEvent.MAP_DESTROY,onMapSwitchOpen);
         _isSwitching = true;
         destroy();
      }
      
      private static function onMapSwitchComplete(_arg_1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
         _isSwitching = false;
      }
   }
}

