package com.robot.app.experienceShared
{
   import flash.utils.IDataInput;
   
   public class ExperienceSharedInfo
   {
      
      private var fraction:uint = 0;
      
      public function ExperienceSharedInfo(_arg_1:IDataInput)
      {
         super();
         this.fraction = _arg_1.readUnsignedInt();
      }
      
      public function get getFraction() : uint
      {
         return this.fraction;
      }
   }
}

