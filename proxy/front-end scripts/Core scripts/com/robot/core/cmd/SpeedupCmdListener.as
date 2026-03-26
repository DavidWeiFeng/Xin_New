package com.robot.core.cmd
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.*;
   import flash.display.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class SpeedupCmdListener extends BaseBeanController
   {
      
      private static var icon:MovieClip;
      
      public function SpeedupCmdListener()
      {
         super();
      }
      
      public static function showIcon() : void
      {
         icon["txt"].text = MainManager.actorInfo.twoTimes.toString();
         LeftToolBarManager.addIcon(icon);
      }
      
      public static function delIcon() : void
      {
         LeftToolBarManager.delIcon(icon);
      }
      
      override public function start() : void
      {
         EventManager.addEventListener(RobotEvent.SPEEDUP_CHANGE,this.onChange);
         icon = TaskIconManager.getIcon("speedup_icon") as MovieClip;
         SocketConnection.addCmdListener(CommandID.USE_SPEEDUP_ITEM,this.onUseSpeedup);
         if(MainManager.actorInfo.twoTimes > 0)
         {
            showIcon();
         }
         finish();
      }
      
      private function onUseSpeedup(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         MainManager.actorInfo.twoTimes = _local_2.readUnsignedInt();
         MainManager.actorInfo.threeTimes = _local_2.readUnsignedInt();
         if(MainManager.actorInfo.twoTimes > 0)
         {
            showIcon();
         }
         else
         {
            delIcon();
         }
      }
      
      private function onChange(_arg_1:RobotEvent) : void
      {
         if(MainManager.actorInfo.twoTimes > 0)
         {
            showIcon();
         }
         else
         {
            delIcon();
         }
      }
   }
}

