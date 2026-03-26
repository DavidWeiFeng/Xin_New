package com.robot.app.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class TranUserCmdListener extends BaseBeanController
   {
      
      public function TranUserCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NOTE_TRANSFORM_USER,this.onTran);
         finish();
      }
      
      private function onTran(_arg_1:SocketEvent) : void
      {
         var _local_2:BasePeoleModel = null;
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         var _local_5:uint = _local_3.readUnsignedInt();
         var _local_6:uint = _local_3.readUnsignedInt();
         if(_local_4 == MainManager.actorID)
         {
            _local_2 = MainManager.actorModel;
         }
         else
         {
            _local_2 = UserManager.getUserModel(_local_4);
         }
         if(Boolean(_local_2))
         {
         }
      }
   }
}

