package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class SimpleTeamInfo implements ITeamLogoInfo
   {
      
      private var _teamID:uint;
      
      private var _leader:uint;
      
      private var _memberCount:uint;
      
      private var _interest:uint;
      
      private var _joinFlag:uint;
      
      private var _visitFlag:uint;
      
      private var _exp:uint;
      
      private var _score:uint;
      
      private var _name:String;
      
      private var _slogan:String;
      
      private var _notice:String;
      
      private var _logoBg:uint;
      
      private var _logoIcon:uint;
      
      private var _logoColor:uint;
      
      private var _txtColor:uint;
      
      private var _logoWord:String;
      
      private var _superCoreNum:uint;
      
      public function SimpleTeamInfo(_arg_1:IDataInput)
      {
         super();
         this._teamID = _arg_1.readUnsignedInt();
         this._leader = _arg_1.readUnsignedInt();
         this._superCoreNum = _arg_1.readUnsignedInt();
         this._memberCount = _arg_1.readUnsignedInt();
         this._interest = _arg_1.readUnsignedInt();
         this._joinFlag = _arg_1.readUnsignedInt();
         this._visitFlag = _arg_1.readUnsignedInt();
         this._exp = _arg_1.readUnsignedInt();
         this._score = _arg_1.readUnsignedInt();
         this._name = _arg_1.readUTFBytes(16);
         this._slogan = _arg_1.readUTFBytes(60);
         this._notice = _arg_1.readUTFBytes(60);
         this._logoBg = _arg_1.readShort();
         this._logoIcon = _arg_1.readShort();
         this._logoColor = _arg_1.readShort();
         this._txtColor = _arg_1.readShort();
         this._logoWord = _arg_1.readUTFBytes(4);
      }
      
      public function get logoBg() : uint
      {
         return this._logoBg;
      }
      
      public function get logoIcon() : uint
      {
         return this._logoIcon;
      }
      
      public function get logoColor() : uint
      {
         return this._logoColor;
      }
      
      public function get txtColor() : uint
      {
         return this._txtColor;
      }
      
      public function get logoWord() : String
      {
         return this._logoWord;
      }
      
      public function set logoBg(_arg_1:uint) : void
      {
         this._logoBg = _arg_1;
      }
      
      public function set logoIcon(_arg_1:uint) : void
      {
         this._logoIcon = _arg_1;
      }
      
      public function set logoColor(_arg_1:uint) : void
      {
         this._logoColor = _arg_1;
      }
      
      public function set txtColor(_arg_1:uint) : void
      {
         this._txtColor = _arg_1;
      }
      
      public function set logoWord(_arg_1:String) : void
      {
         this._logoWord = _arg_1;
      }
      
      public function get superCoreNum() : uint
      {
         return this._superCoreNum;
      }
      
      public function set superCoreNum(_arg_1:uint) : void
      {
         this._superCoreNum = _arg_1;
      }
      
      public function get exp() : uint
      {
         return this._exp;
      }
      
      public function get score() : uint
      {
         return this._score;
      }
      
      public function get teamID() : uint
      {
         return this._teamID;
      }
      
      public function get leader() : uint
      {
         return this._leader;
      }
      
      public function get memberCount() : uint
      {
         return this._memberCount;
      }
      
      public function get interest() : uint
      {
         return this._interest;
      }
      
      public function get joinFlag() : uint
      {
         return this._joinFlag;
      }
      
      public function get visitFlag() : uint
      {
         return this._visitFlag;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get slogan() : String
      {
         return this._slogan;
      }
      
      public function get notice() : String
      {
         return this._notice;
      }
      
      public function get level() : uint
      {
         var _local_1:uint = 2;
         var _local_2:int = this.countExp(_local_1);
         while(_local_2 < this._exp)
         {
            _local_1++;
            _local_2 = this.countExp(_local_1);
         }
         var _local_3:uint = uint(_local_1 - 1);
         if(_local_3 > 100)
         {
            _local_3 = 100;
         }
         return _local_3;
      }
      
      public function get realLevel() : uint
      {
         var _local_1:uint = 2;
         var _local_2:int = this.countExp(_local_1);
         while(_local_2 < this._exp)
         {
            _local_1++;
            _local_2 = this.countExp(_local_1);
         }
         return uint(_local_1 - 1);
      }
      
      public function countExp(_arg_1:uint) : int
      {
         return uint(Math.ceil(6 * Math.pow(_arg_1,3) / 5 - 15 * Math.pow(_arg_1,2) + 100 * _arg_1 - 140));
      }
   }
}

