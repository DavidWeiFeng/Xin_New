package com.robot.app.mapProcess.active
{
   import com.robot.core.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class ActiveStar
   {
      
      private var start:Point;
      
      private var end:Point;
      
      private var timer:Timer;
      
      public function ActiveStar(start:Point, end:Point)
      {
         super();
         this.start = start;
         this.end = end;
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,arguments.callee);
            var _local_3:Date = (_arg_1.data as SystemTimeInfo).date;
            if(_local_3.getDate() >= 24)
            {
               timer = new Timer(500);
               timer.addEventListener(TimerEvent.TIMER,onTimer);
               timer.start();
            }
         });
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      
      private function onTimer(_arg_1:TimerEvent) : void
      {
         var _local_2:Star = null;
         _local_2 = null;
         var _local_3:Number = this.start.x + Math.random() * (this.end.x - this.end.y);
         _local_2 = new Star();
         _local_2.x = _local_3;
         _local_2.y = -10;
         MapManager.currentMap.animatorLevel["mc"].addChild(_local_2);
      }
      
      public function destroy() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.stop();
            this.timer = null;
         }
      }
   }
}

import com.robot.core.manager.MainManager;
import com.robot.core.manager.map.MapLibManager;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;

class Star extends Sprite
{
   
   private var mc:MovieClip;
   
   public function Star()
   {
      super();
      this.mc = MapLibManager.getMovieClip("star");
      if(!this.mc)
      {
         return;
      }
      addChild(this.mc);
      this.mc.alpha = 0.8;
      this.mc.scaleY = 0.8;
      this.mc.scaleX = 0.8;
      this.addEventListener(Event.ENTER_FRAME,this.onEnter);
   }
   
   private function onEnter(_arg_1:Event) : void
   {
      var _local_2:uint = Math.floor(Math.random() * 4) + 8;
      this.mc.x += _local_2 * 1.3;
      this.mc.y += _local_2;
      if(this.mc.x > MainManager.getStageWidth() || this.mc.y > MainManager.getStageHeight())
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnter);
         this.mc = null;
      }
   }
}
