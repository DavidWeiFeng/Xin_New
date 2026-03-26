package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class PetCmdListener extends BaseBeanController
   {
      
      public function PetCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PET_SHOW,this.onPetShow);
         finish();
      }
      
      private function onPetShow(_arg_1:SocketEvent) : void
      {
         var _local_2:PetShowInfo = _arg_1.data as PetShowInfo;
         if(_local_2.flag == 1)
         {
            UserManager.dispatchAction(_local_2.userID,PeopleActionEvent.PET_SHOW,_local_2);
         }
         else
         {
            UserManager.dispatchAction(_local_2.userID,PeopleActionEvent.PET_HIDE,_local_2);
         }
      }
   }
}

