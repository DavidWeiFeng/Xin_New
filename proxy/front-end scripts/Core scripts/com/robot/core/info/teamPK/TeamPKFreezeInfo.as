package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKFreezeInfo
   {
      
      private var _flag:uint;
      
      private var _uid:uint;
      
      public function TeamPKFreezeInfo(_arg_1:IDataInput)
      {
         super();
         this._flag = _arg_1.readUnsignedInt();
         this._uid = _arg_1.readUnsignedInt();
      }
      
      public function get flag() : uint
      {
         return this._flag;
      }
      
      public function get uid() : uint
      {
         return this._uid;
      }
   }
}

