package com.robot.app.task.noviceGuide
{
   import com.robot.core.CommandID;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.net.SocketConnection;
   
   public class SelectPet
   {
      
      private static var curPetId:uint;
      
      private static var bSend:Boolean = false;
      
      public function SelectPet()
      {
         super();
      }
      
      public static function checkStatus(_arg_1:uint) : void
      {
         if(TasksManager.getTaskStatus(2) == TasksManager.COMPLETE)
         {
            return;
         }
         curPetId = _arg_1;
         okFun();
      }
      
      private static function okFun() : void
      {
         if(bSend)
         {
            return;
         }
         SocketConnection.send(CommandID.COMPLETE_TASK,2,curPetId);
         bSend = true;
      }
   }
}

