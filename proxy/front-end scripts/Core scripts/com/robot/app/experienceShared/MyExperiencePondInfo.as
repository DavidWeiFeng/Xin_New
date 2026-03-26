package com.robot.app.experienceShared
{
   import flash.utils.IDataInput;
   
   public class MyExperiencePondInfo
   {
      
      private var myExp:uint = 0;
      
      public function MyExperiencePondInfo(_arg_1:IDataInput)
      {
         super();
         this.myExp = _arg_1.readUnsignedInt();
      }
      
      public function get getMyExp() : uint
      {
         return this.myExp;
      }
   }
}

