package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class TeamMemberListInfo
   {
      
      private var _teamID:uint;
      
      private var _userList:Array;
      
      private var _superCoreNum:uint;
      
      public function TeamMemberListInfo(_arg_1:IDataInput)
      {
         var _local_3:uint = 0;
         this._userList = [];
         super();
         this._teamID = _arg_1.readUnsignedInt();
         this._superCoreNum = _arg_1.readUnsignedInt();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         while(_local_3 < _local_2)
         {
            this._userList.push(new TeamMemberInfo(_arg_1));
            _local_3++;
         }
      }
      
      public function get teamID() : uint
      {
         return this._teamID;
      }
      
      public function get superCoreNum() : uint
      {
         return this._superCoreNum;
      }
      
      public function get memberList() : Array
      {
         return this._userList;
      }
   }
}

