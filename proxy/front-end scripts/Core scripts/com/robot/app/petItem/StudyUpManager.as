package com.robot.app.petItem
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class StudyUpManager
   {
      
      private static var leftTime:uint;
      
      private static var icon:MovieClip;
      
      private static var txt:TextField;
      
      public function StudyUpManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         EventManager.addEventListener(RobotEvent.STUDY_TIMES_CHANGE,onTimesChange);
         leftTime = MainManager.actorInfo.learnTimes;
         checkTime();
      }
      
      private static function onTimesChange(_arg_1:Event) : void
      {
         leftTime = MainManager.actorInfo.learnTimes;
         checkTime();
      }
      
      public static function useItem(_arg_1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.USE_STUDY_ITEM,onUseItem);
         SocketConnection.send(CommandID.USE_STUDY_ITEM,_arg_1);
      }
      
      private static function onUseItem(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.USE_STUDY_ITEM,onUseItem);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         leftTime = _local_3;
         MainManager.actorInfo.learnTimes = _local_3;
         checkTime();
      }
      
      private static function checkTime() : void
      {
         if(!icon)
         {
            icon = TaskIconManager.getIcon("study_icon") as MovieClip;
            txt = icon["txt"];
         }
         if(leftTime > 0)
         {
            txt.text = leftTime.toString();
            LeftToolBarManager.addIcon(icon);
         }
         else
         {
            LeftToolBarManager.delIcon(icon);
         }
      }
   }
}

