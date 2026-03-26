package com.robot.app.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.FortressItemXMLInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.info.team.ArmInfo;
   import com.robot.core.info.team.HeadquarterInfo;
   import com.robot.core.manager.ArmManager;
   import com.robot.core.manager.FitmentManager;
   import com.robot.core.manager.HeadquarterManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class BuyCmdListener extends BaseBeanController
   {
      
      public function BuyCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ARM_UP_BUY,this.onArmUpBuy);
         SocketConnection.addCmdListener(CommandID.BUY_FITMENT,this.onFitmentBuy);
         SocketConnection.addCmdListener(CommandID.HEAD_BUY,this.onHeadBuy);
         finish();
      }
      
      private function onArmUpBuy(_arg_1:SocketEvent) : void
      {
         var _local_4:uint = 0;
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         _local_4 = _local_2.readUnsignedInt();
         var _local_5:uint = _local_2.readUnsignedInt();
         var _local_6:uint = _local_2.readUnsignedInt();
         MainManager.actorInfo.coins = _local_3;
         var _local_7:ArmInfo = new ArmInfo();
         _local_7.id = _local_4;
         _local_7.form = _local_5;
         _local_7.buyTime = _local_6;
         ArmManager.addInStorage(_local_7);
         Alarm.show("1个" + TextFormatUtil.getRedTxt(FortressItemXMLInfo.getName(_local_4)) + "已经放入你的仓库，你还剩下" + _local_3 + "个骄阳豆");
      }
      
      private function onFitmentBuy(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         var _local_5:uint = _local_2.readUnsignedInt();
         MainManager.actorInfo.coins = _local_3;
         var _local_6:FitmentInfo = new FitmentInfo();
         _local_6.id = _local_4;
         FitmentManager.addInStorage(_local_6);
         Alarm.show("1个<font color=\'#FF0000\'>" + ItemXMLInfo.getName(_local_4) + "</font>已经放入你的仓库，你还剩下" + _local_3 + "个骄阳豆");
      }
      
      private function onHeadBuy(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         var _local_5:uint = _local_2.readUnsignedInt();
         MainManager.actorInfo.coins = _local_3;
         var _local_6:HeadquarterInfo = new HeadquarterInfo();
         _local_6.id = _local_4;
         HeadquarterManager.addInStorage(_local_6);
         Alarm.show("1个<font color=\'#FF0000\'>" + ItemXMLInfo.getName(_local_4) + "</font>已经放入你的仓库，你还剩下" + _local_3 + "个骄阳豆");
      }
   }
}

