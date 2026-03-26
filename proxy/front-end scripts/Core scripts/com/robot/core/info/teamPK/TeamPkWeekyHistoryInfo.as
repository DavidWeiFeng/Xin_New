package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPkWeekyHistoryInfo
   {
      
      public var killPlayer:uint;
      
      public var killBuilding:uint;
      
      public var mvpNum:uint;
      
      public var winTimes:uint;
      
      public var lostTimes:uint;
      
      public var drawTimes:uint;
      
      public var point:uint;
      
      public function TeamPkWeekyHistoryInfo(_arg_1:IDataInput)
      {
         super();
         this.killPlayer = _arg_1.readUnsignedInt();
         this.killBuilding = _arg_1.readUnsignedInt();
         this.mvpNum = _arg_1.readUnsignedInt();
         this.winTimes = _arg_1.readUnsignedInt();
         this.lostTimes = _arg_1.readUnsignedInt();
         this.drawTimes = _arg_1.readUnsignedInt();
         this.point = _arg_1.readUnsignedInt();
      }
   }
}

