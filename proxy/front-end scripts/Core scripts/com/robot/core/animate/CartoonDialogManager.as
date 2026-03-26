package com.robot.core.animate
{
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.newloader.MCLoader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   
   public class CartoonDialogManager
   {
      
      private static var mc:MovieClip;
      
      private static var method:Function;
      
      private static var animate:String;
      
      private static var timer:Timer;
      
      private static var mcloader:MCLoader;
      
      public function CartoonDialogManager()
      {
         super();
      }
      
      public static function play(param1:String, param2:Function = null, param3:String = "mc") : void
      {
         method = param2;
         animate = param3;
         if(param1 != "")
         {
            if(Boolean(mcloader))
            {
               mcloader.clear();
               mcloader = null;
            }
            mcloader = new MCLoader(param1,LevelManager.appLevel,1,"正在加载动画..");
            mcloader.addEventListener(MCLoadEvent.SUCCESS,onLoadSuccess);
            mcloader.doLoad(param1);
            return;
         }
         throw new Error("加载的动画路径不对哟!");
      }
      
      private static function onLoadSuccess(param1:MCLoadEvent) : void
      {
         LevelManager.closeMouseEvent();
         mcloader.removeEventListener(MCLoadEvent.SUCCESS,onLoadSuccess);
         mc = param1.getContent() as MovieClip;
         MainManager.getStage().addChild(mc);
         mc.gotoAndStop(1);
         mc.buttonMode = true;
         mc.addEventListener(MouseEvent.CLICK,onClick);
         mc.addEventListener(Event.ENTER_FRAME,onEnterFrame);
         timer = new Timer(4000);
         timer.addEventListener(TimerEvent.TIMER,onTimer);
         timer.start();
      }
      
      private static function onClick(param1:MouseEvent) : void
      {
         if(checkFrame())
         {
            timer.reset();
            timer.start();
            mc.nextFrame();
            if(!mc.hasEventListener(Event.ENTER_FRAME))
            {
               mc.addEventListener(Event.ENTER_FRAME,onEnterFrame);
            }
         }
      }
      
      private static function onEnterFrame(param1:Event) : void
      {
         var m:MovieClip = null;
         m = null;
         var e:Event = param1;
         if(Boolean(mc[animate]))
         {
            mc.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
            mc.mouseEnabled = false;
            mc.mouseChildren = false;
            timer.reset();
            m = mc[animate];
            m.gotoAndPlay(2);
            m.addEventListener(Event.ENTER_FRAME,function(param1:Event):void
            {
               if(m.currentFrame == m.totalFrames)
               {
                  m.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  m.gotoAndStop(m.totalFrames);
                  onClick(null);
                  mc.mouseEnabled = true;
                  mc.mouseChildren = true;
               }
            });
         }
      }
      
      private static function onTimer(param1:TimerEvent) : void
      {
         if(checkFrame())
         {
            mc.nextFrame();
            if(!mc.hasEventListener(Event.ENTER_FRAME))
            {
               mc.addEventListener(Event.ENTER_FRAME,onEnterFrame);
            }
         }
      }
      
      private static function checkFrame() : Boolean
      {
         if(mc.currentFrame == mc.totalFrames)
         {
            LevelManager.openMouseEvent();
            if(method != null)
            {
               method();
            }
            method = null;
            mc.removeEventListener(MouseEvent.CLICK,onClick);
            mc.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
            DisplayUtil.removeForParent(mc);
            mc = null;
            timer.reset();
            timer.removeEventListener(TimerEvent.TIMER,onTimer);
            timer = null;
            return false;
         }
         return true;
      }
   }
}

