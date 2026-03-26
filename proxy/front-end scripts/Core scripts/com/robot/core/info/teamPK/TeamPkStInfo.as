package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPkStInfo
   {
      
      private var _flag:uint;
      
      private var _time:uint;
      
      private var _home_player_count:uint;
      
      private var _home_kill_player:uint;
      
      private var _home_kill_building:int;
      
      private var _home_hqrts_hp:int;
      
      private var _home_left_building:uint;
      
      private var _home_get_flag:int;
      
      private var _home_destroy_hqrts:int;
      
      private var _away_player_count:uint;
      
      private var _away_kill_player:uint;
      
      private var _away_kill_building:int;
      
      private var _away_hqrts_hp:int;
      
      private var _away_left_building:uint;
      
      private var _away_get_flag:int;
      
      private var _away_destroy_hqrts:int;
      
      private var _pkStatus:uint;
      
      public function TeamPkStInfo(_arg_1:IDataInput = null)
      {
         super();
         if(!_arg_1)
         {
            return;
         }
         this._flag = _arg_1.readUnsignedInt();
         if(this._flag == 0)
         {
            return;
         }
         this._time = _arg_1.readInt();
         this._pkStatus = _arg_1.readUnsignedInt();
         this._home_player_count = _arg_1.readUnsignedInt();
         this._home_kill_player = _arg_1.readInt();
         this._home_kill_building = _arg_1.readInt();
         this._home_hqrts_hp = _arg_1.readInt();
         this._home_left_building = _arg_1.readUnsignedInt();
         this._home_get_flag = _arg_1.readInt();
         this._home_destroy_hqrts = _arg_1.readInt();
         this._away_player_count = _arg_1.readUnsignedInt();
         this._away_kill_player = _arg_1.readInt();
         this._away_kill_building = _arg_1.readInt();
         this._away_hqrts_hp = _arg_1.readInt();
         this._away_left_building = _arg_1.readUnsignedInt();
         this._away_get_flag = _arg_1.readInt();
         this._away_destroy_hqrts = _arg_1.readInt();
      }
      
      public function get time() : uint
      {
         return this._time;
      }
      
      public function get awayDestroyHqrts() : int
      {
         return this._away_destroy_hqrts;
      }
      
      public function get awayGetFlag() : int
      {
         return this._away_get_flag;
      }
      
      public function get awayLeftBuilding() : uint
      {
         return this._away_left_building;
      }
      
      public function get awayHqrtsHp() : int
      {
         return this._away_hqrts_hp;
      }
      
      public function get awayKillBuilding() : int
      {
         return this._away_kill_building;
      }
      
      public function get awayKillPlayer() : int
      {
         return this._away_kill_player;
      }
      
      public function get awayPlayerCount() : uint
      {
         return this._away_player_count;
      }
      
      public function get homeDestroyHqrts() : int
      {
         return this._home_destroy_hqrts;
      }
      
      public function get homeGetFlag() : int
      {
         return this._home_get_flag;
      }
      
      public function get homeLeftBuilding() : uint
      {
         return this._home_left_building;
      }
      
      public function get homeHqrtsHp() : uint
      {
         return this._home_hqrts_hp;
      }
      
      public function get homeKillPlayer() : int
      {
         return this._home_kill_player;
      }
      
      public function get homeKillBuilding() : int
      {
         return this._home_kill_building;
      }
      
      public function get homePlayerCount() : uint
      {
         return this._home_player_count;
      }
      
      public function get flag() : uint
      {
         return this._flag;
      }
      
      public function get pkStatus() : uint
      {
         return this._pkStatus;
      }
   }
}

