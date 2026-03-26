package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class VipCmdListener extends BaseBeanController
   {
      
      public static const BE_VIP:String = "beVip";
      
      public static const FIRST_VIP:String = "firstVip";
      
      public function VipCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.VIP_CO,this.onChange);
         finish();
      }
      
      private function onChange(_arg_1:SocketEvent) : void
      {
         var _local_2:BasePeoleModel = null;
         var _local_3:NonoInfo = null;
         var _local_4:ByteArray = _arg_1.data as ByteArray;
         var _local_5:uint = _local_4.readUnsignedInt();
         var _local_6:uint = _local_4.readUnsignedInt();
         var _local_7:uint = _local_4.readUnsignedInt();
         var _local_8:uint = _local_4.readUnsignedInt();
         if(MainManager.actorID == _local_5)
         {
            MainManager.actorInfo.autoCharge = _local_7;
            MainManager.actorInfo.vipEndTime = _local_8;
            MainManager.actorInfo.vip = _local_6;
            if(_local_6 == 1)
            {
               EventManager.dispatchEvent(new Event(FIRST_VIP));
            }
            else if(_local_6 == 2)
            {
               MainManager.actorInfo.viped = 1;
               MainManager.actorInfo.superNono = true;
               EventManager.dispatchEvent(new Event(BE_VIP));
            }
            else if(_local_6 == 0)
            {
               if(MainManager.actorInfo.superNono)
               {
                  MainManager.actorInfo.superNono = false;
                  if(Boolean(NonoManager.info))
                  {
                     NonoManager.info.superNono = false;
                     MainManager.actorModel.hideNono();
                     MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
                  }
               }
            }
         }
         else if(_local_6 == 2)
         {
            _local_2 = UserManager.getUserModel(_local_5);
            if(Boolean(_local_2))
            {
               _local_2.info.superNono = true;
               if(Boolean(_local_2.nono))
               {
                  _local_3 = _local_2.nono.info;
                  _local_3.superNono = true;
                  _local_2.hideNono();
                  _local_2.showNono(_local_3);
               }
            }
         }
      }
   }
}

