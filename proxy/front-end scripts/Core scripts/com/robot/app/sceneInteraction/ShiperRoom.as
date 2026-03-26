package com.robot.app.sceneInteraction
{
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.utils.*;
   
   public class ShiperRoom
   {
      
      private static var firTVMC:MovieClip;
      
      private static var secTVMC:MovieClip;
      
      private static var redBtn:SimpleButton;
      
      private static var blueBtn:SimpleButton;
      
      private static var greenBtn:SimpleButton;
      
      private static var yellowBtn:SimpleButton;
      
      private static var npcMc:MovieClip;
      
      private static var isGreen:Boolean;
      
      private static var isYellow:Boolean;
      
      private static var isBlue:Boolean;
      
      private static var colorMC:MovieClip;
      
      public function ShiperRoom()
      {
         super();
      }
      
      public static function start() : void
      {
         var _local_1:SimpleButton = MapManager.currentMap.controlLevel["startBtn"] as SimpleButton;
         _local_1.addEventListener(MouseEvent.CLICK,showColorPanel);
         firTVMC = MapManager.currentMap.controlLevel["firstTV"] as MovieClip;
         firTVMC.addEventListener(MouseEvent.MOUSE_OVER,onOver);
         firTVMC.buttonMode = true;
         firTVMC.mouseChildren = false;
         firTVMC.addEventListener(MouseEvent.MOUSE_OUT,onOut1);
         DisplayUtil.stopAllMovieClip(firTVMC);
         var _local_2:SimpleButton = MapManager.currentMap.controlLevel["firTVBtn"] as SimpleButton;
         _local_2.addEventListener(MouseEvent.CLICK,showFTV);
         secTVMC = MapManager.currentMap.controlLevel["tv2"] as MovieClip;
         secTVMC.buttonMode = true;
         DisplayUtil.stopAllMovieClip(secTVMC);
         secTVMC.mouseChildren = false;
         secTVMC.addEventListener(MouseEvent.MOUSE_OVER,onOver2);
         secTVMC.addEventListener(MouseEvent.MOUSE_OUT,onOut2);
         var _local_3:SimpleButton = MapManager.currentMap.controlLevel["secTVBtn"] as SimpleButton;
         _local_3.addEventListener(MouseEvent.CLICK,showSTV);
      }
      
      public static function destroy() : void
      {
         firTVMC = null;
         secTVMC = null;
         redBtn = null;
         blueBtn = null;
         greenBtn = null;
         yellowBtn = null;
         npcMc = null;
      }
      
      private static function showColorPanel(_arg_1:MouseEvent) : void
      {
         colorMC.visible = !colorMC.visible;
         MapManager.currentMap.controlLevel["startBtn"].mouseEnabled = false;
      }
      
      private static function onRed(_arg_1:MouseEvent) : void
      {
         if(isBlue)
         {
            isBlue = false;
         }
      }
      
      private static function onOver(_arg_1:MouseEvent) : void
      {
         firTVMC.gotoAndStop(2);
      }
      
      private static function onOver2(_arg_1:MouseEvent) : void
      {
         secTVMC.gotoAndStop(2);
      }
      
      private static function onOut2(_arg_1:MouseEvent) : void
      {
         secTVMC.gotoAndStop(1);
         secTVMC.addEventListener(Event.ENTER_FRAME,onLeft2);
      }
      
      private static function onOut1(_arg_1:MouseEvent) : void
      {
         firTVMC.gotoAndStop(1);
         firTVMC.addEventListener(Event.ENTER_FRAME,onLeft);
      }
      
      private static function onLeft2(_arg_1:Event) : void
      {
         var _local_2:MovieClip = null;
         if(secTVMC.currentFrame == 1)
         {
            _local_2 = secTVMC.getChildByName("up") as MovieClip;
            if(Boolean(_local_2))
            {
               secTVMC.removeEventListener(Event.ENTER_FRAME,onLeft2);
               _local_2.gotoAndPlay(18);
            }
         }
      }
      
      private static function onLeft(_arg_1:Event) : void
      {
         var _local_2:MovieClip = null;
         if(firTVMC.currentFrame == 1)
         {
            _local_2 = firTVMC.getChildByName("up") as MovieClip;
            if(Boolean(_local_2))
            {
               firTVMC.removeEventListener(Event.ENTER_FRAME,onLeft);
               _local_2.gotoAndPlay(10);
            }
         }
      }
      
      private static function onBlue(_arg_1:MouseEvent) : void
      {
         if(isYellow)
         {
            isBlue = true;
            isYellow = false;
            isGreen = false;
         }
      }
      
      private static function onGreen(_arg_1:MouseEvent) : void
      {
         isGreen = true;
         isYellow = false;
         isBlue = false;
      }
      
      private static function onYellow(_arg_1:MouseEvent) : void
      {
         if(isGreen)
         {
            isYellow = true;
            isGreen = false;
            isBlue = false;
         }
      }
      
      private static function showFTV(_arg_1:MouseEvent) : void
      {
         firTVMC.gotoAndStop(1);
         firTVMC.addEventListener(Event.ENTER_FRAME,onEnterShow);
      }
      
      private static function showSTV(_arg_1:MouseEvent) : void
      {
         secTVMC.gotoAndStop(1);
         secTVMC.addEventListener(Event.ENTER_FRAME,onEnterShow2);
      }
      
      private static function onEnterShow(_arg_1:Event) : void
      {
         var _local_2:MovieClip = null;
         if(firTVMC.currentFrame == 1)
         {
            _local_2 = firTVMC.getChildByName("up") as MovieClip;
            if(Boolean(_local_2))
            {
               firTVMC.removeEventListener(Event.ENTER_FRAME,onEnterShow);
               _local_2.gotoAndPlay(2);
            }
         }
      }
      
      private static function onEnterShow2(_arg_1:Event) : void
      {
         var _local_2:MovieClip = null;
         if(secTVMC.currentFrame == 1)
         {
            _local_2 = secTVMC.getChildByName("up") as MovieClip;
            if(Boolean(_local_2))
            {
               secTVMC.removeEventListener(Event.ENTER_FRAME,onEnterShow2);
               _local_2.gotoAndPlay(2);
            }
         }
      }
   }
}

