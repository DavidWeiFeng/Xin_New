package com.robot.app.ogre
{
   import com.robot.app.mapProcess.active.SpecialPetActive;
   import com.robot.core.CommandID;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class SpecialPetCmdListener extends BaseBeanController
   {
      
      public function SpecialPetCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.SPECIAL_PET_NOTE,this.onSpecialList);
         finish();
      }
      
      private function onSpecialList(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         if(_local_3 == 1)
         {
            SpecialPetActive.show(_local_4);
         }
         else
         {
            SpecialPetActive.hide();
         }
      }
   }
}

