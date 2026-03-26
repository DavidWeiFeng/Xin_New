package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKInfo
   {
      
      private var _groupID:uint;
      
      private var _homeTeamID:uint;
      
      public function TeamPKInfo(_arg_1:IDataInput)
      {
         super();
         this._groupID = _arg_1.readUnsignedInt();
         this._homeTeamID = _arg_1.readUnsignedInt();
      }
      
      public function get groupID() : uint
      {
         return this._groupID;
      }
      
      public function get homeTeamID() : uint
      {
         return this._homeTeamID;
      }
      
      public function set homeTeamID(_arg_1:uint) : void
      {
         this._homeTeamID = _arg_1;
      }
   }
}

