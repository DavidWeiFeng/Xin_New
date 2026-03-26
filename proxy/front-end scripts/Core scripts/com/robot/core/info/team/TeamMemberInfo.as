package com.robot.core.info.team
{
   import com.robot.core.info.UserInfo;
   import flash.utils.IDataInput;
   
   public class TeamMemberInfo extends UserInfo
   {
      
      public var priv:uint;
      
      public var contribute:uint;
      
      public function TeamMemberInfo(_arg_1:IDataInput = null)
      {
         super();
         if(Boolean(_arg_1))
         {
            userID = _arg_1.readUnsignedInt();
            this.priv = _arg_1.readUnsignedInt();
            this.contribute = _arg_1.readUnsignedInt();
         }
      }
   }
}

