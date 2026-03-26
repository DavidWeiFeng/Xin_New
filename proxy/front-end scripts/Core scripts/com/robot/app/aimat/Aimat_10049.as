package com.robot.app.aimat
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.effect.LightEffect;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.Timer;
   
   public class Aimat_10049 extends BaseAimat
   {
      
      private var speedPos:Point;
      
      private var ui:LightEffect;
      
      private var ui2:MovieClip;
      
      private var timer:Timer;
      
      private var _sound:Sound;
      
      private var _sounds:SoundChannel;
      
      private var _soundt:SoundTransform = new SoundTransform(0.5);
      
      public function Aimat_10049()
      {
         super();
      }
      
      override public function execute(_arg_1:AimatInfo) : void
      {
         var _local_2:DisplayObject = null;
         super.execute(_arg_1);
         this._sound = AimatController.getResSound(_info.id);
         this._sounds = this._sound.play(0,1,this._soundt);
         this.ui = new LightEffect();
         this.ui.show(_info.startPos,_info.endPos,false);
         var _local_3:Array = MapManager.getObjectsPointRect(_info.endPos,30,[IAimatSprite]);
         for each(_local_2 in _local_3)
         {
            if(_local_2 is IAimatSprite)
            {
               IAimatSprite(_local_2).aimatState(_info);
            }
         }
         this.timer = new Timer(1500,1);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onEnter);
         this.timer.start();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this.ui))
         {
            this.ui = null;
         }
         this.speedPos = null;
      }
      
      private function onEnter(_arg_1:TimerEvent) : void
      {
         this._sounds.stop();
         this._sound = null;
         this._sounds = null;
         this._soundt = null;
         AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
      }
      
      private function onEnd() : void
      {
      }
   }
}

