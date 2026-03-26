package com.robot.app.teacherAward
{
   import flash.utils.IDataInput;
   
   public class SevenNoLoginInfo
   {
      
      private var isLogin:uint;
      
      public function SevenNoLoginInfo(_arg_1:IDataInput)
      {
         super();
         this.isLogin = _arg_1.readUnsignedInt();
      }
      
      public function get getStatus() : uint
      {
         return this.isLogin;
      }
   }
}

