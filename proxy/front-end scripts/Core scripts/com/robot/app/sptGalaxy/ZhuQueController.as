package com.robot.app.sptGalaxy
{
   import com.robot.core.animate.*;
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.npc.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import org.taomee.manager.*;
   
   public class ZhuQueController
   {
      
      private static var _door:MovieClip;
      
      private static var _mapIndex:int;
      
      private static var _spt:Array = [323,325,326];
      
      private static var _map:Array = [404,424,429,435,437,439,481,459];
      
      private static var _pos:Array = [[340,320],[620,330],[840,300],[140,400],[420,340],[140,340],[500,170],[80,280]];
      
      public function ZhuQueController()
      {
         super();
      }
      
      public static function setup() : void
      {
         _mapIndex = int(Math.random() * _map.length);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapOpenHandler);
      }
      
      private static function onMapOpenHandler(param1:MapEvent) : void
      {
         var event:MapEvent = param1;
         if(event.mapModel.id == _map[_mapIndex])
         {
            if(SystemTimerManager.sysDate.getMinutes() >= 40 && SystemTimerManager.sysDate.getMinutes() < 50)
            {
               ResourceManager.getResource(ClientConfig.getAppRes("GuardBeastPortal"),function(_arg_1:DisplayObject):void
               {
                  _door = _arg_1 as MovieClip;
                  _door.x = _pos[_mapIndex][0];
                  _door.y = _pos[_mapIndex][1];
                  _door.buttonMode = true;
                  _door["mc"].gotoAndStop(1);
                  _door.addEventListener(MouseEvent.CLICK,onDoorClick);
                  ToolTipManager.add(_door,"朱雀空间传送阵");
                  MapManager.currentMap.controlLevel.addChild(_door);
               },"SptGalaxyDoor_UI");
            }
         }
      }
      
      private static function onDoorClick(_arg_1:MouseEvent) : void
      {
         MainManager.actorModel.walkAction(new Point(_door.x,_door.y));
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,onWalkEnterFrame);
      }
      
      private static function onWalkEnterFrame(_arg_1:RobotEvent) : void
      {
         if(Point.distance(MainManager.actorModel.pos,new Point(_door.x,_door.y)) < 10)
         {
            MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,onWalkEnterFrame);
            MainManager.actorModel.stop();
            check();
         }
      }
      
      public static function check(param1:Boolean = false) : void
      {
         var b:Boolean = param1;
         if(b || isReady())
         {
            NpcDialog.show(NPC.KONGJIANSHIZHE,["我是空间使者，朱雀空间是裂空星系最神秘的地方，你已具备了进入空间的实力，我现在可以让你传送过去。"],["我决定进去一探究竟。","我还是下次再来吧。"],[function():void
            {
               if(Boolean(_door))
               {
                  AnimateManager.playMcAnimate(_door,1,"mc",function():void
                  {
                     enter();
                  });
               }
               else
               {
                  enter();
               }
            }]);
         }
         else
         {
            NpcDialog.show(NPC.KONGJIANSHIZHE,["我是空间使者，朱雀空间是裂空星系最神秘的地方，你只有战胜了0xff0000德拉萨，卡修斯0xffffff和0xff0000迪符特0xffffff，我才会让你进去。"],["我还是下次再来吧。"]);
         }
      }
      
      private static function enter() : void
      {
         MapManager.changeMap(318);
      }
      
      private static function isReady() : Boolean
      {
         var _local_2:int = 0;
         var _local_1:int = int(_spt.length);
         while(_local_2 < _local_1)
         {
            if(TasksManager.getTaskStatus(_spt[_local_2]) != TasksManager.COMPLETE)
            {
               return false;
            }
            _local_2++;
         }
         return true;
      }
      
      private static function onMapDestroyHandler(_arg_1:MapEvent) : void
      {
         if(_door != null)
         {
            _door.removeEventListener(MouseEvent.CLICK,onDoorClick);
            ToolTipManager.remove(_door);
            _door = null;
            MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,onWalkEnterFrame);
         }
      }
   }
}

