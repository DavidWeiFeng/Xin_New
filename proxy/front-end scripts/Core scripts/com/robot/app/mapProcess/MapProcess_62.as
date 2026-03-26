package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class MapProcess_62 extends BaseMapProcess
   {
      
      public function MapProcess_62()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(FightInviteManager.isKillBigPetB0 == false)
         {
            SocketConnection.addCmdListener(CommandID.PET_BARGE_LIST,this.addCmListenrPet);
            SocketConnection.send(CommandID.PET_BARGE_LIST,242,242);
         }
      }
      
      private function addCmListenrPet(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_BARGE_LIST,this.addCmListenrPet);
         var _local_2:PetBargeListInfo = _arg_1.data as PetBargeListInfo;
         var _local_3:Array = _local_2.isKillList;
         if(_local_3.length != 0)
         {
            FightInviteManager.isKillBigPetB0 = true;
         }
         else
         {
            EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
         }
      }
      
      private function onCloseFight(_arg_1:PetFightEvent) : void
      {
         var _local_2:FightOverInfo = _arg_1.dataObj["data"];
         if(_local_2.winnerID == MainManager.actorInfo.userID)
         {
            EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
            FightInviteManager.isKillBigPetB0 = true;
         }
      }
      
      override public function destroy() : void
      {
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
      }
      
      public function changeMap() : void
      {
         MapManager.changeLocalMap(63);
      }
   }
}

