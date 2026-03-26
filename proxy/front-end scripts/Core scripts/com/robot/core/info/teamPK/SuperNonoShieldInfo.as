package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class SuperNonoShieldInfo
   {
      
      private var _uid:uint;
      
      private var _leftTime:uint;
      
      public function SuperNonoShieldInfo(_arg_1:IDataInput)
      {
         super();
         this._uid = _arg_1.readUnsignedInt();
         this._leftTime = _arg_1.readUnsignedInt();
      }
      
      public function get uid() : uint
      {
         return this._uid;
      }
      
      public function get leftTime() : uint
      {
         return this._leftTime;
      }
   }
}

