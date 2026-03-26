package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   
   public class PetPropClass_default
   {
      
      public function PetPropClass_default(_arg_1:PetPropInfo)
      {
         super();
         SocketConnection.send(CommandID.USE_PET_ITEM_OUT_OF_FIGHT,_arg_1.petInfo.catchTime,_arg_1.itemId);
         Alarm.show("道具已经成功使用完毕");
      }
   }
}

