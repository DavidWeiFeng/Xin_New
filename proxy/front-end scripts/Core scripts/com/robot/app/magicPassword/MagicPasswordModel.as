package com.robot.app.magicPassword
{
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class MagicPasswordModel
   {
      
      private static var gift_a:Array;
      
      private static const MAX:int = 32;
      
      public function MagicPasswordModel()
      {
         super();
      }
      
      public static function send(_arg_1:String) : void
      {
         var _local_4:int = 0;
         SocketConnection.addCmdListener(CommandID.GET_GIFT_COMPLETE,onSendCompleteHandler);
         var _local_2:ByteArray = new ByteArray();
         var _local_3:int = _arg_1.length;
         while(_local_4 < _local_3)
         {
            if(_local_2.length > MAX)
            {
               break;
            }
            _local_2.writeUTFBytes(_arg_1.charAt(_local_4));
            _local_4++;
         }
         SocketConnection.send(CommandID.GET_GIFT_COMPLETE,_local_2);
      }
      
      private static function onSendCompleteHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_GIFT_COMPLETE,onSendCompleteHandler);
         var _local_2:GiftItemInfo = _arg_1.data as GiftItemInfo;
      }
      
      public static function get list() : Array
      {
         return gift_a;
      }
   }
}

