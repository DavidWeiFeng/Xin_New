package com.robot.core.cmd
{
   import com.robot.core.*;
   import com.robot.core.aimat.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class AimatCmdListener extends BaseBeanController
   {
      
      public function AimatCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.AIMAT,this.onAimat);
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onPlayEnd);
         finish();
      }
      
      private function onAimat(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         if(UserManager._hideOtherUserModelFlag && _local_3 != MainManager.actorID)
         {
            return;
         }
         var _local_4:Object = new Object();
         _local_4.itemID = _local_2.readUnsignedInt();
         _local_4.type = _local_2.readUnsignedInt();
         _local_4.pos = new Point(_local_2.readUnsignedInt(),_local_2.readUnsignedInt());
         UserManager.dispatchAction(_local_3,PeopleActionEvent.AIMAT,_local_4);
      }
      
      private function onPlayEnd(_arg_1:AimatEvent) : void
      {
         var _local_2:BasePeoleModel = null;
         var _local_3:Array = null;
         var _local_4:AimatInfo = _arg_1.info;
         for each(_local_2 in UserManager.getUserModelList())
         {
            if(_local_2.hitTestPoint(_local_4.endPos.x,_local_4.endPos.y,true))
            {
               _local_3 = AimatXMLInfo.getCloths(_local_4.id);
               SocketConnection.send(CommandID.TRANSFORM_USER,_local_2.info.userID,uint(_local_3[0]));
               break;
            }
         }
      }
   }
}

