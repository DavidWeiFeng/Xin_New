package com.robot.app.fightLevel
{
   import com.robot.core.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import org.taomee.events.SocketEvent;
   
   public class FightMHTController
   {
      
      private static var _handler:Function;
      
      private static var _petInfoA:Array = [];
      
      private static var _curIndex:uint = 0;
      
      public function FightMHTController()
      {
         super();
      }
      
      public static function check() : void
      {
         if(PetManager.getBagMap().length < 6)
         {
            Alarm.show("只有具备了足够的实力才能进入勇者之塔神秘领域，等你将6只精灵全都训练到100级后再来挑战吧。");
            return;
         }
         _petInfoA = PetManager.getBagMap();
         _curIndex = 0;
         send1((_petInfoA[_curIndex] as PetListInfo).catchTime);
      }
      
      public static function checkIsFight(_arg_1:Function) : void
      {
         _handler = _arg_1;
         _petInfoA = PetManager.getBagMap();
         _curIndex = 0;
         send((_petInfoA[_curIndex] as PetListInfo).catchTime);
      }
      
      private static function send(_arg_1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_PET_INFO,onCheckComHandler);
         SocketConnection.send(CommandID.GET_PET_INFO,_arg_1);
      }
      
      private static function send1(_arg_1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_PET_INFO,onGetComHandler);
         SocketConnection.send(CommandID.GET_PET_INFO,_arg_1);
      }
      
      private static function onCheckComHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,onCheckComHandler);
         var _local_2:PetInfo = _arg_1.data as PetInfo;
         if(_local_2.level >= 30)
         {
            _handler(true);
            return;
         }
         ++_curIndex;
         if(_curIndex < _petInfoA.length)
         {
            send((_petInfoA[_curIndex] as PetListInfo).catchTime);
         }
         else
         {
            _handler(false);
         }
      }
      
      private static function onGetComHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,onGetComHandler);
         var _local_2:PetInfo = _arg_1.data as PetInfo;
         if(_local_2.level < 100)
         {
            Alarm.show("只有具备了足够的实力才能进入勇者之塔神秘领域，等你将6只精灵全都训练到100级后再来挑战吧。");
            destroy();
         }
         else
         {
            ++_curIndex;
            if(_curIndex > 5)
            {
               destroy();
               MapManager.changeLocalMap(514);
            }
            else
            {
               send1((_petInfoA[_curIndex] as PetListInfo).catchTime);
            }
         }
      }
      
      public static function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,onGetComHandler);
         _petInfoA = null;
         _curIndex = 0;
      }
   }
}

