package com.robot.app.im.talk
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.MapEvent;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.AppModel;
   import org.taomee.ds.HashMap;
   
   public class TeamChatPanelManager
   {
      
      private static var _list:HashMap;
      
      public function TeamChatPanelManager()
      {
         super();
      }
      
      public static function showTeamChatPanel(_arg_1:uint) : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         var _local_2:AppModel = getTeamChatPanel(_arg_1);
         if(_local_2 == null)
         {
            _local_2 = new AppModel(ClientConfig.getAppModule("TeamChatPanel"),"正在打开战队聊天");
            _list.add(_arg_1,_local_2);
            _local_2.init(_arg_1);
            _local_2.setup();
            _local_2.show();
         }
      }
      
      public static function closeTalkPanel(_arg_1:uint) : void
      {
         var _local_2:AppModel = _list.remove(_arg_1) as AppModel;
         if(Boolean(_local_2))
         {
            _local_2.destroy();
            _local_2 = null;
         }
         if(_list.length == 0)
         {
            MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         }
      }
      
      public static function closeAll() : void
      {
         _list.eachValue(function(_arg_1:AppModel):void
         {
            _arg_1.destroy();
            _arg_1 = null;
         });
         _list.clear();
      }
      
      public static function getTeamChatPanel(_arg_1:uint) : AppModel
      {
         return _list.getValue(_arg_1) as AppModel;
      }
      
      public static function isOpen(_arg_1:uint) : Boolean
      {
         return _list.containsKey(_arg_1);
      }
      
      private static function onMapOpen(_arg_1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         closeAll();
      }
   }
}

