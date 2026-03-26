package com.robot.core.info.teamPK
{
   import com.robot.core.info.team.SimpleTeamInfo;
   
   public class TeamPKTeamInfo
   {
      
      private var _ename:String;
      
      private var _eleader:String;
      
      private var _elevel:uint;
      
      private var _myLevel:uint;
      
      private var _myLeader:String;
      
      private var _myName:String;
      
      private var _eInfo:SimpleTeamInfo;
      
      private var _myInfo:SimpleTeamInfo;
      
      public function TeamPKTeamInfo()
      {
         super();
      }
      
      public function set myInfo(_arg_1:SimpleTeamInfo) : void
      {
         this._myInfo = _arg_1;
      }
      
      public function get myInfo() : SimpleTeamInfo
      {
         return this._myInfo;
      }
      
      public function set eInfo(_arg_1:SimpleTeamInfo) : void
      {
         this._eInfo = _arg_1;
      }
      
      public function get eInfo() : SimpleTeamInfo
      {
         return this._eInfo;
      }
      
      public function get myName() : String
      {
         return this._myName;
      }
      
      public function set myName(_arg_1:String) : void
      {
         this._myName = _arg_1;
      }
      
      public function get myLevel() : uint
      {
         return this._myLevel;
      }
      
      public function set myLevel(_arg_1:uint) : void
      {
         this._myLevel = _arg_1;
      }
      
      public function get elevel() : uint
      {
         return this._elevel;
      }
      
      public function set elevel(_arg_1:uint) : void
      {
         this._elevel = _arg_1;
      }
      
      public function set myLeader(_arg_1:String) : void
      {
         this._myLeader = _arg_1;
      }
      
      public function get myLeader() : String
      {
         return this._myLeader;
      }
      
      public function get eLeader() : String
      {
         return this._eleader;
      }
      
      public function set eLeader(_arg_1:String) : void
      {
         this._eleader = _arg_1;
      }
      
      public function set ename(_arg_1:String) : void
      {
         this._ename = _arg_1;
      }
      
      public function get ename() : String
      {
         return this._ename;
      }
   }
}

