package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKBuildingListInfo
   {
      
      private var _homeList:Array;
      
      private var _awayList:Array;
      
      public function TeamPKBuildingListInfo(_arg_1:IDataInput)
      {
         var _local_4:uint = 0;
         this._homeList = [];
         this._awayList = [];
         super();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         var _local_3:uint = uint(_arg_1.readUnsignedInt());
         _local_4 = 0;
         while(_local_4 < _local_2)
         {
            this._homeList.push(new TeamPkBuildingInfo(_arg_1,_local_3));
            _local_4++;
         }
         var _local_5:uint = uint(_arg_1.readUnsignedInt());
         _local_3 = uint(_arg_1.readUnsignedInt());
         _local_4 = 0;
         while(_local_4 < _local_5)
         {
            this._awayList.push(new TeamPkBuildingInfo(_arg_1,_local_3));
            _local_4++;
         }
      }
      
      public function get homeList() : Array
      {
         return this._homeList;
      }
      
      public function get awayList() : Array
      {
         return this._awayList;
      }
   }
}

