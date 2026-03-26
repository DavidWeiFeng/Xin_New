package com.robot.app.nono.featureApp
{
   import com.robot.core.*;
   import com.robot.core.aticon.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.skeleton.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.ui.nono.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class App_700017
   {
      
      public function App_700017(_arg_1:uint)
      {
         super();
         if(MainManager.actorModel.isTransform)
         {
            Alarm.show("你目前处在变身状态不可以飞行！");
            return;
         }
         var _local_2:uint = uint(MainManager.actorInfo.actionType);
         SocketConnection.addCmdListener(CommandID.ON_OR_OFF_FLYING,this.onFlyHandler);
         if(MainManager.actorInfo.actionType == 0)
         {
            SocketConnection.send(CommandID.ON_OR_OFF_FLYING,1);
         }
         else
         {
            SocketConnection.send(CommandID.ON_OR_OFF_FLYING,0);
         }
      }
      
      private function onFlyHandler(_arg_1:SocketEvent) : void
      {
         NonoShortcut.onNonoPanelClose(null);
         SocketConnection.removeCmdListener(CommandID.ON_OR_OFF_FLYING,this.onFlyHandler);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         MainManager.actorInfo.actionType = _local_4;
         MainManager.actorModel.hideNono();
         if(_local_4 == 0)
         {
            MainManager.actorInfo.nonoState[1] = false;
            MainManager.actorModel.walk = new WalkAction();
            MainManager.actorModel.footMC.visible = true;
            new PeculiarAction().standUp(MainManager.actorModel.skeleton as EmptySkeletonStrategy);
            MainManager.actorModel.nameTxt.y -= 40;
         }
         else
         {
            NonoManager.dispatchEvent(new NonoEvent(NonoEvent.FOLLOW,NonoManager.info));
            MainManager.actorInfo.nonoState[1] = true;
            MainManager.actorModel.walk = new FlyAction(MainManager.actorModel);
         }
         MainManager.actorModel.showNono(NonoManager.info,_local_4);
      }
   }
}

