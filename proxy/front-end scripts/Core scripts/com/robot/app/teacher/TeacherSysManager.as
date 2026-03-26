package com.robot.app.teacher
{
   import com.robot.app.teacherAward.SevenNoLoginInfo;
   import com.robot.core.CommandID;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.PeopleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.Answer;
   import flash.display.Sprite;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.ArrayUtil;
   import org.taomee.utils.DisplayUtil;
   
   public class TeacherSysManager
   {
      
      private static var sprite:Sprite;
      
      public function TeacherSysManager()
      {
         super();
      }
      
      public static function hideSendTip() : void
      {
         DisplayUtil.removeForParent(sprite);
         sprite = null;
      }
      
      public static function addTeacher(_arg_1:uint) : void
      {
         sprite = Alarm.show("申请已发送，请耐心等待对方的答复！");
         SocketConnection.send(CommandID.REQUEST_ADD_TEACHER,_arg_1);
      }
      
      public static function addStudent(_arg_1:uint) : void
      {
         sprite = Alarm.show("申请已发送，请耐心等待对方的答复！");
         SocketConnection.send(CommandID.REQUEST_ADD_STUDENT,_arg_1);
      }
      
      public static function delTeacher() : void
      {
         Answer.show("你确定要和你的教官解除关系吗？",function():void
         {
            SocketConnection.send(CommandID.DELETE_TEACHER);
         });
      }
      
      public static function delStudent() : void
      {
         SocketConnection.send(CommandID.SEVENNOLOGIN_COMPLETE);
         SocketConnection.addCmdListener(CommandID.SEVENNOLOGIN_COMPLETE,onCompleteHandler);
      }
      
      private static function onCompleteHandler(e:SocketEvent) : void
      {
         var data:SevenNoLoginInfo = null;
         SocketConnection.removeCmdListener(CommandID.SEVENNOLOGIN_COMPLETE,onCompleteHandler);
         data = e.data as SevenNoLoginInfo;
         if(data.getStatus == 0)
         {
            Answer.show("你确定要和你的学员解除关系吗？教官主动解除需要<font color=\'#ff0000\'>支付200个骄阳豆</font>哦！",function():void
            {
               SocketConnection.send(CommandID.DELETE_STUDENT);
               if(MainManager.actorInfo.coins > 200)
               {
                  MainManager.actorInfo.coins -= 200;
               }
               else
               {
                  MainManager.actorInfo.coins = 0;
               }
            });
            return;
         }
         if(data.getStatus == 1)
         {
            Answer.show("由于你的学员连续7天没登陆飞船，你可以免费解除关系。",function():void
            {
               SocketConnection.send(CommandID.DELETE_STUDENT);
            });
         }
      }
      
      public static function checkMapUser() : void
      {
         var _local_1:PeopleModel = null;
         var _local_2:BasePeoleModel = null;
         var _local_3:Array = UserManager.getUserModelList();
         var _local_4:Array = [];
         for each(_local_1 in _local_3)
         {
            _local_4.push(_local_1.info.userID);
         }
         for each(_local_1 in _local_3)
         {
            if(ArrayUtil.arrayContainsValue(_local_4,_local_1.info.teacherID))
            {
               _local_2 = UserManager.getUserModel(_local_1.info.teacherID);
               _local_2.addProtectMC();
               _local_1.addProtectMC();
            }
            else if(ArrayUtil.arrayContainsValue(_local_4,_local_1.info.studentID))
            {
               _local_2 = UserManager.getUserModel(_local_1.info.studentID);
               _local_2.addProtectMC();
               _local_1.addProtectMC();
            }
            if(_local_1.info.teacherID == MainManager.actorID || _local_1.info.studentID == MainManager.actorID)
            {
               MainManager.actorModel.addProtectMC();
               _local_1.addProtectMC();
            }
         }
      }
      
      public static function updateAfterDel() : void
      {
         var _local_1:BasePeoleModel = null;
         var _local_2:uint = 0;
         var _local_3:Array = UserManager.getUserModelList();
         for each(_local_1 in _local_3)
         {
            _local_2 = uint(_local_1.info.userID);
            if(_local_2 == MainManager.actorInfo.teacherID || _local_2 == MainManager.actorInfo.studentID)
            {
               _local_1.delProtectMC();
            }
         }
         MainManager.actorModel.delProtectMC();
      }
      
      public static function updateAfterAdd() : void
      {
         var _local_1:BasePeoleModel = null;
         var _local_2:uint = 0;
         var _local_3:Array = UserManager.getUserModelList();
         for each(_local_1 in _local_3)
         {
            _local_2 = uint(_local_1.info.userID);
            if(_local_2 == MainManager.actorInfo.teacherID || _local_2 == MainManager.actorInfo.studentID)
            {
               MainManager.actorModel.addProtectMC();
               _local_1.addProtectMC();
            }
         }
      }
   }
}

