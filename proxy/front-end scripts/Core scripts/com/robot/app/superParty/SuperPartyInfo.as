package com.robot.app.superParty
{
   public class SuperPartyInfo
   {
      
      private var _mapID:uint;
      
      private var _petIDs:Array;
      
      private var _oreIDs:Array;
      
      private var _games:Array;
      
      public function SuperPartyInfo()
      {
         super();
      }
      
      public function get mapID() : uint
      {
         return this._mapID;
      }
      
      public function set mapID(_arg_1:uint) : void
      {
         this._mapID = _arg_1;
      }
      
      public function get petIDs() : Array
      {
         return this._petIDs;
      }
      
      public function set petIDs(_arg_1:Array) : void
      {
         this._petIDs = _arg_1;
      }
      
      public function get oreIDs() : Array
      {
         return this._oreIDs;
      }
      
      public function set oreIDs(_arg_1:Array) : void
      {
         this._oreIDs = _arg_1;
      }
      
      public function get games() : Array
      {
         return this._games;
      }
      
      public function set games(_arg_1:Array) : void
      {
         this._games = _arg_1;
      }
   }
}

