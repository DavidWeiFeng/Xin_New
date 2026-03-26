package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKJoinInfo
   {
      
      private var _homeUserList:Array;
      
      private var _awayUserList:Array;
      
      private var _homeid:uint;
      
      private var _awayid:uint;
      
      public function TeamPKJoinInfo(_arg_1:IDataInput)
      {
         var _local_2:uint = 0;
         this._homeUserList = [];
         this._awayUserList = [];
         super();
         this._homeid = _arg_1.readUnsignedInt();
         var _local_3:uint = uint(_arg_1.readUnsignedInt());
         _local_2 = 0;
         while(_local_2 < _local_3)
         {
            this._homeUserList.push(new TeamPkUserInfo(_arg_1));
            _local_2++;
         }
         this._awayid = _arg_1.readUnsignedInt();
         var _local_4:uint = uint(_arg_1.readUnsignedInt());
         _local_2 = 0;
         while(_local_2 < _local_4)
         {
            this._awayUserList.push(new TeamPkUserInfo(_arg_1));
            _local_2++;
         }
      }
      
      public function get homeTeamId() : uint
      {
         return this._homeid;
      }
      
      public function get awayTeamId() : uint
      {
         return this._awayid;
      }
      
      public function get homeUserList() : Array
      {
         return this._homeUserList;
      }
      
      public function get awayUserList() : Array
      {
         return this._awayUserList;
      }
   }
}

