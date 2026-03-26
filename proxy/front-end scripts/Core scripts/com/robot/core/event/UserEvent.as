package com.robot.core.event
{
   import com.robot.core.info.UserInfo;
   import flash.events.Event;
   
   public class UserEvent extends Event
   {
      
      public static const CLICK:String = "userClick";
      
      public static const INFO_CHANGE:String = "infoChange";
      
      public static const REMOVED_FROM_MAP:String = "removedFromMap";
      
      private var _userInfo:UserInfo;
      
      public function UserEvent(_arg_1:String, _arg_2:UserInfo = null, _arg_3:Boolean = false, _arg_4:Boolean = false)
      {
         super(_arg_1,_arg_3,_arg_4);
         this._userInfo = _arg_2;
      }
      
      public function get userInfo() : UserInfo
      {
         return this._userInfo;
      }
   }
}

