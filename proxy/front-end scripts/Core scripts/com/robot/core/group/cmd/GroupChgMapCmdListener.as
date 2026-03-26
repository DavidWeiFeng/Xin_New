package com.robot.core.group.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.group.info.GroupChgMapInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class GroupChgMapCmdListener extends BaseBeanController
   {
      
      private var _trsfInfoList:Array = [];
      
      private var _cancelInfoList:Array = [];
      
      public function GroupChgMapCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.GROUP_CHANGE_MAP,this.onGroupChgMap);
         finish();
      }
      
      private function onGroupChgMap(param1:SocketEvent) : void
      {
         var _loc2_:GroupChgMapInfo = param1.data as GroupChgMapInfo;
         if(MapManager.currentMap.id != _loc2_.mapID)
         {
            MapManager.getMapController().changeMap(_loc2_.mapID);
         }
      }
   }
}

