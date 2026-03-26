package com.robot.core.aticon
{
   import com.robot.core.CommandID;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.IActionSprite;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   
   public class ChatAction
   {
      
      private static const MAX:int = 131;
      
      public function ChatAction()
      {
         super();
      }
      
      public function execute(_arg_1:IActionSprite, _arg_2:String, _arg_3:uint = 0, _arg_4:Boolean = true) : void
      {
         var _local_5:ByteArray = null;
         var _local_6:int = 0;
         var _local_7:int = 0;
         if(_arg_2 == "")
         {
            return;
         }
         if(_arg_4)
         {
            _local_5 = new ByteArray();
            _local_6 = _arg_2.length;
            _local_7 = 0;
            while(_local_7 < _local_6)
            {
               if(_local_5.length > MAX)
               {
                  break;
               }
               _local_5.writeUTFBytes(_arg_2.charAt(_local_7));
               _local_7++;
            }
            _local_5.writeUTFBytes("0");
            SocketConnection.send(CommandID.CHAT,_arg_3,_local_5.length,_local_5);
         }
         else
         {
            BasePeoleModel(_arg_1).showBox(_arg_2,5);
         }
      }
   }
}

