package com.robot.app.nono.featureApp
{
   import com.robot.app.MoleculePanel.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class App_700002
   {
      
      private var _panel:AppModel;
      
      public function App_700002(_arg_1:uint)
      {
         super();
         this.check();
      }
      
      private function check() : void
      {
         if(SocketConnection.hasCmdListener(CommandID.PET_HATCH_GET))
         {
            return;
         }
         SocketConnection.addCmdListener(CommandID.PET_HATCH_GET,function(e:SocketEvent):void
         {
            var data:ByteArray = null;
            var falg:Boolean = false;
            var leftTime:uint = 0;
            var captmTime:uint = 0;
            var petID:uint = 0;
            var leftMinutes:uint = 0;
            var leftHours:uint = 0;
            petID = 0;
            SocketConnection.removeCmdListener(CommandID.PET_HATCH_GET,arguments.callee);
            data = e.data as ByteArray;
            falg = Boolean(data.readUnsignedInt());
            leftTime = data.readUnsignedInt();
            petID = data.readUnsignedInt();
            captmTime = data.readUnsignedInt();
            if(falg)
            {
               if(leftTime == 0)
               {
                  if(PetManager.length < 6)
                  {
                     PetManager.addEventListener(PetEvent.ADDED,function(_arg_1:PetEvent):void
                     {
                        PetInBagAlert.show(petID,TextFormatUtil.getRedTxt(PetXMLInfo.getName(petID)) + "已经放入你的背包中。");
                     });
                     PetManager.setIn(captmTime,1);
                  }
                  else
                  {
                     PetManager.addStorage(petID,captmTime);
                     PetInStorageAlert.show(petID,TextFormatUtil.getRedTxt(PetXMLInfo.getName(petID)) + "已经放入你的仓库中。");
                  }
               }
               else
               {
                  leftMinutes = uint(Math.ceil(leftTime / 60));
                  leftHours = uint(Math.floor(leftMinutes / 60));
                  leftMinutes %= 60;
                  Alarm.show("分子转化仪中有正在转化的精元，预计剩余孵化时间: " + leftHours + " 小时 " + leftMinutes + " 分钟");
               }
            }
            else
            {
               MoleculePanelController.show();
            }
         });
         SocketConnection.send(CommandID.PET_HATCH_GET);
      }
   }
}

