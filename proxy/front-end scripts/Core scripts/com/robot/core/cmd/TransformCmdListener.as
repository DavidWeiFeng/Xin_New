package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.info.transform.TransformInfo;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.TransformSkeleton;
   import org.taomee.events.SocketEvent;
   
   public class TransformCmdListener extends BaseBeanController
   {
      
      public function TransformCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PEOPLE_TRANSFROM,this.onTransform);
         finish();
      }
      
      private function onTransform(_arg_1:SocketEvent) : void
      {
         var _local_2:TransformSkeleton = null;
         var _local_3:TransformInfo = _arg_1.data as TransformInfo;
         var _local_4:BasePeoleModel = UserManager.getUserModel(_local_3.userID);
         if(Boolean(_local_4))
         {
            _local_4.stop();
            _local_4.info.changeShape = _local_3.suitID;
            if(_local_3.suitID == 0)
            {
               _local_2 = _local_4.skeleton as TransformSkeleton;
               if(Boolean(_local_2))
               {
                  _local_2.untransform();
               }
            }
            else
            {
               _local_4.skeleton = new TransformSkeleton();
            }
         }
      }
   }
}

