package com.robot.core.info.fightInfo.attack
{
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.MainManager;
   import flash.utils.IDataInput;
   import org.taomee.manager.EventManager;
   
   public class FightOverInfo
   {
      
      private var _deltaTopLv:int;
      
      private var _daltaTopHonour:uint;
      
      private var _winnerID:uint;
      
      private var _reason:uint;
      
      public function FightOverInfo(_arg_1:IDataInput)
      {
         super();
         this._reason = _arg_1.readUnsignedInt();
         this._winnerID = _arg_1.readUnsignedInt();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         var _local_3:uint = uint(_arg_1.readUnsignedInt());
         MainManager.actorInfo.twoTimes = _local_2;
         MainManager.actorInfo.threeTimes = _local_3;
         MainManager.actorInfo.autoFightTimes = _arg_1.readUnsignedInt();
         var _local_4:uint = uint(_arg_1.readUnsignedInt());
         var _local_5:uint = uint(_arg_1.readUnsignedInt());
         MainManager.actorInfo.energyTimes = _local_4;
         MainManager.actorInfo.learnTimes = _local_5;
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.ENERGY_TIMES_CHANGE));
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.SPEEDUP_CHANGE));
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.AUTO_FIGHT_CHANGE));
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.STUDY_TIMES_CHANGE));
      }
      
      public function get winnerID() : uint
      {
         return this._winnerID;
      }
      
      public function get reason() : uint
      {
         return this._reason;
      }
      
      public function get deltaTopLv() : int
      {
         return this._deltaTopLv;
      }
      
      public function get daltaTopHonour() : uint
      {
         return this._daltaTopHonour;
      }
   }
}

