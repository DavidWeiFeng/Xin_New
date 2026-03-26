package com.robot.app.mapProcess.active
{
   import com.robot.core.ui.DialogBox;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.manager.ToolTipManager;
   
   public class SuperNonoIndex
   {
      
      public static var _timer1:Timer;
      
      private static var boxMc:MovieClip;
      
      private static var _talkStr:String = "我是超能指引，有什么需要我帮忙的吗？";
      
      public function SuperNonoIndex()
      {
         super();
      }
      
      public static function superIndx(_arg_1:MovieClip) : void
      {
         _arg_1.buttonMode = true;
         boxMc = _arg_1;
         ToolTipManager.add(_arg_1,"侠客的超能指引");
         showBox();
         startTime();
      }
      
      private static function showBox() : void
      {
         var _local_1:DialogBox = new DialogBox();
         _local_1.show(_talkStr,25,5,boxMc);
      }
      
      private static function startTime() : void
      {
         _timer1 = new Timer(8000);
         _timer1.addEventListener(TimerEvent.TIMER,onTimerHandler);
         _timer1.start();
      }
      
      private static function onTimerHandler(_arg_1:TimerEvent) : void
      {
         showBox();
      }
   }
}

