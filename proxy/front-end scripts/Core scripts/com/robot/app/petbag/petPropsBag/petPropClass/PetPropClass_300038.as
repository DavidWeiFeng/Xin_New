package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   
   public class PetPropClass_300038
   {
      
      public function PetPropClass_300038(_arg_1:PetPropInfo)
      {
         super();
         if(_arg_1.petInfo.ev_defence == 0)
         {
            Alarm.show("你的<font color=\'#ff0000\'>" + _arg_1.petInfo.name + "</font>不需要再使用此物品啦!");
         }
         else
         {
            SocketConnection.send(CommandID.USE_PET_ITEM_OUT_OF_FIGHT,_arg_1.petInfo.catchTime,_arg_1.itemId);
         }
      }
   }
}

