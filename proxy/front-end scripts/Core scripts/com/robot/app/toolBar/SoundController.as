package com.robot.app.toolBar
{
   import com.robot.core.*;
   import com.robot.core.manager.*;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class SoundController
   {
      
      private static var _musicPower_mc:MovieClip;
      
      public function SoundController()
      {
         super();
      }
      
      public static function controller(_arg_1:DisplayObjectContainer, _arg_2:Number, _arg_3:Number) : void
      {
         _musicPower_mc = UIManager.getMovieClip("SoundController_mc");
         _arg_1.addChild(_musicPower_mc);
         _musicPower_mc.x = _arg_2;
         _musicPower_mc.y = _arg_3;
         _musicPower_mc.addEventListener(MouseEvent.CLICK,onMusicMcClickHandler);
         ToolTipManager.add(_musicPower_mc,"关闭音乐");
      }
      
      private static function onMusicMcClickHandler(_arg_1:MouseEvent) : void
      {
         if(SoundManager.getIsPlay == true)
         {
            _musicPower_mc["mc2"].visible = false;
            _musicPower_mc["mc1"].visible = true;
            ToolTipManager.remove(_musicPower_mc);
            ToolTipManager.add(_musicPower_mc,"打开音乐");
            SoundManager.setIsPlay = false;
            SoundManager.stopSound();
         }
         else
         {
            _musicPower_mc["mc2"].visible = true;
            _musicPower_mc["mc1"].visible = false;
            ToolTipManager.remove(_musicPower_mc);
            ToolTipManager.add(_musicPower_mc,"关闭音乐");
            SoundManager.setIsPlay = true;
            SoundManager.playSound();
         }
      }
      
      public static function destroy() : void
      {
         _musicPower_mc.removeEventListener(MouseEvent.CLICK,onMusicMcClickHandler);
         ToolTipManager.remove(_musicPower_mc);
         DisplayUtil.removeForParent(_musicPower_mc);
         _musicPower_mc = null;
      }
   }
}

