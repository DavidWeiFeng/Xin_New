package com.robot.core.dayGift
{
   import com.robot.core.CommandID;
   import com.robot.core.info.task.DayTalkInfo;
   import com.robot.core.info.task.MiningCountInfo;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.events.SocketEvent;
   
   [Event(name="countSuccess",type="com.robot.core.dayGift.DayGiftController")]
   public class DayGiftController extends EventDispatcher
   {
      
      public static const COUNT_SUCCESS:String = "countSuccess";
      
      private var type:uint;
      
      private var errortipStr:String;
      
      private var maxCount:uint;
      
      private var fun:Function;
      
      private var isError:Boolean = false;
      
      private var isGetCount:Boolean = false;
      
      private var isBuf:Boolean = false;
      
      public function DayGiftController(_arg_1:uint, _arg_2:uint, _arg_3:String = "", _arg_4:Boolean = false)
      {
         super();
         this.type = _arg_1;
         this.errortipStr = _arg_3;
         this.maxCount = _arg_2;
         if(_arg_4)
         {
            this.getCount();
         }
      }
      
      public function getCount() : void
      {
         this.isGetCount = false;
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,this.onCount);
         SocketConnection.send(CommandID.TALK_COUNT,this.type);
      }
      
      private function onCount(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_COUNT,this.onCount);
         var _local_2:MiningCountInfo = _arg_1.data as MiningCountInfo;
         var _local_3:uint = _local_2.miningCount;
         this.isGetCount = true;
         this.isError = _local_3 >= this.maxCount;
         if(this.isError)
         {
            if(this.errortipStr != "")
            {
               Alarm.show(this.errortipStr);
            }
         }
         else
         {
            dispatchEvent(new Event(COUNT_SUCCESS));
            if(this.isBuf)
            {
               this.send();
            }
         }
      }
      
      public function sendToServer(_arg_1:Function = null) : void
      {
         this.fun = _arg_1;
         if(!this.isGetCount)
         {
            this.isBuf = true;
            return;
         }
         this.send();
      }
      
      private function send() : void
      {
         if(this.isError)
         {
            return;
         }
         SocketConnection.addCmdListener(CommandID.TALK_CATE,this.onSend);
         SocketConnection.send(CommandID.TALK_CATE,this.type);
      }
      
      private function onSend(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,this.onSend);
         if(this.fun != null)
         {
            this.fun(_arg_1.data as DayTalkInfo);
         }
      }
   }
}

