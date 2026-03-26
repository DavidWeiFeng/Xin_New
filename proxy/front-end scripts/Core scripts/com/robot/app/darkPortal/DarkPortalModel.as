package com.robot.app.darkPortal
{
   import com.robot.app.fightLevel.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class DarkPortalModel
   {
      
      private static var _curBossId:uint;
      
      private static var _curDoor:uint;
      
      private static var _doorHanlder:Function;
      
      private static var _fiSucHandler:Function;
      
      private static var _panel:AppModel;
      
      private static var _curFun:Function;
      
      private static var _petBtn:SimpleButton;
      
      public static var doorIndex:uint = 0;
      
      public function DarkPortalModel()
      {
         super();
      }
      
      public static function get curDoor() : uint
      {
         return _curDoor;
      }
      
      public static function set curDoor(_arg_1:uint) : void
      {
         _curDoor = _arg_1;
      }
      
      public static function get curBossId() : uint
      {
         return _curBossId;
      }
      
      public static function set curBossId(_arg_1:uint) : void
      {
         _curBossId = _arg_1;
      }
      
      public static function enterDarkProtal(_arg_1:uint, _arg_2:Function = null, _arg_3:uint = 0) : void
      {
         doorIndex = _arg_3;
         _curDoor = _arg_1;
         _doorHanlder = _arg_2;
         SocketConnection.addCmdListener(CommandID.OPEN_DARKPORTAL,onSucHandler);
         SocketConnection.send(CommandID.OPEN_DARKPORTAL,_arg_1);
      }
      
      private static function onSucHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.OPEN_DARKPORTAL,onSucHandler);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         _curBossId = _local_3;
         if(_doorHanlder != null)
         {
            _doorHanlder();
            _doorHanlder = null;
         }
         enterMap();
      }
      
      public static function enterMap() : void
      {
         var _local_1:uint = 502;
         var _local_2:uint = uint(_curDoor + 1);
         if(_local_2 > 6)
         {
            if(_local_2 % 6 == 0)
            {
               _local_1 = uint(_local_1 + _local_2 / 6);
            }
            else
            {
               _local_1 = uint(_local_1 + (uint(_local_2 / 6) + 1));
            }
         }
         else
         {
            _local_1++;
         }
         MapManager.changeLocalMap(_local_1);
      }
      
      public static function fightDarkProtal(_arg_1:Function = null) : void
      {
         _fiSucHandler = _arg_1;
         SocketConnection.addCmdListener(CommandID.FIGHT_DARKPORTAL,onFiHandler);
         SocketConnection.send(CommandID.FIGHT_DARKPORTAL);
      }
      
      private static function onFiHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_DARKPORTAL,onFiHandler);
         if(_fiSucHandler != null)
         {
            _fiSucHandler();
            _fiSucHandler = null;
         }
      }
      
      public static function leaveDarkProtal(func:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.LEAVE_DARKPORTAL,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.LEAVE_DARKPORTAL,arguments.callee);
            if(func != null)
            {
               func();
            }
            MapManager.changeMap(110);
         });
         SocketConnection.send(CommandID.LEAVE_DARKPORTAL);
      }
      
      public static function showDoor(_arg_1:uint, _arg_2:Function = null) : void
      {
         destroyPanel();
         _curFun = _arg_2;
         _panel = new AppModel(ClientConfig.getAppModule("DarkDoorChoicePanel_" + _arg_1),"正在打开暗黑之门");
         _panel.setup();
         _panel.sharedEvents.addEventListener(Event.CLOSE,onCloseHandler);
         _panel.show();
      }
      
      private static function onCloseHandler(_arg_1:Event) : void
      {
         if(_curFun != null)
         {
            _curFun();
            _curFun = null;
         }
      }
      
      public static function destroyPanel() : void
      {
         if(Boolean(_panel))
         {
            _panel.sharedEvents.removeEventListener(Event.CLOSE,onCloseHandler);
            _panel.destroy();
            _panel = null;
         }
      }
      
      public static function destroy() : void
      {
         destroyPanel();
         SocketConnection.removeCmdListener(CommandID.OPEN_DARKPORTAL,onSucHandler);
         SocketConnection.removeCmdListener(CommandID.FIGHT_DARKPORTAL,onFiHandler);
         onCloseHandler(null);
      }
      
      public static function showPetEnrichBlood() : void
      {
         setTimeout(function():void
         {
            _petBtn = MapManager.currentMap.controlLevel["petMc"];
            _petBtn.addEventListener(MouseEvent.CLICK,onClickHandler);
            ToolTipManager.add(_petBtn,"精灵背包");
         },200);
      }
      
      private static function onClickHandler(_arg_1:MouseEvent) : void
      {
         FightPetBagController.show();
      }
      
      public static function des() : void
      {
         if(Boolean(_petBtn))
         {
            ToolTipManager.remove(_petBtn);
            _petBtn.addEventListener(MouseEvent.CLICK,onClickHandler);
            _petBtn = null;
         }
         FightPetBagController.destroy();
      }
   }
}

