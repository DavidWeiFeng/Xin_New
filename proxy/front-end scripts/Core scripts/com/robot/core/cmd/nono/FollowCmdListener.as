package com.robot.core.cmd.nono
{
   import com.robot.core.*;
   import com.robot.core.aticon.*;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.*;
   import com.robot.core.skeleton.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class FollowCmdListener extends BaseBeanController
   {
      
      public function FollowCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_FOLLOW_OR_HOOM,this.onChanged);
         finish();
      }
      
      private function onChanged(_arg_1:SocketEvent) : void
      {
         var _local_2:NonoInfo = null;
         var _local_3:BasePeoleModel = null;
         var _local_4:ByteArray = _arg_1.data as ByteArray;
         var _local_5:uint = _local_4.readUnsignedInt();
         var _local_6:uint = _local_4.readUnsignedInt();
         var _local_7:Boolean = Boolean(_local_4.readUnsignedInt());
         if(Boolean(NonoManager.info))
         {
            if(NonoManager.info.userID == _local_5)
            {
               NonoManager.info.state[1] = _local_7;
            }
         }
         if(_local_7)
         {
            _local_2 = new NonoInfo();
            _local_2.userID = _local_5;
            _local_2.superStage = _local_6;
            _local_2.nick = _local_4.readUTFBytes(16);
            _local_2.color = _local_4.readUnsignedInt();
            _local_2.power = _local_4.readUnsignedInt() / 1000;
            if(MainManager.actorID == _local_5)
            {
               if(Boolean(NonoManager.info))
               {
                  NonoManager.info.power = _local_2.power;
                  _local_2 = NonoManager.info;
               }
               else
               {
                  _local_2.superNono = MainManager.actorInfo.superNono;
                  NonoManager.info = _local_2;
               }
            }
            else
            {
               _local_3 = UserManager.getUserModel(_local_5);
               if(Boolean(_local_3))
               {
                  _local_2.superNono = _local_3.info.superNono;
               }
            }
            UserManager.dispatchAction(_local_5,PeopleActionEvent.NONO_FOLLOW,_local_2);
            NonoManager.dispatchEvent(new NonoEvent(NonoEvent.FOLLOW,_local_2));
         }
         else
         {
            UserManager.dispatchAction(_local_5,PeopleActionEvent.NONO_HOOM,_local_7);
            NonoManager.dispatchEvent(new NonoEvent(NonoEvent.HOOM,null));
            if(MainManager.actorInfo.actionType == 1 && MainManager.actorID == _local_5)
            {
               MainManager.actorModel.walk = new WalkAction();
               MainManager.actorInfo.nonoState[1] = false;
               MainManager.actorModel.footMC.visible = true;
               new PeculiarAction().standUp(MainManager.actorModel.skeleton as EmptySkeletonStrategy);
               MainManager.actorModel.nameTxt.y -= 40;
               MainManager.actorInfo.actionType = 0;
            }
         }
      }
   }
}

