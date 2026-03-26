package com.robot.app.vote
{
   import com.robot.app.energy.ore.DayOreCount;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import flash.events.Event;
   import org.taomee.events.SocketEvent;
   
   public class VoteManager
   {
      
      private static var _sendId:uint;
      
      public function VoteManager()
      {
         super();
      }
      
      public static function vote(id:uint, answer:Array, sendId:uint) : void
      {
         _sendId = sendId;
         var day:DayOreCount = new DayOreCount();
         day.addEventListener(DayOreCount.countOK,function(_arg_1:Event):void
         {
            var _local_2:uint = 0;
            var _local_3:uint = 0;
            if(DayOreCount.oreCount < 1)
            {
               for each(_local_3 in answer)
               {
                  _local_2 += Math.pow(2,_local_3);
               }
               SocketConnection.addCmdListener(CommandID.USER_INDAGATE,onIndagate);
               SocketConnection.send(CommandID.USER_INDAGATE,1,id,_local_2);
            }
            else
            {
               Alarm.show("你已经投过票了");
            }
         });
         day.sendToServer(sendId);
      }
      
      private static function onIndagate(_arg_1:SocketEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.TALK_CATE,onSuccess);
         SocketConnection.send(CommandID.TALK_CATE,_sendId);
      }
      
      private static function onSuccess(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,onSuccess);
         ItemInBagAlert.show(400501,"5个扭蛋牌已经放入你的储存箱");
      }
   }
}

