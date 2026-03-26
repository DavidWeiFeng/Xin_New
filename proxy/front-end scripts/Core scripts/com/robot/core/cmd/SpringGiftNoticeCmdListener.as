package com.robot.core.cmd
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class SpringGiftNoticeCmdListener extends BaseBeanController
   {
      
      public function SpringGiftNoticeCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         finish();
      }
      
      private function onGigtNoticeHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         MainManager.actorInfo.coins = _local_2.readUnsignedInt();
         MainManager.actorInfo.superNono = true;
         _local_2.readUnsignedInt();
         NonoManager.info.superEnergy = _local_2.readUnsignedInt();
         NonoManager.info.superLevel = _local_2.readUnsignedInt();
         NonoManager.info.superStage = _local_2.readUnsignedInt();
         MainManager.actorInfo.vipLevel = NonoManager.info.superLevel;
         MainManager.actorInfo.vipValue = NonoManager.info.superEnergy;
         MainManager.actorInfo.vipStage = NonoManager.info.superStage;
         if(Boolean(MainManager.actorModel.nono))
         {
            MainManager.actorModel.hideNono();
            MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
         }
      }
   }
}

