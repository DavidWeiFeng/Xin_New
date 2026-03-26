package com.robot.core.animate
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.*;
   
   public class AnimateManager
   {
      
      private static var url:String;
      
      private static var name:String;
      
      private static var soundName:String;
      
      private static var func:Function;
      
      private static var mcloader:MCLoader;
      
      private static var soundChal:SoundChannel;
      
      private static var frameFunc:Function;
      
      public static const MC_NOT_FIND:String = "mcIsNotFind";
      
      public function AnimateManager()
      {
         super();
      }
      
      public static function playFullScreenAnimate(_arg_1:String = "", _arg_2:Function = null, _arg_3:String = null, _arg_4:String = null) : void
      {
         url = _arg_1;
         name = _arg_3;
         soundName = _arg_4;
         func = _arg_2;
         if(_arg_1 != "" && _arg_1 != null)
         {
            if(Boolean(mcloader))
            {
               mcloader.clear();
               mcloader = null;
            }
            mcloader = new MCLoader(url,LevelManager.appLevel,1,"正在加载动画..");
            mcloader.addEventListener(MCLoadEvent.SUCCESS,onLoadAnimateSuccess);
            mcloader.doLoad(url);
            return;
         }
         throw new Error("加载的动画路径不对哟!");
      }
      
      private static function onLoadAnimateSuccess(_arg_1:MCLoadEvent) : void
      {
         var _local_2:ApplicationDomain = null;
         var _local_4:Sound = null;
         var _local_5:ApplicationDomain = null;
         var _local_7:MovieClip = null;
         var _local_8:MovieClip = null;
         var _local_3:* = undefined;
         var _local_6:* = undefined;
         LevelManager.closeMouseEvent();
         SoundManager.stopSound();
         mcloader.removeEventListener(MCLoadEvent.SUCCESS,onLoadAnimateSuccess);
         if(soundName != "" && soundName != null)
         {
            _local_2 = _arg_1.getApplicationDomain();
            _local_3 = _local_2.getDefinition(soundName);
            _local_4 = new _local_3() as Sound;
            if(Boolean(soundChal))
            {
               soundChal.stop();
               soundChal = null;
            }
            soundChal = _local_4.play(10);
         }
         if(name != "" && name != null)
         {
            _local_5 = _arg_1.getApplicationDomain();
            _local_6 = _local_5.getDefinition(name);
            _local_7 = new _local_6() as MovieClip;
            if(_local_7 == null)
            {
               throw new Error("加载的动画出错!");
            }
            MainManager.getStage().addChild(_local_7);
            playMovieClip(_local_7);
         }
         else
         {
            _local_8 = _arg_1.getContent() as MovieClip;
            MainManager.getStage().addChild(_local_8);
            playMovieClip(_local_8);
         }
      }
      
      private static function playMovieClip(mc:MovieClip) : void
      {
         mc.gotoAndPlay(2);
         mc.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
         {
            if(mc.currentFrame == mc.totalFrames)
            {
               mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               DisplayUtil.removeForParent(mc);
               mc = null;
               SoundManager.playSound();
               LevelManager.openMouseEvent();
               if(Boolean(soundChal))
               {
                  soundChal.stop();
               }
               url = "";
               name = "";
               soundName = "";
               if(func != null)
               {
                  func();
               }
            }
         });
      }
      
      public static function playMcAnimate(mc:MovieClip, frame:uint = 0, name:String = "", func:Function = null) : void
      {
         frameFunc = func;
         if(func == null)
         {
            throw new Error("动画播放回调函数不能为null");
         }
         if(frame == 0 || name == "" || name == null)
         {
            playFrameMC(mc);
         }
         else
         {
            mc.gotoAndStop(frame);
            LevelManager.closeMouseEvent();
            mc.addEventListener(Event.ENTER_FRAME,function():void
            {
               var _local_2:MovieClip = mc[name] as MovieClip;
               if(Boolean(_local_2))
               {
                  mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  playFrameMC(_local_2);
               }
            });
         }
      }
      
      private static function playFrameMC(frameMC:MovieClip) : void
      {
         if(Boolean(frameMC))
         {
            frameMC.gotoAndPlay(2);
            frameMC.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
            {
               if(frameMC.currentFrame == frameMC.totalFrames)
               {
                  frameMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  LevelManager.openMouseEvent();
                  frameFunc();
               }
            });
         }
      }
   }
}

