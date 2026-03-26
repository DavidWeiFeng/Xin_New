package com.robot.app.spt
{
   public class SptInfo
   {
      
      private var _id:uint;
      
      private var _online:Boolean;
      
      private var _status:uint;
      
      private var _title:String;
      
      private var _description:String;
      
      private var _level:uint;
      
      private var _seatID:uint;
      
      private var _enterID:uint;
      
      private var _fightCondition:String;
      
      public function SptInfo()
      {
         super();
      }
      
      public function get seatID() : uint
      {
         return this._seatID;
      }
      
      public function set seatID(_arg_1:uint) : void
      {
         this._seatID = _arg_1;
      }
      
      public function get enterID() : uint
      {
         return this._enterID;
      }
      
      public function set enterID(_arg_1:uint) : void
      {
         this._enterID = _arg_1;
      }
      
      public function get fightCondition() : String
      {
         return this._fightCondition;
      }
      
      public function set fightCondition(_arg_1:String) : void
      {
         this._fightCondition = _arg_1;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(_arg_1:uint) : void
      {
         this._id = _arg_1;
      }
      
      public function get level() : uint
      {
         return this._level;
      }
      
      public function set level(_arg_1:uint) : void
      {
         this._level = _arg_1;
      }
      
      public function get onLine() : Boolean
      {
         return this._online;
      }
      
      public function set onLine(_arg_1:Boolean) : void
      {
         this._online = _arg_1;
      }
      
      public function get status() : uint
      {
         return this._status;
      }
      
      public function set status(_arg_1:uint) : void
      {
         this._status = _arg_1;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(_arg_1:String) : void
      {
         this._title = _arg_1;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set description(_arg_1:String) : void
      {
         this._description = _arg_1;
      }
   }
}

