package com.robot.app.ogre
{
   import com.robot.app.fightNote.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.ui.alert.*;
   import flash.events.Event;
   import flash.geom.*;
   import org.taomee.ds.*;
   
   public class BossController
   {
      
      private static var _list:HashMap;
      
      private static var _currObj:BossModel;
      
      private static var D_MAX:int = 60;
      
      private static var _isSwitching:Boolean = false;
      
      private static var _idList:HashMap = new HashMap();
      
      public function BossController()
      {
         super();
      }
      
      public static function getRegion(_arg_1:uint) : uint
      {
         return _idList.getValue(_arg_1);
      }
      
      public static function add(id:uint, region:uint, hp:uint, pos:int) : void
      {
         var _local_5:Class = null;
         var _local_6:BossModel = null;
         var _local_7:BossModel = null;
         if(_isSwitching)
         {
            return;
         }
         if(_list == null)
         {
            _list = new HashMap();
            MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitchOpen);
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
            MapManager.addEventListener(MapEvent.MAP_DESTROY,onMapSwitchOpen);
            MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,onMapDown);
         }
         _idList = new HashMap();
         _idList.add(id,region);
         var _local_8:Array = OgreXMLInfo.getBossList(MainManager.actorInfo.mapID,region);
         if(Boolean(_local_8))
         {
            if(pos >= _local_8.length)
            {
               return;
            }
            if(_list.containsKey(region))
            {
               _local_6 = _list.getValue(region) as BossModel;
               if(Boolean(_local_6))
               {
                  if(_local_6.id == id)
                  {
                     _local_6.show(_local_8[pos],hp);
                     return;
                  }
                  _local_6.removeEventListener(RobotEvent.OGRE_CLICK,onClick);
                  _local_6.destroy();
                  _local_6 = null;
               }
            }
            _local_5 = PetXMLInfo.getClass(id);
            if(_local_5 == null)
            {
               _local_5 = BossModel;
            }
            if(Boolean(_local_5))
            {
               _local_7 = new _local_5(id,region);
               _local_7.addEventListener(RobotEvent.OGRE_CLICK,onClick);
               _list.add(region,_local_7);
               _local_7.show(_local_8[pos],hp);
            }
         }
      }
      
      public static function remove(_arg_1:uint) : void
      {
         if(_list == null)
         {
            return;
         }
         var _local_2:BossModel = _list.remove(_arg_1) as BossModel;
         if(Boolean(_local_2))
         {
            _local_2.removeEventListener(RobotEvent.OGRE_CLICK,onClick);
            _local_2.destroy();
            _local_2 = null;
         }
      }
      
      public static function destroy() : void
      {
         var _local_1:BossModel = null;
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
      }
      
      private static function startFight(_arg_1:BossModel) : Boolean
      {
         var _local_2:Array = null;
         var _local_3:PetInfo = null;
         if(Point.distance(_arg_1.pos,MainManager.actorModel.pos) < D_MAX)
         {
            if(PetManager.length == 0)
            {
               Alarm.show("你没有可出战的精灵哦");
               return true;
            }
            _local_2 = PetManager.infos;
            for each(_local_3 in _local_2)
            {
               if(_local_3.hp > 0)
               {
                  MainManager.actorModel.stop();
                  LevelManager.closeMouseEvent();
                  if(_arg_1.id == 219)
                  {
                     FightInviteManager.fightWithBoss("依卢",219);
                     return true;
                  }
                  FightInviteManager.fightWithBoss("蘑菇怪");
                  return true;
               }
            }
            Alarm.show("你没有可出战的精灵哦");
            return true;
         }
         return false;
      }
      
      private static function onClick(_arg_1:RobotEvent) : void
      {
         _currObj = _arg_1.currentTarget as BossModel;
         if(_currObj.hp <= 0)
         {
            if(startFight(_currObj))
            {
               _currObj = null;
               return;
            }
         }
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,onEnter);
         MainManager.actorModel.walkAction(_currObj.pos);
      }
      
      private static function onEnter(_arg_1:Event) : void
      {
         if(Boolean(_currObj))
         {
            if(_currObj.hp <= 0)
            {
               if(startFight(_currObj))
               {
                  _currObj = null;
                  onMapDown(null);
                  return;
               }
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

