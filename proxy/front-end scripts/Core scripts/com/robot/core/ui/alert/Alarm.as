package com.robot.core.ui.alert
{
   import com.robot.core.manager.*;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.geom.*;
   import flash.text.*;
   import org.taomee.utils.*;
   
   public class Alarm
   {
      
      public function Alarm()
      {
         super();
      }
      
      public static function sunlog(... _args) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.call("sunlog",JSON.stringify(_args));
      }
      
      public static function show(str:String, applyFun:Function = null, isColor:Boolean = false, isMouse:Boolean = false) : Sprite
      {
         var bgmc:Sprite = null;
         var txt:TextField = null;
         var sprite:Sprite = null;
         var applyBtn:SimpleButton = null;
         var apply:Function = null;
         sprite = null;
         applyBtn = null;
         apply = null;
         apply = function(_arg_1:MouseEvent):void
         {
            LevelManager.openMouseEvent();
            if(applyFun != null)
            {
               applyFun();
            }
            applyBtn.removeEventListener(MouseEvent.CLICK,apply);
            DisplayUtil.removeForParent(sprite);
         };
         if(isColor)
         {
            sprite = UIManager.getSprite("AlarmMc_Orange");
         }
         else
         {
            sprite = UIManager.getSprite("AlarmMC");
         }
         bgmc = sprite["bgMc"];
         bgmc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            sprite.startDrag();
         });
         bgmc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            sprite.stopDrag();
         });
         LevelManager.tipLevel.addChild(sprite);
         DisplayUtil.align(sprite,null,AlignType.MIDDLE_CENTER);
         if(!isMouse)
         {
            LevelManager.closeMouseEvent();
         }
         txt = sprite["txt"];
         txt.autoSize = TextFormatAlign.CENTER;
         txt.width = 265;
         txt.htmlText = str;
         txt.addEventListener(TextEvent.LINK,function(_arg_1:TextEvent):void
         {
            _arg_1.stopImmediatePropagation();
            sprite.dispatchEvent(_arg_1);
         });
         DisplayUtil.align(txt,new Rectangle(40,60,265,90),AlignType.MIDDLE_CENTER);
         applyBtn = sprite["applyBtn"];
         applyBtn.addEventListener(MouseEvent.CLICK,apply);
         return sprite;
      }
   }
}

