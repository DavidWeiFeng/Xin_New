package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   
   public class PetPropClass_300045
   {
      
      public function PetPropClass_300045(_arg_1:PetPropInfo)
      {
         super();
         SocketConnection.send(CommandID.EAT_SPECIAL_MEDICINE,_arg_1.petInfo.catchTime,_arg_1.itemId);
      }
   }
}

