package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   
   public class PetPropClass_300020
   {
      
      public function PetPropClass_300020(_arg_1:PetPropInfo)
      {
         super();
         SocketConnection.send(CommandID.USE_PET_ITEM_OUT_OF_FIGHT,_arg_1.petInfo.catchTime,_arg_1.itemId);
      }
   }
}

