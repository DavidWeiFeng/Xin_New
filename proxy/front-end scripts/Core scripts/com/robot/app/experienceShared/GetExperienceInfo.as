package com.robot.app.experienceShared
{
   import flash.utils.IDataInput;
   
   public class GetExperienceInfo
   {
      
      private var exp:uint;
      
      public function GetExperienceInfo(_arg_1:IDataInput)
      {
         super();
         this.exp = _arg_1.readUnsignedInt();
      }
      
      public function get getExp() : uint
      {
         return this.exp;
      }
   }
}

