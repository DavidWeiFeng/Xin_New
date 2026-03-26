package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.utils.Direction;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class SpecialCmdListener extends BaseBeanController
   {
      
      public function SpecialCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.DANCE_ACTION,this.onSpecial);
         finish();
      }
      
      private function onSpecial(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         var _local_5:String = Direction.indexToStr(_local_2.readUnsignedInt());
         UserManager.dispatchAction(_local_3,PeopleActionEvent.SPECIAL,_local_5);
      }
   }
}

