package com.robot.core.info.fightInfo
{
   import com.robot.core.manager.MainManager;
   import flash.utils.IDataInput;
   
   public class FightStartInfo
   {
      
      private var _myInfo:FightPetInfo;
      
      private var _otherInfo:FightPetInfo;
      
      private var _infoArray:Array = [];
      
      private var _isCanAuto:Boolean;
      
      public function FightStartInfo(_arg_1:IDataInput)
      {
         super();
         this._isCanAuto = _arg_1.readUnsignedInt() == 1;
         var _local_2:FightPetInfo = new FightPetInfo(_arg_1);
         if(_local_2.userID == MainManager.actorInfo.userID)
         {
            this._myInfo = _local_2;
            this._otherInfo = new FightPetInfo(_arg_1);
            this._infoArray.push(this._myInfo,this._otherInfo);
         }
         else
         {
            this._otherInfo = _local_2;
            this._myInfo = new FightPetInfo(_arg_1);
            this._infoArray.push(this._myInfo,this._otherInfo);
         }
      }
      
      public function get isCanAuto() : Boolean
      {
         return this._isCanAuto;
      }
      
      public function get myInfo() : FightPetInfo
      {
         return this._myInfo;
      }
      
      public function get otherInfo() : FightPetInfo
      {
         return this._otherInfo;
      }
      
      public function get infoArray() : Array
      {
         return this._infoArray;
      }
   }
}

