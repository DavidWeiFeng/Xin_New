package com.robot.app.im.talk
{
   import com.robot.core.event.MapEvent;
   import com.robot.core.manager.MapManager;
   import org.taomee.ds.HashMap;
   
   public class TalkPanelManager
   {
      
      private static var _list:HashMap = new HashMap();
      
      public function TalkPanelManager()
      {
         super();
      }
      
      public static function showTalkPanel(_arg_1:uint) : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         var _local_2:TalkPanel = getTalkPanel(_arg_1);
         if(_local_2 == null)
         {
            _local_2 = new TalkPanel();
            _list.add(_arg_1,_local_2);
            _local_2.show(_arg_1);
         }
      }
      
      public static function closeTalkPanel(_arg_1:uint) : void
      {
         var _local_2:TalkPanel = _list.remove(_arg_1) as TalkPanel;
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
         _list.eachValue(function(_arg_1:TalkPanel):void
         {
            _arg_1.destroy();
            _arg_1 = null;
         });
         _list.clear();
      }
      
      public static function getTalkPanel(_arg_1:uint) : TalkPanel
      {
         return _list.getValue(_arg_1) as TalkPanel;
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

