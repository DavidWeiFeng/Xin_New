package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class TeamAddInfo
   {
      
      private var _ret:uint;
      
      private var _teamID:uint;
      
      public function TeamAddInfo(_arg_1:IDataInput)
      {
         super();
         this._ret = _arg_1.readUnsignedInt();
         this._teamID = _arg_1.readUnsignedInt();
      }
      
      public function get ret() : uint
      {
         return this._ret;
      }
      
      public function get teamID() : uint
      {
         return this._teamID;
      }
   }
}

