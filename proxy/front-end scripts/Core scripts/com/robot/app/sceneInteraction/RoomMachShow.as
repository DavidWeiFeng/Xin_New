package com.robot.app.sceneInteraction
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class RoomMachShow
   {
      
      private var _nono:NonoModel;
      
      private var _info:NonoInfo;
      
      public function RoomMachShow(_arg_1:uint)
      {
         super();
         if(_arg_1 == MainManager.actorID)
         {
            NonoManager.addEventListener(NonoEvent.GET_INFO,this.onMyNonoInfo);
            NonoManager.getInfo(true);
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.NONO_INFO,this.onNonoInfo);
            SocketConnection.send(CommandID.NONO_INFO,_arg_1);
         }
         NonoManager.addEventListener(NonoEvent.FOLLOW,this.onNonoFollow);
         NonoManager.addEventListener(NonoEvent.HOOM,this.onNonoHoom);
      }
      
      public function destroy() : void
      {
         NonoManager.removeEventListener(NonoEvent.FOLLOW,this.onNonoFollow);
         NonoManager.removeEventListener(NonoEvent.HOOM,this.onNonoHoom);
         NonoManager.removeEventListener(NonoEvent.GET_INFO,this.onMyNonoInfo);
         SocketConnection.removeCmdListener(CommandID.NONO_INFO,this.onNonoInfo);
         if(Boolean(this._nono))
         {
            this._nono.destroy();
            this._nono = null;
         }
      }
      
      private function init(_arg_1:NonoInfo) : void
      {
         this._info = _arg_1;
         if(this._info.flag.length == 0)
         {
            return;
         }
         if(!this._info.flag[0])
         {
            return;
         }
         if(!this._info.state[1])
         {
            this.showNono(this._info);
         }
      }
      
      private function showNono(_arg_1:NonoInfo) : void
      {
         if(this._nono == null)
         {
            this._nono = new NonoModel(_arg_1);
            this._nono.pos = MapXMLInfo.getDefaultPos(MapManager.getResMapID(MainManager.actorInfo.mapID));
            MapManager.currentMap.depthLevel.addChild(this._nono);
         }
      }
      
      private function onNonoInfo(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.NONO_INFO,this.onNonoInfo);
         var _local_2:NonoInfo = new NonoInfo(_arg_1.data as ByteArray);
         this.init(_local_2);
      }
      
      private function onMyNonoInfo(_arg_1:NonoEvent) : void
      {
         NonoManager.removeEventListener(NonoEvent.GET_INFO,this.onMyNonoInfo);
         this.init(_arg_1.info);
      }
      
      private function onNonoFollow(_arg_1:NonoEvent) : void
      {
         this._info.state[1] = true;
         if(Boolean(this._nono))
         {
            this._nono.destroy();
            this._nono = null;
         }
      }
      
      private function onNonoHoom(_arg_1:NonoEvent) : void
      {
         this._info.state[1] = false;
         this.showNono(this._info);
      }
   }
}

