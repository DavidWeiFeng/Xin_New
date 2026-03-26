package com.robot.core.manager
{
   import com.robot.core.*;
   import com.robot.core.info.*;
   import com.robot.core.info.relation.*;
   import com.robot.core.net.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class UserInfoManager
   {
      
      public function UserInfoManager()
      {
         super();
      }
      
      public static function getInfo(id:uint, event:Function) : void
      {
         if(id == 0)
         {
            event(new UserInfo());
            return;
         }
         SocketConnection.addCmdListener(CommandID.GET_SIM_USERINFO,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_SIM_USERINFO,arguments.callee);
            var _local_3:UserInfo = new UserInfo();
            UserInfo.setForSimpleInfo(_local_3,_arg_1.data as IDataInput);
            event(_local_3);
            if(RelationManager.isFriend(_local_3.userID) || RelationManager.isBlack(_local_3.userID))
            {
               RelationManager.upDateInfoForSimpleInfo(_local_3);
            }
         });
         SocketConnection.send(CommandID.GET_SIM_USERINFO,id);
      }
      
      public static function upDateSimpleInfo(info:UserInfo, event:Function = null) : void
      {
         if(info.userID == 0)
         {
            if(event != null)
            {
               event();
            }
            return;
         }
         SocketConnection.addCmdListener(CommandID.GET_SIM_USERINFO,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_SIM_USERINFO,arguments.callee);
            UserInfo.setForSimpleInfo(info,_arg_1.data as IDataInput);
            if(event != null)
            {
               event();
            }
         });
         SocketConnection.send(CommandID.GET_SIM_USERINFO,info.userID);
      }
      
      public static function upDateMoreInfo(info:UserInfo, event:Function = null) : void
      {
         if(info.userID == 0)
         {
            if(event != null)
            {
               event();
            }
            return;
         }
         SocketConnection.addCmdListener(CommandID.GET_MORE_USERINFO,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_MORE_USERINFO,arguments.callee);
            UserInfo.setForMoreInfo(info,_arg_1.data as IDataInput);
            if(event != null)
            {
               event();
            }
         });
         SocketConnection.send(CommandID.GET_MORE_USERINFO,info.userID);
      }
      
      public static function seeOnLine(ids:Array, event:Function) : void
      {
         var byd:ByteArray = null;
         var i:int = 0;
         var arr:Array = null;
         arr = null;
         arr = [];
         var len:int = int(ids.length);
         if(len == 0)
         {
            event(arr);
            return;
         }
         byd = new ByteArray();
         i = 0;
         while(i < len)
         {
            byd.writeUnsignedInt(ids[i]);
            i += 1;
         }
         SocketConnection.addCmdListener(CommandID.SEE_ONLINE,function(_arg_1:SocketEvent):void
         {
            var _local_5:int = 0;
            var _local_3:ByteArray = _arg_1.data as ByteArray;
            var _local_4:uint = _local_3.readUnsignedInt();
            while(_local_5 < _local_4)
            {
               arr.push(new OnLineInfo(_local_3));
               _local_5++;
            }
            event(arr);
            SocketConnection.removeCmdListener(CommandID.SEE_ONLINE,arguments.callee);
         });
         SocketConnection.send(CommandID.SEE_ONLINE,len,byd);
      }
   }
}

