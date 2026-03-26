package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   
   public class PetPropClass_300027
   {
      
      public function PetPropClass_300027(_arg_1:PetPropInfo)
      {
         super();
         SocketConnection.send(CommandID.USE_SPEEDUP_ITEM,_arg_1.itemId);
      }
   }
}

